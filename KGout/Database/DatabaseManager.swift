//
//  DatabaseManager.swift
//  Gout
//
//  Created by khstar on 2018. 8. 29..
//  Copyright © 2018년 khstar. All rights reserved.
//

import Foundation
import SQLite3

class DatabaseManager {
    
    var password:String = ""
    var rc: Int32 = 0
    var db: OpaquePointer? = nil
    var stmt: OpaquePointer? = nil
    
    let fileManager = GoutFileManager.sharedInstance()
    
    private init() {}
    
    struct StaticInstance {
        static var databaseManager:DatabaseManager?
    }
    
    public class func sharedInstance() -> DatabaseManager {
        if StaticInstance.databaseManager == nil {
            StaticInstance.databaseManager = DatabaseManager()
        }
        
        return StaticInstance.databaseManager!
    }
    
    /**
     DatabaseManager Key 설정
     - Parameter password : 데이터 베이스 암호화에 사용할 패스워드
     */
    func setPassword(password:String) {
        self.password = password
    }
    
    /**
     Gout 데이터 베이스를 만든다.
    */
    func createDatabase() {

        let dbFileFullPath = fileManager.getDBFilePath()
        
        rc = sqlite3_open(dbFileFullPath, &db)
        if (rc != SQLITE_OK) {
            let errmsg = String(cString: sqlite3_errmsg(db))
            NSLog("Error opening database: \(errmsg)")
            return
        }
        
        createTable()
    }
    
    private func createTable() {
        let createGout = "CREATE TABLE if not exists tb_gout (id INTEGER PRIMARY KEY AUTOINCREMENT, reg_dt text, reg_time text, uric_acid_value real, kidney_value real, liver_ggt_value real, gout_desc text)"
        rc = sqlite3_exec(db, createGout, nil, nil, nil)
        if (rc != SQLITE_OK) {
            let errmsg = String(cString: sqlite3_errmsg(db))
            NSLog("sqlite3_exec key: \(errmsg)")
        }
        
        let createUserInfo = "CREATE TABLE if not exists tb_user_info (id INTEGER PRIMARY KEY AUTOINCREMENT, name text, birthday text, age text, height_value text, weight_value text, user_desc text)"
        rc = sqlite3_exec(db, createUserInfo, nil, nil, nil)
        if (rc != SQLITE_OK) {
            let errmsg = String(cString: sqlite3_errmsg(db))
            NSLog("sqlite3_exec key: \(errmsg)")
        }
        
        let createDrugInfo = "CREATE TABLE if not exists tb_drug_info (id INTEGER PRIMARY KEY AUTOINCREMENT, drug_name text, drug_img text, drug_desc text)"
        rc = sqlite3_exec(db, createDrugInfo, nil, nil, nil)
        if (rc != SQLITE_OK) {
            let errmsg = String(cString: sqlite3_errmsg(db))
            NSLog("sqlite3_exec key: \(errmsg)")
        }
        
        let createDrugAlarm = "CREATE TABLE if not exists tb_drug_alarm (id INTEGER PRIMARY KEY AUTOINCREMENT, drug_id INTEGER, alarm_time text, alarm_sound text, alarm_enable INTEGER, all_week INTEGER, monday INTEGER, tuesday INTEGER, wednesday INTEGER, thursday INTEGER, friday INTEGER, saturday INTEGER, sunday INTEGER, repeat_time INTEGER, alarm_desc text, CONSTRAINT drugId_fk FOREIGN KEY (drug_id) REFERENCES tb_drug_info(id))"
        rc = sqlite3_exec(db, createDrugAlarm, nil, nil, nil)
        if (rc != SQLITE_OK) {
            let errmsg = String(cString: sqlite3_errmsg(db))
            NSLog("sqlite3_exec key: \(errmsg)")
        }
        
        sqlite3_finalize(stmt)
        sqlite3_close(db)
    }
    
    func selectUserInfo() -> UserInfo? {
        
        var rc: Int32 = 0
        var db: OpaquePointer? = nil
        let dbFileFullPath = fileManager.getDBFilePath()
        var userInfo:UserInfo? = nil
        
        rc = sqlite3_open(dbFileFullPath, &db)
        
        if (rc != SQLITE_OK) {
            let errmsg = String(cString: sqlite3_errmsg(db))
            NSLog("Error opening database: \(errmsg)")
        }
        
        let queryStatementString = "select * from tb_user_info;"
        var queryStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                
                let col1        = sqlite3_column_int(queryStatement, 0)
                let name        = String(cString: sqlite3_column_text(queryStatement, 1))
                let birthDay    = String(cString: sqlite3_column_text(queryStatement, 2))
                let age         = String(cString: sqlite3_column_text(queryStatement, 3))
                let height      = String(cString: sqlite3_column_text(queryStatement, 4))
                let weight      = String(cString: sqlite3_column_text(queryStatement, 5))
                
                
                userInfo = UserInfo()
                userInfo!.id            = Int(col1)
                userInfo!.userName      = name
                userInfo!.userBirthDay  = birthDay
                userInfo!.userAge       = age
                userInfo!.userHeight    = height
                userInfo!.userWeight    = weight
            }
        } else {
            // Fail
            NSLog("Query Failed: \(queryStatementString)")
        }
        
        sqlite3_finalize(queryStatement)
        
        return userInfo
    }
    
    func upsertUserInfo(userInfo:UserInfo) -> Bool{
        
        if userInfo.id < 0 {
            return insertUserInfo(userInfo: userInfo)
        } else {
            return updateUserInfo(userInfo: userInfo)
        }
    }
    
    func insertUserInfo(userInfo:UserInfo) -> Bool {
        var rc: Int32 = 0
        var db: OpaquePointer? = nil
        let dbFileFullPath = fileManager.getDBFilePath()
        
        rc = sqlite3_open(dbFileFullPath, &db)
        
        if (rc != SQLITE_OK) {
            let errmsg = String(cString: sqlite3_errmsg(db))
            NSLog("Error opening database: \(errmsg)")
            return false
        }
        
        var createGout = "INSERT INTO tb_user_info (name, birthday, age, height_value, weight_value, user_desc) VALUES "
        createGout.append("('\(userInfo.userName)', '\(userInfo.userBirthDay)', '\(userInfo.userAge)', '\(userInfo.userHeight)', '\(userInfo.userWeight)', '\(userInfo.userDesc)');")
        
        rc = sqlite3_exec(db, createGout, nil, nil, nil)
        if (rc != SQLITE_OK) {
            let errmsg = String(cString: sqlite3_errmsg(db))
            NSLog("sqlite3_exec key: \(errmsg)")
            return false
        }
        
        return true
    }
    
    func updateUserInfo(userInfo:UserInfo) -> Bool {
        var rc: Int32 = 0
        var db: OpaquePointer? = nil
        let dbFileFullPath = fileManager.getDBFilePath()
        
        rc = sqlite3_open(dbFileFullPath, &db)
        
        if (rc != SQLITE_OK) {
            let errmsg = String(cString: sqlite3_errmsg(db))
            NSLog("Error opening database: \(errmsg)")
            return false
        }
        
//        rc = sqlite3_key(db, password, Int32(password.utf8CString.count))
//        sqlite3_
        
        
        
//        if (rc != SQLITE_OK) {
//            let errmsg = String(cString: sqlite3_errmsg(db))
//            NSLog("Error setting key: \(errmsg)")
//        }
        
        var updateGoutValue = "UPDATE tb_user_info SET "
        updateGoutValue.append("name = '\(userInfo.userName)', ")
        updateGoutValue.append("birthday = '\(userInfo.userBirthDay)', ")
        updateGoutValue.append("age = '\(userInfo.userAge)', ")
        updateGoutValue.append("height_value = '\(userInfo.userHeight)', ")
        updateGoutValue.append("weight_value = '\(userInfo.userWeight)', ")
        updateGoutValue.append("user_desc = '\(userInfo.userDesc)' ")
        updateGoutValue.append("WHERE ")
        updateGoutValue.append("id = \(userInfo.id)")
        
        sqlite3_finalize(stmt)
        stmt = nil
        
        if sqlite3_prepare_v2(db, updateGoutValue, -1, &stmt, nil)  == SQLITE_OK {
            return true
        }
        
        rc = sqlite3_exec(db, updateGoutValue, nil, nil, nil)
        if (rc != SQLITE_OK) {
            let errmsg = String(cString: sqlite3_errmsg(db))
            NSLog("sqlite3_exec key: \(errmsg)")
        }
        
        return true
    }
    
    func selectGoutId(date:String) -> Int {
        
        var rc: Int32 = 0
        var db: OpaquePointer? = nil
        let dbFileFullPath = fileManager.getDBFilePath()
        var goutId = -1
        
        rc = sqlite3_open(dbFileFullPath, &db)
        
        if (rc != SQLITE_OK) {
            let errmsg = String(cString: sqlite3_errmsg(db))
            NSLog("Error opening database: \(errmsg)")
        }
        
        let queryStatementString = "select id from tb_gout WHERE reg_dt = '\(date)' ;"
        var queryStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                
                let col1 = sqlite3_column_int(queryStatement, 0)
                goutId = Int(col1)
            }
        } else {
            // Fail
            NSLog("Query Failed: \(queryStatementString)")
        }
        
        sqlite3_finalize(queryStatement)
        
        return goutId
    }
    
    func upsertGoutValue(goutData:GoutData) -> Bool{
        
        //goutData.id가 0 보다 작으면 insert 아닌 경우 update처리
        if goutData.id < 0 {
            return insertGoutValue(goutData: goutData)
        } else {
            return updateGoutValue(goutData: goutData)
        }
    }
    
    func updateGoutValue(goutData:GoutData) -> Bool {
        var rc: Int32 = 0
        var db: OpaquePointer? = nil
        let dbFileFullPath = fileManager.getDBFilePath()
        
        rc = sqlite3_open(dbFileFullPath, &db)
        
        if (rc != SQLITE_OK) {
            let errmsg = String(cString: sqlite3_errmsg(db))
            NSLog("Error opening database: \(errmsg)")
            return false
        }
        
        var updateGoutValue = "UPDATE tb_gout SET "
        updateGoutValue.append("reg_dt = '\(goutData.regDate)', ")
        updateGoutValue.append("reg_time = '\(goutData.regTime)', ")
        updateGoutValue.append("uric_acid_value = '\(goutData.gout)', ")
        updateGoutValue.append("kidney_value = '\(goutData.kidney)', ")
        updateGoutValue.append("liver_ggt_value = '0.0', ")
        updateGoutValue.append("gout_desc = '\(goutData.goutDesc)' ")
        updateGoutValue.append("WHERE ")
        updateGoutValue.append("id = \(goutData.id)")
        
        rc = sqlite3_exec(db, updateGoutValue, nil, nil, nil)
        if (rc != SQLITE_OK) {
            let errmsg = String(cString: sqlite3_errmsg(db))
            NSLog("sqlite3_exec key: \(errmsg)")
        }
        
        return true
    }
    
    /**
     요산 데이터 저장
     */
    func insertGoutValue(goutData:GoutData) -> Bool {
        
        var rc: Int32 = 0
        var db: OpaquePointer? = nil
        let dbFileFullPath = fileManager.getDBFilePath()
        
        rc = sqlite3_open(dbFileFullPath, &db)
        
        if (rc != SQLITE_OK) {
            let errmsg = String(cString: sqlite3_errmsg(db))
            NSLog("Error opening database: \(errmsg)")
            return false
        }
        
        var createGout = "INSERT INTO tb_gout (reg_dt, reg_time, uric_acid_value, kidney_value, liver_ggt_value, gout_desc) VALUES "
        createGout.append("('\(goutData.regDate)', '\(goutData.regTime)', '\(goutData.gout)', '\(goutData.kidney)', '0.0', '\(goutData.goutDesc)');")
        
        rc = sqlite3_exec(db, createGout, nil, nil, nil)
        if (rc != SQLITE_OK) {
            let errmsg = String(cString: sqlite3_errmsg(db))
            NSLog("sqlite3_exec key: \(errmsg)")
        }
        
        return true
    }
    
    func selectGoutVaule(date:String?, listType:goutListType) -> [GoutData]? {
        
        var rc: Int32 = 0
        var db: OpaquePointer? = nil
        
        
        let dbFileFullPath = fileManager.getDBFilePath()
        
        rc = sqlite3_open(dbFileFullPath, &db)
        
        if (rc != SQLITE_OK) {
            let errmsg = String(cString: sqlite3_errmsg(db))
            NSLog("Error opening database: \(errmsg)")
            return nil
        }
        
        var queryString = ""
        if listType == goutListType.month {
            queryString = "select reg_dt, reg_time, uric_acid_value, kidney_value, liver_ggt_value, gout_desc from tb_gout where strftime('%Y-%m', reg_dt, 'localtime') = '\(date!)' order by reg_dt desc;"
        } else if listType == goutListType.year {
            queryString = "select reg_dt, reg_time, uric_acid_value, kidney_value, liver_ggt_value, gout_desc from tb_gout where strftime('%Y', reg_dt, 'localtime') = '\(date!)' order by reg_dt desc;"
        } else {
            queryString = "select reg_dt, reg_time, uric_acid_value, kidney_value, liver_ggt_value, gout_desc from tb_gout order by reg_dt desc;"
        }
        
        var queryStatement: OpaquePointer? = nil
        var uricacidDatas:[GoutData]? = []
        
        if sqlite3_prepare_v2(db, queryString, -1, &queryStatement, nil) == SQLITE_OK {
            
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                
                let queryResultCol1 = String(cString: sqlite3_column_text(queryStatement, 0))
                let queryResultCol2 = String(cString: sqlite3_column_text(queryStatement, 1))
                let queryResultCol3 = sqlite3_column_double(queryStatement, 2)
                let queryResultCol4 = String(cString: sqlite3_column_text(queryStatement, 5))

                var goutData:GoutData = GoutData(regDate: queryResultCol1, gout: queryResultCol3.toString())
                let regTime = queryResultCol2.split(separator: ":")
                
                goutData.regTime = regTime[0] + ":" + regTime[1]
                goutData.goutDesc = queryResultCol4
                
                uricacidDatas?.append(goutData)
            }
        } else {
            // Fail
        }
        
        sqlite3_finalize(queryStatement)
        
        return uricacidDatas
    }
    
    func deleteGoutDataList(uricacidList:[Int:GoutData]) -> Bool {
        
        for goutData in uricacidList {
            //삭제 결과가 false인 경우 삭제 종료 하고 false 리턴
            if !deleteGoutData(uricacid: goutData.value) {
                return false
            }
        }
        
        return true
    }
    
    func deleteGoutData(uricacid:GoutData) -> Bool {
        var rc: Int32 = 0
        var db: OpaquePointer? = nil
        let dbFileFullPath = fileManager.getDBFilePath()
        
        rc = sqlite3_open(dbFileFullPath, &db)
        
        if (rc != SQLITE_OK) {
            let errmsg = String(cString: sqlite3_errmsg(db))
            NSLog("Error opening database: \(errmsg)")
            return false
        }
        
        let createGout = "DELETE FROM tb_gout WHERE reg_dt = '\(uricacid.regDate)';"
        
        rc = sqlite3_exec(db, createGout, nil, nil, nil)
        if (rc != SQLITE_OK) {
            let errmsg = String(cString: sqlite3_errmsg(db))
            NSLog("sqlite3_exec key: \(errmsg)")
            return false
        }
        
        return true
    }
    
    func selectGoutDateList(listType:goutListType) -> [String]? {
        var rc: Int32 = 0
        var db: OpaquePointer? = nil
        let dbFileFullPath = fileManager.getDBFilePath()
        
        rc = sqlite3_open(dbFileFullPath, &db)
        
        if (rc != SQLITE_OK) {
            let errmsg = String(cString: sqlite3_errmsg(db))
            NSLog("Error opening database: \(errmsg)")
            return nil
        }
        
//        let queryStatementString = "select strftime('%Y-%m', reg_dt) as reg_dt from tb_gout group by strftime('%Y-%m', reg_dt)  order by reg_dt desc;"
        
        var queryString = ""
        
        if listType == .month {
            queryString = "select strftime('%Y-%m', reg_dt) as reg_dt from tb_gout group by strftime('%Y-%m', reg_dt) order by reg_dt desc;"
        } else if listType == .year {
            queryString = "select strftime('%Y', reg_dt) as reg_dt from tb_gout group by strftime('%Y', reg_dt) order by reg_dt desc;"
        }
        
        var queryStatement: OpaquePointer? = nil
        var months: [String]? = []
        
        if sqlite3_prepare_v2(db, queryString, -1, &queryStatement, nil) == SQLITE_OK {
            
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                
                let month = String(cString: sqlite3_column_text(queryStatement, 0))
                months?.append(month)
            }
        } else {
            // Fail
        }
        
        sqlite3_finalize(queryStatement)
        
        return months
    }
    
    /**
     요산 정보 입력된 날짜의 데이터 반환
     */
    func selectGoutDateMonth() -> [String]? {
        
        var rc: Int32 = 0
        var db: OpaquePointer? = nil
        let dbFileFullPath = fileManager.getDBFilePath()
        
        rc = sqlite3_open(dbFileFullPath, &db)
        
        if (rc != SQLITE_OK) {
            let errmsg = String(cString: sqlite3_errmsg(db))
            NSLog("Error opening database: \(errmsg)")
            return nil
        }
        
        let queryStatementString = "select strftime('%Y-%m', reg_dt) as reg_dt from tb_gout group by strftime('%Y-%m', reg_dt)  order by reg_dt desc;"
        var queryStatement: OpaquePointer? = nil
        var months: [String]? = []
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                
                let month = String(cString: sqlite3_column_text(queryStatement, 0))
                months?.append(month)
            }
        } else {
            // Fail
        }
        
        sqlite3_finalize(queryStatement)
        
        return months
    }
    
    /**
     요산 정보 입력된 날짜의 데이터 반환
     */
    func selectGoutDateYear() -> [String]? {
        
        var rc: Int32 = 0
        var db: OpaquePointer? = nil
        let dbFileFullPath = fileManager.getDBFilePath()
        
        rc = sqlite3_open(dbFileFullPath, &db)
        
        if (rc != SQLITE_OK) {
            let errmsg = String(cString: sqlite3_errmsg(db))
            NSLog("Error opening database: \(errmsg)")
            return nil
        }
        
        let queryStatementString = "select strftime('%Y', reg_dt) as reg_dt from tb_gout group by strftime('%Y', reg_dt)  order by reg_dt desc;"
        var queryStatement: OpaquePointer? = nil
        var months: [String]? = []
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                
                let month = String(cString: sqlite3_column_text(queryStatement, 0))
                months?.append(month)
            }
        } else {
            // Fail
        }
        
        sqlite3_finalize(queryStatement)
        
        return months
    }
    
    /**
     입력된 날짜에 해당하는 정보만 가져오기
     - Parameter date: 입력 날짜
     */
    func selectGoutRegdate(date:String) -> [GoutData]? {
        
        var rc: Int32 = 0
        var db: OpaquePointer? = nil
        
        
        let dbFileFullPath = fileManager.getDBFilePath()
        
        rc = sqlite3_open(dbFileFullPath, &db)
        
        if (rc != SQLITE_OK) {
            let errmsg = String(cString: sqlite3_errmsg(db))
            NSLog("Error opening database: \(errmsg)")
            return nil
        }
        
        let queryStatementString = "select id, reg_dt, reg_time, uric_acid_value, kidney_value, liver_ggt_value from tb_gout where strftime('%Y-%m-%d', reg_dt, 'localtime') = '\(date)' order by reg_time desc;"
        var queryStatement: OpaquePointer? = nil
        var uricacidDatas: [GoutData]? = []
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                
                let col1 = sqlite3_column_int(queryStatement, 0)
                let col2 = String(cString: sqlite3_column_text(queryStatement, 1))
                
                var col3 = ""
                if sqlite3_column_text(queryStatement, 1) != nil {
                    col3 = String(cString: sqlite3_column_text(queryStatement, 2))
                }

                let col4 = sqlite3_column_double(queryStatement, 3)
                
                var goutData:GoutData = GoutData(regDate: col2, gout: col4.toString())
                goutData.id = Int(col1)
                goutData.regTime = col3
                
                uricacidDatas?.append(goutData)
            }
        } else {
            // Fail
        }
        
        sqlite3_finalize(queryStatement)
        
        return uricacidDatas
    }
    
    /**
     약품 정보를 기준으로 기존데이터가 있으면 Update, 없으면 Insert 처리
     */
    func upsertDrugInfo(drugInfo:DrugInfo) {
        
        //drugInfo.id가 0 보다 작으면 insert 아닌 경우 update처리
        if drugInfo.id < 0 {
            insertDrugInfo(drugInfo: drugInfo)
        } else {
            updateDrugInfo(drugInfo: drugInfo)
        }
    }
    
    /**
     약품 정보에 해당 아이디가 존재하는지 확인
     - Parameter id : 약품 정보 id
     - Return int : 
    */
    func isDrugInfoId(id:Int) -> Int {
        
        return 0
    }
    
    /**
     약품 정보 업데이트
     - Parameter drugInfo : 약품 정보
     */
    func updateDrugInfo(drugInfo:DrugInfo) {
        
        var rc: Int32 = 0
        var db: OpaquePointer? = nil
        
        let dbFileFullPath = fileManager.getDBFilePath()
        
        rc = sqlite3_open(dbFileFullPath, &db)
        
        if (rc != SQLITE_OK) {
            let errmsg = String(cString: sqlite3_errmsg(db))
            NSLog("Error opening database: \(errmsg)")
            return
        }
        
        var updateDrugInfo = "UPDATE tb_drug_info SET "
        updateDrugInfo.append("drug_name = '\(drugInfo.drugName)', ")
        updateDrugInfo.append("drug_img = '\(drugInfo.drugImg)', ")
        updateDrugInfo.append("drug_desc = '\(drugInfo.drugDesc)' ")
        updateDrugInfo.append("WHERE ")
        updateDrugInfo.append("id = \(drugInfo.id)")
        
        rc = sqlite3_exec(db, updateDrugInfo, nil, nil, nil)
        
        if (rc != SQLITE_OK) {
            let errmsg = String(cString: sqlite3_errmsg(db))
            NSLog("sqlite3_exec key: \(errmsg)")
        }
        
        sqlite3_close(db)

        upsertDrugAlarmInfo(drugAlarmList: drugInfo.drunAlarmInfos, drugInfoId: drugInfo.id)
    }
    
    func insertDrugInfo(drugInfo:DrugInfo) {
        
        var rc: Int32 = 0
        var db: OpaquePointer? = nil
        
        let dbFileFullPath = fileManager.getDBFilePath()
        
        rc = sqlite3_open(dbFileFullPath, &db)
        
        if (rc != SQLITE_OK) {
            let errmsg = String(cString: sqlite3_errmsg(db))
            NSLog("Error setting key: \(errmsg)")
        }
        
        var insertDrugInfo = "INSERT INTO tb_drug_info (drug_name, drug_img, drug_desc) VALUES "
        insertDrugInfo.append("('\(drugInfo.drugName)', '\(drugInfo.drugImg)', '\(drugInfo.drugDesc)');")
        
        rc = sqlite3_exec(db, insertDrugInfo, nil, nil, nil)

        if (rc != SQLITE_OK) {
            let errmsg = String(cString: sqlite3_errmsg(db))
            NSLog("sqlite3_exec key: \(errmsg)")
        }
        
        sqlite3_close(db)
        
        let maxId = drugInfoMaxId()
        
        //약품 정보가 insert인 경우는 그냥 처리
//        insertDrugAlarmInfo(drugInfos: drugInfo.drunAlarmInfos, drugInfoId: maxId)
        
        upsertDrugAlarmInfo(drugAlarmList: drugInfo.drunAlarmInfos, drugInfoId: maxId)
    }
    
    /**
     약품 정보 삭제
     */
    func deleteDrugInfoList(drugInfoList:[Int:DrugInfo]) -> Bool {
        
        for drugInfoValue in drugInfoList {
            let drugInfo = drugInfoValue.value
            
            //삭제 결과가 false인 경우 삭제 종료
            if !deleteDrugAlarmInfo(drugId: drugInfo.id) {
                return false
            }

            //삭제 결과가 false인 경우 삭제 종료 하고 false 리턴
            if !deleteDrugInfo(drugInfo: drugInfo) {
                return false
            }
        }

        return true
    }
    
    func deleteDrugInfo(drugInfo:DrugInfo) -> Bool {
        var rc: Int32 = 0
        var db: OpaquePointer? = nil
        let dbFileFullPath = fileManager.getDBFilePath()
        
        rc = sqlite3_open(dbFileFullPath, &db)
        
        if (rc != SQLITE_OK) {
            let errmsg = String(cString: sqlite3_errmsg(db))
            NSLog("Error opening database: \(errmsg)")
            return false
        }
        
        let deleteDrugInfo = "DELETE FROM tb_drug_info WHERE id = '\(drugInfo.id)';"
        
        rc = sqlite3_exec(db, deleteDrugInfo, nil, nil, nil)
        if (rc != SQLITE_OK) {
            let errmsg = String(cString: sqlite3_errmsg(db))
            NSLog("sqlite3_exec key: \(errmsg)")
            return false
        }
        
        return true
    }
    
    func selectDrugInfoList() -> [DrugInfo]? {
        
        var rc: Int32 = 0
        var db: OpaquePointer? = nil
        
        
        let dbFileFullPath = fileManager.getDBFilePath()
        
        rc = sqlite3_open(dbFileFullPath, &db)
        
        if (rc != SQLITE_OK) {
            let errmsg = String(cString: sqlite3_errmsg(db))
            NSLog("Error opening database: \(errmsg)")
            return nil
        }
        
        let queryStatementString = "select * from tb_drug_info;"
        var queryStatement: OpaquePointer? = nil
        var drugInfoList: [DrugInfo]? = []
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                
                let col1 = sqlite3_column_int(queryStatement, 0)
                let col2 = String(cString: sqlite3_column_text(queryStatement, 1))
                let col3 = String(cString: sqlite3_column_text(queryStatement, 2))
                let col4 = String(cString: sqlite3_column_text(queryStatement, 3))
                
                var drugInfo:DrugInfo = DrugInfo()
                drugInfo.id = Int(col1)
                drugInfo.drugName = String(describing: col2)
                drugInfo.drugImg = String(describing: col3)
                drugInfo.drugDesc = String(describing: col4)
                drugInfo.drunAlarmInfos = selectDrugInfoAlarmList(drugInfoId: drugInfo.id) ?? []
                
                drugInfoList?.append(drugInfo)
            }
        } else {
            // Fail
        }
        
        sqlite3_finalize(queryStatement)
        
        return drugInfoList
    }
    
    func goutInfoMaxId() -> Int{
        var rc: Int32 = 0
        var db: OpaquePointer? = nil
        var maxId = -1
        
        let dbFileFullPath = fileManager.getDBFilePath()
        
        rc = sqlite3_open(dbFileFullPath, &db)
        
        if (rc != SQLITE_OK) {
            let errmsg = String(cString: sqlite3_errmsg(db))
            NSLog("Error opening database: \(errmsg)")
            return maxId
        }
        
        let queryStatementString = "select MAX(gout_seq) from tb_gout;"
        var queryStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                
                let id = sqlite3_column_int(queryStatement, 0)
                maxId = Int(id)
            }
        } else {
            // Fail
        }
        
        sqlite3_finalize(queryStatement)
        
        return maxId
    }
    
    ///
    func drugInfoMaxId() -> Int{
        var rc: Int32 = 0
        var db: OpaquePointer? = nil
        var maxId = -1
        
        let dbFileFullPath = fileManager.getDBFilePath()

        rc = sqlite3_open(dbFileFullPath, &db)
        
        if (rc != SQLITE_OK) {
            let errmsg = String(cString: sqlite3_errmsg(db))
            NSLog("Error setting key: \(errmsg)")
        }
        
        let queryStatementString = "select MAX(id) from tb_drug_info;"
        var queryStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                
                let id = sqlite3_column_int(queryStatement, 0)
                maxId = Int(id)
            }
        } else {
            // Fail
        }
        
        sqlite3_finalize(queryStatement)
        
        return maxId
    }
    
    func upsertDrugAlarmInfo(drugAlarmList:[DrugAlarmInfo], drugInfoId:Int) {
        
        //약 복용 시간 알람리스트 처리
        for drugAlarmInfo in drugAlarmList {
            //약 알람 id가 0보다 작으면 insert 아니면 update
            if drugAlarmInfo.id < 0 {
                insertDrugAlarm(drugAlarm: drugAlarmInfo, drugInfoId: drugInfoId)
            } else {
                updateDrugAlarmInfo(drugAlarm: drugAlarmInfo, drugInfoId: drugInfoId)
            }
        }
        
    }
    
    /**
     약 알람 정보 업데이트
     - Parameter drugAlarm : 약 알람 정보
     - Parameter drugInfoId : 약품 정보 Id
     */
    func updateDrugAlarmInfo(drugAlarm:DrugAlarmInfo, drugInfoId:Int) {
        var rc: Int32 = 0
        var db: OpaquePointer? = nil
        
        let dbFileFullPath = fileManager.getDBFilePath()
        
        rc = sqlite3_open(dbFileFullPath, &db)
        
        if (rc != SQLITE_OK) {
            let errmsg = String(cString: sqlite3_errmsg(db))
            NSLog("Error opening database: \(errmsg)")
            return
        }
        
        var updateDrugInfo = "UPDATE tb_drug_alarm SET "
        updateDrugInfo.append("alarm_time = '\(drugAlarm.alarmTime)', ")
        updateDrugInfo.append("alarm_sound = '\(drugAlarm.alarmSound)', ")
        updateDrugInfo.append("alarm_enable = '\(drugAlarm.enable)', ")
        updateDrugInfo.append("all_week = \(drugAlarm.week.allDay.intValue), ")
        updateDrugInfo.append("monday = \(drugAlarm.week.monday.intValue), ")
        updateDrugInfo.append("tuesday = \(drugAlarm.week.tuesday.intValue), ")
        updateDrugInfo.append("wednesday = \(drugAlarm.week.wednesday.intValue), ")
        updateDrugInfo.append("thursday = \(drugAlarm.week.thursday.intValue), ")
        updateDrugInfo.append("friday = \(drugAlarm.week.friday.intValue), ")
        updateDrugInfo.append("saturday = \(drugAlarm.week.saturday.intValue), ")
        updateDrugInfo.append("sunday = \(drugAlarm.week.sunday.intValue), ")
        updateDrugInfo.append("repeat_time = \(drugAlarm.snoozeTime), ")
        updateDrugInfo.append("alarm_desc = '\(drugAlarm.alarmDesc)' ")
        updateDrugInfo.append("WHERE ")
        updateDrugInfo.append("id = \(drugAlarm.id) AND ")
        updateDrugInfo.append("drug_id = \(drugInfoId);")
        
        rc = sqlite3_exec(db, updateDrugInfo, nil, nil, nil)
        
        if (rc != SQLITE_OK) {
            let errmsg = String(cString: sqlite3_errmsg(db))
            NSLog("sqlite3_exec key: \(errmsg)")
        }
        
        sqlite3_close(db)
    }
    
    func insertDrugAlarm(drugAlarm:DrugAlarmInfo, drugInfoId:Int) {
        var rc: Int32 = 0
        var db: OpaquePointer? = nil
        
        let dbFileFullPath = fileManager.getDBFilePath()
        
        rc = sqlite3_open(dbFileFullPath, &db)
        
        if (rc != SQLITE_OK) {
            let errmsg = String(cString: sqlite3_errmsg(db))
            NSLog("Error opening database: \(errmsg)")
            return
        }
        
        var insertDrugInfo = "INSERT INTO tb_drug_alarm (drug_id, alarm_time, alarm_sound, alarm_enable, all_week, monday, tuesday, wednesday, thursday, friday, saturday, sunday, repeat_time, alarm_desc) VALUES "
        
        insertDrugInfo.append("('\(drugInfoId)', '\(drugAlarm.alarmTime)', '\(drugAlarm.alarmSound)', '\(drugAlarm.enable)', '\(drugAlarm.week.allDay.intValue)', '\(drugAlarm.week.monday.intValue)', '\(drugAlarm.week.tuesday.intValue)', '\(drugAlarm.week.wednesday.intValue)', '\(drugAlarm.week.thursday.intValue)', '\(drugAlarm.week.friday.intValue)', '\(drugAlarm.week.saturday.intValue)' , '\(drugAlarm.week.sunday.intValue)', '\(drugAlarm.snoozeTime)', '\(drugAlarm.alarmDesc)');")
        
        rc = sqlite3_exec(db, insertDrugInfo, nil, nil, nil)
        
        if (rc != SQLITE_OK) {
            let errmsg = String(cString: sqlite3_errmsg(db))
            NSLog("sqlite3_exec key: \(errmsg)")
        }
        
        sqlite3_close(db)
    }
    
    func insertDrugAlarmInfo(drugInfos:[DrugAlarmInfo], drugInfoId:Int) {
        
        var rc: Int32 = 0
        var db: OpaquePointer? = nil


        let dbFileFullPath = fileManager.getDBFilePath()

        rc = sqlite3_open(dbFileFullPath, &db)

        if (rc != SQLITE_OK) {
            let errmsg = String(cString: sqlite3_errmsg(db))
            NSLog("Error opening database: \(errmsg)")
            return
        }
        
        var insertDrugInfo = "INSERT INTO tb_drug_alarm (drug_id, alarm_time, alarm_sound, alarm_enable, all_week, monday, tuesday, wednesday, thursday, friday, saturday, sunday, repeat_time, alarm_desc) VALUES "
        
        for i in 0 ..< drugInfos.count {
            let drugAlarmInfo = drugInfos[i]
            
            insertDrugInfo.append("('\(drugInfoId)', '\(drugAlarmInfo.alarmTime)', '\(drugAlarmInfo.alarmSound)', '\(drugAlarmInfo.enable)', '\(drugAlarmInfo.week.allDay.intValue)', '\(drugAlarmInfo.week.monday.intValue)', '\(drugAlarmInfo.week.tuesday.intValue)', '\(drugAlarmInfo.week.wednesday.intValue)', '\(drugAlarmInfo.week.thursday.intValue)', '\(drugAlarmInfo.week.friday.intValue)', '\(drugAlarmInfo.week.saturday.intValue)' , '\(drugAlarmInfo.week.sunday.intValue)', '\(drugAlarmInfo.snoozeTime)', '\(drugAlarmInfo.alarmDesc)'")
            
            if i < drugInfos.count - 1 {
                insertDrugInfo.append(", ")
            } else {
                insertDrugInfo.append(";")
            }
        }

        rc = sqlite3_exec(db, insertDrugInfo, nil, nil, nil)

        if (rc != SQLITE_OK) {
            let errmsg = String(cString: sqlite3_errmsg(db))
            NSLog("sqlite3_exec key: \(errmsg)")
        }

        sqlite3_close(db)
    }
    
    /**
     약 정보 삭제시 하위의 복용 알람 정보 전부 삭제
    */
    func deleteDrugAlarmInfo(drugId:Int) -> Bool {
        
        //이럴일은 일단 없을듯
        if drugId < 0 {
            return false
        }
        
        var rc: Int32 = 0
        var db: OpaquePointer? = nil
        let dbFileFullPath = fileManager.getDBFilePath()
        
        rc = sqlite3_open(dbFileFullPath, &db)
        
        if (rc != SQLITE_OK) {
            let errmsg = String(cString: sqlite3_errmsg(db))
            NSLog("Error opening database: \(errmsg)")
            return false
        }
        
        let deleteDrugInfo = "DELETE FROM tb_drug_alarm WHERE drug_id = \(drugId);"
        
        rc = sqlite3_exec(db, deleteDrugInfo, nil, nil, nil)
        if (rc != SQLITE_OK) {
            let errmsg = String(cString: sqlite3_errmsg(db))
            NSLog("sqlite3_exec key: \(errmsg)")
            return false
        }
        
        return true
    }
    
    /**
     */
    func deleteDrugAlarmInfo(drugId:Int, id:Int) -> Bool {
        //이럴일은 일단 없을듯
        if drugId < 0 {
            return false
        }
        
        var rc: Int32 = 0
        var db: OpaquePointer? = nil
        let dbFileFullPath = fileManager.getDBFilePath()
        
        rc = sqlite3_open(dbFileFullPath, &db)
        
        if (rc != SQLITE_OK) {
            let errmsg = String(cString: sqlite3_errmsg(db))
            NSLog("Error opening database: \(errmsg)")
            return false
        }
        
        let deleteDrugInfo = "DELETE FROM tb_drug_alarm WHERE drug_id = \(drugId) AND id = \(id);"
        
        rc = sqlite3_exec(db, deleteDrugInfo, nil, nil, nil)
        if (rc != SQLITE_OK) {
            let errmsg = String(cString: sqlite3_errmsg(db))
            NSLog("sqlite3_exec key: \(errmsg)")
            return false
        }
        
        return true
    }
    
    func selectDrugInfoAlarmList(drugInfoId:Int) -> [DrugAlarmInfo]? {
        
        var rc: Int32 = 0
        var db: OpaquePointer? = nil
        
        
        let dbFileFullPath = fileManager.getDBFilePath()
        
        rc = sqlite3_open(dbFileFullPath, &db)
        
        if (rc != SQLITE_OK) {
            let errmsg = String(cString: sqlite3_errmsg(db))
            NSLog("Error opening database: \(errmsg)")
            return nil
        }
        
        let queryStatementString = "select * from tb_drug_alarm where drug_id = \(drugInfoId) order by alarm_time asc;"
        var queryStatement: OpaquePointer? = nil
        var drugAlarmInfoList: [DrugAlarmInfo]? = []
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            
            while sqlite3_step(queryStatement) == SQLITE_ROW {

                let id = Int(sqlite3_column_int(queryStatement, 0))
                let drugId = Int(sqlite3_column_int(queryStatement, 1))
                let alarmTime = String(cString: sqlite3_column_text(queryStatement, 2))
                let alarmSound = String(cString: sqlite3_column_text(queryStatement, 3))
                let alamrEnable = sqlite3_column_int(queryStatement, 4)
                let allWeek = sqlite3_column_int(queryStatement, 5) == 1 ? true : false
                
                var repeatWeek:RepeatWeek = RepeatWeek(allDay: allWeek)
                
                if !allWeek {
                    repeatWeek.monday = sqlite3_column_int(queryStatement, 6) == 1 ? true : false
                    repeatWeek.tuesday = sqlite3_column_int(queryStatement, 7) == 1 ? true : false
                    repeatWeek.wednesday = sqlite3_column_int(queryStatement, 8) == 1 ? true : false
                    repeatWeek.thursday = sqlite3_column_int(queryStatement, 9) == 1 ? true : false
                    repeatWeek.friday = sqlite3_column_int(queryStatement, 10) == 1 ? true : false
                    repeatWeek.saturday = sqlite3_column_int(queryStatement, 11) == 1 ? true : false
                    repeatWeek.sunday = sqlite3_column_int(queryStatement, 12) == 1 ? true : false
                }
                
                let repeatTime = Int(sqlite3_column_int(queryStatement, 13))
                let alarm_desc = String(cString: sqlite3_column_text(queryStatement, 14))
                
                var drugAlarmInfo:DrugAlarmInfo = DrugAlarmInfo()
                drugAlarmInfo.id = id
                drugAlarmInfo.drugId = drugId
                drugAlarmInfo.alarmTime = alarmTime
                drugAlarmInfo.alarmSound = alarmSound
                drugAlarmInfo.enable = Int(alamrEnable)
                drugAlarmInfo.week = repeatWeek
                drugAlarmInfo.snoozeTime = repeatTime
                drugAlarmInfo.alarmDesc = alarm_desc
                
                drugAlarmInfoList?.append(drugAlarmInfo)
            }
        } else {
            // Fail
        }
        
        sqlite3_finalize(queryStatement)
        
        return drugAlarmInfoList
    }
    

    func selectDrugInfoAlarmListAll() -> [DrugAlarmInfo]? {
        
        var rc: Int32 = 0
        var db: OpaquePointer? = nil
        
        
        let dbFileFullPath = fileManager.getDBFilePath()
        
        rc = sqlite3_open(dbFileFullPath, &db)
        
        if (rc != SQLITE_OK) {
            let errmsg = String(cString: sqlite3_errmsg(db))
            NSLog("Error opening database: \(errmsg)")
            return nil
        }
        
        let queryStatementString = "select * from tb_drug_alarm order by alarm_time asc;"
        var queryStatement: OpaquePointer? = nil
        var drugAlarmInfoList: [DrugAlarmInfo]? = []
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                
                let id = Int(sqlite3_column_int(queryStatement, 0))
                let drugId = Int(sqlite3_column_int(queryStatement, 1))
                let alarmTime = String(cString: sqlite3_column_text(queryStatement, 2))
                let alarmSound = String(cString: sqlite3_column_text(queryStatement, 3))
                let alamrEnable = sqlite3_column_int(queryStatement, 4)
                let allWeek = sqlite3_column_int(queryStatement, 5) == 1 ? true : false
                
                var repeatWeek:RepeatWeek = RepeatWeek(allDay: allWeek)
                
                if !allWeek {
                    repeatWeek.monday = sqlite3_column_int(queryStatement, 6) == 1 ? true : false
                    repeatWeek.tuesday = sqlite3_column_int(queryStatement, 7) == 1 ? true : false
                    repeatWeek.wednesday = sqlite3_column_int(queryStatement, 8) == 1 ? true : false
                    repeatWeek.thursday = sqlite3_column_int(queryStatement, 9) == 1 ? true : false
                    repeatWeek.friday = sqlite3_column_int(queryStatement, 10) == 1 ? true : false
                    repeatWeek.saturday = sqlite3_column_int(queryStatement, 11) == 1 ? true : false
                    repeatWeek.sunday = sqlite3_column_int(queryStatement, 12) == 1 ? true : false
                }
                
                let repeatTime = Int(sqlite3_column_int(queryStatement, 13))
                let alarm_desc = String(cString: sqlite3_column_text(queryStatement, 14))
                
                var drugAlarmInfo:DrugAlarmInfo = DrugAlarmInfo()
                drugAlarmInfo.id = id
                drugAlarmInfo.drugId = drugId
                drugAlarmInfo.alarmTime = alarmTime
                drugAlarmInfo.alarmSound = alarmSound
                drugAlarmInfo.enable = Int(alamrEnable)
                drugAlarmInfo.week = repeatWeek
                drugAlarmInfo.snoozeTime = repeatTime
                drugAlarmInfo.alarmDesc = alarm_desc
                
                drugAlarmInfoList?.append(drugAlarmInfo)
            }
        } else {
            // Fail
        }
        
        sqlite3_finalize(queryStatement)
        
        return drugAlarmInfoList
    }
    
}
