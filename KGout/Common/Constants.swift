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

class StringConstants {
    
    //common
    static let commonDate = NSLocalizedString("date", comment: "날짜")
    static let commonTime = NSLocalizedString("time", comment: "시간")
    static let commonDesc = NSLocalizedString("desc", comment: "요약")
    
    //common message
    static let noData = NSLocalizedString("noData", comment: "데이터가 없습니다.")
    static let noDataDelete = NSLocalizedString("noDataDelete", comment: "삭제할 데이터가 없습니다.")
    
    //Btn
    static let addBtn = NSLocalizedString("addBtn", comment: "추가")
    static let delBtn = NSLocalizedString("delBtn", comment: "삭제")
    static let saveBtn = NSLocalizedString("saveBtn", comment: "저장")
    static let cancelBtn = NSLocalizedString("cancelBtn", comment: "취소")
    static let modifyBtn = NSLocalizedString("modifyBtn", comment: "수정")
    static let yesBtn = NSLocalizedString("yesBtn", comment: "예")
    static let noBtn = NSLocalizedString("noBtn", comment: "아니오")
    static let completeBtn = NSLocalizedString("completeBtn", comment: "완료")
    
    //요산 리스트 조회 타입 문자열
    static let allUricacidList = NSLocalizedString("allUricacidList", comment: "전체")
    static let yearUricacidList = NSLocalizedString("yearUricacidList", comment: "년도별")
    static let monthUricacidList = NSLocalizedString("monthUricacidList", comment: "월별")
    
    //gout
    static let uricacid = NSLocalizedString("uricacid", comment: "요산")
    static let uricacidTitle = NSLocalizedString("uricacidTitle", comment: "요산 관리")
    static let uricacidAdd = NSLocalizedString("uricacidAdd", comment: "요산 추가")
    static let uricacidInfoDesc = NSLocalizedString("uricacidInfoDesc", comment: "해당 날짜에 기록해야할 정보가 있으면 입력해 주세요. ")
    
    static let uricacidDataExistMSG = NSLocalizedString("uricacidDataExistMSG", comment: "데이터가 이미 존재합니다.")
    static let uricacidDataModifyMSG = NSLocalizedString("uricacidDataModifyMSG", comment: "수정 하시겠습니까?")
    static let uricacidDataAddMSG = NSLocalizedString("uricacidDataAddMSG", comment: "추가 하시겠습니까?")
    
    //
    static let uricacidMinMaxRangeMSG = NSLocalizedString("uricacidMinMaxRangeMSG", comment: "입력 값은 0 이상 20 이하여야 합니다.")
    static let uricacidDecimalErrMSG = NSLocalizedString("uricacidDecimalErrMSG", comment: "소수점 한 자리까지 입력 할 수 있습니다.")
    static let uricacidDotErrMSG = NSLocalizedString("uricacidDotErrMSG", comment: ".이 두 개 들어갈수 없습니다.")
}
