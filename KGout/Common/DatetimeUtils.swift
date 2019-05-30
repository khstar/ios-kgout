//
//  DatetimeUtil.swift
//  KGout
//
//  Created by khstar on 29/05/2019.
//  Copyright © 2019 khstar. All rights reserved.
//

import Foundation

class DatetimeUtils {
    
    /**
     date 또는 time 변환시 1~9의 경우 앞에 0 붙여줄때 사용
     */
    static func zeroMigrationDate(date: Int) -> String {
        return date < 10 ? "0\(date)" : "\(date)"
    }
    
    static func transLongToDate(date: Int64) -> String {
        let baseOffset: Int64 = 8 * 60 * 60 * 24
        let dateMills = date / 1000
        let currentMills = Int64(NSDate().timeIntervalSince1970)
        
        let fommetter = DateFormatter()
        let subMills = (currentMills - dateMills) < 0 ? 0 : currentMills - dateMills
        
        
        if subMills < baseOffset {
            
            switch  subMills {
                
            case let x where x < 60:
                fommetter.dateFormat = "s초 전"
                
            case let x where x < 3600:
                fommetter.dateFormat = "m분 전"
                
            case let x where x <  86400:
                fommetter.dateFormat = "H시간 전"
                
            case let x where x < 604800:
                fommetter.dateFormat = "d일 전"
            default:
                return "1주 전"
                
            }
            
            fommetter.timeZone = TimeZone(secondsFromGMT: 0)
            return fommetter.string(from: Date(timeIntervalSince1970: Double(subMills)))
            
        } else {
            
            fommetter.dateFormat = "M월 d일"
            return fommetter.string(from: Date(timeIntervalSince1970: Double(dateMills)))
            
        }
    }
    
    ///데이트 포맷 1월 1일 오전 1:01 분 사용자가 24시간 으로 사용하는 경우 오전과 시는 24시간 제로 표시됨
    static func dateToMMDDahmm(date: Int64) -> String {
        let dateMills = date / 1000
        let fommetter = DateFormatter()
        fommetter.dateFormat = "M월 d일 a h:mm"
        return fommetter.string(from: Date(timeIntervalSince1970: Double(dateMills)))
    }
    
    ///데이트 포맷 1/1 오전 1:01 분 사용자가 24시간 으로 사용하는 경우 오전과 시는 24시간 제로 표시됨
    static func dateToSimpleMMDDHHmm(date: Int64) -> String {
        let dateMills = date / 1000
        let fommetter = DateFormatter()
        fommetter.dateFormat = "MM/dd HH:mm"
        return fommetter.string(from: Date(timeIntervalSince1970: Double(dateMills)))
    }
    
    ///데이트 포맷 1/1 오전 1:01 분 사용자가 24시간 으로 사용하는 경우 오전과 시는 24시간 제로 표시됨
    static func nowMMDDHHmmss() -> String {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd_HH:mm:ss"
        
        return dateFormatter.string(from: now)
    }
    
    static func stringToDate(_ dateString: String) -> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd hh:mm:ss"
        return dateFormatter.date(from: dateString)
    }
    
    static func stringToyyyyMMdd(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: dateString)
    }
    
    ///데이트 포맷 1/1 오전 1:01 분 사용자가 24시간 으로 사용하는 경우 오전과 시는 24시간 제로 표시됨
    static func nowHHmmss() -> String {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        
        return dateFormatter.string(from: now)
    }
    
    /**
     사용자의 시간제 설정이 24시간제인 경우 true, 12시간제인 경우 false리턴
     */
    static func is12Hour() -> Bool {
        let locale = NSLocale.current
        let timeFormat = DateFormatter.dateFormat(fromTemplate: "j", options:0, locale:locale)!
        
        if timeFormat.contains("a") {
            //phone is set to 12 hours
            return true
        } else {
            //phone is set to 24 hours
            return false
        }
    }
    
    /**
     오전, 오후 타입을 24시간제 타입으로 변환 
     */
    static func convertAmPmToHHmm(time:String) -> String {
        
        let timeFormat = "a h:mm"
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = timeFormat
        
        //time의 DateFormat이 a h:mm인 경우
        if let date = dateFormatter.date(from: time) {
            // HH:mm 포맷으로 변환해서 리턴
            dateFormatter.dateFormat = "HH:mm"
            return dateFormatter.string(from: date)
        }
        
        return time
    }
    
    static func showHHmmmss(timeString:String) -> String {
        
        let timeFormat = "HH:mm"
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = timeFormat
        
        //DateFormat이 HH:mm인지 확인
        if let date = dateFormatter.date(from: timeString) {
            // 12시간제 인경우
            if is12Hour() {
                dateFormatter.dateFormat = "a h:mm"
            }
            
            return dateFormatter.string(from: date)
        }
        
        dateFormatter.dateFormat = "\(timeFormat):ss"
        
        //DateFormat이 HH:mm:ss인지 확인
        if let date = dateFormatter.date(from: timeString) {
            // 12시간제 인경우
            if is12Hour() {
                dateFormatter.dateFormat = "a h:mm:ss"
            }
            
            return dateFormatter.string(from: date)
        }
        
        return ""
    }
    
    static func showDateHHmmmss(timeString:String) -> Date {
        
        let timeFormat = "HH:mm"
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = timeFormat
        
        //DateFormat이 HH:mm인지 확인
        if let date = dateFormatter.date(from: timeString) {
            return date
        } else {
            return stringToDateahmm(timeString: timeString)
        }
    }
    
    /**
     HH:mm:ss -> HH:mm 포맷으로 변경
     */
    static func hhmmmssTohhmm(timeString:String) -> String {
        
        var timeFormat = "a h:mm"
        
        if !is12Hour() {
            timeFormat = "HH:mm"
        }
        
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "HH:mm:ss"
        let date = dateFormatter.date(from: timeString)
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = timeFormat
        
        return dateFormatter2.string(from: date!)
        
    }
    
    /**
     String -> Date로 변환
     */
    static func stringToDateHHmmss(timeString:String) -> Date {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "HH:mm:ss"
        let date = dateFormatter.date(from: timeString)
        
        return date!
    }
    
    /**
     String -> Date로 변환
     */
    static func stringToDateahmm(timeString:String) -> Date {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "a h:mm"
        let date = dateFormatter.date(from: timeString)
        
        return date!
    }
    
    /**
     String -> Date로 변환
     */
    static func stringToDateHHmm(timeString:String) -> Date {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.date(from: timeString)
        
        return date!
    }
    
    /**
     date를 String으로 변환
     */
    static func dateToStringHHmm(timeDate:Date) -> String {
        let now = timeDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        return dateFormatter.string(from: now)
    }
    
    /*
     생년월일로 한국 나이 구하기
     */
    static func getUserAge(birth:String) -> Int {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        dateFormatter.string(from: now)
        
        let bDate = dateFormatter.date(from: birth)
        var age = 0
        
        do {
            let calendar = Calendar(identifier: .gregorian)
            let compos = calendar.dateComponents([.year,.month,.day], from:bDate!, to:now)
            age = compos.year!
        }
        
        if Utils.getContryCode() != "KR" {
            return age
        }
        
        if userAgeMonth(birth: birth) >= 0 {
            age = age + 1
        } else {
            age = age + 2
        }
        
        return age
    }
    
    /**
     생년월일이 지났는지 판단
     */
    static func userAgeMonth(birth:String) -> Int {
        
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        var nowStr = dateFormatter.string(from: now).split(separator: "-")
        var birthStr = birth.split(separator: "-")
        
        birthStr[0] = nowStr[0]
        
        let bDate = dateFormatter.date(from: "\(birthStr[0])-\(birthStr[1])-\(birthStr[2])")
        var age = 0
        
        do {
            let calendar = Calendar(identifier: .gregorian)
            let compos = calendar.dateComponents([.month, .day], from:bDate!, to:now)
            age = compos.day!
        }
        
        return age
    }
}
