//
//  Constants.swift
//  Gout
//
//  Created by khstar on 2018. 9. 6..
//  Copyright © 2018년 khstar. All rights reserved.
//

import Foundation
import UIKit

class Constants {
    
    
    ///업데이트 Push 알림 체크키
    static let versionUpdatePush = "versionUpdatePush"
    
    ///노치 스타일 대응을 위한 상위 Status 높이
    static func statusHeight() -> CGFloat {
        var height = 20
        
        if Utils.bIphoneX() {
            height = 44
        }
        
        return CGFloat(height)
    }
    
    ///노치 스타일 대응을 위한 하단 Bottom 높이
    static func bottomHeight() -> CGFloat {
        var height = 0
        
        if Utils.bIphoneX() {
            height = 22
        }
        
        return CGFloat(height)
    }
    
    ///최저 요산 수치
    static let minUricacid:CGFloat = 0.0
    ///최대 요산 수치
    static let maxUricacid:CGFloat = 20.0
    
    static let monthList:[String] = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"]
    static let snoozeTimeList:[String] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10",
                                          "11", "12", "13", "14", "15", "16", "17", "18", "19", "20",
                                           "21", "22", "23", "24", "25", "26", "27", "28", "29", "30",
                                            "31", "32", "33", "34", "35", "36", "37", "38", "39", "40",
                                             "41", "42", "43", "44", "45", "46", "47", "48", "49", "50",
                                              "51", "52", "53", "54", "55", "56", "57", "58", "59", "60"]
    
    static let soundList:[String] = ["기본사운드"]
    
    ///최저 요산 수치
    static let minUserHeight:CGFloat = 100.0
    ///최대 요산 수치
    static let maxUserHeight:CGFloat = 250.0
    
    ///Push Identifier Prefix
    static let goutIdentifier = "goutIdentifier_"
}

