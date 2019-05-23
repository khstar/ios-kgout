//
//  DefaultCollectionViewCell.swift
//  Gout
//
//  Created by khstar on 2018. 9. 10..
//  Copyright © 2018년 khstar. All rights reserved.
//

import UIKit
import RxSwift

protocol CustomCellDelegate{
    func didSelectButton(cell: DefaultCollectionViewCell,_ index: Int)
    func didSelectButton(indexPath: IndexPath, _ index: Int)
}

extension CustomCellDelegate{
    func didSelectButton(cell: DefaultCollectionViewCell,_ index: Int) { }
    func didSelectButton(indexPath: IndexPath, _ index: Int) {}
}

class DefaultCollectionViewCell: UICollectionViewCell {
    
    let disposeBag = DisposeBag()
    let screenWidth = UIScreen.main.bounds.width
    let ratio = UIScreen.main.bounds.width / 375
    let tabbarHeight: CGFloat = 53
    let statusHeight:CGFloat = Constants.statusHeight()
    
    var delegate: CustomCellDelegate?
    
    var reachedBottom = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        UIView.performWithoutAnimation {
            setupView()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView(){
        //do subclass
    }
    
    override var isHighlighted: Bool {
        
        didSet {
            if self.isHighlighted {
                self.selected()
            } else {
                self.unselected()
            }
        }
    }
    
    //cell이 선택 될때 호출 되는 메소드
    func selected() {}
    
    //cell이 선택 해제 될때 호출 되는 메소드
    func unselected() {}
}

class EmptyCell: DefaultCollectionViewCell {
    
    lazy var titleLabel: UILabel! = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = UIColor(0x1c1c1c)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var subsLabel: UILabel! = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(0x7a7a7a)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var centerPanel: UIView! = {
        return UIView()
    }()
    
    override func setupView() {
        addSubview(centerPanel)
        centerPanel.addSubview(titleLabel)
        centerPanel.addSubview(subsLabel)
        
        centerPanel.autoCenterInSuperview()
        centerPanel.autoPinEdge(toSuperviewEdge: .left)
        centerPanel.autoPinEdge(toSuperviewEdge: .right)
        
        titleLabel.autoPinEdge(toSuperviewEdge: .top)
        titleLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 24)
        titleLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 24)
        subsLabel.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 14)
        subsLabel.autoPinEdge(toSuperviewEdge: .left)
        subsLabel.autoPinEdge(toSuperviewEdge: .right)
        subsLabel.autoPinEdge(toSuperviewEdge: .bottom)
        
        backgroundColor = .white
    }
}
