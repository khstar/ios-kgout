//
//  Extensions.swift
//  Gout
//
//  Created by khstar on 2018. 8. 31..
//  Copyright © 2018년 khstar. All rights reserved.
//

import Foundation
import UIKit

extension UIColor{
    convenience init(_ hex: Int, alpha: Double = 1.0){
        let r = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(hex & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b, alpha: CGFloat(alpha))
    }
    
    static var defaultTxt: UIColor { return UIColor(0x2B2B2B) }
    static var pressTxt: UIColor { return UIColor(0x2B2B2B, alpha: 0.5) }
    static var guideErrorTxt: UIColor { return UIColor(0x000000, alpha: 0.3) }
    static var guideTxt: UIColor { return UIColor(0xABABAB) }
    static var errorTxt: UIColor { return UIColor(0xd00f0f) }
    static var answerTxt: UIColor { return UIColor(0x575757) }
    static var answerPressTxt: UIColor { return UIColor(0x575757, alpha: 0.5) }
    static var beforeGraphColor: UIColor { return UIColor(0xEAB4B4, alpha: 0.4) }
    static var beforeLineColor: UIColor { return UIColor(0xEBC5C5) }
    static var currentGraphColor: UIColor { return UIColor(0x9AD0E5, alpha: 0.6) }
    static var currentLineColor: UIColor { return UIColor(0x5B97AF) }
    
    static var sBlack: UIColor { return UIColor(0x2C2C2C) }
    static var placeholder: UIColor { return UIColor(0x000000, alpha: 0.5) }
    static var line1: UIColor { return UIColor(0x000000, alpha: 0.2) }
    
    static var buttonTxt1: UIColor { return UIColor(0xFFFFFF) }
    static var buttonTxt1Pre: UIColor { return UIColor(0xACACAC) }
    static var buttonTxt1Dis: UIColor { return UIColor(0xCECECE) }
    
    static var buttonTxt2: UIColor { return UIColor(0x2C2C2C) }
    static var buttonTxt2Pre: UIColor { return UIColor(0x5C5C5C) }
    static var buttonTxt2Dis: UIColor { return UIColor(0xCFCFCF) }
    
    static var buttonTxt3: UIColor { return UIColor(0xFFFFFF) }
    static var buttonTxt3Pre: UIColor { return UIColor(0xE5E5E5) }
    
    static var lineGrey: UIColor {return UIColor(0xf8f8f8)}
    
    static var collectionBackgroundColor:UIColor {return UIColor(0xf8f8f8)}
}

extension UILabel{
    func totalLine() -> Int{
        let textSize = CGSize(width: frame.size.width, height: .greatestFiniteMagnitude)
        
        let rHeight = lroundf(Float(sizeThatFits(textSize).height))
        let charSize = lroundf(Float(font.lineHeight))
        return rHeight / charSize
        
    }
    
    func getNumOfLines(width: CGFloat) -> Int{
        //        self.text.rect
        //        let label: UILabel = obj as! UILabel
        guard let _ = self.text else { return 0 }
        let requiredSize: CGSize = (self.text)!.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: self.font], context: nil).size
        var charSize: CGFloat = self.font.lineHeight
        let rHeight: CGFloat = requiredSize.height
        charSize = charSize == 0 ? 1 : charSize
        return (NSInteger)(rHeight/charSize)
    }
    
    func getActualWidth() -> CGFloat {
        let requiredSize: CGSize = (self.text)!.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: self.font], context: nil).size
        
        return requiredSize.width
    }
    
    //    func getLinesOfString() -> [String]{
    //        if let text = self.text {
    //            getLine
    //        }
    //    }
    
    func getLinesArrayOfStringInLabel() -> [String] {
        guard let _ = self.text else { return [""] }
        let text:NSString = self.text! as NSString // TODO: Make safe?
        let font:UIFont = self.font
        let rect:CGRect = self.frame
        
        let myFont:CTFont = CTFontCreateWithName(font.fontName as CFString, font.pointSize, nil)
        let attStr:NSMutableAttributedString = NSMutableAttributedString(string: text as String)
        attStr.addAttribute(NSAttributedString.Key(rawValue: String(kCTFontAttributeName)), value:myFont, range: NSMakeRange(0, attStr.length))
        let frameSetter:CTFramesetter = CTFramesetterCreateWithAttributedString(attStr as CFAttributedString)
        let path:CGMutablePath = CGMutablePath()
        path.addRect(CGRect(x: 0, y: 0, width: rect.size.width, height: 100000))
        //        CGPathAddRect(path, nil, CGRectMake(0, 0, rect.size.width, 100000))
        let frame:CTFrame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, nil)
        let lines = CTFrameGetLines(frame) as NSArray
        var linesArray = [String]()
        
        for line in lines {
            let lineRange = CTLineGetStringRange(line as! CTLine)
            let range:NSRange = NSMakeRange(lineRange.location, lineRange.length)
            let lineString = text.substring(with: range)
            linesArray.append(lineString as String)
        }
        return linesArray
    }
    
    func marqueeLabel(){
        if Utils.widthOfString(self.text!, font: self.font) > self.bounds.size.width {
            
            UIView.animate(withDuration: 12.0, delay: 1, options: [.curveLinear, .repeat], animations: {
                self.center = CGPoint(x: 0 - self.bounds.size.width / 2, y: self.center.y)
            }, completion: nil)
        }
    }
}

private var __maxLengths = [UITextField: Int]()

extension UITextField {
    var maxLength: Int {
        get{
            guard let l = __maxLengths[self] else{
                return 150
            }
            return l
        }
        set{
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    @objc func fix(textField: UITextField){
        if (textField.text?.characters.count)! > maxLength {
            textField.text = textField.text?.safeLimitedTo(lenght: maxLength)
        }
    }
}

extension String {
    func isValidEmail() -> Bool {
        let emailRegEx = "^[_A-Za-z0-9-]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$"//"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func isValidNick() -> Bool {
        return self.characters.count > 0 && self.characters.count < 20
    }
    
    func isValidPassword() -> Bool {
        return self.characters.count > 5
    }
    
    func safeLimitedTo(lenght n: Int) -> String {
        let c = self.characters
        if (c.count <= n) { return self }
        return String(Array(c).prefix(upTo: n))
    }
    
    func replace(_ index: Int, _ newChar: Character) -> String{
        var chars = Array(self.characters)
        chars[index] = newChar
        return String(chars)
    }
        
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}

extension CGFloat {
    var roundTo1f: CGFloat {return CGFloat((10 * self)/10)  }
    var roundTo2f: CGFloat {return CGFloat((100 * self)/100)  }
    var roundTo3f: CGFloat {return CGFloat((1000 * self)/1000) }
}

extension NSObject{
    class var className: String{
        return String(describing: self)
    }
    
    var className: String{
        return type(of: self).className
    }
}

extension Double {
    func toString() -> String {
        return String(format: "%.1f",self)
    }
}

extension Bool {
    var intValue: Int {
        return self ? 1 : 0
    }
}

extension UIImage {
    
    
    func fixOrientation() -> UIImage {
        
        
        // No-op if the orientation is already correct
        if ( self.imageOrientation == UIImage.Orientation.up ) {
            return self;
        }
        
        
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        
        if ( self.imageOrientation == UIImage.Orientation.down || self.imageOrientation == UIImage.Orientation.downMirrored ) {
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: CGFloat(M_PI))
        }
        
        
        if ( self.imageOrientation == UIImage.Orientation.left || self.imageOrientation == UIImage.Orientation.leftMirrored ) {
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(M_PI_2))
        }
        
        
        if ( self.imageOrientation == UIImage.Orientation.right || self.imageOrientation == UIImage.Orientation.rightMirrored ) {
            transform = transform.translatedBy(x: 0, y: self.size.height);
            transform = transform.rotated(by: CGFloat(-M_PI_2));
        }
        
        
        if ( self.imageOrientation == UIImage.Orientation.upMirrored || self.imageOrientation == UIImage.Orientation.downMirrored ) {
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        }
        
        
        if ( self.imageOrientation == UIImage.Orientation.leftMirrored || self.imageOrientation == UIImage.Orientation.rightMirrored ) {
            transform = transform.translatedBy(x: self.size.height, y: 0);
            transform = transform.scaledBy(x: -1, y: 1);
        }
        
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        let ctx: CGContext = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height),
                                       bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0,
                                       space: self.cgImage!.colorSpace!,
                                       bitmapInfo: self.cgImage!.bitmapInfo.rawValue)!;
        
        
        ctx.concatenate(transform)
        
        
        if ( self.imageOrientation == UIImage.Orientation.left ||
            self.imageOrientation == UIImage.Orientation.leftMirrored ||
            self.imageOrientation == UIImage.Orientation.right ||
            self.imageOrientation == UIImage.Orientation.rightMirrored ) {
            ctx.draw(self.cgImage!, in: CGRect(x: 0,y: 0,width: self.size.height,height: self.size.width))
        } else {
            ctx.draw(self.cgImage!, in: CGRect(x: 0,y: 0,width: self.size.width,height: self.size.height))
        }
        
        
        // And now we just create a new UIImage from the drawing context and return it
        return UIImage(cgImage: ctx.makeImage()!)
    }
}

extension UIImage {
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

extension UIButton {
    func setBackgroundColor(_ color: UIColor, forState controlState: UIControl.State) {
        let colorImage = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1)).image { _ in
            color.setFill()
            UIBezierPath(rect: CGRect(x: 0, y: 0, width: 1, height: 1)).fill()
        }
        
        setBackgroundImage(colorImage, for: controlState)
    }
    
    func setBackgroundColor(_ color: UIColor, forState controlState: UIControl.State, corner:CGFloat) {
//        let colorImage = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1)).image { _ in
//            color.setFill()
//            UIBezierPath(roundedRect: self.bounds,
//                            byRoundingCorners: [.topLeft , .topRight, .bottomLeft, .bottomRight],
//                            cornerRadii:CGSize(width:corner, height:corner)).fill()
//        }
//        setBackgroundImage(colorImage, for: controlState)
        let colorImage = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1)).image { _ in
            color.setFill()
            UIBezierPath(rect: CGRect(x: 0, y: 0, width: 1, height: 1)).fill()
        }
        
        setBackgroundImageClippedToBounds(colorImage, for: controlState)
    }
    
    
    func setBackgroundImageClippedToBounds(_ image: UIImage, for state: UIControl.State) {
        if !(!clipsToBounds && layer.cornerRadius != 0.0) {
            setBackgroundImage(image, for: state)
            return
        }
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        
        UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).addClip()
        image.draw(in: bounds)
        let clippedBackgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        setBackgroundImage(clippedBackgroundImage, for: state)
    }
    
    func roundedButton(){
        let maskPAth1 = UIBezierPath(roundedRect: self.bounds,
                                     byRoundingCorners: [.topLeft , .topRight],
                                     cornerRadii:CGSize(width:8.0, height:8.0))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = self.bounds
        maskLayer1.path = maskPAth1.cgPath
        self.layer.mask = maskLayer1
    }
}

extension Date {
    
    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
    
    init(millis: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(millis / 1000))
        self.addTimeInterval(TimeInterval(Double(millis % 1000) / 1000 ))
    }
    
}
