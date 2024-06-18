//
//  FoodModel.swift
//  WhatEat
//
//  Created by Chen William on 2024/5/13.
//

import Foundation

struct FoodModel: Decodable {
    let id: Int
    let name: String
    let image: String
    let order: Int
    
    static let imageList = [
        "🍲",
        "🥟",
        "🍛",
        "🍝",
        "🥩",
        "🍔",
        "🥚",
        "🌭",
        "🍕",
        "🍳",
        "🥪",
        "🥗",
        "🍱",
        "🍢",
        "🍣",
        "🦀",
        "🦐",
        "🍞",
        "🌽",
        "🍺"
    ]
    
    static let defaultNameList: [String: String] = [
        "火鍋": "🍲",
        "水餃": "🥟",
        "咖喱飯": "🍛",
        "義大利麵": "🍝",
        "牛排": "🥩",
        "速食": "🍔"
    ]
}
