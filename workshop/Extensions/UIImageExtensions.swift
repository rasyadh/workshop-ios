//
//  UIImageExtensions.swift
//  workshop
//
//  Created by Twiscode on 21/07/20.
//  Copyright © 2020 rasyadh. All rights reserved.
//

import UIKit

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    func compressImage(_ quality: JPEGQuality) -> Data? {
        return self.jpegData(compressionQuality: quality.rawValue)
    }
    
    func scaledImageByWidth(scaledToWidth: CGFloat) -> UIImage {
        let oldWidth = self.size.width
        let scaleFactor = scaledToWidth / oldWidth
        
        let newHeight = self.size.height * scaleFactor
        let newWidth = oldWidth * scaleFactor
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    func scaledImageByHeight(scaledToHeight: CGFloat) -> UIImage {
        let oldHeight = self.size.height
        let scaleFactor = scaledToHeight / oldHeight
        
        let newWidth = self.size.width * scaleFactor
        let newHeight = oldHeight * scaleFactor
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
