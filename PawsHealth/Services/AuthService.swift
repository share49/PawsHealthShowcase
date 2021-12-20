//
//  AuthService.swift
//  Hoowie
//
//  Created by Roger Pintó Diaz on 7/14/18.
//  Copyright © 2018 Roger Pintó Diaz. All rights reserved.
//

import AuthenticationServices
import Foundation
import Firebase

final class AuthService {
    
    // MARK: - Properties
    static let instance = AuthService()

    // MARK: - Methods
    func registerUser(email: String, password: String, onCompletion: @escaping (_ status: Bool, _ error: Error?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            guard let user = user else {
                onCompletion(false, error)
                return
            }

            self.createDBUser(authDataResult: user)
            onCompletion(true, nil)
        }
    }
    
    func loginUser(email: String, password: String, onCompletion: @escaping (_ status: Bool, _ error: Error?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error.isNotNil {
                onCompletion(false, error)
                return
            }
            onCompletion(true, nil)
        }
    }
    
    func sendPasswordReset(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let errorMessage = error?.localizedDescription {
                MyLogE("SignIn: Reset password. \(errorMessage)")
                ToastMessageHelper.showToastWithMessage(errorMessage)
                
            } else {
                ToastMessageHelper.showToast(.resetPasswordSuccess)
            }
        }
    }
    
    func signInAnonymously(onCompletion: @escaping (_ status: Bool, _ error: Error?) -> ()) {
        Auth.auth().signInAnonymously { (authDataResult, error) in
            if error.isNotNil {
                onCompletion(false, error)
                return
            }
            onCompletion(true, nil)
        }
    }

    private func createDBUser(authDataResult: AuthDataResult) {
        let privateData: Dictionary<String, String> = [
            k.firebase.email: authDataResult.user.email!,
            k.firebase.provider: authDataResult.user.providerID
        ]

        let userData: Dictionary<String, Any> = [
            k.firebase.privateData: privateData
        ]

        DataService.instance.createDBUser(uid: authDataResult.user.uid, userData: userData)
    }

    func signInWithApple(authorization: ASAuthorization, nonce: String?, onCompletion: @escaping () -> Void) {
        guard let nonce = nonce else {
            fatalError("Invalid state: A login callback was received, but no login request was sent.")
        }

        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
            let appleIDToken = appleIDCredential.identityToken else {

                MyLogE("Unable to fetch identity token")
                return
        }

        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            MyLogE("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
            return
        }

        // Initialize a Firebase credential
        let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)

        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                // Error. If error.code == .MissingOrInvalidNonce, make sure
                // you're sending the SHA256-hashed nonce as a hex string with
                // your request to Apple.
                MyLogE("AuthService: signInWithApple: \(error.localizedDescription)")
                return
            }

            if let authResult = authResult {
                self.createDBUser(authDataResult: authResult)
            }

            MyLogI("AuthService: SignInWithApple: User logged in successfully")
            onCompletion()
        }
    }
}
