//
//  GoutTabbarViewController.swift
//  Gout
//
//  Created by khstar on 2018. 8. 31..
//  Copyright © 2018년 khstar. All rights reserved.
//

import UIKit
import PureLayout
import RxSwift
import SwiftyJSON
import GoogleMobileAds
import Firebase
import FirebaseDatabase

class GoutTabbarViewController: UITabBarController {
    
    var ref:DatabaseReference!
    let GOUT_TAG = 9999
    
    lazy var customSolidView: UIView! = {
        let view = UIView()
        return view
    }()
    
    lazy var chartLine: UIView! = {
        let view = UIView()
        view.backgroundColor = .gray
        view.isHidden = true
        return view
    }()
    
    lazy var drugLine: UIView! = {
        let view = UIView()
        view.backgroundColor = .gray
        view.isHidden = true
        return view
    }()
    
    lazy var personLine: UIView! = {
        let view = UIView()
        view.backgroundColor = .gray
        view.isHidden = true
        return view
    }()
    
    lazy var chartTab: UIButton! = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "chart_normal"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "chart_selected"), for: .selected)
        button.setImage(#imageLiteral(resourceName: "chart_selected"), for: .highlighted)
        return button
    }()
    
    lazy var drugTab : UIButton! = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "drug_normal"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "drug_selected"), for: .selected)
        button.setImage(#imageLiteral(resourceName: "drug_selected"), for: .highlighted)
        return button
    }()
    
    lazy var personTab: UIButton! = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "person_normal"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "person_selected"), for: .selected)
        button.setImage(#imageLiteral(resourceName: "person_selected"), for: .highlighted)
        return button
    }()

    lazy var buttons: [UIButton] = [self.chartTab, self.drugTab, self.personTab]
    lazy var lines: [UIView] = [self.chartLine, self.drugLine, self.personLine]
    
    lazy var adMobView:GADBannerView! = {
        let view = GADBannerView()
        return view
    }()
    
    var nextVC: UIViewController?
    
    override var selectedIndex: Int{
        didSet{
            if oldValue < buttons.count {
                buttons[oldValue].isSelected = false
                lines[oldValue].isHidden = true
            }
            if selectedIndex < buttons.count {
                buttons[selectedIndex].isSelected = true
                lines[selectedIndex].isHidden = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        buttons = [self.mainTab, self.selfcareTab, self.noteTab, self.menuTab, self.skinTab ]
        self.tabBar.isHidden = true
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        self.selectedIndex = 0
        if let vc = nextVC {
            present(vc, animated: false, completion: nil)
            nextVC = nil
        }
    }
    
    
    private func setupView() {
        let totalWidth = UIScreen.main.bounds.width
        
        let zeroInset: CGFloat = 0
        let tabbarHeight: CGFloat = 53
        let iconWidth: CGFloat = 48
        let iconHeight: CGFloat = 48
        let iconInset: CGFloat = ((totalWidth / 3) - iconWidth) / 2
        let iconSpacing: CGFloat = iconInset * 2
        let iconBottomInset = (tabbarHeight - iconHeight) / 2
        let bottomHeight = Constants.bottomHeight()
        
//        adMobView.adUnitID = "ca-app-pub-3940256099942544/2934735716"   //테스트
        adMobView.adUnitID = "ca-app-pub-8837395530354963/7062014527"   //운영
        adMobView.rootViewController = self
        adMobView.load(GADRequest())
        
        self.view.addSubview(customSolidView)
        self.view.addSubview(adMobView)
        
        customSolidView.addSubview(chartLine)
        customSolidView.addSubview(drugLine)
        customSolidView.addSubview(personLine)

        adMobView.autoPinEdge(toSuperviewEdge: .left)
        adMobView.autoPinEdge(toSuperviewEdge: .right)
        adMobView.autoPinEdge(toSuperviewEdge: .bottom, withInset: bottomHeight)
        adMobView.autoSetDimension(.height, toSize: 50)
        
        customSolidView.autoPinEdge(toSuperviewEdge: .left, withInset: zeroInset)
        customSolidView.autoPinEdge(toSuperviewEdge: .right, withInset: zeroInset)
        customSolidView.autoPinEdge(.bottom, to: .top, of: adMobView)
        customSolidView.autoSetDimension(.height, toSize: tabbarHeight)
        customSolidView.backgroundColor = .white
        
        chartTab.tag = TapType.chart.rawValue
        drugTab.tag = TapType.drug.rawValue
        personTab.tag = TapType.person.rawValue
        
        for button in buttons {
            
            customSolidView.addSubview(button)
            button.autoSetDimensions(to: CGSize(width: iconWidth, height: iconHeight))
            button.autoPinEdge(toSuperviewEdge: .bottom, withInset: iconBottomInset )
            
            //gout_tag 선택이 아닌 경우
            if button.tag != GOUT_TAG {
                button.addTarget(self, action: #selector(onTabClick(sender:)), for: .touchUpInside)
            }
            
        }
        
        chartTab.autoPinEdge(toSuperviewEdge: .left, withInset: iconInset )
        drugTab.autoPinEdge(.left, to: .right, of: chartTab, withOffset: iconSpacing)
        personTab.autoPinEdge(.left, to: .right, of: drugTab, withOffset: iconSpacing)

        chartLine.autoPinEdge(toSuperviewEdge: .top)
        chartLine.autoSetDimensions(to: CGSize(width: 16.5, height: 2.5))
        chartLine.autoAlignAxis(.vertical, toSameAxisOf: chartTab, withOffset: 0.5)
        
        drugLine.autoPinEdge(toSuperviewEdge: .top)
        drugLine.autoSetDimensions(to: CGSize(width: 16.5, height: 2.5))
        drugLine.autoAlignAxis(.vertical, toSameAxisOf: drugTab, withOffset: 0.5)
        
        self.selectedIndex = 1
        
    }
    
    @objc func onTabClick(sender: UIButton){
        
        self.selectedIndex = sender.tag
    }
    
    func onCenterTabClck(){
    }
    
    func moveSkinNote(b: Bool){
    }
    
    func showLoginPopup(){
    }
    
    func goToLoginViewController(){
    }

}
