//
//  DrugInfoViewCell.swift
//  Gout
//
//  Created by khstar on 24/10/2018.
//  Copyright © 2018 khstar. All rights reserved.
//

import UIKit

class DrugInfoViewCell: DefaultCollectionViewCell {
    
    lazy var drugName: BaseLabel! = {
        let label = BaseLabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor(0x1c1c1c)
        label.numberOfLines = 1
        
        return label
    }()
    
    lazy var drugDesc:BaseLabel! = {
        let label = BaseLabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(0x7a7a7a)
        label.numberOfLines = 2
        return label
    }()
    
    lazy var drugAlarmLabel:BaseLabel! = {
        let label = BaseLabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.text = "\(StringConstants.alarmTitle) :"
        return label
    }()
    
    lazy var drugAlarmCount:BaseLabel! = {
        let label = BaseLabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.text = "0"
        return label
    }()
    
    lazy var drugImgPanel:UIView! = {
        let view = UIView()
        view.backgroundColor = UIColor(0x000000, alpha: 0.06)
        return view
    }()
    
    lazy var drugImgView:UIImageView! = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "emptyDrugImg")
        return image
    }()
    
    lazy var bottomLineView:UIView! = {
        let view = UIView()
        view.backgroundColor = UIColor(0xe3e3e3)
        return view
    }()
    
    lazy var textPanel:UIView! = {
        let view = UIView()
        return view
    }()
    
    override func setupView() {
        
        addSubview(drugImgPanel)
        addSubview(textPanel)
        addSubview(bottomLineView)
        
        drugImgPanel.autoPinEdge(toSuperviewEdge: .top, withInset: 12)
        drugImgPanel.autoPinEdge(toSuperviewEdge: .left, withInset: 15)
        drugImgPanel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 12)
        drugImgPanel.autoSetDimensions(to: CGSize(width: 50, height: 50))
        drugImgPanel.addSubview(drugImgView)
        
        drugImgView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets.init(top: 0.5, left: 0.5, bottom: 0.5, right: 0.5))
        
        let textPanelWidth:CGFloat = screenWidth - (15.0 + 50 + 14 + 15.0)
        let titleLabelHeigth = Utils.heightOfString("타이틀", fontSize: 14, width: textPanelWidth)         //텍스트 Label의 높이 계산
        let descriptionLabelHeigth = Utils.heightOfString("설명", fontSize: 12, width: textPanelWidth)    //텍스트 Label의 높이 계산
        
        let textPanelHeight = titleLabelHeigth + 8 + descriptionLabelHeigth
        
        textPanel.autoPinEdge(.left, to: .right, of: drugImgPanel, withOffset: 14)
        textPanel.autoSetDimension(.height, toSize: textPanelHeight)
        textPanel.autoPinEdge(toSuperviewEdge: .right, withInset: 15)
        textPanel.autoAlignAxis(.horizontal, toSameAxisOf: drugImgPanel)
        
        textPanel.addSubview(drugName)
        textPanel.addSubview(drugDesc)
        textPanel.addSubview(drugAlarmLabel)
        textPanel.addSubview(drugAlarmCount)
        
        drugName.autoPinEdge(toSuperviewEdge: .left)
        drugName.autoPinEdge(.right, to: .left, of: drugAlarmLabel, withOffset: -10)
        drugName.autoPinEdge(toSuperviewEdge: .top)
        drugName.autoSetDimensions(to: CGSize(width: textPanelWidth, height: titleLabelHeigth))
        
        drugDesc.autoPinEdge(.top, to: .bottom, of: drugName, withOffset: 4)
        drugDesc.autoPinEdge(toSuperviewEdge: .left)
        drugDesc.autoPinEdge(.right, to: .left, of: drugAlarmLabel, withOffset: -10)
        drugDesc.autoSetDimensions(to: CGSize(width: textPanelWidth, height: descriptionLabelHeigth))
    
        drugAlarmLabel.autoAlignAxis(toSuperviewAxis: .horizontal)
        drugAlarmLabel.autoPinEdge(.right, to: .left, of: drugAlarmCount, withOffset: 3)
        drugAlarmLabel.autoSetDimension(.width, toSize: 50)
        
        drugAlarmCount.autoAlignAxis(toSuperviewAxis: .horizontal)
        drugAlarmCount.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
        drugAlarmCount.autoSetDimension(.width, toSize: 20)
        
        bottomLineView.autoPinEdge(toSuperviewEdge: .left, withInset: 15)
        bottomLineView.autoPinEdge(toSuperviewEdge: .right, withInset: 15)
        bottomLineView.autoPinEdge(toSuperviewEdge: .bottom)
        bottomLineView.autoSetDimension(.height, toSize: 1)
        
    }
}

class DeleteDrugInfoViewCell: DefaultCollectionViewCell {
    
    lazy var deleteImage:UIImageView! = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "unSelect_Check")
        return image
    }()
    
    lazy var drugName: BaseLabel! = {
        let label = BaseLabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor(0x1c1c1c)
        label.numberOfLines = 1
        
        return label
    }()
    
    lazy var drugDesc:BaseLabel! = {
        let label = BaseLabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(0x7a7a7a)
        label.numberOfLines = 2
        return label
    }()
    
    lazy var drugAlarmLabel:BaseLabel! = {
        let label = BaseLabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.text = "\(StringConstants.alarmTitle) :"
        return label
    }()
    
    lazy var drugAlarmCount:BaseLabel! = {
        let label = BaseLabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.text = "0"
        return label
    }()
    
    lazy var drugImgPanel:UIView! = {
        let view = UIView()
        view.backgroundColor = UIColor(0x000000, alpha: 0.06)
        return view
    }()
    
    lazy var drugImgView:UIImageView! = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "emptyDrugImg")
        return image
    }()
    
    lazy var bottomLineView:UIView! = {
        let view = UIView()
        view.backgroundColor = UIColor(0xe3e3e3)
        return view
    }()
    
    lazy var textPanel:UIView! = {
        let view = UIView()
        return view
    }()
    
    override func setupView() {
        
        addSubview(deleteImage)
        addSubview(drugImgPanel)
        addSubview(textPanel)
        addSubview(bottomLineView)
        
        deleteImage.autoPinEdge(toSuperviewEdge: .left, withInset: 15)
        deleteImage.autoAlignAxis(toSuperviewAxis: .horizontal)
        deleteImage.autoSetDimensions(to: CGSize(width: 20, height: 20))
        
        drugImgPanel.autoPinEdge(.left, to: .right, of: deleteImage, withOffset: 5)
        drugImgPanel.autoPinEdge(toSuperviewEdge: .top, withInset: 12)
//        drugImgPanel.autoPinEdge(toSuperviewEdge: .left, withInset: 15)
        drugImgPanel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 12)
        drugImgPanel.autoSetDimensions(to: CGSize(width: 50, height: 50))
        drugImgPanel.addSubview(drugImgView)
        
        drugImgView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets.init(top: 0.5, left: 0.5, bottom: 0.5, right: 0.5))
        
        let textPanelWidth:CGFloat = screenWidth - (15.0 + 50 + 14 + 15.0)
        let titleLabelHeigth = Utils.heightOfString("타이틀", fontSize: 14, width: textPanelWidth)         //텍스트 Label의 높이 계산
        let descriptionLabelHeigth = Utils.heightOfString("설명", fontSize: 12, width: textPanelWidth)    //텍스트 Label의 높이 계산
        
        let textPanelHeight = titleLabelHeigth + 8 + descriptionLabelHeigth
        
        textPanel.autoPinEdge(.left, to: .right, of: drugImgPanel, withOffset: 14)
        textPanel.autoSetDimension(.height, toSize: textPanelHeight)
        textPanel.autoPinEdge(toSuperviewEdge: .right, withInset: 15)
        textPanel.autoAlignAxis(.horizontal, toSameAxisOf: drugImgPanel)
        
        textPanel.addSubview(drugName)
        textPanel.addSubview(drugDesc)
        textPanel.addSubview(drugAlarmLabel)
        textPanel.addSubview(drugAlarmCount)
        
        drugName.autoPinEdge(toSuperviewEdge: .left)
        drugName.autoPinEdge(.right, to: .left, of: drugAlarmLabel, withOffset: -10)
        drugName.autoPinEdge(toSuperviewEdge: .top)
        drugName.autoSetDimensions(to: CGSize(width: textPanelWidth, height: titleLabelHeigth))
        
        drugDesc.autoPinEdge(.top, to: .bottom, of: drugName, withOffset: 4)
        drugDesc.autoPinEdge(toSuperviewEdge: .left)
        drugDesc.autoPinEdge(.right, to: .left, of: drugAlarmLabel, withOffset: -10)
        drugDesc.autoSetDimensions(to: CGSize(width: textPanelWidth, height: descriptionLabelHeigth))
        
        drugAlarmLabel.autoAlignAxis(toSuperviewAxis: .horizontal)
        drugAlarmLabel.autoPinEdge(.right, to: .left, of: drugAlarmCount, withOffset: 3)
        drugAlarmLabel.autoSetDimension(.width, toSize: 50)
        
        drugAlarmCount.autoAlignAxis(toSuperviewAxis: .horizontal)
        drugAlarmCount.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
        drugAlarmCount.autoSetDimension(.width, toSize: 20)
        
        bottomLineView.autoPinEdge(toSuperviewEdge: .left, withInset: 15)
        bottomLineView.autoPinEdge(toSuperviewEdge: .right, withInset: 15)
        bottomLineView.autoPinEdge(toSuperviewEdge: .bottom)
        bottomLineView.autoSetDimension(.height, toSize: 1)
        
    }
}
