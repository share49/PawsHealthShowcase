//
//  SignInWithAppleBaseController.swift
//  Hoowie
//
//  Created by Pinto Diaz, Roger on 3/22/20.
//  Copyright © 2020 Roger Pintó Diaz. All rights reserved.
//

import AuthenticationServices
import UIKit

class SignInWithAppleBaseController: UIViewController, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {

    // MARK: - Properties
    var btnSignInWithApple: UIControl = {
        let button = ASAuthorizationAppleIDButton()
        button.addTarget(self, action: #selector(onSignInWithApple), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var currentNonce: String? // Unhashed nonce
    var hasSignInWithApple = false

    // MARK: - SignInWithApple methods

    @objc func onSignInWithApple() {
        let nonce = AppleSignInHelper.randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = AppleSignInHelper.sha256(nonce)

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.presentationContextProvider = self
        authorizationController.delegate = self
        authorizationController.performRequests()
    }

    // MARK: - ASAuthorizationControllerDelegate

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        AuthService.instance.signInWithApple(authorization: authorization, nonce: currentNonce, onCompletion: {
            onMain {
                self.dismiss(animated: true)
            }
        })
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        guard !error.localizedDescription.contains("AuthorizationError error 1001") else { return }

        MyLogE("Sign in with Apple errored: \(error)")

        let alert = UIAlertController(title: "Authorization error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    // MARK: - ASAuthorizationControllerPresentationContextProviding

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        view.window!
    }
}
