//
//  AddValueViewController.swift
//  Gout
//
//  Created by khstar on 2018. 9. 6..
//  Copyright © 2018년 khstar. All rights reserved.
//

import UIKit

protocol AddValueViewDelegate {
    func successGoutValue()
    func cancelGoutValue()
}

class AddValueViewController: GoutDefaultViewController, UITextFieldDelegate {
    
    var addValueViewDelegate:AddValueViewDelegate?
    var reqView:String = "Add"
    var goutId:Int = -1
    
    var addValueViewModel = AddGoutValueViewModel()
    
    lazy var defaultPanelView:UIView! = {
        let view = UIView()
        view.layer.cornerRadius = 15
        
        return view
    }()
    
    lazy var addTitle:UILabel! = {
        let label = UILabel()
        label.text = StringConstants.uricacidAdd
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    lazy var datePanel:UIView! = {
        let view = UIView()
        return view
    }()
    
    lazy var dateLabel:UILabel! = {
        let label = UILabel()
        label.text = StringConstants.commonDate
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor(0x7a7a7a)
        return label
    }()
    
    lazy var dateTextField:UITextField! = {
        let field = UITextField()
        
        field.keyboardType = .decimalPad
        field.leftViewMode = .always
        field.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        field.textColor = UIColor(0x1c1c1c)
        field.placeholder = "1900-01-01"
        
        let doneToolBar = UIToolbar()
        let doneBarButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(setDone))
        
        doneToolBar.sizeToFit()
        doneToolBar.items = [doneBarButton]
        
        field.inputAccessoryView = doneToolBar
        
        return field
    }()
    
    lazy var timeLabel:UILabel! = {
        let label = UILabel()
        label.text = StringConstants.commonTime
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor(0x7a7a7a)
        return label
    }()
    
    lazy var timeTextField:UITextField! = {
        let field = UITextField()
        
        field.keyboardType = .decimalPad
        field.leftViewMode = .always
        field.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        field.textColor = UIColor(0x1c1c1c)
        field.placeholder = "00:00:00"
        
        let doneToolBar = UIToolbar()
        let doneBarButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(setDone))
        
        doneToolBar.sizeToFit()
        doneToolBar.items = [doneBarButton]
        
        field.inputAccessoryView = doneToolBar
        
        return field
    }()
    
    lazy var goutPanel:UIView! = {
        let view = UIView()
        return view
    }()
    
    lazy var goutLabel:UILabel! = {
        let label = UILabel()
        label.text = StringConstants.uricacid
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor(0x7a7a7a)
        return label
    }()
    
    lazy var goutTextField:UITextField! = {
        let field = UITextField()
        
        field.keyboardType = .decimalPad
        field.leftViewMode = .always
        field.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        field.textColor = UIColor(0x1c1c1c)
        field.placeholder = "0.0"
        
        let doneToolBar = UIToolbar()
        let doneBarButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(setDone))
        
        doneToolBar.sizeToFit()
        doneToolBar.items = [doneBarButton]
            
        field.inputAccessoryView = doneToolBar
        
        return field
    }()
    
    lazy var descPanel:UIView! = {
        let view = UIView()
        return view
    }()
    
    lazy var descLabel:UILabel! = {
        let label = UILabel()
        label.text = StringConstants.commonDesc
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor(0x7a7a7a)
        return label
    }()
    
    lazy var descTextView:UITextView! = {
        let field = UITextView()
        
        field.text = StringConstants.uricacidInfoDesc
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
    
    lazy var kidneyPanel:UIView! = {
        let view = UIView()
        return view
    }()
    
    lazy var kidneyLabel:UILabel! = {
        let label = UILabel()
        label.text = "신장(콩팥)"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor(0x7a7a7a)
        return label
    }()
    
    lazy var kidneyTextField:UITextField! = {
        let field = UITextField()
        
        field.keyboardType = .decimalPad
        field.leftViewMode = .always
        field.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        field.textColor = UIColor(0x1c1c1c)
        field.placeholder = "0.0"
        
        let doneToolBar = UIToolbar()
        let doneBarButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(setDone))
        doneToolBar.sizeToFit()
        doneToolBar.items = [doneBarButton]
        
        field.inputAccessoryView = doneToolBar
        
        return field
    }()
    
    lazy var completeButton: UIButton! = {
        let button = UIButton()
        button.setBackgroundImage(#imageLiteral(resourceName: "addSaveBtnNormal"), for: .normal)
        button.setBackgroundImage(#imageLiteral(resourceName: "addSaveBtnSelect"), for: .selected)
        button.setTitle(StringConstants.saveBtn, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        
        return button
    }()

    lazy var cancelButton: UIButton! = {
        let button = UIButton()
        button.setBackgroundImage(#imageLiteral(resourceName: "addSaveBtnNormal"), for: .normal)
        button.setBackgroundImage(#imageLiteral(resourceName: "addSaveBtnSelect"), for: .selected)
        button.setTitle(StringConstants.cancelBtn, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        
        return button
    }()
    
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    
    let databaseManager = DatabaseManager.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        goutTextField.delegate = self
        kidneyTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        setupView()
        setupRX()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @objc func keyboardWillShow(_ sender:Notification) {
        UIView.animate(withDuration: 0.3, animations: ({
            self.view.frame.origin.y = -150
        }))
    }
    
    @objc func keyboardWillHide(_ sender:Notification) {
        UIView.animate(withDuration: 0.3, animations: ({
            self.view.frame.origin.y = 0
        }))
    }
    
    @objc func setDone() {
        goutTextField.resignFirstResponder()
        kidneyTextField.resignFirstResponder()
    }
    
    /**
     화면 그리기
     */
    func setupView() {
        
        self.view.addSubview(defaultPanelView)
        defaultPanelView.autoAlignAxis(toSuperviewAxis: .horizontal)
        defaultPanelView.autoAlignAxis(toSuperviewAxis: .vertical)
        defaultPanelView.autoSetDimensions(to: CGSize(width: 300, height: 321))
        defaultPanelView.backgroundColor = .white
        defaultPanelView.alpha = 1.0
        
        defaultPanelView.addSubview(addTitle)
        addTitle.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
        addTitle.autoPinEdge(toSuperviewEdge: .left)
        addTitle.autoPinEdge(toSuperviewEdge: .right)
        addTitle.autoSetDimension(.height, toSize: 24)
        
        defaultPanelView.addSubview(datePanel)
        defaultPanelView.addSubview(goutPanel)
        defaultPanelView.addSubview(descPanel)
        defaultPanelView.addSubview(completeButton)
        defaultPanelView.addSubview(cancelButton)
        
        datePanel.autoPinEdge(.top, to: .bottom, of: addTitle, withOffset: 13)
        datePanel.autoPinEdge(toSuperviewEdge: .left, withInset: 15)
        datePanel.autoPinEdge(toSuperviewEdge: .right, withInset: 15)
        datePanel.autoSetDimension(.height, toSize: 55)
        
        datePanel.addSubview(dateLabel)
        datePanel.addSubview(dateTextField)
        datePanel.addSubview(timeLabel)
        datePanel.addSubview(timeTextField)
        
        let datePanelWidthHalf:CGFloat = (300 - 30)/2
        
        dateLabel.autoPinEdge(toSuperviewEdge: .top)
        dateLabel.autoPinEdge(toSuperviewEdge: .left)
        dateLabel.autoPinEdge(toSuperviewEdge: .right, withInset: datePanelWidthHalf)
        
        dateTextField.autoPinEdge(.top, to: .bottom, of: dateLabel, withOffset: 8)
        dateTextField.autoPinEdge(toSuperviewEdge: .left)
        dateTextField.autoPinEdge(toSuperviewEdge: .right, withInset: datePanelWidthHalf)
        
        timeLabel.autoPinEdge(toSuperviewEdge: .top)
        timeLabel.autoPinEdge(toSuperviewEdge: .right)
        timeLabel.autoPinEdge(toSuperviewEdge: .left, withInset: datePanelWidthHalf)
        
        timeTextField.autoPinEdge(.top, to: .bottom, of: dateLabel, withOffset: 8)
        timeTextField.autoPinEdge(toSuperviewEdge: .right)
        timeTextField.autoPinEdge(toSuperviewEdge: .left, withInset: datePanelWidthHalf)
        
        goutPanel.autoPinEdge(.top, to: .bottom, of: datePanel, withOffset: 4)
        goutPanel.autoPinEdge(toSuperviewEdge: .left, withInset: 15)
        goutPanel.autoPinEdge(toSuperviewEdge: .right, withInset: 15)
        goutPanel.autoSetDimension(.height, toSize: 55)
        
        goutPanel.addSubview(goutLabel)
        goutPanel.addSubview(goutTextField)
        
        goutLabel.autoPinEdge(toSuperviewEdge: .top)
        goutLabel.autoPinEdge(toSuperviewEdge: .left)
        goutLabel.autoPinEdge(toSuperviewEdge: .right)
        
        goutTextField.autoPinEdge(.top, to: .bottom, of: goutLabel, withOffset: 8)
        goutTextField.autoPinEdge(toSuperviewEdge: .left)
        goutTextField.autoPinEdge(toSuperviewEdge: .right)
        
        descPanel.autoPinEdge(.top, to: .bottom, of: goutPanel, withOffset: 4)
        descPanel.autoPinEdge(toSuperviewEdge: .left, withInset: 15)
        descPanel.autoPinEdge(toSuperviewEdge: .right, withInset: 15)
        descPanel.autoSetDimension(.height, toSize: 165)
        
        descPanel.addSubview(descLabel)
        descPanel.addSubview(descTextView)
        
        descLabel.autoPinEdge(toSuperviewEdge: .top)
        descLabel.autoPinEdge(toSuperviewEdge: .left)
        descLabel.autoPinEdge(toSuperviewEdge: .right)
        
        descTextView.autoPinEdge(.top, to: .bottom, of: descLabel, withOffset: 8)
        descTextView.autoPinEdge(toSuperviewEdge: .left)
        descTextView.autoPinEdge(toSuperviewEdge: .right)
        descTextView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 45)
        
        completeButton.autoPinEdge(toSuperviewEdge: .left, withInset: 15)
        completeButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 7)
        completeButton.autoSetDimension(.height, toSize: 30)
        completeButton.autoSetDimensions(to: CGSize(width: 127.5, height: 30))
        
        cancelButton.autoPinEdge(toSuperviewEdge: .right, withInset: 15)
        cancelButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 7)
        cancelButton.autoSetDimension(.height, toSize: 30)
        cancelButton.autoSetDimensions(to: CGSize(width: 127.5, height: 30))
        
        createDatePicker()
        createTimePicker()
        
        goutTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        kidneyTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    /**
     RXSwift 액션 설정
     */
    func setupRX() {
        
        cancelButton.rx.tap.bind {
            [weak self] _ in
            self?.addValueViewDelegate?.cancelGoutValue()
            self?.dismiss(animated: true)
            }.disposed(by: disposeBag)
        
        completeButton.rx.tap.bind {
            [weak self] _ in
            self?.saveGoutValue()
            }.disposed(by: disposeBag)
        
        goutTextField.rx.text.orEmpty
        .bind(to: addValueViewModel.goutValue)
        .disposed(by: disposeBag)
        
    }
    
    func rxAction() {
//        goutTextField.rx.tex
//        goutTextField.rx.observe(<#T##type: E.Type##E.Type#>, <#T##keyPath: String##String#>)
    }
    
    func createDatePicker(){
        
        let doneToolBar = UIToolbar()
        let doneBarButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(donePressed))
        doneToolBar.sizeToFit()
        doneToolBar.items = [doneBarButton]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "yyyy-MM-dd"
        
        let components = DateComponents()
        let maxDate = Calendar.current.date(byAdding: components, to: Date())
        var minDate = dateFormatter.date(from: "1900-01-01")
        var defaultDate = maxDate
        
        if reqView != "Add" {
            minDate = dateFormatter.date(from: "1900-01-01")
            defaultDate = Calendar.current.date(byAdding: components, to: DatetimeUtils.stringToyyyyMMdd(dateTextField.text!)!)
        } else {
            let today = dateFormatter.string(from: maxDate!)
            dateTextField.text = today
        }
        
        datePicker.date = defaultDate!
        datePicker.maximumDate = maxDate
        datePicker.minimumDate = minDate
        
        datePicker.datePickerMode = .date
        datePicker.timeZone = NSTimeZone.local
        
        dateTextField.inputAccessoryView = doneToolBar
        dateTextField.inputView = datePicker
        
        datePicker.addTarget(self, action: #selector(updateDate), for: .valueChanged)
    }
    
    func createTimePicker(){
        
        let doneToolBar = UIToolbar()
        let doneBarButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(donePressed))
        doneToolBar.sizeToFit()
        doneToolBar.items = [doneBarButton]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a h:mm"
        
        let components = DateComponents()
        var defaultDate = Calendar.current.date(byAdding: components, to: Date())
        
        if reqView != "Add" {
            defaultDate = Calendar.current.date(byAdding: components, to: DatetimeUtils.showDateHHmmmss(timeString: timeTextField.text!))
        } else {
            let today = dateFormatter.string(from: defaultDate!)
            timeTextField.text = today
        }
        
        timePicker.date = defaultDate!
        timePicker.datePickerMode = .time
        timePicker.timeZone = NSTimeZone.local
        
        timeTextField.inputAccessoryView = doneToolBar
        timeTextField.inputView = timePicker
        
        timePicker.addTarget(self, action: #selector(updateTime), for: .valueChanged)
    }
    
    @objc func donePressed(){
        view.endEditing(true)
    }
    
    /**
     DatePicker의 변화에 따른 자동으로 값 변경 처리
     */
    @objc func updateDate() {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateTextField.text = dateFormatter.string(from: datePicker.date)
    }
    
    /*
     TimePicker의 변화에 따른 자동으로 값 변경 처리
     */
    @objc func updateTime() {
        var timeFormat = "HH:mm"
        
        if DatetimeUtils.is12Hour() {
            timeFormat = "a h:mm"
        }
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = timeFormat
        timeTextField.text = dateFormatter.string(from: timePicker.date)
    }
    
    /**
     입력값 저장하기
     */
    func saveGoutValue() {
        
        dateTextField.resignFirstResponder()
        descTextView.resignFirstResponder()
        goutTextField.resignFirstResponder()
        
//        let hasGoutData = databaseManager.selectGoutId(date: dateTextField.text!)
        let hadGout = databaseManager.selectGoutIdToDatetime(date: dateTextField.text!, time: DatetimeUtils.convertAmPmToHHmm(time: timeTextField.text!))
        
        if hadGout > 0 {
            
            showAlert2("\(dateTextField.text!) \(timeTextField.text!)\n\(StringConstants.uricacidDataExistMSG) \n \(StringConstants.uricacidDataModifyMSG)",
                yes: StringConstants.yesBtn,
                no: StringConstants.noBtn,
                nextFunction: {() -> Void in
                    self.goutId = hadGout
                    self.saveGout()
                }, closeFunction: {})
            
//            if self.goutId > -1 {
//                showAlert2("\(dateTextField.text!) \(timeTextField.text!)\n\(StringConstants.uricacidDataExistMSG) \n \(StringConstants.uricacidDataModifyMSG)",
//                    yes: StringConstants.yesBtn,
//                    no: StringConstants.noBtn,
//                    nextFunction: self.saveGout, closeFunction: {})
//            } else {
//                showAlert2("\(dateTextField.text!) \(StringConstants.uricacidDataExistMSG) \n \(StringConstants.uricacidDataAddMSG)",
//                    yes: StringConstants.yesBtn,
//                    no: StringConstants.noBtn,
//                    nextFunction: {() -> Void in
//                        self.goutId = hasGoutData
//                        self.saveGout()
//                    }, closeFunction: {})
//            }
            
        } else {
            saveGout()
        }
    }
    
    /**
     요산 데이터 저장하기 액션
     */
    func saveGout() {
        var gout = goutTextField.text!
        
        //마지막에 .이 있는 경우 0 붙여주기 ex) 1. -> 1.0
        if gout.last == "." {
            gout.append("0")
        }
        
        //.이 포함되지 않은 경우 .0 붙여주기 ex) 1 -> 1.0
        if !gout.contains(".") {
            gout.append(".0")
        }
        
        let nowTime = DatetimeUtils.convertAmPmToHHmm(time: timeTextField.text!)
        
        var goutData:GoutData = GoutData.init(regDate: dateTextField.text!, gout: gout)
        goutData.id = self.goutId
        goutData.regTime = nowTime
        
        if descTextView.textColor == .placeholder {
            goutData.goutDesc = ""
        } else {
            goutData.goutDesc = descTextView.text
        }
        
        //요산 데이터 Upsert 요청
        if databaseManager.upsertGoutValue(goutData: goutData) {
            self.dismissView()
        }
    }
    
    func dismissView() {
        addValueViewDelegate!.successGoutValue()
        dismiss(animated: true)
    }
    
    /**
     요산 데이터 유효성 체크
     */
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        let value = textField.text!
        
        if value.isEmpty {
            return
        }
        
        //소수점이 두개 연속으로 들어가면 알림
        if value.contains("..") {
            textField.text = String(value.dropLast())
            self.showAlert(StringConstants.uricacidDotErrMSG, nextFunction: {})
            return
        }
        
        let valueArr = value.split(separator: ".")
        
        //소수점이 하나인가?
        if valueArr.count > 1 {
            //소수점이 하나 더 들어간경우
            if value.last == "." {
                textField.text = String(value.dropLast())
                self.showAlert(StringConstants.uricacidDotErrMSG, nextFunction: {})
            }
            
            //소수점 두자리인 경우
            if valueArr[1].count > 1 {
                //알림창 띄우기
                textField.text = String(value.dropLast())
                self.showAlert(StringConstants.uricacidDecimalErrMSG, nextFunction: {})
            }
        }
        
        let n = CGFloat(truncating: NumberFormatter().number(from: value)!)
        
        //범위 관리
        if n < Constants.minUricacid || Constants.maxUricacid < n {
            textField.text = ""
            self.showAlert(StringConstants.uricacidMinMaxRangeMSG, nextFunction: {})
        }
    }
}

extension AddValueViewController:UITextViewDelegate {
    
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
            textView.text = StringConstants.uricacidInfoDesc
            textView.textColor = .placeholder
        }
    }
}
