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
    var viewTypeStr = BehaviorRelay<String?>(value: "")
    var test2 = BehaviorRelay<String?>(value: "")
    var uricacidDataList:Observable<[GoutData]>!
    var te:Observable<String>!
    
    init() {
        uricacidObserve()
    }
    
    func uricacidObserve() {
        
//       uricacidDataList = Observable.combineLatest(viewTypeStr, test2, resultSelector: { (lastLeft, lastRight) in
//        
//            print("lastLeft = \(lastLeft!), lastRight = \(lastRight!)")
//            var goutDatas:[GoutData] = []
//
//            return goutDatas
//        })
        
        te = viewTypeStr.asObservable().map{
            v in
            print("v = \(v!)")
            return v!
        }
        
//        uricacidDataList = viewTypeStr.asObservable().map{
//            viewTypeStr in
//            
//            print("test = \(viewTypeStr!)")
//            
//            var goutDatas:[GoutData] = []
//            
//            return goutDatas
//        }
        
//        Obser
    
    }
}
