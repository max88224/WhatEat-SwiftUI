//
//  HomeViewModel.swift
//  WhatEat
//
//  Created by Chen William on 2024/5/13.
//

import Foundation

enum HomeViewModelRowType: CaseIterable {
    
    case hello
    
    case near
    
    case foodType
    
    case featured
    
    case random
    
    var title: String {
        switch self {
        case .hello:
            return ""
        case .near:
            return "附近店家"
        case .foodType:
            return "所有類型"
        case .featured:
            return "你的精選"
        case .random:
            return "幫你隨機選擇"
        }
    }
}

class HomeViewModel: ObservableObject {
    
    private(set) var timePeriodType: TimePeriodType = .morning
    
    var selectedNearStoreModel: NearStoreModel?
    
    var isNavigationAppear: Bool = false
    
    @Published var randomId: Int?
    
    @Published var featuredId: Int?
    
    @Published var isShowActionSheet = false
    
    @Published var isShowAddStoreSheet = false
    
    @Published var isShowAddFoodSheet = false
    
    init() {
        self.setTimePeriodType()
        self.setFeaturedStoreId()
        self.setRandomStoreId()
    }
    
    func setTimePeriodType() {
        // 獲取當前時間
        let currentTime = Date()
        
        // 創建一個日曆對象
        let calendar = Calendar.current
        
        // 獲取當前時間的小時
        let hour = calendar.component(.hour, from: currentTime)
        
        // 根據小時判斷是早上、下午還是晚上
        if (6..<12).contains(hour) {
            self.timePeriodType = .morning
        } else if (12..<18).contains(hour) {
            self.timePeriodType = .afternoon
        } else {
            self.timePeriodType = .night
        }
    }
    
    /// 精選店家
    func setFeaturedStoreId() {
        guard let id = SQLiteDatabase.shared.storeList.sorted(by: { $0.enterCount > $1.enterCount }).prefix(10).shuffled().first?.id else {
            return
        }
        self.featuredId = id
    }
    
    /// 隨機選擇店家
    func setRandomStoreId() {
        if let randomId = self.randomId, let id = SQLiteDatabase.shared.storeList.filter({ $0.id != self.randomId }).shuffled().first?.id {
            self.randomId = id
        }
        else {
            self.randomId = SQLiteDatabase.shared.storeList.shuffled().first?.id
        }
    }
    
    func changeStoreListData() {
        if !SQLiteDatabase.shared.storeList.contains(where: { $0.id == self.featuredId }) {
            self.featuredId = nil
        }
        if !SQLiteDatabase.shared.storeList.contains(where: { $0.id == self.randomId }) {
            self.randomId = nil
        }
        
        if self.featuredId == nil {
            self.setFeaturedStoreId()
        }
        if self.randomId == nil {
            self.setRandomStoreId()
        }
    }
}
