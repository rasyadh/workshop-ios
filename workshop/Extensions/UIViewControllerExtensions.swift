//
//  UIViewControllerExtensions.swift
//  workshop
//
//  Created by Twiscode on 21/07/20.
//  Copyright © 2020 rasyadh. All rights reserved.
//

import UIKit

enum ToolbarPickerType {
    case gender,
    birthDate
}

extension UIViewController {
    // MARK: - Navigation Bar
    func configureTransparentNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = nil
        navigationController?.navigationBar.isTranslucent = true
    }
    
    func configureColorNavigationBar(_ color: UIColor, isTranslucent: Bool = true, withShadow: Bool = true) {
        if withShadow {
            navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
            navigationController?.navigationBar.shadowImage = nil
        } else {
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.shadowImage = UIImage()
        }
        navigationController?.navigationBar.barTintColor = color
        navigationController?.navigationBar.isTranslucent = isTranslucent
    }
    
    func showNavigationBarColor() {
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = true
    }
    
    func showNavigationBar() {
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.barTintColor = nil
    }
    
    func hideNavigationBarShadow() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = nil
    }
    
    func showNavigationBarShadow() {
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.barTintColor = nil
    }
    
    func omitNavBackButtonTitle() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
    }
    
    func hideNavBackButton() {
        navigationItem.setHidesBackButton(true, animated: true)
    }
    
    func setBarButtonImageView(imageName: String) -> UIBarButtonItem {
        let logo = UIImage(named: imageName)
        let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.image = logo
        logoImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        return UIBarButtonItem(customView: logoImageView)
    }
    
    func setNavigationLeft(title: String) -> UIBarButtonItem {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = .black
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18.0)
        
        return UIBarButtonItem(customView: titleLabel)
    }
    
    func setNavigationLeft(imageNamed: String, width: CGFloat, height: CGFloat) -> UIBarButtonItem {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        imageView.tintColor = UIColor.white
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: imageNamed)
        imageView.widthAnchor.constraint(equalToConstant: width).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        return UIBarButtonItem(customView: imageView)
    }
    
    // MARK: - Dismiss Keyboard
    func hideKeyboardWhenTapped() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // MARK: - Tab Bar
    func showTabBarTopBorder(_ color: CGColor, _ height: CGFloat = 1.0) {
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: height)
        topBorder.backgroundColor = color
        tabBarController?.tabBar.layer.addSublayer(topBorder)
        tabBarController?.tabBar.clipsToBounds = true
    }
    
    // MARK: - Toolbar Picker
    func createToolbarPicker(_ type: ToolbarPickerType) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        var done = UIBarButtonItem()
        switch type {
        case .gender:
            done = UIBarButtonItem(title: Localify.get("toolbar.done"), style: .plain, target: self, action: #selector(genderPickerTouchUpInside(_:)))
        case .birthDate:
            done = UIBarButtonItem(title: Localify.get("toolbar.done"), style: .plain, target: self, action: #selector(birthDatePickerTouchUpInside(_:)))
        }
        let cancel = UIBarButtonItem(title: Localify.get("toolbar.cancel"), style: .plain, target: self, action: #selector(cancelPickerTouchUpInside(_:)))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.setItems([cancel, space, done], animated: false)
        
        return toolbar
    }
    
    @objc func cancelPickerTouchUpInside(_ sender: Any) {
        self.view.endEditing(true)
    }
    @objc func genderPickerTouchUpInside(_ sender: Any) {}
    @objc func birthDatePickerTouchUpInside(_ sender: Any) {}
}
