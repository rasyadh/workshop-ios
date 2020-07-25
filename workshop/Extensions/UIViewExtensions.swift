//
//  UIViewExtensions.swift
//  workshop
//
//  Created by Twiscode on 21/07/20.
//  Copyright © 2020 rasyadh. All rights reserved.
//

import UIKit

extension UIView {
    func setRoundedCorner(cornerRadius: CGFloat = 0.0, isCircular: Bool = false) {
        if isCircular {
            self.layer.cornerRadius = CGFloat(roundf(Float(self.frame.size.width / 2.0)))
        } else {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    func setCardView(cornerRadius: CGFloat, shadowSizeOffset: CGSize, shadowOpacity: Float, shadowColor: UIColor) {
        self.setRoundedCorner(cornerRadius: cornerRadius)
        let shadowPath = UIBezierPath(
            roundedRect: self.bounds,
            cornerRadius: cornerRadius)
        self.layer.masksToBounds = false
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = shadowSizeOffset
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowPath = shadowPath.cgPath
    }
    
    func setDefaultView() {
        self.setRoundedCorner(cornerRadius: 0)
        self.layer.masksToBounds = true
        self.layer.shadowColor = nil
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0
        self.layer.shadowPath = nil
    }
    
    func setGrayBorderViewColor() {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.ntGray.cgColor
        self.layer.masksToBounds = true
    }
    
    func setBorderViewColor(_ color: UIColor) {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = color.cgColor
        self.layer.masksToBounds = true
    }
}
