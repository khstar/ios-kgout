//
//  BaseButton.swift
//  Gout
//
//  Created by khstar on 22/10/2018.
//  Copyright © 2018 khstar. All rights reserved.
//

import UIKit

class BaseButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

class repeatButton:UIButton {
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
                setBackgroundImage(#imageLiteral(resourceName: "repeat_btn_nor"), for: .normal)
                setBackgroundImage(#imageLiteral(resourceName: "repeat_btn_sel"), for: .selected)
            } else {
                setBackgroundImage(#imageLiteral(resourceName: "repeat_btn_nor"), for: .normal)
                setBackgroundImage(#imageLiteral(resourceName: "repeat_btn_sel"), for: .selected)
            }
        }
    }
    
    func setupView(){
        setBackgroundImage(#imageLiteral(resourceName: "repeat_btn_nor"), for: .normal)
        setBackgroundImage(#imageLiteral(resourceName: "repeat_btn_sel"), for: .selected)
    }
}
