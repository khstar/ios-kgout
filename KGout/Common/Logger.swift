//
//  Logger.swift
//  Gout
//
//  Created by khstar on 2018. 9. 6..
//  Copyright © 2018년 khstar. All rights reserved.
//

import Foundation

public class Logger {
    
    struct StaticInstance {
        static var logger:Logger?
    }
    
    public class func sharedInstance() -> Logger {
        if StaticInstance.logger == nil {
            StaticInstance.logger = Logger()
        }
        
        return StaticInstance.logger!
    }
    
    public func DFT_TRACE(filename: String = #file, line: Int = #line, funcname: String = #function) {
        print("[T][\(getDateTime())][\(getFileName(fullFilePath: filename))][\(funcname)][Line \(line)]")
    }
    
    public func DFT_TRACE_PRINT(filename: String = #file, line: Int = #line, funcname: String = #function, output:Any...) {
        print("[T][\(getDateTime())][\(filename)][\(funcname)][Line \(line)] \(output)")
    }
    
    public func debug(filename: String = #file, line: Int = #line, funcname: String = #function, output:Any...) {
        print("[D][\(getDateTime())][\(getFileName(fullFilePath: filename))][\(funcname)][Line \(line)] \(output)")
    }
    
    public func error(filename: String = #file, line: Int = #line, funcname: String = #function, output:Any...) {
        NSLog("[E][\(getFileName(fullFilePath: filename))][\(funcname)][Line \(line)] \(output)")
    }
    
    //파일명만 반환
    private func getFileName(fullFilePath:String) -> String {
        var pathArr:[String] = fullFilePath.components(separatedBy: "/")
        let pathArrCnt:Int = pathArr.count - 1
        
        return pathArr[pathArrCnt]
    }
    
    //현재 시간 반환 - yyyy-MM-dd HH:mm:ss
    private func getDateTime() -> String {
        let now:Date = Date.init()
        let dateFormat:DateFormatter = DateFormatter.init()
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss.SS"
        
        return dateFormat.string(from: now)
    }
}
