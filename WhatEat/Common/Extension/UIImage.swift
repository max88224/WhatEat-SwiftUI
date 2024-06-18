//
//  UIImage.swift
//  WhatEat
//
//  Created by Chen William on 2024/5/17.
//

import UIKit

extension UIImage {
    
    func convertImageToBase64String() -> String? {
        guard let imageData = self.jpegData(compressionQuality: 1) else {
            return nil
        }
        return imageData.base64EncodedString()
    }
}
