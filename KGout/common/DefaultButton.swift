//
//  DefaultButton.swift
//  Gout
//
//  Created by khstar on 2018. 9. 6..
//  Copyright © 2018년 khstar. All rights reserved.
//

import UIKit

class DefaultButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

class AddButton:UIButton {
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var isWhite: Bool = false {
        didSet{
            if isWhite {
                setImage(#imageLiteral(resourceName: "add_normal"), for: .normal)
                setImage(#imageLiteral(resourceName: "add_selected"), for: .highlighted)
            } else {
                setImage(#imageLiteral(resourceName: "add_normal"), for: .normal)
                setImage(#imageLiteral(resourceName: "add_selected"), for: .highlighted)
            }
        }
    }
    
    func setupView(){
        setImage(#imageLiteral(resourceName: "add_normal"), for: .normal)
        setImage(#imageLiteral(resourceName: "add_selected"), for: .highlighted)
    }
}

class PickerIconButton:UIButton {
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var isWhite: Bool = false {
        didSet{
            if isWhite {
                setImage(#imageLiteral(resourceName: "date_select_nor"), for: .normal)
                setImage(#imageLiteral(resourceName: "date_select_sel"), for: .highlighted)
            } else {
                setImage(#imageLiteral(resourceName: "date_select_nor"), for: .normal)
                setImage(#imageLiteral(resourceName: "date_select_sel"), for: .highlighted)
            }
        }
    }
    
    func setupView(){
        setImage(#imageLiteral(resourceName: "date_select_nor"), for: .normal)
        setImage(#imageLiteral(resourceName: "date_select_sel"), for: .highlighted)
    }
}
