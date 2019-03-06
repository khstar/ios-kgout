//
//  Structs.swift
//  Gout
//
//  Created by khstar on 2018. 9. 10..
//  Copyright © 2018년 khstar. All rights reserved.
//

import Foundation
import UIKit

protocol GoutDataType {
    init(regDate: String, gout:String)
}

struct GoutData:GoutDataType {
    var id:Int = -1
    var regDate:String
    var regTime:String = ""
    let gout:String
    var kidney:String = "0.0"
    var goutDesc:String = ""
    
    init(regDate:String, gout:String) {
        self.regDate = regDate
        self.gout = gout
    }
}

///약 정보
struct DrugInfo {
    var id:Int = -1
    var drugName:String = ""
    var drugImg:String  = ""
    var drugDesc:String = ""
    var drunAlarmInfos:[DrugAlarmInfo] = []
}

///약 복용 시간 알림 정보
struct DrugAlarmInfo {
    var id:Int              = -1
    var drugId:Int          = 0
    var enable:Int          = 0
    var alarmTime:String    = ""
    var alarmSound:String   = "default"
    var week:RepeatWeek     = RepeatWeek.init(allDay: false)
    var snoozeTime:Int      = 0
    var alarmDesc:String     = ""
}

struct RepeatWeek {
    var allDay:Bool
    var monday:Bool
    var tuesday:Bool
    var wednesday:Bool
    var thursday:Bool
    var friday:Bool
    var saturday:Bool
    var sunday:Bool
    
    init(allDay: Bool) {
        
        self.allDay = allDay
        
        //초기값에 따라 모두 설정
        if allDay {
            self.monday = true
            self.tuesday = true
            self.wednesday = true
            self.thursday = true
            self.friday = true
            self.saturday = true
            self.sunday = true
        } else {
            self.monday = false
            self.tuesday = false
            self.wednesday = false
            self.thursday = false
            self.friday = false
            self.saturday = false
            self.sunday = false
        }
    }
}

///약 정보
struct UserInfo {
    var id:Int = -1
    var userName:String = ""
    var userBirthDay:String = ""
    var userAge:String = ""
    var userWeight:String = ""
    var userHeight:String = ""
    var userDesc:String = ""
}
