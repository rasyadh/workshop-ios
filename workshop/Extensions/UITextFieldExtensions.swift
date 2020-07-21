//
//  UITextFieldExtensions.swift
//  workshop
//
//  Created by Twiscode on 21/07/20.
//  Copyright © 2020 rasyadh. All rights reserved.
//

import UIKit

extension UITextField {
    func setGrayBorderColor() {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.ntGray.cgColor
        self.layer.masksToBounds = true
    }
    
    func setPadding(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
