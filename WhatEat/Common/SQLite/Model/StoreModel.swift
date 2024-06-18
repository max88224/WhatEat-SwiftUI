//
//  StoreModel.swift
//  WhatEat
//
//  Created by Chen William on 2024/5/13.
//

import Foundation

struct StoreModel: Decodable {
    var id: Int
    /// 名稱
    var name: String = ""
    /// 食物識別碼
    var foodId: Int = 0
    /// 食物名稱
    var foodName: String = ""
    /// 縣市識別碼
    var bigAreaId: Int = 0
    /// 縣市名稱
    var bigAreaName: String = ""
    /// 區域識別碼
    var smallAreaId: Int = 0
    /// 區域名稱
    var smallAreaName: String = ""
    /// 分數
    var score: Int = 0
    /// 地址
    var address: String = ""
    /// 電話號碼
    var phone: String = ""
    /// 備註
    var desc: String = ""
    /// 進入頁面次數
    var enterCount: Int = 0
    var image: String = ""
    
    var item1: String = ""
    var item2: String = ""
    var item3: String = ""
    var item4: String = ""
    var item5: String = ""
    var amount1: String = ""
    var amount2: String = ""
    var amount3: String = ""
    var amount4: String = ""
    var amount5: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case foodId
        case foodName = "food_name"
        case bigAreaId
        case bigAreaName = "bigArea_name"
        case smallAreaId
        case smallAreaName = "smallArea_name"
        case score
        case address
        case phone
        case desc
        case enterCount
        case image
        case item1
        case item2
        case item3
        case item4
        case item5
        case amount1
        case amount2
        case amount3
        case amount4
        case amount5
    }
    
    var displayScore: String {
        String(repeating: "💛", count: self.score)
    }
}
