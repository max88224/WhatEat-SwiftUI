//
//  AddStoreViewModel.swift
//  WhatEat
//
//  Created by Chen William on 2024/5/14.
//

import Foundation
import UIKit
import _PhotosUI_SwiftUI
import SQLite

enum AddStoreViewModelRowType: CaseIterable {
    
    case name
    
    case bigArea
    
    case smallArea
    
    case food
    
    case score
    
    case address

    case image
    
    var title: String {
        switch self {
        case .name:
            "名稱"
        case .bigArea:
            "縣市"
        case .smallArea:
            "區域"
        case .food:
            "類別"
        case .score:
            "分數"
        case .address:
            "地址"
        case .image:
            "圖片"
        }
    }
    
    var placeholder: String {
        switch self {
        case .name, .bigArea, .smallArea, .food, .score, .address, .image:
            return ""
        }
    }
    
    /// 是否必填
    var isRequired: Bool {
        switch self {
        case .name, .bigArea, .smallArea, .food, .score:
            return true
        case .address, .image:
            return false
        }
    }
}

class AddStoreViewModel: ObservableObject {
    
    @Published var name: String = ""
    
    @Published var food: String = ""
    
    @Published var foodSelectedIndex: Int = 0
    
    @Published var bigArea: String = ""
    
    @Published var bigAreaSelectedIndex: Int = 0
    
    @Published var smallArea: String = ""
    
    @Published var smallAreaSelectedIndex: Int = 0
    
    @Published var address: String = ""
    
    @Published var score: Int?
    
    var pickRowType: AddStoreViewModelRowType = .bigArea
    
    let minScore: Int = 1
    
    let maxScore: Int = 5
    
    @Published var selectedImagePickItem: PhotosPickerItem?
    
    @Published var image: UIImage?
    
    var errorType: AddStoreViewModelRowType?
    
    @Published var isShowAlert: Bool = false
    
    @Published var isShowPicker: Bool = false
    
    lazy var foodNameList = SQLiteDatabase.shared.foodList.map { $0.name }
    
    lazy var bigAreaNameList = SQLiteDatabase.shared.bigAreaList.map { $0.name }
    
    var smallAreaList: [SmallAreaModel] = []
    
    init(nearStoreModel: NearStoreModel? = nil) {
        if let nearStore = nearStoreModel {
            self.name = nearStore.name
            self.address = nearStore.address
            
            if let bigIndex = SQLiteDatabase.shared.bigAreaList.firstIndex(where: { $0.countyCode == nearStore.countyCode }) {
                let bigAreaModel = SQLiteDatabase.shared.bigAreaList[bigIndex]
                self.bigArea = bigAreaModel.name
                self.bigAreaSelectedIndex = bigIndex
                
                self.smallAreaList = SQLiteDatabase.shared.smallAreaList.filter { $0.bigId == bigAreaModel.id }
                if let smallIndex = self.smallAreaList.firstIndex(where: { $0.towncode01 == nearStore.towncode01 }) {
                    self.smallArea = self.smallAreaList[smallIndex].name
                    self.smallAreaSelectedIndex = smallIndex
                }
            }
            self.image = nearStore.image.convertToBase64StringImage()!
        }
    }
    
    var checkDataList: [AddStoreViewModelRowType: String] {
        return [
            .name: self.name,
            .bigArea: self.bigArea,
            .smallArea: self.smallArea,
            .food: self.food,
            .address: self.address,
            .score: self.score == nil ? "" : String(self.score!)
        ]
    }
    
    func insetStoreToDatabase() {
        if let errorType = AddStoreViewModelRowType.allCases.first(where: { $0.isRequired && self.checkDataList[$0]!.isEmpty }) {
            self.errorType = errorType
            self.isShowAlert = true
            return
        }
        let modelList: [StoreModel] = SQLiteDatabase.shared.sqlSelectForModel(tableName: SQLiteDatabase.shared.storeTableName)
        
        let id: Int
        if let tempId = modelList.sorted(by: { $0.id > $1.id }).first?.id {
            id = tempId + 1
        }
        else {
            id = 0
        }
        let foodId = SQLiteDatabase.shared.foodList[self.foodSelectedIndex].id
        
        let smallArea = self.smallAreaList[self.smallAreaSelectedIndex]
        
        let base64String = self.image?.convertImageToBase64String() ?? ""
        
        SQLiteDatabase.shared.insertStoreTable(model: StoreModel(id: id, name: self.name, foodId: foodId, bigAreaId: smallArea.bigId, smallAreaId: smallArea.id, score: self.score!, address: self.address, image: base64String))
    }
    
    func clearAllData() {
        self.name = ""
        self.food = ""
        self.foodSelectedIndex = 0
        self.bigArea = ""
        self.bigAreaSelectedIndex = 0
        self.smallArea = ""
        self.smallAreaSelectedIndex = 0
        self.score = nil
        self.address = ""
        self.selectedImagePickItem = nil
        self.image = nil
    }
    
    func getPickerList(type: AddStoreViewModelRowType) -> [String] {
        switch type {
        case .name, .address, .score, .image:
            return []
        case .bigArea:
            return self.bigAreaNameList
        case .smallArea:
            guard !self.bigArea.isEmpty else {
                return []
            }
            self.smallAreaList = SQLiteDatabase.shared.smallAreaList.filter { $0.bigId == SQLiteDatabase.shared.bigAreaList[self.bigAreaSelectedIndex].id }
            return self.smallAreaList.map { $0.name }
        case .food:
            return self.foodNameList
        }
    }
    
    func getPickerIndex(type: AddStoreViewModelRowType) -> Int? {
        switch type {
        case .name, .address, .score, .image:
            return 0
        case .bigArea:
            return self.bigAreaSelectedIndex
        case .smallArea:
            guard !self.bigArea.isEmpty else {
                return nil
            }
            return self.smallAreaSelectedIndex
        case .food:
            return self.foodSelectedIndex
        }
    }
    
    func setPickerSelected(type: AddStoreViewModelRowType) {
        guard let index = self.getPickerIndex(type: type) else {
            return
        }
        let stringValue = self.getPickerList(type: type)[index]
        switch type {
        case .name, .address, .score, .image:
            break
        case .bigArea:
            self.bigArea = stringValue
        case .smallArea:
            self.smallArea = stringValue
        case .food:
            self.food = stringValue
        }
    }
}
