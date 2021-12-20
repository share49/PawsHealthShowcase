//
//  RegisterViewController.swift
//  Hoowie
//
//  Created by Roger Pintó Diaz on 7/14/18.
//  Copyright © 2018 Roger Pintó Diaz. All rights reserved.
//

import Firebase
import UIKit

final class RegisterViewController: SignInWithAppleBaseController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var lblConfirmPassword: UILabel!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfConfirmPassword: UITextField!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var vContainerOr: UIView!
    @IBOutlet weak var lblOr: UILabel!
    @IBOutlet weak var lblAlreadyHaveAnAccount: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Initializers
    static func create() -> UIViewController {
        let vc = UIStoryboard(name: "SignIn", bundle: Bundle.main).instantiateViewController(withIdentifier: "RegisterVC")
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
    
    // MARK: - ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTapGestureRecognizerToHideKeyboardTappingOutsideIt()
        setupTextFields()
        setupView()
        setupSignInWithAppleButton()
    }
    
    deinit {
        MyLogD("Dealloc: \(self)")
    }
    
    // MARK: - UI methods
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private func setupTextFields() {
        tfEmail.delegate = self
        tfPassword.delegate = self
        tfConfirmPassword.delegate = self
    }
    
    private func setupView() {
        setupButtons()
        //lblSignIn.textColor = .gray
        activityIndicator.alpha = 0
        lblPassword.text = ls.password()
        lblConfirmPassword.text = ls.confirmPassword()
        lblOr.text = ls.or()
        lblAlreadyHaveAnAccount.text = ls.already_have_an_account_q()
        lblAlreadyHaveAnAccount.textColor = .gray
    }
    
    private func setupButtons() {
        btnRegister.shadow()
        btnRegister.circularView()
        btnRegister.setTitle(ls.register(), for: UIControl.State())
        btnSignIn.setTitle(ls.sign_in(), for: UIControl.State())
    }

    private func setupSignInWithAppleButton() {
        view.addSubview(btnSignInWithApple)

        btnSignInWithApple.topAnchor.constraint(equalTo: vContainerOr.bottomAnchor, constant: 25).isActive = true
        btnSignInWithApple.widthAnchor.constraint(equalTo: btnRegister.widthAnchor, constant: 0).isActive = true
        btnSignInWithApple.heightAnchor.constraint(equalTo: btnRegister.heightAnchor, constant: 0).isActive = true
        btnSignInWithApple.centerXAnchor.constraint(equalTo: btnRegister.centerXAnchor, constant: 0).isActive = true
    }
    
    // MARK: - onButton Actions
    @IBAction func onLogIn(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func onRegister(_ sender: UIButton) {
        guard let email = tfEmail.text, email.count >= 5, email.contains("@"), email.contains(".") else {
            ToastMessageHelper.showToast(.invalidEmail)
            return
        }

        guard let password = tfPassword.text, password.count >= 8 else {
            ToastMessageHelper.showToast(.invalidPassword)
            return
        }

        guard password == tfConfirmPassword.text else {
            ToastMessageHelper.showToast(.passwordDontMatch)
            return
        }

        Utils.startActivityIndicator(activityIndicator: activityIndicator)

        AuthService.instance.registerUser(email: email, password: password, onCompletion: { (success, registrationError) in
            Utils.stopActivityIndicator(activityIndicator: self.activityIndicator)

            if success {
                AuthService.instance.loginUser(email: self.tfEmail.text!, password: self.tfPassword.text!, onCompletion: { (success, _) in
                    MyLogI("Successfully registered user")
                    onMain {
                        self.dismiss(animated: true) {
                            Utils.topViewController().dismiss(animated: true) {
                                ToastMessageHelper.showToast(.registerSuccess)
                            }
                        }
                    }
                })
            } else if let err = registrationError {
                let message = err.localizedDescription
                ToastMessageHelper.showToastWithMessage(message)
                MyLogE("Firebase: Register: \(message)")
            }
        })
    }
}

// MARK: - UITextFieldDelegate
extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        switch textField {
            case tfEmail:
                tfPassword.becomeFirstResponder()
            
            case tfPassword:
                tfConfirmPassword.becomeFirstResponder()

            case tfConfirmPassword:
                onRegister(btnRegister)
            
            default:
                MyLogE("TextField: This should never happen")
        }
        
        return true
    }
}
