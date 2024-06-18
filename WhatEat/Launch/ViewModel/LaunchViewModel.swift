//
//  LaunchViewModel.swift
//  WhatEat
//
//  Created by Chen William on 2024/5/14.
//

import Foundation

class LaunchViewModel: NSObject {
    
    var countyCode: String = ""
    var tagContent: String = ""
    var countryList: [CountyModel] = []
    var townList: [String: [TownModel]] = [:]
    var tempTownModel = TownModel()
    
    /// 設定預設資料
    func setupDefaultData() async {
        SQLiteDatabase.shared.storeList = SQLiteDatabase.shared.sqlSelectForModel(tableName: SQLiteDatabase.shared.storeTableName)
        SQLiteDatabase.shared.foodList = SQLiteDatabase.shared.sqlSelectForModel(tableName: SQLiteDatabase.shared.foodTableName)
        
        self.readNearSotreJsonFile()
        
        // 新增食物類型資料
        if !SQLiteDatabase.shared.checkIsExistTableValue(tableName: SQLiteDatabase.shared.foodTableName) {
            for (index, (name, image)) in FoodModel.defaultNameList.enumerated() {
                SQLiteDatabase.shared.insertFoodTable(model: FoodModel(id: index, name: name, image: image, order: index))
            }
        }
        
        // 新增地區資料
        if SQLiteDatabase.shared.checkIsExistTableValue(tableName: SQLiteDatabase.shared.bigAreaTableName) && SQLiteDatabase.shared.checkIsExistTableValue(tableName: SQLiteDatabase.shared.smallAreaTableName) {
        }
        else {
            SQLiteDatabase.shared.deleteBigAreaTable()
            SQLiteDatabase.shared.deleteSmallAreaTable()
            
            await self.getTwainConuty()
            for (index, county) in self.countryList.enumerated() {
                let bigId = BigAreaModel.countyCodeOrder.firstIndex(of: county.countyCode) ?? 0
                SQLiteDatabase.shared.insertBigAreaTable(model: BigAreaModel(id: bigId, name: county.countyName, order: bigId, countyCode: county.countyCode))
                
                await self.getTwainConuty(countyModel: county)
                
                if let townModel = self.townList[county.countyCode] {
                    for (smallId, town) in townModel.enumerated() {
                        SQLiteDatabase.shared.insertSmallAreaTable(model: SmallAreaModel(id: smallId, name: town.townName, order: smallId, bigId: bigId, towncode01: town.townCode01))
                    }
                }
            }
        }
    }
    
    func setAreaList() {
        SQLiteDatabase.shared.bigAreaList = SQLiteDatabase.shared.sqlSelectForModel(tableName: SQLiteDatabase.shared.bigAreaTableName)
        SQLiteDatabase.shared.smallAreaList = SQLiteDatabase.shared.sqlSelectForModel(tableName: SQLiteDatabase.shared.smallAreaTableName)
    }
    
    /// 取得台灣縣市清單
    private func getTwainConuty(countyModel: CountyModel? = nil) async {
        let countyCode = countyModel?.countyCode ?? ""
        let path = "https://api.nlsc.gov.tw/other/" + (countyCode.isEmpty ? "ListCounty" : "ListTown1/\(countyCode)")
        if let url = URL(string: path) {
            // GET
            do {
                let (data, _) = try await URLSession.shared.data(for: URLRequest(url: url))
                let parser = XMLParser(data: data)
                parser.delegate = self
                parser.parse()
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    /// 取得附近店家資料
    func readNearSotreJsonFile() {
        do {
            if let bundlePath = Bundle.main.path(forResource: "NearStore", ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                CommonSystemManager.shared.nearStoreList = try JSONDecoder().decode([NearStoreModel].self, from: jsonData)
            }
        }
        catch {
            print(error)
        }
    }
}

extension LaunchViewModel: XMLParserDelegate {
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        self.tagContent = ""
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        self.tagContent += string
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "countycode" {
            let model = CountyModel()
            model.countyCode = self.tagContent
            self.countryList.append(model)
        } else if elementName == "countyname" {
            self.countryList.last?.countyName = self.tagContent
        } else if elementName == "towncode" {
            self.tempTownModel = TownModel()
            self.tempTownModel.townCode = self.tagContent
        } else if elementName == "towncode01" {
            self.tempTownModel.townCode01 = tagContent
            self.countyCode = "\(self.tempTownModel.townCode01.prefix(1))"
            if self.townList[self.countyCode] == nil {
                self.townList[self.countyCode] = [self.tempTownModel]
            } else {
                self.townList[self.countyCode]?.append(self.tempTownModel)
                
            }
        } else if elementName == "townname" {
            self.tempTownModel.townName = self.tagContent
        }
    }
}
