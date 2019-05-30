//
//  AddPharmInfoViewController.swift
//  Gout
//
//  Created by khstar on 30/09/2018.
//  Copyright © 2018 khstar. All rights reserved.
//

import UIKit

protocol AddDrugInfoDelegate {
    func successDrugInfo()
}

class AddDrugInfoViewController: GoutDefaultViewController, UITextFieldDelegate {
    
    var drugInfo:DrugInfo? = nil
    
    var drugAlarmInfo:[DrugAlarmInfo] = [] {
        didSet{
            drugAlarmCollectionView.reloadData()
        }
    }
    var delDrugAlarmList:[Int:DrugAlarmInfo] = [:]
    var addDrugInfoDelegate:AddDrugInfoDelegate?
    var isDeleteMode = false
    
    lazy var defaultPanelView:UIView! = {
        let view = UIView()
        return view
    }()
    
    lazy var cameraImageView:UIImageView! = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "camera")
        return imageView
    }()
    
    lazy var pharmNamePanel:UIView! = {
        let view = UIView()
        return view
    }()
    
    lazy var pharmNameLabel:UILabel! = {
        let label = UILabel()
        label.text = StringConstants.medicineName
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor(0x7a7a7a)
        return label
    }()
    
    lazy var drugNameTextField:UITextField! = {
        let field = UITextField()
        
        field.keyboardType = .default
        field.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        field.textColor = UIColor(0x1c1c1c)
        field.placeholder = StringConstants.medicineNameFieldMSG
        
        let doneToolBar = UIToolbar()
        let doneBarButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(setDone))
        
        doneToolBar.sizeToFit()
        doneToolBar.items = [doneBarButton]
        
        field.inputAccessoryView = doneToolBar
        
        return field
    }()
    
    lazy var pharmDescPanel:UIView! = {
        let view = UIView()
        return view
    }()
    
    lazy var pharmDescLabel:UILabel! = {
        let label = UILabel()
        label.text = StringConstants.medicineInfo
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor(0x7a7a7a)
        return label
    }()
    
    lazy var drugDesc:UITextView! = {
        let field = UITextView()

        field.text = StringConstants.medicineInfoFieldMSG
        field.textColor = .placeholder
        
        field.keyboardType = .default
        field.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        field.delegate = self
        
        //UITextView의 여백 없에기
        field.textContainerInset = UIEdgeInsets.zero
        field.textContainer.lineFragmentPadding = 0
        
        let doneToolBar = UIToolbar()
        let doneBarButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(setDone))
        
        doneToolBar.sizeToFit()
        doneToolBar.items = [doneBarButton]
        
        field.inputAccessoryView = doneToolBar
        
        return field
    }()
    
    lazy var completeButton: UIButton! = {
        let button = UIButton()
        button.setTitle(StringConstants.saveBtn, for: .normal)
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
    
    lazy var addAlarmBtn:UIButton! = {
        let button = UIButton()
        button.setTitle(StringConstants.addAlarm, for: .normal)
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
    
    lazy var delAlarmBtn:UIButton! = {
        let button = UIButton()
        button.setTitle(StringConstants.delAlarm, for: .normal)
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
    
    lazy var delComformAlarmBtn:UIButton! = {
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
    
    lazy var delCancelAlarmBtn:UIButton! = {
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
    lazy var drugAlarmLabel:UILabel! = {
        let label = UILabel()
        label.text = StringConstants.medicineAlarm
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor(0x7a7a7a)
        return label
    }()
    
    lazy var drugAlarmPanel:UIView! = {
        let view = UIView()
        return view
    }()
    
    lazy var drugAlarmCollectionView: UICollectionView! = {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        collectionView.backgroundColor = .white
        collectionView.register(EmptyCell.self, forCellWithReuseIdentifier: EmptyCell.className)
        collectionView.register(DrugAlarmViewCell.self, forCellWithReuseIdentifier: DrugAlarmViewCell.className)
        collectionView.register(DeleteDrugAlarmViewCell.self, forCellWithReuseIdentifier: DeleteDrugAlarmViewCell.className)
        
        collectionView.bounces = false
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    let datePicker = UIDatePicker()
    
    let databaseManager = DatabaseManager.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drugDesc.delegate = self
        drugNameTextField.delegate = self
        
        setView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @objc func keyboardWillShow(_ sender:Notification) {
//        self.view.frame.origin.y = -150
    }
    
    @objc func keyboardWillHide(_ sender:Notification) {
//        self.view.frame.origin.y = 0
    }
    
    @objc func setDone() {
        drugDesc.resignFirstResponder()
        drugNameTextField.resignFirstResponder()
    }
    
    /**
     화면 그리기
     */
    func setView() {
        
        self.view.addSubview(naviBar)
        self.view.addSubview(defaultPanelView)
        
        naviBar.autoPinEdge(toSuperviewEdge: .top, withInset: Constants.statusHeight())
        naviBar.autoPinEdge(toSuperviewEdge: .left)
        naviBar.autoPinEdge(toSuperviewEdge: .right)
        naviBar.autoSetDimension(.height, toSize: 44)
        naviBar.title = StringConstants.medicineInfoAddTitle
        naviBar.rightButton = completeButton
        naviBar.leftButton = cancelButton
        
        defaultPanelView.autoPinEdge(.top, to: .bottom, of: naviBar)
        defaultPanelView.autoPinEdge(toSuperviewEdge: .left)
        defaultPanelView.autoPinEdge(toSuperviewEdge: .right)
        defaultPanelView.autoPinEdge(toSuperviewEdge: .bottom, withInset: Constants.bottomHeight())
        defaultPanelView.backgroundColor = .white

        defaultPanelView.addSubview(cameraImageView)
        defaultPanelView.addSubview(pharmNamePanel)
        defaultPanelView.addSubview(pharmDescPanel)
        defaultPanelView.addSubview(drugAlarmPanel)
        defaultPanelView.addSubview(drugAlarmCollectionView)
        
        cameraImageView.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
        cameraImageView.autoAlignAxis(toSuperviewAxis: .vertical)
        cameraImageView.autoSetDimensions(to: CGSize(width: 100, height: 100))
        
        pharmNamePanel.autoPinEdge(.top, to: .bottom, of: cameraImageView, withOffset: 13)
        pharmNamePanel.autoPinEdge(toSuperviewEdge: .left, withInset: 15)
        pharmNamePanel.autoPinEdge(toSuperviewEdge: .right, withInset: 15)
        pharmNamePanel.autoSetDimension(.height, toSize: 55)
        
        pharmNamePanel.addSubview(pharmNameLabel)
        pharmNamePanel.addSubview(drugNameTextField)
        
        pharmNameLabel.autoPinEdge(toSuperviewEdge: .top)
        pharmNameLabel.autoPinEdge(toSuperviewEdge: .left)
        pharmNameLabel.autoPinEdge(toSuperviewEdge: .right)
        
        drugNameTextField.autoPinEdge(.top, to: .bottom, of: pharmNameLabel, withOffset: 8)
        drugNameTextField.autoPinEdge(toSuperviewEdge: .left)
        drugNameTextField.autoPinEdge(toSuperviewEdge: .right)
        
        pharmDescPanel.autoPinEdge(.top, to: .bottom, of: pharmNamePanel, withOffset: 4)
        pharmDescPanel.autoPinEdge(toSuperviewEdge: .left, withInset: 15)
        pharmDescPanel.autoPinEdge(toSuperviewEdge: .right, withInset: 15)
        pharmDescPanel.autoSetDimension(.height, toSize: 88)
        
        pharmDescPanel.addSubview(pharmDescLabel)
        pharmDescPanel.addSubview(drugDesc)
        
        pharmDescLabel.autoPinEdge(toSuperviewEdge: .top)
        pharmDescLabel.autoPinEdge(toSuperviewEdge: .left)
        pharmDescLabel.autoPinEdge(toSuperviewEdge: .right)
        
        drugDesc.autoPinEdge(.top, to: .bottom, of: pharmDescLabel, withOffset: 8)
        drugDesc.autoPinEdge(toSuperviewEdge: .left)
        drugDesc.autoPinEdge(toSuperviewEdge: .right)
        drugDesc.autoPinEdge(toSuperviewEdge: .bottom, withInset: 8)
        
        drugAlarmPanel.autoPinEdge(.top, to: .bottom, of: pharmDescPanel, withOffset: 4)
        drugAlarmPanel.autoPinEdge(toSuperviewEdge: .left, withInset: 15)
        drugAlarmPanel.autoPinEdge(toSuperviewEdge: .right, withInset: 15)
        drugAlarmPanel.autoSetDimension(.height, toSize: 35)
        
        drugAlarmPanel.addSubview(drugAlarmLabel)
        drugAlarmPanel.addSubview(delComformAlarmBtn)
        drugAlarmPanel.addSubview(addAlarmBtn)
        drugAlarmPanel.addSubview(delCancelAlarmBtn)
        drugAlarmPanel.addSubview(delAlarmBtn)
        
        //영어 가 들어가면 약간 짧아서 + 5 넣어줌 
        let drugAlarmLabelWidth = Utils.widthOfString(drugAlarmLabel.text!, font: drugAlarmLabel.font!) + 5
        
        drugAlarmLabel.autoPinEdge(toSuperviewEdge: .top)
        drugAlarmLabel.autoPinEdge(toSuperviewEdge: .left)
        drugAlarmLabel.autoSetDimensions(to: CGSize(width: drugAlarmLabelWidth, height: 20))
        
        delComformAlarmBtn.autoPinEdge(toSuperviewEdge: .top)
        delComformAlarmBtn.autoPinEdge(.left, to: .right, of: drugAlarmLabel, withOffset: 5)
        delComformAlarmBtn.autoSetDimensions(to: CGSize(width: 80, height: 20))
        
        addAlarmBtn.autoPinEdge(toSuperviewEdge: .top)
        addAlarmBtn.autoPinEdge(.left, to: .right, of: drugAlarmLabel, withOffset: 5)
        addAlarmBtn.autoSetDimensions(to: CGSize(width: 80, height: 20))
        
        delCancelAlarmBtn.autoPinEdge(toSuperviewEdge: .top)
        delCancelAlarmBtn.autoPinEdge(.left, to: .right, of: addAlarmBtn, withOffset: 5)
        delCancelAlarmBtn.autoSetDimensions(to: CGSize(width: 80, height: 20))
        
        delAlarmBtn.autoPinEdge(toSuperviewEdge: .top)
        delAlarmBtn.autoPinEdge(.left, to: .right, of: addAlarmBtn, withOffset: 5)
        delAlarmBtn.autoSetDimensions(to: CGSize(width: 80, height: 20))
        
        drugAlarmCollectionView.autoPinEdge(.top, to: .bottom, of: drugAlarmPanel, withOffset: 5)
        drugAlarmCollectionView.autoPinEdge(toSuperviewEdge: .left, withInset: 15)
        drugAlarmCollectionView.autoPinEdge(toSuperviewEdge: .right, withInset: 15)
        drugAlarmCollectionView.autoPinEdge(toSuperviewEdge: .bottom)
        
        //취소 버튼 이벤트
        cancelButton.rx.tap.bind {
            [weak self] _ in
            self?.dismiss(animated: true)
            }.disposed(by: disposeBag)
        
        //정보 추가 이벤트
        completeButton.rx.tap.bind {
            [weak self] _ in
            self?.saveDrugInfo()
            }.disposed(by: disposeBag)
        
        //알람 추가 버튼 이벤트
        addAlarmBtn.rx.tap.bind {
            [weak self] _ in
            self?.showAddDrugAlarm(drugAlarm: nil, drugAlarmIndex: -1)
            }.disposed(by: disposeBag)
        
        delAlarmBtn.rx.tap.bind {
            [weak self] _ in
            self?.deleteAlarmMode()
            }.disposed(by:disposeBag)
        
        //삭제 확인
        delComformAlarmBtn.rx.tap.bind {
            [weak self] _ in
            self?.showAddDrugAlarm(drugAlarm: nil, drugAlarmIndex: -1)
            }.disposed(by: disposeBag)
        
        delCancelAlarmBtn.rx.tap.bind {
            [weak self] _ in
            self?.deleteAlarmMode()
            }.disposed(by:disposeBag)
        
        //카메라 이미지 선택 이벤트
        cameraImageView.rx.tapGesture().when(.recognized).bind{
            [weak self] _ in
            self?.showCamera()
            }.disposed(by: disposeBag)
        
        if self.drugInfo == nil {
            self.drugInfo = DrugInfo()
            drugAlarmInfo = []
        } else {
            drugNameTextField.text = drugInfo!.drugName
            drugDesc.textColor = .black
            drugDesc.text = drugInfo!.drugDesc
            drugAlarmInfo = drugInfo!.drunAlarmInfos
            
            //약품 이미지가 없는 경우는 기본 이미지 사용
            if drugInfo!.drugImg.isEmpty {
                
                cameraImageView.image = #imageLiteral(resourceName: "camera")
                
            } else {
                do {
                    let pathString = "\(GoutFileManager.sharedInstance().getDocumentsDirectory())\(drugInfo!.drugImg)"
                    let imageData = try Data(contentsOf: URL.init(string: pathString)!)
                    cameraImageView.image = UIImage.init(data: imageData)
                    
                } catch {
                    print("Fail Drug Image")
                }
            }
        }
    }
    
    @objc func touchDown(sender:UIButton) {
        sender.backgroundColor = UIColor(0x97C1C4)
    }
    
    @objc func touchUp(sender:UIButton) {
        sender.backgroundColor = UIColor(0xAFDFE3)
    }
    
    /**
     약품 알람 추가 뷰 보여주기
     */
    func showAddDrugAlarm(drugAlarm:DrugAlarmInfo?, drugAlarmIndex:Int?){
        
        if isDeleteMode {
            showAlert2(StringConstants.alarmDeleteAlertMSG,
                       yes: StringConstants.yesBtn,
                       no: StringConstants.noBtn,
                       nextFunction: self.deleteDrugAlarm,
                       closeFunction: self.cancelDeleteDrugAlarm)
            return
        } else {
            let addDrugAlarm = AddDrugAlarmViewController()
            addDrugAlarm.drugAlarmInfo = drugAlarm
            addDrugAlarm.addDrugAlarmDelegate = self
            addDrugAlarm.drugAlarmIndex = drugAlarmIndex!
            
            self.present(addDrugAlarm, animated: true, completion:{})
        }
    }
    
    /**
     선택된 약 알람 정보 삭제
     */
    func deleteDrugAlarm() {
        
        let keys = delDrugAlarmList.keys.sorted(by: >)
        
        for key in keys {
            let drugAlarm = delDrugAlarmList[key]
            let drugId = drugAlarm!.drugId
            let drugAlarmId = drugAlarm!.id
            let identifier = "\(drugId)_\(drugAlarmId)"
            
            drugAlarmInfo.remove(at: key)
            LocalPushManager.sharedInstance().removeAlarm(identifier: identifier)
            databaseManager.deleteDrugAlarmInfo(drugId: drugId, id: drugAlarmId)
        }
        
        self.isDeleteMode = false
        delDrugAlarmList = [:]
        addDrugInfoDelegate?.successDrugInfo()
    }
    
    func cancelDeleteDrugAlarm() {
        self.isDeleteMode = false
        delDrugAlarmList = [:]
        drugAlarmCollectionView.reloadData()
    }
    
    /**
     약 이미지 저장을 위한 카메라 화면 로드
     */
    func showCamera(){
        let cameraView = CameraViewController()
        cameraView.cameraDelegate = self
        present(cameraView, animated: true, completion: nil)
    }
    
    func deleteAlarmMode() {
        
        if self.isDeleteMode {
            self.isDeleteMode = false
            self.addAlarmBtn.isHidden = false
            self.delAlarmBtn.isHidden = false
        
        } else {
            
            if drugAlarmInfo.count == 0 {
                showAlertAll(title: Bundle.main.displayName!, StringConstants.noAlarmMSG, nextFunction: {})
                return
            }
            
            self.isDeleteMode = true
            self.addAlarmBtn.isHidden = true
            self.delAlarmBtn.isHidden = true
        }
        
        drugAlarmCollectionView.reloadData()
    }
    
    @objc func donePressed(){
        view.endEditing(true)
    }
    
    @objc func updateDate() {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        drugNameTextField.text = dateFormatter.string(from: datePicker.date)
    }
    
    /**
     입력값 저장하기
     */
    func saveDrugInfo() {
        let drugName = self.drugNameTextField.text!
        var drugDesc = self.drugDesc.text!
        var drugImgName = ""
        
        if drugName.isEmpty {
            showAlert2(StringConstants.medicineNameFieldMSG)
            return
        }
        
        //텍스트 색이 placeholder 색과 같으면
        if self.drugDesc.textColor == .placeholder {
            drugDesc = ""
        }
        
        if !(cameraImageView.image?.isEqual(#imageLiteral(resourceName: "camera")))! {
            if (drugInfo?.drugImg.isEmpty)! {
                drugImgName = "\(DatetimeUtils.nowMMDDHHmmss()).png"
                
                var pathString = GoutFileManager.sharedInstance().getDocumentsDirectory()
                pathString.appendPathComponent(drugImgName)
                
                let drugImg = self.cameraImageView.image!.resized(toWidth: 300)
                let data = UIImage.pngData(drugImg!)
                
                do {
                    try data()?.write(to: pathString)
                }
                catch {
                    print("이미지 생성중 에러")
                }
            } else {
                //삭제 후 저장
                GoutFileManager.sharedInstance().removeImage(fileName: drugInfo!.drugImg)
                
                drugImgName = "\(DatetimeUtils.nowMMDDHHmmss()).png"
                
                var pathString = GoutFileManager.sharedInstance().getDocumentsDirectory()
                pathString.appendPathComponent(drugImgName)
                
                let drugImg = self.cameraImageView.image!.resized(toWidth: 300)
                let data = UIImage.pngData(drugImg!)
                
                do {
                    try data()?.write(to: pathString)
                }
                catch {
                    print("이미지 생성중 에러")
                }
            }
        }
        
        self.drugInfo!.drugName = drugName
        self.drugInfo!.drugDesc = drugDesc
        self.drugInfo!.drunAlarmInfos = self.drugAlarmInfo
        self.drugInfo!.drugImg = drugImgName
        
        //DB에 약 정보 데이터 입력
        databaseManager.upsertDrugInfo(drugInfo: self.drugInfo!)
        LocalPushManager.sharedInstance().setDrugAlarm(drugInfo: self.drugInfo!)
        addDrugInfoDelegate?.successDrugInfo()
        
        dismissSelf(true)
        
    }
    
    
    @objc func goutValid() {
        print("\(String(describing: drugDesc.text))")
    }
}

extension AddDrugInfoViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 10000
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .placeholder {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = StringConstants.medicineInfoFieldMSG
            textView.textColor = .placeholder
        }
    }
}

extension AddDrugInfoViewController:AddDrugAlarmInfoDelegate, CameraDelegate {
    ///약 알람 정보 추가
    func addDrugAlarmInfo(drugInfo: DrugAlarmInfo, drugAlarmIndex:Int) {
        
        if drugAlarmIndex < 0 {
            self.drugAlarmInfo.append(drugInfo)
        } else {
            self.drugAlarmInfo[drugAlarmIndex] = drugInfo
        }
        
        self.drugAlarmCollectionView.reloadData()
    }
    
    func capture(image: UIImage) {
        self.cameraImageView.image = image
    }
}



extension AddDrugInfoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return drugAlarmInfo.count == 0 ? 1 : drugAlarmInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if drugAlarmInfo.count == 0 {
            return CGSize(width: collectionView.bounds.width, height: 63)
        }
        
        return CGSize(width: UIScreen.main.bounds.width - 30, height: 58)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if drugAlarmInfo.count == 0 {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyCell.className, for: indexPath) as? EmptyCell {
                cell.titleLabel.text = StringConstants.noAlarmMSG
                cell.subsLabel.isHidden = true
                return cell
            }
        }
        
        if isDeleteMode {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DeleteDrugAlarmViewCell.className, for: indexPath) as? DeleteDrugAlarmViewCell else {
                return UICollectionViewCell()
            }
            
            let data = drugAlarmInfo[indexPath.row]
            
            cell.alarmTime.text = data.alarmTime
            
            let repeatWeek = data.week
            cell.setRepeat(repeatWeek: repeatWeek)
            cell.index = indexPath.row
            cell.drugAlarmDelegate = self
            cell.deleteImage.image = #imageLiteral(resourceName: "unSelect_Check")
            cell.drugAlamrDesc.text = data.alarmDesc
            
            if data.enable == 1 {
                cell.switchBtn.isOn = true
            } else {
                cell.switchBtn.isOn = false
            }
            
            //약품 이미지가 없는 경우는 기본 이미지 사용
            return cell
            
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DrugAlarmViewCell.className, for: indexPath) as? DrugAlarmViewCell else {
                return UICollectionViewCell()
            }
            
            let data = drugAlarmInfo[indexPath.row]
            
            cell.alarmTime.text = data.alarmTime
            
            let repeatWeek = data.week
            cell.setRepeat(repeatWeek: repeatWeek)
            cell.index = indexPath.row
            cell.drugAlarmDelegate = self
            cell.drugAlamrDesc.text = data.alarmDesc
            
            if data.enable == 1 {
                cell.switchBtn.isOn = true
            } else {
                cell.switchBtn.isOn = false
            }
            
            //약품 이미지가 없는 경우는 기본 이미지 사용
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if drugAlarmInfo.count == 0 {
            return
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let drugAlarm = drugAlarmInfo[indexPath.row]
        
        if isDeleteMode {
            guard let cell = drugAlarmCollectionView.cellForItem(at: indexPath) as? DeleteDrugAlarmViewCell else { return }
            
            if delDrugAlarmList[indexPath.row] == nil {
                cell.deleteImage.image = #imageLiteral(resourceName: "select_Check")
                delDrugAlarmList[indexPath.row] =  drugAlarmInfo[indexPath.row]
            } else {
                cell.deleteImage.image = #imageLiteral(resourceName: "unSelect_Check")
                delDrugAlarmList.removeValue(forKey: indexPath.row)
            }
            
        } else {
            showAddDrugAlarm(drugAlarm: drugAlarm, drugAlarmIndex: indexPath.row)
        }
    }
    
}

extension AddDrugInfoViewController:DrugAlarmViewCellDelegate {
    /**
     알람 상태 변경
     */
    func alarmEnable(index: Int, enable: Int) {
        var drugAlarm = drugAlarmInfo[index]
        drugAlarm.enable = enable
        drugAlarmInfo[index] = drugAlarm
    }
}
