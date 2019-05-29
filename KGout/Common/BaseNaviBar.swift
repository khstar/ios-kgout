//
//  BaseNaviBar.swift
//  Gout
//
//  Created by khstar on 2018. 9. 6..
//  Copyright © 2018년 khstar. All rights reserved.
//

import UIKit

class BaseNaviBar: UIView {

    lazy var titleLabel: BaseLabel! = {
        let label = BaseLabel()
        label.textColor = UIColor(0x000000)
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    lazy var clipView: UIView! = {
        let view = UIView()
        view.layer.masksToBounds = true
        return view
    }()
    
    var leftButton: UIButton?{
        didSet{
            addSubview(leftButton!)
            leftButton?.autoAlignAxis(toSuperviewAxis: .horizontal)
            leftButton?.autoPinEdge(toSuperviewEdge: .top, withInset: 4.5)
            leftButton?.autoPinEdge(toSuperviewEdge: .bottom, withInset: 4.5)
            leftInset = leftButton?.autoPinEdge(toSuperviewEdge: .left, withInset: 4.5)
            leftButton?.autoSetDimension(.width, toSize: 50)
        }
    }
    
    var rightButton: UIButton? {
        didSet{
            addSubview(rightButton!)
            rightButton?.autoAlignAxis(toSuperviewAxis: .horizontal)
            rightButton?.autoPinEdge(toSuperviewEdge: .top, withInset: 4.5)
            rightButton?.autoPinEdge(toSuperviewEdge: .bottom, withInset: 4.5)
            rightInset = rightButton?.autoPinEdge(toSuperviewEdge: .right, withInset: 4.5)
            rightButton?.autoSetDimension(.width, toSize: 50)
        }
    }
    
    var leftInset: NSLayoutConstraint?
    var rightInset: NSLayoutConstraint?
    
    var title: String? = "" {
        didSet{
            self.titleLabel.text = title
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    lazy var lineView:UIView! = {
        let view = UIView()
        view.backgroundColor = UIColor(0xededed)
        return view
    }()
    
    func setupView(){
        self.backgroundColor = .white
        
        addSubview(clipView)
        addSubview(lineView)
        
        clipView.addSubview(titleLabel)
        
        clipView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 5.5, left: 69, bottom: 5.5, right: 69))
        titleLabel.autoPinEdge(toSuperviewEdge: .left)
        titleLabel.autoPinEdge(toSuperviewEdge: .right)
        titleLabel.autoAlignAxis(toSuperviewAxis: .horizontal)
        
        lineView.autoPinEdge(toSuperviewEdge: .left)
        lineView.autoPinEdge(toSuperviewEdge: .right)
        lineView.autoPinEdge(toSuperviewEdge: .bottom)
        lineView.autoSetDimension(.height, toSize: 1)
        
    }

}
