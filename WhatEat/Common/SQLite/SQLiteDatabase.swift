//
//  SQLiteDatabase.swift
//  WhatEat
//
//  Created by Chen William on 2024/5/13.
//

import SQLite

class SQLiteDatabase: ObservableObject {
    
    static let shared: SQLiteDatabase = SQLiteDatabase()
    
    @Published var storeList: [StoreModel] = []
    
    @Published var foodList: [FoodModel] = []
    
    var bigAreaList: [BigAreaModel] = []
    
    var smallAreaList: [SmallAreaModel] = []
    
    var db: Connection!
    
    private init() {
        self.connectSQLiteDatabase()
        
//        self.dropStoreTable()
//        self.dropBigAreaTable()
//        self.dropSmallAreaTable()
//        self.dropFoodTable()

        self.createStoreTable()
        self.createBigAreaTable()
        self.createSmallAreaTable()
        self.createFoodTable()
    }
    
    /// 與數據庫連接
    func connectSQLiteDatabase() {
        guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            return
        }
        
        do { 
            // 與數據庫連接
            self.db = try Connection("\(path)/db.sqlite3")
        } catch {
            
        }
    }

    let storeTableName = "store" // 表名稱
    lazy var storeTable = Table(self.storeTableName) // 表
    
    let store_id = Expression<Int>("store_id")
    let store_name = Expression<String>("store_name")
    let store_foodId = Expression<Int>("store_foodId")
    let store_bigAreaId = Expression<Int>("store_bigAreaId")
    let store_smallAreaId = Expression<Int>("store_smallAreaId")
    let store_score = Expression<Int?>("store_score")
    let store_address = Expression<String>("store_address")
    let store_phone = Expression<String>("store_phone")
    let store_desc = Expression<String>("store_desc")
    let store_enterCount = Expression<Int>("store_enterCount")
    let store_image = Expression<String>("store_image")
    let store_item1 = Expression<String>("store_item1")
    let store_item2 = Expression<String>("store_item2")
    let store_item3 = Expression<String>("store_item3")
    let store_item4 = Expression<String>("store_item4")
    let store_item5 = Expression<String>("store_item5")
    let store_amount1 = Expression<String>("store_amount1")
    let store_amount2 = Expression<String>("store_amount2")
    let store_amount3 = Expression<String>("store_amount3")
    let store_amount4 = Expression<String>("store_amount4")
    let store_amount5 = Expression<String>("store_amount5")
    
    /// 創建店家資料表
    func createStoreTable() {
        let _ = try? self.db.run(
            self.storeTable.create { table in
                table.column(self.store_id, primaryKey: true) // 主键自加且不為空
                table.column(self.store_name)
                table.column(self.store_foodId)
                table.column(self.store_bigAreaId)
                table.column(self.store_smallAreaId)
                table.column(self.store_score)
                table.column(self.store_address)
                table.column(self.store_phone)
                table.column(self.store_desc)
                table.column(self.store_enterCount)
                table.column(self.store_image)
                table.column(self.store_item1)
                table.column(self.store_item2)
                table.column(self.store_item3)
                table.column(self.store_item4)
                table.column(self.store_item5)
                table.column(self.store_amount1)
                table.column(self.store_amount2)
                table.column(self.store_amount3)
                table.column(self.store_amount4)
                table.column(self.store_amount5)
            }
        )
    }
    
    /// 刪除店家資料表
    func dropStoreTable() {
        let sql = "drop table \(self.storeTableName)"
        try? self.db.execute(sql)
    }
    
    /// 新增店家
    func insertStoreTable(model: StoreModel) {
        let sql = """
                  insert into \(self.storeTableName) (store_id, store_name, store_foodId, store_bigAreaId, store_smallAreaId, store_score, store_address, store_phone, store_desc, store_enterCount, store_image, store_item1 , store_item2, store_item3, store_item4, store_item5, store_amount1, store_amount2, store_amount3, store_amount4, store_amount5)
                  values (\(model.id), "\(model.name)", \(model.foodId), \(model.bigAreaId), \(model.smallAreaId), \(model.score), "\(model.address)", "\(model.phone)", "\(model.desc)", \(model.enterCount), "\(model.image)", "\(model.item1)", "\(model.item2)", "\(model.item3)", "\(model.item4)", "\(model.item5)", "\(model.amount1)", "\(model.amount2)", "\(model.amount3)", "\(model.amount4)", "\(model.amount5)")
                  """
        try? self.db.execute(sql)
        
        self.storeList = SQLiteDatabase.shared.sqlSelectForModel(tableName: SQLiteDatabase.shared.storeTableName)
    }
    
    /// 更新店家
    func updateStoreTableEnterCount(model: StoreModel) {
        let sql = """
                  update \(self.storeTableName) set
                  store_enterCount = "\(model.enterCount + 1)"
                  where store_id = \(model.id)
                  """
        try? self.db.execute(sql)
        
        guard let id = SQLiteDatabase.shared.storeList.firstIndex(where: { $0.id == model.id }) else {
            return
        }
        self.storeList[id].enterCount += 1
    }
    
    /// 刪除店家
    func deleteStoreTable(id: Int) {
        let sql = """
                  delete from \(self.storeTableName)
                  where store_id = \(id)
                  """
        try? self.db.execute(sql)
        self.storeList = SQLiteDatabase.shared.sqlSelectForModel(tableName: SQLiteDatabase.shared.storeTableName)
    }
    
    // MARK: - 縣市
    let bigAreaTableName = "bigArea" // 表名稱
    lazy var bigAreaTable = Table(self.bigAreaTableName) // 表
    
    let bigArea_id = Expression<Int>("bigArea_id")
    let bigArea_name = Expression<String>("bigArea_name")
    let bigArea_order = Expression<Int>("bigArea_order")
    let bigArea_countyCode = Expression<String>("bigArea_countyCode")
    
    /// 創建縣市資料表
    func createBigAreaTable() {
        let _ = try? db.run(
            self.bigAreaTable.create { table in
                table.column(self.bigArea_id, primaryKey: true) // 主键自加且不為空
                table.column(self.bigArea_name)
                table.column(self.bigArea_order)
                table.column(self.bigArea_countyCode)
            }
        )
    }
    
    /// 刪除縣市資料表
    func dropBigAreaTable() {
        let sql = "drop table \(self.bigAreaTableName)"
        try? self.db.execute(sql)
    }
    
    /// 新增縣市
    func insertBigAreaTable(model: BigAreaModel) {
        let sql = """
                  insert into \(self.bigAreaTableName) (bigArea_id, bigArea_name, bigArea_order, bigArea_countyCode)
                  values (\(model.id), "\(model.name)", \(model.order), "\(model.countyCode)")
                  """
        try? self.db.execute(sql)
    }
    
    /// 更新縣市
    func updateBigAreaTable(id: Int, newModel: BigAreaModel) {
        let sql = """
                  update \(self.bigAreaTableName) set
                  bigArea_name = "\(newModel.name)",
                  bigArea_order = \(newModel.order)
                  where bigArea_id = \(id)
                  """
        try? self.db.execute(sql)
    }
    
    /// 刪除縣市
    func deleteBigAreaTable(id: Int? = nil) {
        let sqlWhere = id == nil ? "" : "where bigArea_id = \(id!)"
        let sql = """
                  delete from \(self.bigAreaTableName)
                  \(sqlWhere)
                  """
        try? self.db.execute(sql)
    }
    
    // MARK: - 區域
    let smallAreaTableName = "smallArea" // 表名稱
    lazy var smallAreaTable = Table(self.smallAreaTableName) // 表
    
    let smallArea_id = Expression<Int>("smallArea_id")
    let smallArea_name = Expression<String>("smallArea_name")
    let smallArea_order = Expression<Int>("smallArea_order")
    let smallArea_bigId = Expression<Int>("smallArea_bigId")
    let smallArea_towncode01 = Expression<String>("smallArea_towncode01")
    
    /// 創建區域資料表
    func createSmallAreaTable() {
        let _ = try? db.run(
            self.smallAreaTable.create { table in
                table.column(self.smallArea_id) // 主键自加且不為空
                table.column(self.smallArea_name)
                table.column(self.smallArea_order)
                table.column(self.smallArea_bigId)
                table.column(self.smallArea_towncode01)
                table.primaryKey(self.smallArea_id, self.smallArea_bigId)
            }
        )
    }
    
    /// 刪除區域資料表
    func dropSmallAreaTable() {
        let sql = "drop table \(self.smallAreaTableName)"
        try? self.db.execute(sql)
    }
    
    /// 新增區域
    func insertSmallAreaTable(model: SmallAreaModel) {
        let sql = """
                  insert into \(self.smallAreaTableName) (smallArea_id, smallArea_name, smallArea_order, smallArea_bigId, smallArea_towncode01)
                  values (\(model.id), "\(model.name)", \(model.order), \(model.bigId), "\(model.towncode01)")
                  """
        try? self.db.execute(sql)
    }
    
    /// 更新區域
    func updateSmallAreaTable(id: Int, newModel: SmallAreaModel) {
        let sql = """
                  update \(self.smallAreaTableName) set
                  smallArea_name = "\(newModel.name)",
                  smallArea_order = \(newModel.order),
                  smallArea_bigId = \(newModel.bigId)
                  where smallArea_id = \(id)
                  """
        try? self.db.execute(sql)
    }
    
    /// 刪除區域
    func deleteSmallAreaTable(id: Int? = nil) {
        let sqlWhere = id == nil ? "" : "where smallArea_id = \(id!)"
        let sql = """
                  delete from \(self.smallAreaTableName)
                  \(sqlWhere)
                  """
        try? self.db.execute(sql)
    }
    
    // MARK: - 類型
    let foodTableName = "food" // 表名稱
    lazy var foodTable = Table(self.foodTableName) // 表

    let food_id = Expression<Int>("food_id")
    let food_name = Expression<String>("food_name")
    let food_image = Expression<String>("food_image")
    let food_order = Expression<Int>("food_order")
    
    /// 創建食物資料表
    func createFoodTable() {
        let _ = try? self.db.run(
            self.foodTable.create { table in
                table.column(self.food_id, primaryKey: true) // 主键自加且不為空
                table.column(self.food_name)
                table.column(self.food_image)
                table.column(self.food_order)
            }
        )
    }
    
    /// 刪除食物資料表
    func dropFoodTable() {
        let sql = "drop table \(self.foodTableName)"
        try? self.db.execute(sql)
    }
    
    /// 新增食物
    func insertFoodTable(model: FoodModel) {
        let sql = """
                  insert into \(self.foodTableName) (food_id, food_name, food_image, food_order)
                  values (\(model.id), "\(model.name)", "\(model.image)", \(model.order))
                  """
        try? self.db.execute(sql)
        self.foodList = SQLiteDatabase.shared.sqlSelectForModel(tableName: SQLiteDatabase.shared.foodTableName)
    }
    
    /// 更新食物
    func updateFoodTable(id: Int, newModel: FoodModel) -> Void {
        let sql = """
                  update \(self.foodTableName) set
                  food_name = "\(newModel.name)" and
                  food_image = "\(newModel.image)" and
                  food_order = \(newModel.order)
                  where food_id = \(id)
                  """
        try? self.db.execute(sql)
        self.foodList = SQLiteDatabase.shared.sqlSelectForModel(tableName: SQLiteDatabase.shared.foodTableName)
    }
    
    /// 刪除食物
    func deleteFoodTable(id: Int) -> Void {
        let sql = """
                  delete from \(self.foodTableName)
                  where food_id = \(id)
                  """
        try? self.db.execute(sql)
        self.foodList = SQLiteDatabase.shared.sqlSelectForModel(tableName: SQLiteDatabase.shared.foodTableName)
    }
}

extension SQLiteDatabase {
    
    /// 檢查資料是否存在
    func checkIsExistTableValue(tableName: String, sqlWhere: String = "") -> Bool {
        var isExist = false
        let sql = """
                  select count(*)
                  from \(tableName)
                  \(sqlWhere)
                  """
        for row in try! self.db.prepare(sql) {
            if let count = Optional(row[0]) as? Int64, count > 0 {
                isExist = true
            }
        }
        return isExist
    }
    
    /// 找資料
    func sqlSelectForModel<T: Decodable>(tableName: String, sqlWhere: String = "", sqlOrder: String = "") -> [T] {
        var sqlJoin: String = ""
        switch tableName {
        case self.storeTableName:
            sqlJoin += " left join \(self.foodTableName) on store_foodId = food_id "
            sqlJoin += " left join \(self.bigAreaTableName) on store_bigAreaId = bigArea_Id "
            sqlJoin += " left join \(self.smallAreaTableName) on store_smallAreaId = smallArea_Id and store_bigAreaId = smallArea_bigId "
        default:
            break
        }
        
        let sql = """
                  select *
                  from \(tableName)
                  \(sqlJoin.isEmpty ? "" : sqlJoin)
                  where 1 = 1
                  \(sqlWhere)
                  \(sqlOrder.isEmpty ? "" : "order by \(sqlOrder)")
                  """
        let statement = try! self.db.prepare(sql)
        
        var resultModel: [T] = []
        var encodeObject: [[String: Any]] = []
        for row in statement {
            var columnDataList: [Any?] = []
            for columnData in row {
                columnDataList.append(columnData)
            }
            
            if columnDataList.count == statement.columnCount {
                var columnModel: [String: Any] = [:]
                for (index, columnName) in statement.columnNames.enumerated() {
                    
                    let name = columnName.replacingOccurrences(of: "\(tableName)_", with: "")
                    columnModel[name] = columnDataList[index]
                }
                encodeObject.append(columnModel)
            }
        }
        
        for object in encodeObject {
            if let data = try? JSONSerialization.data(withJSONObject: object, options: []) {
                if let model = try? JSONDecoder().decode(T.self, from: data) {
                    resultModel.append(model)
                }
            }
        }
        
        return resultModel
    }
}
