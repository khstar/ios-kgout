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
    var listType = BehaviorRelay<String>(value: StringConstants.allUricacidList)
    var rowV = BehaviorRelay<(row: Int, component: Int)>(value: (0, 0))
    
    var items = Observable.of(["a", "b", "c"])
    
    init() {
//        rowV.asObservable().map({_ in print("Tester")})
//
//        rowV.asObservable().
        
        observeListType()
    }
    
    private func observeListType() {
        
        rowV.asObservable().map({_ in print("Tester")}).subscribe({_ in print("subscribe")})
        
    }
    
}
