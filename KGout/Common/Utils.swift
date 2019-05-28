//
//  Utils.swift
//  Gout
//
//  Created by khstar on 2018. 9. 6..
//  Copyright © 2018년 khstar. All rights reserved.
//

import UIKit
import Photos
import Foundation
import UserNotifications
import AVFoundation

import RxSwift
import SwiftyJSON

class Utils{
    
    static func getAppIcon() -> UIImage {
        
        let iconsDictionary = Bundle.main.infoDictionary?["CFBundleIcons"] as? NSDictionary
        
        let primaryIconsDictionary = iconsDictionary?["CFBundlePrimaryIcon"] as? NSDictionary
        
        let iconFiles = primaryIconsDictionary!["CFBundleIconFiles"] as! NSArray
        
        let lastIcon = iconFiles.lastObject as! NSString
        
        let icon = UIImage(named: lastIcon as String)
        
        return icon!
    }
    
    static func getUnderlineAttributeText(text: String) -> NSAttributedString{
        return  NSAttributedString(string: text, attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
    }
    
    static func getImageURL() -> URL{
        
        let docDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        return docDir.appendingPathComponent("tmp.jpg")
    }
    
    static func nickname( _ nick: String) -> String{
        let name: String
        if nick.count > 10 {
            name = nick.substring(to: nick.index(nick.startIndex, offsetBy: 10)) + "\n" + nick.substring(from: nick.index(nick.startIndex, offsetBy: 10))
        } else {
            name = nick
        }
        return name
    }
    
    static func heightOfString(_ str: String, fontSize: CGFloat, width: CGFloat) -> CGFloat{
        let labelString = NSAttributedString(string: str, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: fontSize)])
        
        let cellRect = labelString.boundingRect(with: CGSize(width: width, height: .greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        
        return cellRect.height
    }
    
    static func widthOfString(_ str: String, font: UIFont) -> CGFloat {
        let requiredSize: CGSize = str.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil).size
        
        return requiredSize.width
    }
    
    static func transTagArray(_ tags : String) -> [String]{
        return tags.components(separatedBy: ",").map{ $0.trimmingCharacters(in: .whitespaces) }.filter{ !$0.isEmpty }
    }
    
    static func makeNotiId(id: Int) -> String{
        return "skin10_noti_\(id)"
    }
    
    //제목을 한줄로 처리 한줄~세줄 제목의 우선순위
    static func convertTitleOne(subject:String, subject2:String, subject3:String) -> String {
        
        if !subject.isEmpty {
            return subject
        }
        
        if !subject2.isEmpty {
            return String(subject2.filter { !"\n".contains($0) })
        }
        
        if !subject3.isEmpty {
            return String(subject3.filter { !"\n".contains($0) })
        }
        
        return ""
    }
    
    static func valueInt(data: [AnyHashable: Any], key: String) -> Int? {
        return data[key] as? Int ?? Int(data[key] as? String ?? "")
    }
    
    static func valueBool(data: [AnyHashable: Any], key: String) -> Bool? {
        return data[key] as? Bool ?? Bool(data[key] as? String ?? "")
    }
    
    static func unscheduleLocalNotification(id: String){
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { items in
            var idArray: [String] = []
            for item in items {
                if item.identifier.contains(id) {
                    idArray.append(item.identifier)
                }
            }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: idArray)
        })
    }
    
    static func hasNotification(id: String, completed : @escaping ((Bool) -> Void) ){
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { items in
            var has = false
            for item in items {
                if item.identifier.contains(id) {
                    completed(true)
                    has = true
                    break
                    
                }
            }
            if !has { completed(false) }
            
        })
        
    }
    
    static func falseArray(_ num: Int) -> [Bool] {
        var array: [Bool] = []
        
        for _ in 0..<num {
            array.append(false)
        }
        
        return array
    }
    
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
    
    
    static func showHHmmmss(timeString:String) -> String {
        
        let timeFormat = "HH:mm"
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = timeFormat
        
        //DateFormat이 HH:mm인지 확인
        if let date = dateFormatter.date(from: timeString) {
            print(date)
            
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
    
    static func cropImage(image: UIImage, rect: CGRect) ->UIImage? {
        
        if let cgImage = image.cgImage {
            let contextImage: UIImage = UIImage(cgImage: cgImage)
            
            var croppedContextImage: CGImage?  = nil
            if let contextImage = contextImage.cgImage {
                if let croppedImage = contextImage.cropping(to: rect) {
                    croppedContextImage = croppedImage
                }
            }
            
            if let croppedImage = croppedContextImage {
                let image = UIImage(cgImage: croppedImage, scale: image.scale, orientation: image.imageOrientation)
                return image
            }
        }
        
        return nil
    }
    
    static func mergeImage(backImage: UIImage, inputImage: UIImage) -> UIImage? {
        let newSize = backImage.size
        UIGraphicsBeginImageContextWithOptions(newSize, false, backImage.scale)
        backImage.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        inputImage.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height), blendMode: .normal, alpha: 1.0)
        let mergeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return mergeImage
    }
    
    static func getAssetThumbnail(asset: PHAsset, size: CGSize) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: size, contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
    
    
    static func getAssetImage(asset: PHAsset, size: CGSize) -> UIImage? {
        var image: UIImage?
        
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        
        options.isSynchronous = true
        options.version = .original
        
        manager.requestImageData(for: asset, options: options){ (data, _, _, _) in
            if let data = data {
                image = UIImage(data: data)
            }
        }
        
        return image
    }
    
    // sampleBufferからUIImageへ変換
    class func imageFromSampleBuffer(_ sampleBuffer: CMSampleBuffer) -> UIImage {
        let imageBuffer: CVImageBuffer! = CMSampleBufferGetImageBuffer(sampleBuffer)
        
        // ベースアドレスをロック
        CVPixelBufferLockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: 0))
        
        // 画像データの情報を取得
        let baseAddress: UnsafeMutableRawPointer = CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0)!
        
        let bytesPerRow: Int = CVPixelBufferGetBytesPerRow(imageBuffer)
        let width: Int = CVPixelBufferGetWidth(imageBuffer)
        let height: Int = CVPixelBufferGetHeight(imageBuffer)
        
        // RGB色空間を作成
        let colorSpace: CGColorSpace! = CGColorSpaceCreateDeviceRGB()
        
        // Bitmap graphic contextを作成
        let bitsPerCompornent: Int = 8
        let bitmapInfo = CGBitmapInfo(rawValue: (CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue) as UInt32)
        let newContext: CGContext! = CGContext(data: baseAddress, width: width, height: height, bitsPerComponent: bitsPerCompornent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) as CGContext!
        
        // Quartz imageを作成
        let imageRef: CGImage! = newContext!.makeImage()
        
        // ベースアドレスをアンロック
        CVPixelBufferUnlockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: 0))
        
        // UIImageを作成
        let resultImage: UIImage = UIImage(cgImage: imageRef)
        
        return resultImage
    }
    
    /*
     OpenCV Error: Assertion failed (!empty()) in detectMultiScale, file /Volumes/build-storage/build/master_iOS-mac/opencv/modules/objdetect/src/cascadedetect.cpp, line 1681
     libc++abi.dylib: terminating with uncaught exception of type cv::Exception: /Volumes/build-storage/build/master_iOS-mac/opencv/modules/objdetect/src/cascadedetect.cpp:1681:
     error: (-215) !empty() in function detectMultiScale
     위와 같은 에러가 발생하는 경우 saveDetectXmlFromBundle가 실행되지 않아서 발생하는 에러로 최초 한번은 호출되어야 문제없이 수행됨
     OpenCV관련 파일을 Path 이동하는 듯??
     */
    class func saveDetectXmlFromBundle() {
        
        if let path = Bundle.main.path(forResource: "haarcascade_frontalface_default", ofType: "xml"){
            
            let fm = FileManager()
            let exists = fm.fileExists(atPath: path)
            if(exists){
                let destPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
                let fullDestPath = NSURL(fileURLWithPath: destPath).appendingPathComponent("haarcascade_frontalface_default.xml")
                let fullDestPathString = fullDestPath?.path
                if fm.fileExists(atPath: fullDestPathString!) { return }
                do {
                    try fm.copyItem(atPath: path, toPath: fullDestPathString!)
                } catch {
                    print(error)
                }
                //let c = fm.contents(atPath: path)
                //_ = NSString(data: c!, encoding: String.Encoding.utf8.rawValue)
                //ret = cString as! String
            }
        }
        if let path = Bundle.main.path(forResource: "haarcascade_eye_tree_eyeglasses", ofType: "xml"){
            
            let fm = FileManager()
            let exists = fm.fileExists(atPath: path)
            if(exists){
                let destPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
                let fullDestPath = NSURL(fileURLWithPath: destPath).appendingPathComponent("haarcascade_eye_tree_eyeglasses.xml")
                let fullDestPathString = fullDestPath?.path
                do {
                    try fm.copyItem(atPath: path, toPath: fullDestPathString!)
                } catch {
                    print(error)
                }
                //let c = fm.contents(atPath: path)
                //_ = NSString(data: c!, encoding: String.Encoding.utf8.rawValue)
                //ret = cString as! String
            }
        }
        if let path = Bundle.main.path(forResource: "haarcascade_mcs_nose", ofType: "xml"){
            
            let fm = FileManager()
            let exists = fm.fileExists(atPath: path)
            if(exists){
                let destPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
                let fullDestPath = NSURL(fileURLWithPath: destPath).appendingPathComponent("haarcascade_mcs_nose.xml")
                let fullDestPathString = fullDestPath?.path
                do {
                    try fm.copyItem(atPath: path, toPath: fullDestPathString!)
                } catch {
                    print(error)
                }
                //let c = fm.contents(atPath: path)
                //_ = NSString(data: c!, encoding: String.Encoding.utf8.rawValue)
                //ret = cString as! String
            }
        }
        if let path = Bundle.main.path(forResource: "haarcascade_mcs_mouth", ofType: "xml"){
            let fm = FileManager()
            let exists = fm.fileExists(atPath: path)
            if(exists){
                let destPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
                let fullDestPath = NSURL(fileURLWithPath: destPath).appendingPathComponent("haarcascade_mcs_mouth.xml")
                let fullDestPathString = fullDestPath?.path
                do {
                    try fm.copyItem(atPath: path, toPath: fullDestPathString!)
                } catch {
                    print(error)
                }
                //let c = fm.contents(atPath: path)
                //_ = NSString(data: c!, encoding: String.Encoding.utf8.rawValue)
                //ret = cString as! String
            }
        }
    }
    
    
    static func decodeJWT(jwtToken jwt: String) -> [String: Any] {
        let segments = jwt.components(separatedBy: ".")
        return decodeJWTPart(segments[1]) ?? [:]
    }
    
    private static func base64UrlDecode(_ value: String) -> Data? {
        var base64 = value
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
        let requiredLength = 4 * ceil(length / 4.0)
        let paddingLength = requiredLength - length
        if paddingLength > 0 {
            let padding = "".padding(toLength: Int(paddingLength), withPad:     "=", startingAt: 0)
            base64 = base64 + padding
        }
        return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
    }
    
    private static func decodeJWTPart(_ value: String) -> [String: Any]? {
        guard let bodyData = base64UrlDecode(value),
            let json = try? JSONSerialization.jsonObject(with: bodyData, options: []), let payload = json as? [String: Any] else {
                return nil
        }
        
        return payload
    }
    
    static func labelHeight(constraintedWidth width: CGFloat, useLabel:UILabel) -> CGFloat {
        
        let label = useLabel
        label.frame = CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude)
        label.sizeToFit()
        
        return label.frame.height
        
    }
    
    static func getSystemVersion() -> String {
        return UIDevice.current.systemVersion
    }
    
    ///디바이스 구분을 위한 Identifier 찾기
    static func getDeviceIdentifier() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        return identifier
    }
    
    //현재 Device가 iPhoneX인지 구분
    static func bIphoneX() -> Bool {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        //iPhoneX 구분
        if identifier == "iPhone10,3" ||
            identifier == "iPhone10,6" ||
            identifier == "x86_64" {
            return true
        }
        
        return false
    }
    
    //iPhone5이하 모델인지 체크
    static func bIphone5Under() -> Bool {
        if UIScreen.main.nativeBounds.height < 1334 {
            return true
        }
        
        return false
    }
    
    /**
     디바이스 모델 (iPhone, iPad) 이름 전달 (iPhone6, iPhone7 Plus...)
     */
    static func deviceModelName() -> String {
        
        let model = UIDevice.current.model
        
        switch model {
        case "iPhone":
            return self.iPhoneModel()
        case "iPad":
            return self.iPadModel()
        case "iPad mini" :
            return self.iPadMiniModel()
        default:
            return "Unknown Model : \(model)"
        }
        
    }
    
    /**
     iPhone 모델 이름 (iPhone6, iPhone7 Plus...)
     */
    static func iPhoneModel() -> String {
        
        let identifier = self.getDeviceIdentifier()
        
        switch identifier {
        case "iPhone1,1" :
            return "iPhone"
        case "iPhone1,2" :
            return "iPhone3G"
        case "iPhone2,1" :
            return "iPhone3GS"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3" :
            return "iPhone4"
        case "iPhone4,1" :
            return "iPhone4s"
        case "iPhone5,1", "iPhone5,2" :
            return "iPhone5"
        case "iPhone5,3", "iPhone5,4" :
            return "iPhone5c"
        case "iPhone6,1", "iPhone6,2" :
            return "iPhone5s"
        case "iPhone7,2" :
            return "iPhone6"
        case "iPhone7,1" :
            return "iPhone6 Plus"
        case "iPhone8,1" :
            return "iPhone6s"
        case "iPhone8,2" :
            return "iPhone6s Plus"
        case "iPhone8,4" :
            return "iPhone SE"
        case "iPhone9,1", "iPhone9,3" :
            return "iPhone7"
        case "iPhone9,2", "iPhone9,4" :
            return "iPhone7 Plus"
        case "iPhone10,1", "iPhone10,4" :
            return "iPhone8"
        case "iPhone10,2", "iPhone10,5" :
            return "iPhone8 Plus"
        case "iPhone10,3", "iPhone10,6" :
            return "iPhoneX"
        default:
            return "Unknown iPhone : \(identifier)"
        }
    }
    
    /**
     iPad 모델 이름
     */
    static func iPadModel() -> String {
        
        let identifier = self.getDeviceIdentifier()
        
        switch identifier {
        case "iPad1,1":
            return "iPad"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4" :
            return "iPad2"
        case "iPad3,1", "iPad3,2", "iPad3,3" :
            return "iPad 3rd Generation"
        case "iPad3,4", "iPad3,5", "iPad3,6" :
            return "iPad 4rd Generation"
        case "iPad4,1", "iPad4,2", "iPad4,3" :
            return "iPad Air"
        case "iPad5,3", "iPad5,4" :
            return "iPad Air2"
        case "iPad6,7", "iPad6,8" :
            return "iPad Pro 12.9"
        case "iPad6,3", "iPad6,4" :
            return "iPad Pro 9.7"
        case "iPad6,11", "iPad6,12" :
            return "iPad 5th Generation"
        case "iPad7,1", "iPad7,2" :
            return "iPad Pro 12.9 2nd Generation"
        case "iPad7,3", "iPad7,4" :
            return "iPad Pro 10.5"
        case "iPad7,5", "iPad7,6" :
            return "iPad 6th Generation"
        default:
            return "Unknown iPad : \(identifier)"
        }
    }
    
    /**
     iPad mini 모델 이름
     */
    static func iPadMiniModel() -> String {
        
        let identifier = self.getDeviceIdentifier()
        
        switch identifier {
        case "iPad2,5", "iPad2,6", "iPad2,7" :
            return "iPad mini"
        case "iPad4,4", "iPad4,5", "iPad4,6" :
            return "iPad mini2"
        case "iPad4,7", "iPad4,8", "iPad4,9" :
            return "iPad mini3"
        case "iPad5,1", "iPad5,2" :
            return "iPad mini4"
        default:
            return "Unknown iPad mini : \(identifier)"
        }
    }
    
    /**
     화면 회정 상태 반환 - 사용되지 않는 함수지만 Util성으로 두기
     - Returns: screenState 화면 회전 enum
     */
    static func getDeviceScreenState() -> ScreenState {
        let deviceOrientation:UIDeviceOrientation = UIDevice.current.orientation
//        if(!UIDeviceOrientationIsLandscape(deviceOrientation)){
        //단말기 회전 상태 처리 변경
        if(deviceOrientation.isLandscape){
            return ScreenState.portrait
        } else {
            return ScreenState.landscape
        }
    }
    
    static var getDecimalNumberFormatter: NumberFormatter  = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        return f
    }()
    
}


extension NSAttributedString {
    
    var trailingNewlineChopped: NSAttributedString {
        if string.hasSuffix("\n") {
            return self.attributedSubstring(from: NSRange(location: 0, length: length - 1))
        } else {
            return self
        }
    }
}
