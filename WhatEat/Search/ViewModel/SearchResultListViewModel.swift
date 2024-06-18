//
//  SearchResultListViewModel.swift
//  WhatEat
//
//  Created by Chen William on 2024/5/16.
//

import Foundation

enum FilterType: CaseIterable {
    case bigArea
    case smallArea
    case food
    
    var title: String {
        switch self {
        case .food:
            "類別"
        case .bigArea:
            "縣市"
        case .smallArea:
            "區域"
        }
    }
}

class SearchResultListViewModel: ObservableObject {
    
    var isNavigationAppear: Bool
    
    var filterModel: SearchFilterModel
    
    var storeList: [StoreModel] = []
    
    let foodList: [FoodModel] = SQLiteDatabase.shared.foodList
    
    let bigAreaList: [BigAreaModel] = SQLiteDatabase.shared.bigAreaList
    
    var smallAreaList: [SmallAreaModel] = []
    
    @Published var selectedFoodIndex: Int?
    
    @Published var selectedBigAreaIndex: Int?
    
    @Published var selectedSmallAreaIndex: Int?
    
    @Published var selectedFilterType: FilterType = .food
    
    @Published var isDropDown: Bool = false
    
    init(filterModel: SearchFilterModel, isNavigationAppear: Bool = false) {
        self.filterModel = filterModel
        self.isNavigationAppear = isNavigationAppear
        if let index = self.foodList.firstIndex(where: { $0.id == filterModel.foodId }) {
            self.selectedFoodIndex = index
        }
        self.setStoreList()
    }
    
    private func setStoreList() {
        var sqlWhere: String = ""
        FilterType.allCases.forEach { type in
            switch type {
            case .food:
                if let id = self.filterModel.foodId {
                    sqlWhere += " and store_foodId = \(id) "
                }
            case .bigArea:
                if let id = self.filterModel.bigAreaId {
                    sqlWhere += " and store_bigAreaId = \(id) "
                }
            case .smallArea:
                if let id = self.filterModel.smallAreaId {
                    sqlWhere += " and store_smallAreaId = \(id) "
                }
            }
        }
        self.storeList = SQLiteDatabase.shared.sqlSelectForModel(tableName: SQLiteDatabase.shared.storeTableName, sqlWhere: sqlWhere)
    }
    
    func clearAllFilter() {
        self.selectedFoodIndex = nil
        self.selectedBigAreaIndex = nil
        self.selectedSmallAreaIndex = nil
        self.smallAreaList.removeAll()
        self.filterModel = SearchFilterModel()
        self.setStoreList()
    }
    
    func getDropDownList() -> [String] {
        switch self.selectedFilterType {
        case .food:
            return self.foodList.map { $0.name }
        case .bigArea:
            return self.bigAreaList.map { $0.name }
        case .smallArea:
            return self.smallAreaList.map { $0.name }
        }
    }
    
    func getSelectedName(type: FilterType) -> String? {
        switch type {
        case .food:
            guard let index = self.selectedFoodIndex else {
                return nil
            }
            return self.foodList[index].name
        case .bigArea:
            guard let index = self.selectedBigAreaIndex else {
                return nil
            }
            return self.bigAreaList[index].name
        case .smallArea:
            guard let index = self.selectedSmallAreaIndex else {
                return nil
            }
            return self.smallAreaList[index].name
        }
    }
    
    func setDropDownSelected(index: Int) {
        switch self.selectedFilterType {
        case .food:
            self.selectedFoodIndex = index
            self.filterModel.foodId = self.foodList[index].id
        case .bigArea:
            self.selectedBigAreaIndex = index
            self.filterModel.bigAreaId = self.bigAreaList[index].id
            
            self.selectedSmallAreaIndex = nil
            self.smallAreaList = SQLiteDatabase.shared.smallAreaList.filter { $0.bigId == self.bigAreaList[index].id }
        case .smallArea:
            self.selectedSmallAreaIndex = index
            self.filterModel.smallAreaId = self.smallAreaList[index].id
        }
        self.setStoreList()
    }
}
