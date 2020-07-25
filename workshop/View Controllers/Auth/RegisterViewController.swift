//
//  RegisterViewController.swift
//  workshop
//
//  Created by Twiscode on 25/07/20.
//  Copyright © 2020 rasyadh. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol RegisterDelegate {
    func onRegister(_ email: String)
}

class RegisterViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    // MARK: - Variables
    var delegate: RegisterDelegate?
    var name: String!
    var email: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        
        subviewSettings()
    }
    
    // MARK: - IBAction
    @IBAction func registerTouchUpInside(_ sender: Any) {
        if validateField() {
            SVProgressHUD.showSuccess(withStatus: Localify.get("messages.success.register"))
            SVProgressHUD.dismiss(withDelay: 1.0) { [weak self] in
                // pass data back to parent view controller with delegation pattern
                self?.delegate?.onRegister(self?.emailField.text ?? "")
                // pop view controller from the stack
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    // MARK: - Functions
    private func subviewSettings() {
        titleLabel.text = Localify.get("register.title")
        subtitleLabel.text = Localify.get("register.subtitle")
        nameField.placeholder = Localify.get("register.field.name.placeholder")
        emailField.placeholder = Localify.get("register.field.email.placeholder")
        passwordField.placeholder = Localify.get("register.field.password.placeholder")
        registerButton.setTitle(Localify.get("register.button.register"), for: .normal)
        
        registerButton.setBorderViewColor(UIColor.systemBlue)
        registerButton.setRoundedCorner(cornerRadius: 8.0)
        
        // set name and email if it's not nill
        if let name = self.name {
            nameField.text = name
        }
        if let email = self.email {
            emailField.text = email
        }
    }
    
    private func validateField() -> Bool {
        var errors = [String]()
        
        if nameField.text!.isEmpty {
            errors.append(Localify.get("field_validation.invalid.message.name_empty"))
        }
        
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
extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextResponder = textField.superview?.viewWithTag(textField.tag + 1) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
