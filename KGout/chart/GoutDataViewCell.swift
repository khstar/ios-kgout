//
//  GoutDataViewCell.swift
//  Gout
//
//  Created by khstar on 29/10/2018.
//  Copyright © 2018 khstar. All rights reserved.
//

import UIKit

class GoutDataViewCell: DefaultCollectionViewCell {
    lazy var dateLabel: BaseLabel! = {
        let label = BaseLabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    lazy var uricacidTitleLabel:BaseLabel! = {
        let label = BaseLabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.text = "요산 :"
        return label
    }()
    
    lazy var uricacidLabel:BaseLabel! = {
        let label = BaseLabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    lazy var bottomLineView:UIView! = {
        let view = UIView()
        view.backgroundColor = UIColor(0xe3e3e3)
        return view
    }()
    
    override func setupView() {
        addSubview(dateLabel)
        addSubview(uricacidTitleLabel)
        addSubview(uricacidLabel)
        addSubview(bottomLineView)
        
        dateLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 15)
        dateLabel.autoAlignAxis(toSuperviewAxis: .horizontal)
        dateLabel.autoSetDimensions(to: CGSize(width: 125, height: 30))
//        dateLabel.backgroundColor = .gray
        
        uricacidTitleLabel.autoPinEdge(.left, to: .right, of: dateLabel, withOffset: 15)
        uricacidTitleLabel.autoAlignAxis(toSuperviewAxis: .horizontal)
        uricacidTitleLabel.autoSetDimensions(to: CGSize(width: 30, height: 30))
        
        uricacidLabel.autoPinEdge(.left, to: .right, of: uricacidTitleLabel, withOffset: 1)
        uricacidLabel.autoAlignAxis(toSuperviewAxis: .horizontal)
        uricacidLabel.autoSetDimensions(to: CGSize(width: 30, height: 30))
        
        bottomLineView.autoPinEdge(toSuperviewEdge: .left)
        bottomLineView.autoPinEdge(toSuperviewEdge: .right)
        bottomLineView.autoPinEdge(toSuperviewEdge: .bottom)
        bottomLineView.autoSetDimension(.height, toSize: 1)
        
    }
}
