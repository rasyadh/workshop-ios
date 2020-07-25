//
//  LoginViewController.swift
//  workshop
//
//  Created by Twiscode on 21/07/20.
//  Copyright © 2020 rasyadh. All rights reserved.
//

import UIKit
import SVProgressHUD

class LoginViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add button item in navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: Localify.get("login.bar_button_item.forgot"),
            style: .plain,
            target: self,
            action: #selector(forgotTouchUpInside(_:)))

        emailField.delegate = self
        passwordField.delegate = self
        
        subviewSettings()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // pass data with segue
        if segue.identifier == "showForgotPassword" {
            let forgotPasswordViewController = segue.destination as! ForgotPasswordViewController
            forgotPasswordViewController.email = "mobile@twiscode.com"
        }
    }
    
    // MARK: - Selector
    @objc func forgotTouchUpInside(_ sender: UIBarButtonItem) {
        // push view controller with segue
        performSegue(withIdentifier: "showForgotPassword", sender: self)
    }
    
    // MARK: - IBActions
    @IBAction func signInTouchUpInside(_ sender: Any) {
        if validateField() {
            SVProgressHUD.showSuccess(withStatus: Localify.get("messages.success.login"))
            SVProgressHUD.dismiss(withDelay: 1.0) { [weak self] in
                guard let self = self else { return }
                Storify.shared.loginUser()
                self.managerViewController?.showHomeScreen()
            }
        }
    }
    
    @IBAction func registerTouchUpInside(_ sender: Any) {
        // push view controller with navigation controller
        let registerViewController = UIStoryboard(name: "Auth", bundle: nil)
            .instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        // implement protocol of register delegate
        registerViewController.delegate = self
        // pass data with navigation controller
        registerViewController.name = "Mobile iOS"
        registerViewController.email = "mobile@twiscoder.com"
        navigationController?.pushViewController(registerViewController, animated: true)
    }
    
    // MARK: - Functions
    private func subviewSettings() {
        titleLabel.text = Localify.get("login.title")
        subtitleLabel.text = Localify.get("login.subtitle")
        emailField.placeholder = Localify.get("login.field.email.placeholder")
        passwordField.placeholder = Localify.get("login.field.password.placeholder")
        signInButton.setTitle(Localify.get("login.button.signin"), for: .normal)
        registerButton.setTitle(Localify.get("login.button.register"), for: .normal)
        
        signInButton.setRoundedCorner(cornerRadius: 8.0)
        registerButton.setBorderViewColor(UIColor.systemBlue)
        registerButton.setRoundedCorner(cornerRadius: 8.0)
    }
    
    private func validateField() -> Bool {
        var errors = [String]()
        
        if emailField.text!.isEmpty {
            errors.append(Localify.get("field_validation.invalid.message.email_empty"))
        } else if !emailField.text!.isValidEmail() {
            errors.append(Localify.get("field_validation.invalid.message.email_invalid"))
        }
        
        if passwordField.text!.isEmpty {
            errors.append(Localify.get("field_validation.invalid.message.password_empty"))
        } else if passwordField.text!.count < 6 {
            errors.append(Localify.get("field_validation.invalid.message.password_length"))
        }
        
        if errors.isEmpty {
            return true
        } else {
            let message = errors.joined(separator: "\n")
            Alertify.displayAlert(
                title: Localify.get("field_validation.invalid.title"),
                message: message,
                sender: self)
            return false
        }
    }
}

// MARK: - UITextField Delegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextResponder = textField.superview?.viewWithTag(textField.tag + 1) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}

// MARK: - Register Delegate
extension LoginViewController: RegisterDelegate {
    func onRegister(_ email: String) {
        emailField.text = email
    }
}
