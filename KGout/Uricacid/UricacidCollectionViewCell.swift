//
//  UricacidCollectionViewCell.swift
//  Gout
//
//  Created by khstar on 2018. 9. 10..
//  Copyright © 2018년 khstar. All rights reserved.
//

import UIKit
import SDWebImage

class UricacidCollectionViewCell: DefaultCollectionViewCell {
    
    lazy var dateLabel: BaseLabel! = {
        let label = BaseLabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    lazy var uricacidLabel:BaseLabel! = {
        let label = BaseLabel()
        label.font = UIFont.systemFont(ofSize: 27, weight: .bold)
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    lazy var uricacidDescLabel:BaseLabel! = {
        let label = BaseLabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .left
        label.numberOfLines = 2

        return label
    }()
    
    lazy var bottomLineView:UIView! = {
        let view = UIView()
        view.backgroundColor = UIColor(0xe3e3e3)
        return view
    }()
    
    lazy var signalIV:UIImageView! = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "valueEqual")
        return image
    }()
    
    override func setupView() {
        addSubview(dateLabel)
        addSubview(uricacidDescLabel)
        addSubview(uricacidLabel)
        addSubview(signalIV)
        addSubview(bottomLineView)
        
        let dateLabelWidth = Utils.widthOfString("1900-01-01", font: dateLabel.font) + 10
        
        dateLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 15)
        dateLabel.autoAlignAxis(toSuperviewAxis: .horizontal)
        dateLabel.autoSetDimensions(to: CGSize(width: dateLabelWidth + 5, height: 50))
        
        uricacidDescLabel.autoPinEdge(.left, to: .right, of: dateLabel, withOffset: 5)
        uricacidDescLabel.autoPinEdge(.right, to: .left, of: uricacidLabel, withOffset: -5)
        uricacidDescLabel.autoSetDimension(.height, toSize: 50)
        
        signalIV.autoAlignAxis(toSuperviewAxis: .horizontal)
        signalIV.autoPinEdge(toSuperviewEdge: .right, withInset: 15)
        signalIV.autoSetDimensions(to: CGSize(width: 25, height: 25))
        
        uricacidLabel.autoPinEdge(.right, to: .left, of: signalIV, withOffset: 10)
        uricacidLabel.autoAlignAxis(toSuperviewAxis: .horizontal)
        uricacidLabel.autoSetDimensions(to: CGSize(width: 80, height: 70))
        
        bottomLineView.autoPinEdge(toSuperviewEdge: .left)
        bottomLineView.autoPinEdge(toSuperviewEdge: .right)
        bottomLineView.autoPinEdge(toSuperviewEdge: .bottom)
        bottomLineView.autoSetDimension(.height, toSize: 1)
    }
}

class DeleteUricacidViewCell: DefaultCollectionViewCell {
    
    lazy var deleteCheckIV:UIImageView! = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "unSelect_Check")
        return image
    }()
    
    lazy var dateLabel: BaseLabel! = {
        let label = BaseLabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    lazy var uricacidDescLabel:BaseLabel! = {
        let label = BaseLabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .left
        label.numberOfLines = 2
        
        return label
    }()
    
    lazy var uricacidLabel:BaseLabel! = {
        let label = BaseLabel()
        label.font = UIFont.systemFont(ofSize: 27, weight: .bold)
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    lazy var signalIV:UIImageView! = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "valueEqual")
        return image
    }()
    
    lazy var bottomLineView:UIView! = {
        let view = UIView()
        view.backgroundColor = UIColor(0xe3e3e3)
        return view
    }()
    
    override func setupView() {
        
        addSubview(deleteCheckIV)
        addSubview(dateLabel)
        addSubview(uricacidDescLabel)
        addSubview(uricacidLabel)
        addSubview(signalIV)
        addSubview(bottomLineView)
        
        deleteCheckIV.autoPinEdge(toSuperviewEdge: .left, withInset: 15)
        deleteCheckIV.autoAlignAxis(toSuperviewAxis: .horizontal)
        deleteCheckIV.autoSetDimensions(to: CGSize(width: 20, height: 20))
        
        let dateLabelWidth = Utils.widthOfString("1900-01-01", font: dateLabel.font) + 10
        
        dateLabel.autoPinEdge(.left, to: .right, of: deleteCheckIV, withOffset: 5)
        dateLabel.autoAlignAxis(toSuperviewAxis: .horizontal)
        dateLabel.autoSetDimensions(to: CGSize(width: dateLabelWidth, height: 50))
        
        uricacidDescLabel.autoPinEdge(.left, to: .right, of: dateLabel, withOffset: 5)
        uricacidDescLabel.autoPinEdge(.right, to: .left, of: uricacidLabel, withOffset: -5)
        uricacidDescLabel.autoSetDimension(.height, toSize: 50)
        
        signalIV.autoAlignAxis(toSuperviewAxis: .horizontal)
        signalIV.autoPinEdge(toSuperviewEdge: .right, withInset: 15)
        signalIV.autoSetDimensions(to: CGSize(width: 25, height: 25))
        
        uricacidLabel.autoPinEdge(.right, to: .left, of: signalIV, withOffset: 10)
        uricacidLabel.autoAlignAxis(toSuperviewAxis: .horizontal)
        uricacidLabel.autoSetDimensions(to: CGSize(width: 80, height: 70))
        
        bottomLineView.autoPinEdge(toSuperviewEdge: .left)
        bottomLineView.autoPinEdge(toSuperviewEdge: .right)
        bottomLineView.autoPinEdge(toSuperviewEdge: .bottom)
        bottomLineView.autoSetDimension(.height, toSize: 1)
    }
}

