//
//  NearStoreModel.swift
//  WhatEat
//
//  Created by Chen William on 2024/5/19.
//

import Foundation

class NearStoreModel: Decodable {
    
    /// 名稱
    let name: String
    /// 地址
    let address: String
    /// 圖片
    let image: String
    /// 縣市代碼
    let countyCode: String
    /// 區域代碼
    let towncode01: String
}
