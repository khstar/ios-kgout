//
//  BaseLabel.swift
//  Gout
//
//  Created by khstar on 2018. 9. 6..
//  Copyright © 2018년 khstar. All rights reserved.
//

import UIKit

class BaseLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView(){
        textColor = UIColor.sBlack
        //do subclass
    }
    
    
}


class HighlightedLabel: UIView {
    
    
    lazy var bgView: UIView! = {
        let view = UIView()
        return view
    }()
    
    lazy var label: UILabel! = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    init(_ margin: CGFloat = 7) {
        super.init(frame: CGRect.zero)
        self.margin = margin
        setupView()
        //        setupView(margin)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var charSize: CGFloat =  10
    
    var lineSpace: CGFloat = 5
    
    var margin: CGFloat = 7
    
    var isChangedText = false
    
    var topConstraint: NSLayoutConstraint?
    var topMargin: CGFloat = 0
    func setupView(){
        addSubview(bgView)
        addSubview(label)
        
        bgView.autoPinEdgesToSuperviewEdges()
        label.autoPinEdge(toSuperviewEdge: .left, withInset: margin)
        label.autoPinEdge(toSuperviewEdge: .right, withInset: margin)
        topConstraint = label.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
        label.autoPinEdge(toSuperviewEdge: .bottom)
        label.textColor = UIColor.defaultTxt
        
        //do subclass
    }
    
    var font: UIFont! = UIFont.systemFont(ofSize: 15){
        didSet{
            label.font = font
            charSize = font.lineHeight
        }
    }
    
    var numberOfLines: Int = 0 {
        didSet{
            label.numberOfLines = numberOfLines
        }
    }
    
    var textAlignment: NSTextAlignment = .center {
        didSet{
            label.textAlignment = textAlignment
        }
    }
    
    var textColor: UIColor = .sBlack {
        didSet{
            label.textColor = textColor
        }
    }
    
    var blockColor: UIColor = .white {
        didSet{
            
        }
    }
    
    var text: String? {
        didSet{
            isChangedText = true
            let t = text!
            let attrString = NSMutableAttributedString(string: t)
            let style = NSMutableParagraphStyle()
            style.lineSpacing = lineSpace
            attrString.addAttribute(.paragraphStyle, value: style, range: NSRange(location: 0, length: t.characters.count))
//            attrString.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSRange(location: 0, length: t.characters.count))
            label.attributedText = attrString//NSAttributedString(string: t, attributes: [NSBackgroundColorAttributeName: backgroundText])
            updateBackView()
            //
            
        }
    }
    
    
    func updateBackView(){
        
        if self.frame.width == 0 {
            return
        }
        
        for subView in bgView.subviews {
            subView.removeFromSuperview()
        }
        var index: CGFloat = 0
        
        let height = charSize + lineSpace
        
        for lineText in label.getLinesArrayOfStringInLabel() {
            
            let backView = UIView()
            backView.backgroundColor = blockColor
            
            bgView.addSubview(backView)
            backView.autoPinEdge(toSuperviewEdge: .left)
            backView.autoSetDimensions(to: CGSize(width: Utils.widthOfString(lineText, font: label.font) + margin * 2, height: charSize + 2))
            backView.autoPinEdge(toSuperviewEdge: .top, withInset: height * index)
            index += 1
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isChangedText {
            isChangedText = false
            
            updateBackView()
            topConstraint?.constant = topMargin
        }
    }
    
}

class UnderlinedLabel: UILabel {
    
    override var text: String! {
        didSet {
            let textRange = NSMakeRange(0, text.characters.count)
            let attributedText = NSMutableAttributedString(string: text)
            
            attributedText.addAttribute(.underlineStyle, value:NSUnderlineStyle.single.rawValue, range: textRange)
            // Add other attributes if needed
            
            self.attributedText = attributedText
        }
    }
}
