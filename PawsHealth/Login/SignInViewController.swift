//
//  SignInViewController.swift
//  Hoowie
//
//  Created by Roger Pintó Diaz on 7/14/18.
//  Copyright © 2018 Roger Pintó Diaz. All rights reserved.
//

import Firebase
import UIKit

final class SignInViewController: SignInWithAppleBaseController {

    // MARK: - IBOutlets
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var lblRegister: UILabel!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var vSeparatorOne: UIView!
    @IBOutlet weak var vSeparatorTwo: UIView!
    @IBOutlet weak var btnLogIn: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var vContainerOr: UIView!
    @IBOutlet weak var lblOr: UILabel!

    // MARK: - Initializers
    static func create() -> UIViewController {
        let vc = UIStoryboard(name: "SignIn", bundle: Bundle.main).instantiateViewController(withIdentifier: "SignInVC")
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
    
    // MARK: - ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTapGestureRecognizerToHideKeyboardTappingOutsideIt()
        setupTextFieldDelegates()
        setupView()
        setupSignInWithAppleButton()
    }
    
    deinit {
        MyLogD("Dealloc: \(self)")
    }
    
    // MARK: - UI methods
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private func setupTextFieldDelegates() {
        tfEmail.delegate = self
        tfPassword.delegate = self
    }
    
    private func setupView() {
        lblEmail.text = "Email"
        lblPassword.text = ls.password()
        lblRegister.text = ls.dont_have_an_account_q()
        lblRegister.textColor = .gray
        lblOr.text = ls.or()
    
        setupButtons()
        activityIndicator.alpha = 0
    }

    private func setupButtons() {
        btnLogIn.shadow()
        btnLogIn.circularView()
        btnLogIn.setTitle(ls.sign_in(), for: UIControl.State())
        btnRegister.setTitle(ls.register(), for: UIControl.State())
    }

    private func setupSignInWithAppleButton() {
        guard !hasSignInWithApple else { return }
        
        hasSignInWithApple = true
        
        view.addSubview(btnSignInWithApple)
        
        btnSignInWithApple.topAnchor.constraint(equalTo: vContainerOr.bottomAnchor, constant: 25).isActive = true
        btnSignInWithApple.widthAnchor.constraint(equalTo: btnLogIn.widthAnchor, constant: 0).isActive = true
        btnSignInWithApple.centerXAnchor.constraint(equalTo: btnLogIn.centerXAnchor, constant: 0).isActive = true
        btnSignInWithApple.heightAnchor.constraint(equalTo: btnLogIn.heightAnchor, constant: 0).isActive = true
    }
    
    // MARK: - onButton Actions
    @IBAction func onSignUp(_ sender: UIButton) {
        present(RegisterViewController.create(), animated: true)
    }
    
    @IBAction func onSignIn(_ sender: UIButton) {
        guard let email = tfEmail.text, email.count > 5, email.contains("@"), email.contains(".") else {
            ToastMessageHelper.showToast(.invalidEmail)
            return
        }

        guard let password = tfPassword.text, password.count >= 8 else {
            ToastMessageHelper.showToast(.invalidPassword)
            return
        }

        Utils.startActivityIndicator(activityIndicator: activityIndicator)
        
        AuthService.instance.loginUser(email: email, password: password, onCompletion: { (success, loginError) in
            Utils.stopActivityIndicator(activityIndicator: self.activityIndicator)

            if success {
                onMain {
                    self.dismiss(animated: true)
                }

            } else if let error = loginError, let errCode = AuthErrorCode(rawValue: error._code) {
                switch errCode {
                    case .userNotFound:
                        ToastMessageHelper.showToast(.userNotFound, duration: 3)

                    case .wrongPassword:
                        ToastMessageHelper.showToastWithMessage(error.localizedDescription)

                    default:
                        ToastMessageHelper.showToast(.tryAgain)
                }
            }
        })
    }
    
    @IBAction func onForgotPassword(_ sender: UIButton) {
        guard let email = tfEmail.text, !email.isEmpty else {
            ToastMessageHelper.showToast(.emptyEmail)
            return
        }
        AuthService.instance.sendPasswordReset(email: email)
    }
}

// MARK: - UITextFieldDelegate
extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        switch textField {
            case tfEmail:
                tfPassword.becomeFirstResponder()
            
            case tfPassword:
                onSignIn(btnLogIn)
            
            default:
                MyLogE("TextField: This should never happen")
        }
        
        return true
    }
}
