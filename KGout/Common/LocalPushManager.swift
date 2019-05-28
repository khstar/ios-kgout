//
//  LocalPushController.swift
//  kFramework
//
//  Created by khstar on 2017. 9. 4..
//  Copyright © 2017년 khstar. All rights reserved.
//

import Foundation
import UserNotifications
import AVFoundation
import UIKit

public class LocalPushManager {
    
    struct StaticInstance {
        static var localPushManager:LocalPushManager?
    }
    
    public class func sharedInstance() -> LocalPushManager {
        if StaticInstance.localPushManager == nil {
            StaticInstance.localPushManager = LocalPushManager()
        }
        
        return StaticInstance.localPushManager!
    }
    
    /**
     약 먹을 시간 알림 설정
     */
    func setDrugAlarm(drugInfo:DrugInfo) {
        let drugAlarmList = drugInfo.drunAlarmInfos
        let title = drugInfo.drugName
        
        for drugAlarm in drugAlarmList {
            
            let notiIdentifier = "\(drugAlarm.drugId)_\(drugAlarm.id)"
            removeAlarm(identifier: notiIdentifier)
            
            //알람을 삭제한게 아니라 비활성화 한 경우
            if drugAlarm.enable == 0 {
                continue
            }
            
            let alarmTime = Utils.stringToDateHHmm(timeString: drugAlarm.alarmTime)
            let alarmSound = drugAlarm.alarmSound
            let alarmSnoozeTime = drugAlarm.snoozeTime
            let alarmDesc = drugAlarm.alarmDesc
            
            var body = "\(drugInfo.drugName) 복용 시간 입니다."
            
            if !alarmDesc.isEmpty {
                body.append("\n\(drugAlarm.alarmDesc)")
            }
            
            if !drugAlarm.week.allDay {
                
                if !drugAlarm.week.sunday &&
                    !drugAlarm.week.monday &&
                    !drugAlarm.week.tuesday &&
                    !drugAlarm.week.wednesday &&
                    !drugAlarm.week.thursday &&
                    !drugAlarm.week.friday &&
                    !drugAlarm.week.saturday &&
                    !drugAlarm.week.sunday {
                    
                    addAlarm(identifier: "\(notiIdentifier)_\(8)", title: title, body: body, alarmTime: alarmTime, weekDay: 0, sound: alarmSound, snoozeTime: alarmSnoozeTime, isRepeats:  false)
                        
                }
                
                //일요일
                if drugAlarm.week.sunday {
                    addAlarm(identifier: "\(notiIdentifier)_\(1)", title: title, body: body, alarmTime: alarmTime, weekDay: 1, sound: alarmSound, snoozeTime: alarmSnoozeTime)
                }
                
                //월요일
                if drugAlarm.week.monday {
                    addAlarm(identifier: "\(notiIdentifier)_\(2)", title: title, body: body, alarmTime: alarmTime, weekDay: 2, sound: alarmSound, snoozeTime: alarmSnoozeTime)
                }
                
                //화요일
                if drugAlarm.week.tuesday {
                    addAlarm(identifier: "\(notiIdentifier)_\(3)", title: title, body: body, alarmTime: alarmTime, weekDay: 3, sound: alarmSound, snoozeTime: alarmSnoozeTime)
                }
                
                //수요일
                if drugAlarm.week.wednesday {
                    addAlarm(identifier: "\(notiIdentifier)_\(4)", title: title, body: body, alarmTime: alarmTime, weekDay: 4, sound: alarmSound, snoozeTime: alarmSnoozeTime)
                }
                
                //목요일
                if drugAlarm.week.thursday {
                    addAlarm(identifier: "\(notiIdentifier)_\(5)", title: title, body: body, alarmTime: alarmTime, weekDay: 5, sound: alarmSound, snoozeTime: alarmSnoozeTime)
                }
                
                //금요일
                if drugAlarm.week.friday {
                    addAlarm(identifier: "\(notiIdentifier)_\(6)", title: title, body: body, alarmTime: alarmTime, weekDay: 6, sound: alarmSound, snoozeTime: alarmSnoozeTime)
                }
                
                //토요일
                if drugAlarm.week.saturday {
                    addAlarm(identifier: "\(notiIdentifier)_\(7)", title: title, body: body, alarmTime: alarmTime, weekDay: 7, sound: alarmSound, snoozeTime: alarmSnoozeTime)
                }
            } else {
                addAlarm(identifier: "\(notiIdentifier)_\(0)", title: title, body: body, alarmTime: alarmTime, weekDay: 0, sound: alarmSound, snoozeTime: alarmSnoozeTime)
            }
            
        }
    }
    
    /**
     알람 추가
     - Parameter identifier:알람 구분자
     - Parameter title:알람 타이틀
     - Parameter body:알람 내용
     - Parameter alarmTime:알람 시간
     - Parameter weekDay:주간 반복
     - Parameter sound:알람 소리
     */
    func addAlarm(identifier:String, title:String, body:String, alarmTime:Date, weekDay:Int, sound:String, snoozeTime:Int, isRepeats:Bool = true) {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        let notiIdentifier = "\(Constants.goutIdentifier)_\(identifier)"
        var triggerWeekly = Calendar.current.dateComponents([.hour, .minute], from: alarmTime)
        
        content.title = title
        content.body = body
        content.categoryIdentifier = "notiIdentifier"
        content.sound = UNNotificationSound.init(named: UNNotificationSoundName(rawValue: sound))
        
        if weekDay > 0 {
            triggerWeekly.weekday = weekDay
        }
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerWeekly, repeats: isRepeats)
        let request = UNNotificationRequest(identifier: notiIdentifier, content: content, trigger: trigger)
        
        center.add(request)
        
//        if snoozeTime > 0 {
//            let timeIntervalTrigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(snoozeTime * 60), repeats: true)
//            let timeIntervalRequest = UNNotificationRequest(identifier: notiIdentifier, content: content, trigger: timeIntervalTrigger)
//            
//            center.add(timeIntervalRequest)
//        }
        
    }
    
    /**
     identifier는 drugId_drugAlarmId (ex : 1_1)
     */
    func removeAlarm(identifier:String) {
        
        let goutIdentifier = "\(Constants.goutIdentifier)_\(identifier)"
        var idetifiers:[String] = []
        
        for i in 0...9 {
            idetifiers.append("\(goutIdentifier)_\(i)")
        }
        
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: idetifiers)
    }
    
    /**
     모든 알람 제거
     */
    func removeAlarmAll() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
    }
    
}
