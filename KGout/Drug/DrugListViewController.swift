//
//  PharmListViewController.swift
//  Gout
//
//  Created by khstar on 30/09/2018.
//  Copyright © 2018 khstar. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PureLayout

class DrugListViewController: GoutDefaultViewController {
    
    var isDeleteMode = false
    var deleteDrugList:[Int:DrugInfo] = [:]
    
    var drugList:[DrugInfo] = [] {
        didSet{
            drugInfoCollectionView.reloadData()
        }
    }
    
    lazy var drugInfoCollectionView: UICollectionView! = {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        collectionView.backgroundColor = .white
        collectionView.register(EmptyCell.self, forCellWithReuseIdentifier: EmptyCell.className)
        collectionView.register(DrugInfoViewCell.self, forCellWithReuseIdentifier: DrugInfoViewCell.className)
        collectionView.register(DeleteDrugInfoViewCell.self, forCellWithReuseIdentifier: DeleteDrugInfoViewCell.className)
        
        collectionView.bounces = false
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    lazy var addButton: UIButton! = {
        let button = UIButton()
        button.setTitle(StringConstants.addBtn, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(0xAFDFE3)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 8
        
        button.addTarget(self, action: #selector(touchDown), for: .touchDown)
        button.addTarget(self, action: #selector(touchUp), for: [.touchUpInside, .touchUpOutside, .touchDragExit])
        
        return button
    }()
    
    lazy var completeButton: UIButton! = {
        let button = UIButton()
        button.setTitle(StringConstants.completeBtn, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(0xAFDFE3)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 8
        
        button.addTarget(self, action: #selector(touchDown), for: .touchDown)
        button.addTarget(self, action: #selector(touchUp), for: [.touchUpInside, .touchUpOutside, .touchDragExit])
        
        return button
    }()
    
    lazy var cancelButton: UIButton! = {
        let button = UIButton()
        button.setTitle(StringConstants.cancelBtn, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(0xAFDFE3)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 8
        
        button.addTarget(self, action: #selector(touchDown), for: .touchDown)
        button.addTarget(self, action: #selector(touchUp), for: [.touchUpInside, .touchUpOutside, .touchDragExit])
        
        return button
    }()
    
    lazy var deleteButton: UIButton! = {
        let button = UIButton()
        button.setTitle(StringConstants.delBtn, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(0xAFDFE3)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 8
        
        button.addTarget(self, action: #selector(touchDown), for: .touchDown)
        button.addTarget(self, action: #selector(touchUp), for: [.touchUpInside, .touchUpOutside, .touchDragExit])
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    ///데이터가 없는 경우 표시할 Panel
    lazy var emptyPanel:UIView! = {
        let view = UIView()
        let label = UILabel()
        
        view.addSubview(label)
        label.autoCenterInSuperview()
        label.text = StringConstants.noDataMSG
        
        return view
    }()
    
    func setupView() {
        self.view.addSubview(naviBar)
        
        naviBar.autoPinEdge(toSuperviewEdge: .top, withInset: Constants.statusHeight())
        naviBar.autoPinEdge(toSuperviewEdge: .left)
        naviBar.autoPinEdge(toSuperviewEdge: .right)
        naviBar.autoSetDimension(.height, toSize: 44)
        
        naviBar.title = StringConstants.medicineInfoTitle
        naviBar.rightButton = addButton
        naviBar.leftButton = deleteButton
            
        self.view.addSubview(drugInfoCollectionView)
        drugInfoCollectionView.autoPinEdge(.top, to: .bottom, of: naviBar)
        drugInfoCollectionView.autoPinEdge(toSuperviewEdge: .left)
        drugInfoCollectionView.autoPinEdge(toSuperviewEdge: .right)
        drugInfoCollectionView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 53)
        
        addButton.rx.tap.bind {
            [weak self] _ in
            self?.nextAddPharmViewCtrl(drugInfo: nil)
            }.disposed(by: disposeBag)
        
        completeButton.rx.tap.bind {
            [weak self] _ in
            self?.reqDeleteMedicine()
            }.disposed(by:disposeBag)
        
        deleteButton.rx.tap.bind {
            [weak self] _ in
            self?.setDeleteMode()
            }.disposed(by:disposeBag)
        
        cancelButton.rx.tap.bind {
            [weak self] _ in
            self?.setDeleteMode()
            }.disposed(by:disposeBag)
        
        fetchData()
    }
    
    func setEmptyView() {
        self.view.addSubview(emptyPanel)
        emptyPanel.autoPinEdge(.top, to: .bottom, of: naviBar)
        emptyPanel.autoPinEdge(toSuperviewEdge: .left)
        emptyPanel.autoPinEdge(toSuperviewEdge: .right)
        emptyPanel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 53 + Constants.bottomHeight())
        emptyPanel.backgroundColor = .white
        
        emptyPanel.tag = 1
    }
    
    @objc func touchDown(sender:UIButton) {
        sender.backgroundColor = UIColor(0x97C1C4)
    }
    
    @objc func touchUp(sender:UIButton) {
        sender.backgroundColor = UIColor(0xAFDFE3)
    }
    
    func removeEmptyView() {
        self.view.viewWithTag(1)?.removeFromSuperview()
    }
    
    func setDeleteMode() {
        
        //데이터가 0인데 삭제 버튼을 누른 경우
        if drugList.count == 0 {
            showAlertAll(title: Bundle.main.displayName!, StringConstants.noDataDeleteMSG, nextFunction: {})
            return
        }
        
        if isDeleteMode {
            self.deleteDrugList = [:]
            isDeleteMode = false
        } else {
            isDeleteMode = true
        }
        
        fetchData()
    }
    
    func fetchData(){
        
        let drugInfoList = DatabaseManager.sharedInstance().selectDrugInfoList()
        
        //약 정보가 있는 경우 대입
        if drugInfoList != nil &&
            drugInfoList!.count > 0{
            self.drugList = drugInfoList!
            self.removeEmptyView()
        } else {
            self.setEmptyView()
        }
        
        if isDeleteMode {
            naviBar.leftButton = cancelButton
            naviBar.rightButton = completeButton
            
            deleteButton.isEnabled = false
            deleteButton.isHidden = true
            addButton.isEnabled = false
            addButton.isHidden = true
            
            cancelButton.isEnabled = true
            cancelButton.isHidden = false
            completeButton.isEnabled = true
            completeButton.isHidden = false
            
        } else {
            naviBar.leftButton = deleteButton
            naviBar.rightButton = addButton
            
            cancelButton.isEnabled = false
            cancelButton.isHidden = true
            completeButton.isEnabled = false
            completeButton.isHidden = true
            
            deleteButton.isEnabled = true
            deleteButton.isHidden = false
            addButton.isEnabled = true
            addButton.isHidden = false
        }
    }
    
    func nextAddPharmViewCtrl(drugInfo:DrugInfo?) {
        let addViewCtrl = AddDrugInfoViewController()
        addViewCtrl.drugInfo = drugInfo
        addViewCtrl.addDrugInfoDelegate = self
        present(addViewCtrl, animated: true, completion: nil)
    }
    
    /**
     약품 정보 삭제
     */
    func reqDeleteMedicine() {
        let database = DatabaseManager.sharedInstance()
        
        if database.deleteDrugInfoList(drugInfoList: deleteDrugList) {
            logger.debug(output: "삭제 성공")
        }
        
        self.isDeleteMode = false
        deleteDrugList = [:]
        fetchData()
    }
    
    /**
     탭이 동하여 뷰가 사라질때 처리
     */
    override func viewDidDisappear(_ animated: Bool) {
        isDeleteMode = false
        deleteDrugList = [:]
        fetchData()
    }
}

extension DrugListViewController:AddDrugInfoDelegate {
    func successDrugInfo() {
        self.fetchData()
    }
}

extension DrugListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return drugList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if drugList.count == 0 {
            return CGSize(width: collectionView.bounds.width, height: UIScreen.main.bounds.height - 63)
        }
        
        return CGSize(width: self.view.frame.width, height: (12 + 50 + 12))
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if drugList.count == 0 {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyCell.className, for: indexPath) as? EmptyCell {
                cell.titleLabel.text = StringConstants.noAlarmMSG
                cell.subsLabel.isHidden = true
                return cell
            }
        }
        
        if isDeleteMode {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DeleteDrugInfoViewCell.className, for: indexPath) as? DeleteDrugInfoViewCell else {
                return UICollectionViewCell()
            }
            
            let data = drugList[indexPath.row]
            cell.drugName.text = data.drugName
            cell.drugDesc.text = data.drugDesc
            cell.drugAlarmCount.text = "\(data.drunAlarmInfos.count)"
            cell.deleteImage.image = #imageLiteral(resourceName: "unSelect_Check")
            
            //약품 이미지가 없는 경우는 기본 이미지 사용
            if data.drugImg.isEmpty {
                cell.drugImgView.image = #imageLiteral(resourceName: "emptyDrugImg")
            } else {
                do {
                    let pathString = "\(GoutFileManager.sharedInstance().getDocumentsDirectory())\(data.drugImg)"
                    let imageData = try Data(contentsOf: URL.init(string: pathString)!)
                    cell.drugImgView.image = UIImage.init(data: imageData)
                } catch {
                    logger.error(output: "Fail Drug Image")
                }
            }
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DrugInfoViewCell.className, for: indexPath) as? DrugInfoViewCell else {
                return UICollectionViewCell()
            }
            
            let data = drugList[indexPath.row]
            cell.drugName.text = data.drugName
            cell.drugDesc.text = data.drugDesc
            cell.drugAlarmCount.text = "\(data.drunAlarmInfos.count)"
            
            //약품 이미지가 없는 경우는 기본 이미지 사용
            if data.drugImg.isEmpty {
                cell.drugImgView.image = #imageLiteral(resourceName: "emptyDrugImg")
            } else {
                do {
                    let pathString = "\(GoutFileManager.sharedInstance().getDocumentsDirectory())\(data.drugImg)"
                    let imageData = try Data(contentsOf: URL.init(string: pathString)!)
                    cell.drugImgView.image = UIImage.init(data: imageData)
                    
                } catch {
                    logger.error(output: "Fail Drug Image")
                }
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if drugList.count == 0 {
            return
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if isDeleteMode {
            
            deleteButton.titleLabel!.text = StringConstants.cancelBtn
            
            guard let cell = drugInfoCollectionView.cellForItem(at: indexPath) as? DeleteDrugInfoViewCell else { return }
            
            if deleteDrugList[indexPath.row] == nil {
                cell.deleteImage.image = #imageLiteral(resourceName: "select_Check")
                deleteDrugList[indexPath.row] = drugList[indexPath.row]
            } else {
                cell.deleteImage.image = #imageLiteral(resourceName: "unSelect_Check")
                deleteDrugList.removeValue(forKey: indexPath.row)
            }
            
        } else {
            
            let drugInfo = drugList[indexPath.row]
            nextAddPharmViewCtrl(drugInfo: drugInfo)
        }
    }
}
