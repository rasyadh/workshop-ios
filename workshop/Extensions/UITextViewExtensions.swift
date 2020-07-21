//
//  UITextViewExtensions.swift
//  workshop
//
//  Created by Twiscode on 21/07/20.
//  Copyright © 2020 rasyadh. All rights reserved.
//

import UIKit

extension UITextView {
    func setGrayBorderColor() {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.ntGray.cgColor
        self.layer.masksToBounds = true
    }
}
