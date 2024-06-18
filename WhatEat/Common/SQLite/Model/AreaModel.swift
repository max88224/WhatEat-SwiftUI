//
//  AreaModel.swift
//  WhatEat
//
//  Created by Chen William on 2024/5/13.
//

import Foundation

struct BigAreaModel: Decodable {
    let id: Int
    let name: String
    let order: Int
    let countyCode: String
    
    static let countyCodeOrder: [String] = [
        "C", // 基隆市
        "A", // 臺北市
        "F", // 新北市
        "H", // 桃園市
        "O", // 新竹市
        "J", // 新竹縣
        "K", // 苗栗縣
        "B", // 臺中市
        "N", // 彰化縣
        "M", // 南投縣
        "P", // 雲林縣
        "I", // 嘉義市
        "Q", // 嘉義縣
        "D", // 臺南市
        "E", // 高雄市
        "T", // 屏東縣
        "G", // 宜蘭縣
        "U", // 花蓮縣
        "V", // 臺東縣
        "W", // 金門縣
        "X", // 澎湖縣
        "Z" // 連江縣
    ]
}

struct SmallAreaModel: Decodable {
    let id: Int
    let name: String
    let order: Int
    let bigId: Int
    let towncode01: String
}
