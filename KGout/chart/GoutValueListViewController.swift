//
//  GoutValueListViewController.swift
//  Gout
//
//  Created by khstar on 29/10/2018.
//  Copyright © 2018 khstar. All rights reserved.
//

import UIKit

class GoutValueListViewController: GoutDefaultViewController {

    var regDate:String?
    var goutValueList:[GoutData] = [] {
        didSet{
            goutValueCollectionView.reloadData()
        }
    }
    
    lazy var defaultPanelView:UIView! = {
        let view = UIView()
        view.layer.cornerRadius = 15
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
        defaultPanelView.isHidden = false
        print("tester")
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        defaultPanelView.isHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidDisappear")
    }
    
    lazy var addTitle:UILabel! = {
        let label = UILabel()
        label.text = "수치 입력"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    lazy var goutValueCollectionView: UICollectionView! = {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        collectionView.backgroundColor = .white
        collectionView.register(EmptyCell.self, forCellWithReuseIdentifier: EmptyCell.className)
        collectionView.register(GoutDataViewCell.self, forCellWithReuseIdentifier: GoutDataViewCell.className)
        collectionView.bounces = false
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    lazy var closeButton: UIButton! = {
        let button = UIButton()
        button.setBackgroundImage(#imageLiteral(resourceName: "addSaveBtnNormal"), for: .normal)
        button.setBackgroundImage(#imageLiteral(resourceName: "addSaveBtnSelect"), for: .selected)
        button.setTitle("닫기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        
        return button
    }()
    
    func setupView() {
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.view.addSubview(defaultPanelView)
        defaultPanelView.autoAlignAxis(toSuperviewAxis: .horizontal)
        defaultPanelView.autoAlignAxis(toSuperviewAxis: .vertical)
        defaultPanelView.autoSetDimensions(to: CGSize(width: 300, height: 266))
        defaultPanelView.backgroundColor = .white
        defaultPanelView.alpha = 1.0
        
        defaultPanelView.addSubview(addTitle)
        addTitle.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
        addTitle.autoPinEdge(toSuperviewEdge: .left)
        addTitle.autoPinEdge(toSuperviewEdge: .right)
        addTitle.autoSetDimension(.height, toSize: 24)
        addTitle.text = regDate!
        
        defaultPanelView.addSubview(goutValueCollectionView)
        goutValueCollectionView.autoPinEdge(.top, to: .bottom, of: addTitle, withOffset: 5)
        goutValueCollectionView.autoPinEdge(toSuperviewEdge: .left)
        goutValueCollectionView.autoPinEdge(toSuperviewEdge: .right)
        goutValueCollectionView.autoSetDimension(.height, toSize: 180)
//        goutValueCollectionView.backgroundColor = .gray
        
        defaultPanelView.addSubview(closeButton)
        closeButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 7)
        closeButton.autoAlignAxis(toSuperviewAxis: .vertical)
        closeButton.autoSetDimensions(to: CGSize(width: 127.5, height: 30))
        
        closeButton.rx.tap.bind {
            [weak self] _ in
            self?.dismiss(animated: true)
            }.disposed(by: disposeBag)
        
        fetchData()
    }
    
    func fetchData(){
        do{
            let uricacids = DatabaseManager.sharedInstance().selectGoutRegdate(date: regDate!)
            
            if uricacids != nil {
                goutValueList = uricacids!
            }
            
        } catch {
            print("Fetching Failed")
        }
    }

}

extension GoutValueListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return goutValueList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if goutValueList.count == 0 {
            return CGSize(width: collectionView.bounds.width, height: UIScreen.main.bounds.height - 63)
        }
        
        return CGSize(width: 300, height: 35)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if goutValueList.count == 0 {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyCell.className, for: indexPath) as? EmptyCell {
                cell.titleLabel.text = "알림이 없습니다."
                cell.subsLabel.isHidden = true
                return cell
            }
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GoutDataViewCell.className, for: indexPath) as? GoutDataViewCell else {
            return UICollectionViewCell()
        }
        
        let data = goutValueList[indexPath.row]
        cell.dateLabel.text = "\(data.regDate) \(data.regTime)"
        cell.uricacidLabel.text = data.gout
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if goutValueList.count == 0 {
            return
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("indexPath = \(indexPath.row)")
        let drugAlarm = goutValueList[indexPath.row]
        
        let addViewCtrl = AddValueViewController()
        addViewCtrl.reqView = "Gout"
        
        addViewCtrl.dateTextField.text = drugAlarm.regDate
        addViewCtrl.goutTextField.text = drugAlarm.gout
        addViewCtrl.goutId = drugAlarm.id
        
        addViewCtrl.addValueViewDelegate = self
        
        //현재화면의 defaultPanel숨기기
        defaultPanelView.isHidden = true
        
        addViewCtrl.modalPresentationStyle = .overFullScreen
        present(addViewCtrl, animated: true, completion: nil)
        
    }
    
}

extension GoutValueListViewController:AddValueViewDelegate {
    func successGoutValue() {
        print("success")
        self.fetchData()
        self.defaultPanelView.isHidden = false
    }
    
    func cancelGoutValue() {
        print("cacnel")
        self.defaultPanelView.isHidden = false
    }
}
