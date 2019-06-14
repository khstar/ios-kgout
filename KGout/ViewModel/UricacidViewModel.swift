//
//  UricacidViewModel.swift
//  KGout
//
//  Created by khstar on 03/06/2019.
//  Copyright © 2019 khstar. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class UricacidViewModel {
    
    let logger = Logger.sharedInstance()
    
    var viewTypeStr = BehaviorRelay<String?>(value: "")
    var test2 = BehaviorRelay<String?>(value: "")
    
    var uricacidDataList:Observable<[GoutData]>!
    var viewTypeObservable:Observable<String>!
    
    ///뷰 타입 플레그
    var viewTypeFlag = BehaviorRelay<Int?>(value: 0)
    var dateListObs:Observable<[String]>!
    
    ///날짜 선택
    var dateStr = BehaviorRelay<String?>(value: "")
    
    var uricacidSelectParam = BehaviorRelay<[String]?>(value: [])
    
    let databaseManager = DatabaseManager.sharedInstance()
    
    init() {
        uricacidObserve()
    }
    
    func uricacidObserve() {
        
        dateListObs = viewTypeFlag.asObservable().map {
            flag in
            
            guard let dateList = self.databaseManager.selectGoutDateList(listType: goutListType(rawValue: flag!)!) else {
                self.logger.error(output: "DateList is Nil : dateFlag = \(flag!)")
                return []
            }
            
            return dateList
        }
        
        
        uricacidDataList = uricacidSelectParam.asObservable().map{
            param in
            
            if param!.count > 0 {
                self.logger.debug(output: "Year : \(param![0]), viewType : \(goutListType(rawValue: Int(param![1])!)!)")
                
                let uricacidList = self.databaseManager.selectGoutVaule(date: param![0], listType: goutListType(rawValue: Int(param![1])!)!)
                return uricacidList!
            }
            
            return []
        }
        
//        uricacidDataList = dateStr.withLatestFrom(viewTypeFlag, resultSelector: {(dateStr, viewTypeFlag) -> [GoutData] in
//            print("dateStr = \(dateStr!), viewTypeFlag = \(viewTypeFlag!)")
//
//            let uricacidList = self.databaseManager.selectGoutVaule(date: dateStr!, listType: goutListType(rawValue: viewTypeFlag!)!)
//
//            print("tester")
//
//            return uricacidList!
//        })
        
        
//       uricacidDataList = Observable.combineLatest(viewTypeFlag, dateStr, resultSelector: { (viewTypeFlag, dateStr) -> [GoutData] in
//        
//            print("dateStr = \(dateStr), viewTypeFlag = \(viewTypeFlag)")
//            let uricacidList = self.databaseManager.selectGoutVaule(date: dateStr, listType: goutListType(rawValue: viewTypeFlag!)!)
//            
//            print("tester")
//            
//            return uricacidList!
//        })
        
        
    }
    
    func selectUricacidList() {
        
    }
}
