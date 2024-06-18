//
//  String.swift
//  WhatEat
//
//  Created by Chen William on 2024/5/17.
//

import Foundation
import UIKit

extension String {
    
    func convertToBase64StringImage() -> UIImage? {
        guard let imageData = Data(base64Encoded: self) else {
            return nil
        }
        return UIImage(data: imageData)
    }
}
