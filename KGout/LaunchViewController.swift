//
//  ViewController.swift
//  KGout
//
//  Created by khstar on 25/02/2019.
//  Copyright © 2019 khstar. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupView()
        UIView.animate(withDuration: 1.5, delay: 0.0, options: .curveEaseInOut, animations: { [weak self] in

            }, completion: { [weak self] _ in
                self?.presentMainViewCtrl()
        })
    }
    
    lazy var titleLabel:UILabel! = {
        let label = UILabel()
        label.text = Bundle.main.displayName
        label.font = UIFont.systemFont(ofSize: 38, weight: .medium)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    lazy var titleImage:UIImageView! = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "launcher")
        return view
    }()
    
    func setupView() {
        self.view.backgroundColor = UIColor(0x17FFD5)
        self.view.addSubview(titleLabel)
        self.view.addSubview(titleImage)
        
        titleLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 125)
        titleLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10.0)
        titleLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10.0)
        titleLabel.autoSetDimension(.height, toSize: 75.0)
        
        titleImage.autoPinEdge(.top, to: .bottom, of: titleLabel)
        titleImage.autoAlignAxis(toSuperviewAxis: .vertical)
        titleImage.autoSetDimensions(to: CGSize(width: 341, height: 341))
    }
    
    
    func presentMainViewCtrl() {
        let firstTab = GoutChartViewController()
        let secondTab = DrugListViewController()
        let thirdTab = UserInfoViewController()
        
        let mainViewController = GoutTabbarViewController()
        mainViewController.viewControllers = [firstTab, secondTab, thirdTab]
        present(mainViewController, animated: true, completion: nil)
    }

}

