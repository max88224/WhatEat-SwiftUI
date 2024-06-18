//
//  AddFoodViewModel.swift
//  WhatEat
//
//  Created by Chen William on 2024/5/22.
//

import Foundation

enum AddFoodViewModelRowType: CaseIterable {
    case name
    case image
    
    var title: String {
        switch self {
        case .name:
            "類別"
        case .image:
            "圖示"
        }
    }
    
    /// 是否必填
    var isRequired: Bool {
        switch self {
        case .name, .image:
            return true
        }
    }
}

class AddFoodViewModel: ObservableObject {
    
    @Published var name: String = ""
    
    var image: String = ""
    
    @Published var imageSelectedIndex: Int?
    
    @Published var isShowAlert: Bool = false
    
    var errorType: AddFoodViewModelRowType?
    
    var checkDataList: [AddFoodViewModelRowType: String] {
        return [
            .name: self.name,
            .image: self.image
        ]
    }
    
    func insetFoodToDatabase() {
        if let errorType = AddFoodViewModelRowType.allCases.first(where: { $0.isRequired && self.checkDataList[$0]!.isEmpty }) {
            self.errorType = errorType
            self.isShowAlert = true
            return
        }
        
        let modelList: [FoodModel] = SQLiteDatabase.shared.sqlSelectForModel(tableName: SQLiteDatabase.shared.foodTableName)
        
        let id: Int
        if let tempId = modelList.sorted(by: { $0.id > $1.id }).first?.id {
            id = tempId + 1
        }
        else {
            id = 0
        }
        
        SQLiteDatabase.shared.insertFoodTable(model: FoodModel(id: id, name: name, image: image, order: id))
    }
    
    func clearAllData() {
        self.name = ""
        self.image = ""
        self.imageSelectedIndex = nil
    }
}
