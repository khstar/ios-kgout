//
//  DefaultSwitchView.swift
//  Gout
//
//  Created by khstar on 23/10/2018.
//  Copyright © 2018 khstar. All rights reserved.
//

import UIKit

class DefaultSwitchView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    lazy var titleLabel: UILabel! = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15.5, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    lazy var alarmSwitch: UISwitch! = {
        let switchButton = UISwitch()
        switchButton.onTintColor = UIColor(0xAAd2E1)
        return switchButton
    }()
    
    lazy var lineView1: UIView! = {
        let view = UIView()
        view.backgroundColor = UIColor(0x000000, alpha: 0.2)
        return view
    }()
    
    lazy var lineView2: UIView! = {
        let view = UIView()
        view.backgroundColor = UIColor(0x000000, alpha: 0.2)
        return view
    }()
    
    func setupView() {
        backgroundColor = .white
        addSubview(titleLabel)
        addSubview(alarmSwitch)
        addSubview(lineView1)
        addSubview(lineView2)
        
        titleLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 15)
        titleLabel.autoAlignAxis(toSuperviewAxis: .horizontal)
        
        alarmSwitch.autoPinEdge(toSuperviewEdge: .right, withInset: 15)
        alarmSwitch.autoAlignAxis(toSuperviewAxis: .horizontal)
        
        lineView1.autoPinEdge(toSuperviewEdge: .left)
        lineView1.autoPinEdge(toSuperviewEdge: .right)
        lineView1.autoPinEdge(toSuperviewEdge: .bottom)
        lineView1.autoSetDimension(.height, toSize: 0.5)
        
        lineView2.autoPinEdge(toSuperviewEdge: .left)
        lineView2.autoPinEdge(toSuperviewEdge: .right)
        lineView2.autoPinEdge(toSuperviewEdge: .top)
        lineView2.autoSetDimension(.height, toSize: 0.5)
    }
    
}
