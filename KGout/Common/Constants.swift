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
    static let noDataMSG = NSLocalizedString("noDataMSG", comment: "데이터가 없습니다.")
    static let noDataDeleteMSG = NSLocalizedString("noDataDeleteMSG", comment: "No data to delete.")
    
    //Btn
    static let addBtn = NSLocalizedString("addBtn", comment: "추가")
    static let delBtn = NSLocalizedString("delBtn", comment: "삭제")
    static let saveBtn = NSLocalizedString("saveBtn", comment: "저장")
    static let cancelBtn = NSLocalizedString("cancelBtn", comment: "취소")
    static let modifyBtn = NSLocalizedString("modifyBtn", comment: "수정")
    static let yesBtn = NSLocalizedString("yesBtn", comment: "예")
    static let noBtn = NSLocalizedString("noBtn", comment: "아니오")
    static let completeBtn = NSLocalizedString("completeBtn", comment: "완료")
    static let okBtn = NSLocalizedString("okBtn", comment: "확인")
    static let closeBtn = NSLocalizedString("closeBtn", comment: "닫기")
    static let retryBtn = NSLocalizedString("retryBtn", comment: "재시도")
    
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
    
    
    //Drug
    static let medicineInfoTitle = NSLocalizedString("medicineInfoTitle", comment: "약품 정보")
    static let medicineInfoAddTitle = NSLocalizedString("medicineInfoAddTitle", comment: "약 정보 추가")
    
    static let medicineName = NSLocalizedString("medicineName", comment: "약 이름")
    static let medicineInfo = NSLocalizedString("medicineInfo", comment: "약 정보")
    static let medicineAlarm = NSLocalizedString("medicineAlarm", comment: "약 알람")
    
    static let medicineNameFieldMSG = NSLocalizedString("medicineNameFieldMSG", comment: "약 이름을 입력하세요.")
    static let medicineInfoFieldMSG = NSLocalizedString("medicineInfoFieldMSG", comment: "약 정보를 입력하세요.")
    
    //Alarm
    static let alarmTitle = NSLocalizedString("alarmTitle", comment: "알람")
    static let alarmRegistTitle = NSLocalizedString("registAlarmTitle", comment: "알람 등록")
    static let noAlarmMSG = NSLocalizedString("noAlarmMSG", comment: "등록된 알람이 없습니다.")
    static let alarmInfoTitle = NSLocalizedString("alarmInfoTitle", comment: "설명")
    
    static let addAlarm = NSLocalizedString("addAlarm", comment: "알람 추가")
    static let delAlarm = NSLocalizedString("delAlarm", comment: "알람 삭제")
    
    static let resetAlarmBtn = NSLocalizedString("resetAlarmBtn", comment: "알람 리셋")
    
    static let allday = NSLocalizedString("allday", comment: "매일")
    static let monday = NSLocalizedString("monday", comment: "월")
    static let tuesday = NSLocalizedString("tuesday", comment: "화")
    static let wednesday = NSLocalizedString("wednesday", comment: "수")
    static let thursday = NSLocalizedString("thursday", comment: "목")
    static let friday = NSLocalizedString("friday", comment: "금")
    static let saturday = NSLocalizedString("saturday", comment: "토")
    static let sunday = NSLocalizedString("sunday", comment: "일")
    
    static let alarmResetCompMSG = NSLocalizedString("alarmResetCompMSG", comment: "알람이 재설정 되었습니다.")
    static let alarmDeleteAlertMSG = NSLocalizedString("alarmDeleteAlertMSG", comment: "알람 삭제는 취소할 수 없습니다.\n계속 하시겠습니까?")
    //UserInfo
    static let infoTitle = NSLocalizedString("infoTitle", comment: "정보")
    static let userNameTitle = NSLocalizedString("userNameTitle", comment: "이름")
    static let birthdayTitle = NSLocalizedString("birthdayTitle", comment: "생년월일")
    static let ageTitle = NSLocalizedString("ageTitle", comment: "나이")
    static let heightTitle = NSLocalizedString("heightTitle", comment: "키(신장)")
    static let weightTitle = NSLocalizedString("weightTitle", comment: "몸무게")
    static let bmiTitle = NSLocalizedString("bmiTitle", comment: "BMI")
    static let obesityTitle = NSLocalizedString("obesityTitle", comment: "비만도")
    
    static let autoMSG = NSLocalizedString("autoMSG", comment: "자동생성")
    static let userNameFieldMSG = NSLocalizedString("userNameFieldMSG", comment: "이름으르 입력해주세요.")
    static let birthdayFieldMSG = NSLocalizedString("birthdayFieldMSG", comment: "1900-01-01")
    static let heightFieldMSG = NSLocalizedString("heightFieldMSG", comment: "키(신장)을 입력해주세요.")
    static let weightFieldMSG = NSLocalizedString("weightFieldMSG", comment: "몸무게를 입력해주세요.")
    
    static let userInfoSaveMSG = NSLocalizedString("userInfoSaveMSG", comment: "사용자 정보가 저장되었습니다.")
    static let bmiGenerationAlertMSG = NSLocalizedString("bmiGenerationAlertMSG", comment: "키와 몸무게를 입력하면 자동으로 생성됩니다.")
    static let weightRangeAlertMSG = NSLocalizedString("weightRangeAlertMSG", comment: "몸무게 입력 범위가 맞습니까?")
    static let heightRangeAlertMSG = NSLocalizedString("heightRangeAlertMSG", comment: "키(신장) 입력 범위가 맞습니까?")
    
    static let lowWeight = NSLocalizedString("lowWeight", comment: "저체중")
    static let standardWeight = NSLocalizedString("standardWeight", comment: "정상")
    static let overWeight = NSLocalizedString("overWeight", comment: "과체중")
    static let obesityWeight = NSLocalizedString("obesityWeight", comment: "비만")
    static let altitudeObesityWeight = NSLocalizedString("altitudeObesityWeight", comment: "고도비만")
    
}
