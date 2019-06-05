//
//  GoutFileManager.swift
//  Gout
//
//  Created by khstar on 2018. 9. 7..
//  Copyright © 2018년 khstar. All rights reserved.
//

import Foundation


class GoutFileManager {
    let logger:Logger = Logger.sharedInstance()
    
    private init() {}
    
    struct StaticInstance {
        static var goutFileManager:GoutFileManager?
    }
    
    public class func sharedInstance() -> GoutFileManager {
        if StaticInstance.goutFileManager == nil {
            StaticInstance.goutFileManager = GoutFileManager()
        }
        
        return StaticInstance.goutFileManager!
    }
    
    func isDatabaseFile() -> Bool {

        let docsDirChange = self.getDBFilePath()
        
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: docsDirChange) {
            return true
        } else {
            return false
        }
    }
    
    func getDBFilePath() -> String {
        let dirPathsChange = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        var docsDirChange = dirPathsChange[0] as String
        docsDirChange.append("/gout.db")
        
        return docsDirChange
    }
    
    func getFilePath() -> String {
        let dirPathsChange = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return dirPathsChange[0] as String
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func removeImage(fileName:String) {
        do {
            var pathString = self.getDocumentsDirectory()
            pathString.appendPathComponent(fileName)
            let fileFullPath = pathString.absoluteString

            try FileManager.default.removeItem(at: URL.init(string: fileFullPath)!)
        } catch {
            logger.error(output: "파일 삭제 실패")
        }
    }
    
}
