//
//  DrugAlarmViewCell.swift
//  Gout
//
//  Created by khstar on 26/10/2018.
//  Copyright © 2018 khstar. All rights reserved.
//

import UIKit

protocol DrugAlarmViewCellDelegate {
    
    func alarmEnable(index:Int, enable:Int)
    
}

class DrugAlarmViewCell: DefaultCollectionViewCell {
    
    var drugAlarmDelegate:DrugAlarmViewCellDelegate?
    var index = -1
    
    lazy var alarmTime: BaseLabel! = {
        let label = BaseLabel()
        label.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    lazy var drugAlarmLabel:BaseLabel! = {
        let label = BaseLabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.text = "알람 :"
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
    
    lazy var valueImage:UIImageView! = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "emptyDrugImg")
        return image
    }()
    
    lazy var bottomLineView:UIView! = {
        let view = UIView()
        view.backgroundColor = UIColor(0xe3e3e3)
        return view
    }()
    
    lazy var drugAlamrDesc:BaseLabel! = {
        let label = BaseLabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(0x7a7a7a)
        label.numberOfLines = 2
        return label
    }()
    
    lazy var repeatPanel:UIView! = {
        let view = UIView()
        return view
    }()
    
    lazy var monBtn:UILabel! = {
        let button = UILabel()
        button.text = "월"
        button.font = UIFont.systemFont(ofSize: 8)
        button.textAlignment = .center
        button.backgroundColor = UIColor(0xAFDFE3)
        button.textColor = .white
        button.tag = WeekType.monday.rawValue
        return button
    }()
    lazy var tueBtn:UILabel! = {
        let button = UILabel()
        button.text = "화"
        button.font = UIFont.systemFont(ofSize: 8)
        button.textAlignment = .center
        button.backgroundColor = UIColor(0xAFDFE3)
        button.textColor = .white
        button.tag = WeekType.tuesday.rawValue
        return button
    }()
    lazy var wedBtn:UILabel! = {
        let button = UILabel()
        button.text = "수"
        button.font = UIFont.systemFont(ofSize: 8)
        button.textAlignment = .center
        button.backgroundColor = UIColor(0xAFDFE3)
        button.textColor = .white
        button.tag = WeekType.wednesday.rawValue
        return button
    }()
    lazy var thuBtn:UILabel! = {
        let button = UILabel()
        button.text = "목"
        button.font = UIFont.systemFont(ofSize: 8)
        button.textAlignment = .center
        button.backgroundColor = UIColor(0xAFDFE3)
        button.textColor = .white
        button.tag = WeekType.thursday.rawValue
        return button
    }()
    lazy var friBtn:UILabel! = {
        let button = UILabel()
        button.text = "금"
        button.font = UIFont.systemFont(ofSize: 8)
        button.textAlignment = .center
        button.backgroundColor = UIColor(0xAFDFE3)
        button.textColor = .white
        button.tag = WeekType.friday.rawValue
        return button
    }()
    lazy var satBtn:UILabel! = {
        let button = UILabel()
        button.text = "토"
        button.font = UIFont.systemFont(ofSize: 8)
        button.textAlignment = .center
        button.backgroundColor = UIColor(0xAFDFE3)
        button.textColor = .white
        button.tag = WeekType.saturday.rawValue
        return button
    }()
    
    lazy var sunBtn:UILabel! = {
        let button = UILabel()
        button.text = "일"
        button.font = UIFont.systemFont(ofSize: 8)
        button.textAlignment = .center
        button.backgroundColor = UIColor(0xAFDFE3)
        button.textColor = .white
        button.tag = WeekType.sunday.rawValue
        return button
    }()
    
    lazy var switchBtn:UISwitch! = {
        let switchBtn = UISwitch()
        switchBtn.transform = CGAffineTransform.init(scaleX: 0.90, y: 0.90)
        return switchBtn
    }()
    
    override func setupView() {
        addSubview(alarmTime)
        addSubview(bottomLineView)
        addSubview(drugAlamrDesc)
        addSubview(repeatPanel)
        addSubview(switchBtn)
        
        alarmTime.autoPinEdge(toSuperviewEdge: .left)
        alarmTime.autoAlignAxis(toSuperviewAxis: .horizontal)
        alarmTime.autoSetDimensions(to: CGSize(width: 90, height: 30))
        
        drugAlamrDesc.autoPinEdge(toSuperviewEdge: .top, withInset: 5)
        drugAlamrDesc.autoPinEdge(.left, to: .right, of: alarmTime, withOffset: 5)
        drugAlamrDesc.autoSetDimensions(to: CGSize(width: 170, height: 20))
//        drugAlamrDesc.backgroundColor = .lightGray
        
        repeatPanel.autoPinEdge(.left, to: .right, of: alarmTime, withOffset: 5)
        repeatPanel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 5)
        repeatPanel.autoSetDimensions(to: CGSize(width: 170, height: 20))
        
        switchBtn.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
        switchBtn.autoAlignAxis(toSuperviewAxis: .horizontal)
        
        repeatPanel.addSubview(monBtn)
        monBtn.autoAlignAxis(toSuperviewAxis: .horizontal)
        monBtn.autoPinEdge(toSuperviewEdge: .left)
        monBtn.autoSetDimensions(to: CGSize(width: 20, height: 20))
        
        repeatPanel.addSubview(tueBtn)
        tueBtn.autoAlignAxis(toSuperviewAxis: .horizontal)
        tueBtn.autoPinEdge(.left, to: .right, of: monBtn, withOffset: 5)
        tueBtn.autoSetDimensions(to: CGSize(width: 20, height: 20))
        
        repeatPanel.addSubview(wedBtn)
        wedBtn.autoAlignAxis(toSuperviewAxis: .horizontal)
        wedBtn.autoPinEdge(.left, to: .right, of: tueBtn, withOffset: 5)
        wedBtn.autoSetDimensions(to: CGSize(width: 20, height: 20))
        
        repeatPanel.addSubview(thuBtn)
        thuBtn.autoAlignAxis(toSuperviewAxis: .horizontal)
        thuBtn.autoPinEdge(.left, to: .right, of: wedBtn, withOffset: 5)
        thuBtn.autoSetDimensions(to: CGSize(width: 20, height: 20))
        
        repeatPanel.addSubview(friBtn)
        friBtn.autoAlignAxis(toSuperviewAxis: .horizontal)
        friBtn.autoPinEdge(.left, to: .right, of: thuBtn, withOffset: 5)
        friBtn.autoSetDimensions(to: CGSize(width: 20, height: 20))
        
        repeatPanel.addSubview(satBtn)
        satBtn.autoAlignAxis(toSuperviewAxis: .horizontal)
        satBtn.autoPinEdge(.left, to: .right, of: friBtn, withOffset: 5)
        satBtn.autoSetDimensions(to: CGSize(width: 20, height: 20))
        
        repeatPanel.addSubview(sunBtn)
        sunBtn.autoAlignAxis(toSuperviewAxis: .horizontal)
        sunBtn.autoPinEdge(.left, to: .right, of: satBtn, withOffset: 5)
        sunBtn.autoSetDimensions(to: CGSize(width: 20, height: 20))
        
        bottomLineView.autoPinEdge(toSuperviewEdge: .left)
        bottomLineView.autoPinEdge(toSuperviewEdge: .right)
        bottomLineView.autoPinEdge(toSuperviewEdge: .bottom)
        bottomLineView.autoSetDimension(.height, toSize: 1)
        
        switchBtn.addTarget(self, action: #selector(switchAction), for: .valueChanged)
        
    }
    
    func setRepeat(repeatWeek:RepeatWeek) {
        
        if repeatWeek.monday {
            monBtn.backgroundColor = UIColor(0x97C1C4)
            monBtn.textColor = .black
        } else {
            monBtn.backgroundColor = UIColor(0xAFDFE3)
            monBtn.textColor = .white
        }
        
        if repeatWeek.tuesday {
            tueBtn.backgroundColor = UIColor(0x97C1C4)
            tueBtn.textColor = .black
        } else {
            tueBtn.backgroundColor = UIColor(0xAFDFE3)
            tueBtn.textColor = .white
        }
        
        if repeatWeek.wednesday {
            wedBtn.backgroundColor = UIColor(0x97C1C4)
            wedBtn.textColor = .black
        } else {
            wedBtn.backgroundColor = UIColor(0xAFDFE3)
            wedBtn.textColor = .white
        }
        
        if repeatWeek.thursday {
            thuBtn.backgroundColor = UIColor(0x97C1C4)
            thuBtn.textColor = .black
        } else {
            thuBtn.backgroundColor = UIColor(0xAFDFE3)
            thuBtn.textColor = .white
        }
        
        if repeatWeek.friday {
            friBtn.backgroundColor = UIColor(0x97C1C4)
            friBtn.textColor = .black
        } else {
            friBtn.backgroundColor = UIColor(0xAFDFE3)
            friBtn.textColor = .white
        }
        
        if repeatWeek.saturday {
            satBtn.backgroundColor = UIColor(0x97C1C4)
            satBtn.textColor = .black
        } else {
            satBtn.backgroundColor = UIColor(0xAFDFE3)
            satBtn.textColor = .white
        }
        
        if repeatWeek.sunday {
            sunBtn.backgroundColor = UIColor(0x97C1C4)
            sunBtn.textColor = .black
        } else {
            sunBtn.backgroundColor = UIColor(0xAFDFE3)
            sunBtn.textColor = .white
        }
    }
    
    @objc func switchAction() {
        
        drugAlarmDelegate?.alarmEnable(index: self.index, enable: self.switchBtn!.isOn ? 1 : 0)
        
//        if self.switchBtn.isOn {
//
//        } else {
//
//        }
//
//        print("on = \(self.switchBtn.isOn)")
    }
    
}

class DeleteDrugAlarmViewCell: DrugAlarmViewCell {
    
//    lazy var delButton:UIButton! = {
//        let button = UIButton()
////        button.setBackgroundImage(#imageLiteral(resourceName: "addSaveBtnNormal"), for: .normal)
////        button.setBackgroundImage(#imageLiteral(resourceName: "addSaveBtnSelect"), for: .selected)
//
//        button.setTitle("삭제", for: .normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
//        button.setBackgroundColor(.red, forState: .normal)
//        button.setBackgroundColor(.green, forState: .selected)
//        button.layer.borderWidth = 1
//        button.layer.borderColor = UIColor.clear.cgColor
//        button.layer.cornerRadius = 10
//
//        return button
//    }()
    
    lazy var deleteImage:UIImageView! = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "unSelect_Check")
        return image
    }()
    
    override func setupView() {
        addSubview(alarmTime)
        addSubview(drugAlamrDesc)
        addSubview(bottomLineView)
        addSubview(repeatPanel)
        addSubview(deleteImage)
        addSubview(switchBtn)
        
        deleteImage.autoPinEdge(toSuperviewEdge: .left)
        deleteImage.autoAlignAxis(toSuperviewAxis: .horizontal)
        deleteImage.autoSetDimensions(to: CGSize(width: 20, height: 20))
        
        alarmTime.autoPinEdge(.left, to: .right, of: deleteImage, withOffset: 5)
        alarmTime.autoAlignAxis(toSuperviewAxis: .horizontal)
        alarmTime.autoSetDimensions(to: CGSize(width: 90, height: 30))
        
        drugAlamrDesc.autoPinEdge(toSuperviewEdge: .top, withInset: 5)
        drugAlamrDesc.autoPinEdge(.left, to: .right, of: alarmTime, withOffset: 5)
        drugAlamrDesc.autoSetDimensions(to: CGSize(width: 170, height: 20))
//        drugAlamrDesc.backgroundColor = .lightGray
        
        repeatPanel.autoPinEdge(.left, to: .right, of: alarmTime, withOffset: 5)
        repeatPanel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 5)
        repeatPanel.autoSetDimensions(to: CGSize(width: 170, height: 20))
        
        switchBtn.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
        switchBtn.autoAlignAxis(toSuperviewAxis: .horizontal)
        
        repeatPanel.addSubview(monBtn)
        monBtn.autoAlignAxis(toSuperviewAxis: .horizontal)
        monBtn.autoPinEdge(toSuperviewEdge: .left)
        monBtn.autoSetDimensions(to: CGSize(width: 20, height: 20))
        
        repeatPanel.addSubview(tueBtn)
        tueBtn.autoAlignAxis(toSuperviewAxis: .horizontal)
        tueBtn.autoPinEdge(.left, to: .right, of: monBtn, withOffset: 5)
        tueBtn.autoSetDimensions(to: CGSize(width: 20, height: 20))
        
        repeatPanel.addSubview(wedBtn)
        wedBtn.autoAlignAxis(toSuperviewAxis: .horizontal)
        wedBtn.autoPinEdge(.left, to: .right, of: tueBtn, withOffset: 5)
        wedBtn.autoSetDimensions(to: CGSize(width: 20, height: 20))
        
        repeatPanel.addSubview(thuBtn)
        thuBtn.autoAlignAxis(toSuperviewAxis: .horizontal)
        thuBtn.autoPinEdge(.left, to: .right, of: wedBtn, withOffset: 5)
        thuBtn.autoSetDimensions(to: CGSize(width: 20, height: 20))
        
        repeatPanel.addSubview(friBtn)
        friBtn.autoAlignAxis(toSuperviewAxis: .horizontal)
        friBtn.autoPinEdge(.left, to: .right, of: thuBtn, withOffset: 5)
        friBtn.autoSetDimensions(to: CGSize(width: 20, height: 20))
        
        repeatPanel.addSubview(satBtn)
        satBtn.autoAlignAxis(toSuperviewAxis: .horizontal)
        satBtn.autoPinEdge(.left, to: .right, of: friBtn, withOffset: 5)
        satBtn.autoSetDimensions(to: CGSize(width: 20, height: 20))
        
        repeatPanel.addSubview(sunBtn)
        sunBtn.autoAlignAxis(toSuperviewAxis: .horizontal)
        sunBtn.autoPinEdge(.left, to: .right, of: satBtn, withOffset: 5)
        sunBtn.autoSetDimensions(to: CGSize(width: 20, height: 20))
        
        bottomLineView.autoPinEdge(toSuperviewEdge: .left)
        bottomLineView.autoPinEdge(toSuperviewEdge: .right)
        bottomLineView.autoPinEdge(toSuperviewEdge: .bottom)
        bottomLineView.autoSetDimension(.height, toSize: 1)
    }
}
