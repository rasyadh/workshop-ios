//
//  ForgotPasswordViewController.swift
//  workshop
//
//  Created by Twiscode on 25/07/20.
//  Copyright © 2020 rasyadh. All rights reserved.
//

import UIKit
import SVProgressHUD

class ForgotPasswordViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    // MARK: - Variables
    var email: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailField.delegate = self
        
        subviewSettings()
    }
    
    // MARK: - IBAction
    @IBAction func forgotPasswordTouchUpInside(_ sender: Any) {
        if validateField() {
            SVProgressHUD.showSuccess(withStatus: Localify.get("messages.success"))
            SVProgressHUD.dismiss(withDelay: 1.0) { [weak self] in
                guard let self = self else { return }
                // pop view controller from the stack
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    // MARK: - Functions
    private func subviewSettings() {
        titleLabel.text = Localify.get("forgot_password.title")
        subtitleLabel.text = Localify.get("forgot_password.subtitle")
        emailField.placeholder = Localify.get("forgot_password.field.email.placeholder")
        forgotPasswordButton.setTitle(Localify.get("forgot_password.button.forgot"), for: .normal)
        
        forgotPasswordButton.setBorderViewColor(UIColor.systemBlue)
        forgotPasswordButton.setRoundedCorner(cornerRadius: 8.0)
        
        // set email to emailField if it's not nill
        guard email != nil else { return }
        emailField.text = email
    }
    
    private func validateField() -> Bool {
        var errors = [String]()
        
        if emailField.text!.isEmpty {
            errors.append(Localify.get("field_validation.invalid.message.email_empty"))
        } else if !emailField.text!.isValidEmail() {
            errors.append(Localify.get("field_validation.invalid.message.email_invalid"))
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
extension ForgotPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
