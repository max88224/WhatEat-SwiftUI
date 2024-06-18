//
//  CommonSystemManager.swift
//  WhatEat
//
//  Created by Chen William on 2024/5/13.
//

import Foundation
import SwiftUI

class CommonSystemManager: ObservableObject {
    
    static let shared = CommonSystemManager()
    
    private init() { }
    
    @Published var tabViewVisibility: Visibility = .visible
    
    var nearStoreList: [NearStoreModel] = []
}
