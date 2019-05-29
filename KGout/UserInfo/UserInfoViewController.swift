//
//  ViewController.swift
//  Gout
//
//  Created by khstar on 2018. 5. 23..
//  Copyright © 2018년 khstar. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PureLayout
import Charts

class UserInfoViewController: GoutDefaultViewController, UITextFieldDelegate {
    
    let datePicker = UIDatePicker()
    var btn = UIButton()
    var userInfo = UserInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRXView()
        setUserInfo()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
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
    
    lazy var userNamePanel:UIView! = {
        let view = UIView()
        return view
    }()
    
    lazy var userNameLabel:UILabel! = {
        let label = UILabel()
        label.text = "사용자 이름"
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor(0x7a7a7a)
        return label
    }()
    
    lazy var userNameTextField:UITextField! = {
        let field = UITextField()
        
        field.keyboardType = .default
        field.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        field.textColor = UIColor(0x1c1c1c)
        field.placeholder = "이름을 입력하세요."
        
        let doneToolBar = UIToolbar()
        let doneBarButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(setDone))
        
        doneToolBar.sizeToFit()
        doneToolBar.items = [doneBarButton]
        
        field.inputAccessoryView = doneToolBar
        
        return field
    }()
    
    lazy var line1View:UIView! = {
        let view = UIView()
        view.backgroundColor = .gray
        
        return view
    }()
    
    lazy var userBirthPanel:UIView! = {
        let view = UIView()
        return view
    }()
    
    lazy var userBirthLabel:UILabel! = {
        let label = UILabel()
        label.text = "생년월일"
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor(0x7a7a7a)
        return label
    }()
    
    lazy var userBirthTextField:UITextField! = {
        let field = UITextField()
        
        field.keyboardType = .decimalPad
        field.leftViewMode = .always
        field.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        field.textColor = UIColor(0x1c1c1c)
        field.placeholder = "1981-01-01"
        
        let doneToolBar = UIToolbar()
        let doneBarButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(setDone))
        
        doneToolBar.sizeToFit()
        doneToolBar.items = [doneBarButton]
        
        field.inputAccessoryView = doneToolBar
        
        return field
    }()
    
    lazy var userAgeLabel:UILabel! = {
        let label = UILabel()
        label.text = "나이"
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor(0x7a7a7a)
        return label
    }()
    
    lazy var userAgeTextField:UITextField! = {
        let field = UITextField()
        
        field.keyboardType = .default
        field.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        field.textColor = UIColor(0x1c1c1c)
        field.placeholder = "자동생성"
        field.isUserInteractionEnabled = false
        
        return field
    }()
    
    lazy var line2View:UIView! = {
        let view = UIView()
        view.backgroundColor = .gray
        
        return view
    }()
    
    lazy var userHeightPanel:UIView! = {
        let view = UIView()
        return view
    }()
    
    lazy var userHeightLabel:UILabel! = {
        let label = UILabel()
        label.text = "키(신장)"
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor(0x7a7a7a)
        return label
    }()
    
    lazy var userHeightTextField:UITextField! = {
        let field = UITextField()
        
        field.keyboardType = .decimalPad
        field.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        field.textColor = UIColor(0x1c1c1c)
        field.placeholder = "키(신장) 입력하세요."
        field.tag = 0
        let doneToolBar = UIToolbar()
        let doneBarButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(setDone))
        
        doneToolBar.sizeToFit()
        doneToolBar.items = [doneBarButton]
        
        field.inputAccessoryView = doneToolBar
        
        return field
    }()
    
    lazy var userWeightLabel:UILabel! = {
        let label = UILabel()
        label.text = "몸무게"
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor(0x7a7a7a)
        return label
    }()
    
    lazy var userWeightTextField:UITextField! = {
        let field = UITextField()
        
        field.keyboardType = .decimalPad
        field.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        field.textColor = UIColor(0x1c1c1c)
        field.placeholder = "몸무게 입력하세요."
        field.tag = 1
        let doneToolBar = UIToolbar()
        let doneBarButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(setDone))
        
        doneToolBar.sizeToFit()
        doneToolBar.items = [doneBarButton]
        
        field.inputAccessoryView = doneToolBar
        
        return field
    }()
    
    lazy var line3View:UIView! = {
        let view = UIView()
        view.backgroundColor = .gray
        
        return view
    }()
    
    lazy var userBMIPanel:UIView! = {
        let view = UIView()
        return view
    }()
    
    lazy var userBMILabel:UILabel! = {
        let label = UILabel()
        label.text = "BMI"
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor(0x7a7a7a)
        return label
    }()
    
    lazy var userBMITextField:UITextField! = {
        let field = UITextField()

        field.isEnabled = false
        field.isUserInteractionEnabled = false
        field.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        field.textColor = UIColor(0x1c1c1c)
        field.placeholder = "자동 생성"
        
        return field
    }()
    
    lazy var userObesityLabel:UILabel! = {
        let label = UILabel()
        label.text = "비만도"
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor(0x7a7a7a)
        return label
    }()
    
    lazy var userObesityTextField:UITextField! = {
        let field = UITextField()
        
        field.isUserInteractionEnabled = false
        field.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        field.textColor = UIColor(0x1c1c1c)
        field.placeholder = "자동 생성"
        
        return field
    }()
    
    lazy var line4View:UIView! = {
        let view = UIView()
        view.backgroundColor = .gray
        
        return view
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    lazy var graphPanel:UIView! = {
        let view = UIView()
        return view
    }()
    
    
    lazy var resetAlarmButton: UIButton! = {
        let button = UIButton()
        button.setTitle("알람 리셋", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        button.setTitleColor(.black, for: .normal)
        
        button.backgroundColor = UIColor(0xAFDFE3)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 8
        
        button.addTarget(self, action: #selector(touchDown), for: .touchDown)
        button.addTarget(self, action: #selector(touchUp), for: [.touchUpInside, .touchUpOutside, .touchDragExit])
        
        return button
    }()
    
    func setupRXView() {
        
        self.view.addSubview(naviBar)
        
        naviBar.autoPinEdge(toSuperviewEdge: .top, withInset: Constants.statusHeight())
        naviBar.autoPinEdge(toSuperviewEdge: .left)
        naviBar.autoPinEdge(toSuperviewEdge: .right)
        naviBar.autoSetDimension(.height, toSize: 44)
        
        naviBar.title = "정보"
        naviBar.rightButton = completeButton
        
        self.view.addSubview(userNamePanel)
        
        userNamePanel.autoPinEdge(.top, to: .bottom, of: naviBar, withOffset: 5)
        userNamePanel.autoPinEdge(toSuperviewEdge: .left, withInset: 15)
        userNamePanel.autoPinEdge(toSuperviewEdge: .right, withInset: 15)
        userNamePanel.autoSetDimension(.height, toSize: 55)
        
        userNamePanel.addSubview(userNameLabel)
        userNamePanel.addSubview(userNameTextField)
        userNamePanel.addSubview(line1View)
        
        userNameLabel.autoPinEdge(toSuperviewEdge: .top)
        userNameLabel.autoPinEdge(toSuperviewEdge: .left)
        userNameLabel.autoPinEdge(toSuperviewEdge: .right)
        
        userNameTextField.autoPinEdge(.top, to: .bottom, of: userNameLabel, withOffset: 8)
        userNameTextField.autoPinEdge(toSuperviewEdge: .left)
        userNameTextField.autoPinEdge(toSuperviewEdge: .right)
        
        line1View.autoPinEdge(toSuperviewEdge: .left)
        line1View.autoPinEdge(toSuperviewEdge: .right)
        line1View.autoPinEdge(toSuperviewEdge: .bottom)
        line1View.autoSetDimension(.height, toSize: 0.5)
        
        let userWidth = (screenWidth - 15 - 15 - 5) / 2
        
        self.view.addSubview(userBirthPanel)
        userBirthPanel.autoPinEdge(.top, to: .bottom, of: userNamePanel, withOffset: 5)
        userBirthPanel.autoPinEdge(toSuperviewEdge: .left, withInset: 15)
        userBirthPanel.autoPinEdge(toSuperviewEdge: .right, withInset: 15)
        userBirthPanel.autoSetDimension(.height, toSize: 55)
        
        userBirthPanel.addSubview(userBirthLabel)
        userBirthPanel.addSubview(userBirthTextField)
        userBirthPanel.addSubview(userAgeLabel)
        userBirthPanel.addSubview(userAgeTextField)
        userBirthPanel.addSubview(line2View)
        
        userBirthLabel.autoPinEdge(toSuperviewEdge: .top)
        userBirthLabel.autoPinEdge(toSuperviewEdge: .left)
        userBirthLabel.autoSetDimension(.width, toSize: userWidth)
        
        userBirthTextField.autoPinEdge(.top, to: .bottom, of: userBirthLabel, withOffset: 8)
        userBirthTextField.autoPinEdge(toSuperviewEdge: .left)
        userBirthTextField.autoSetDimension(.width, toSize: userWidth)
        
        userAgeLabel.autoPinEdge(toSuperviewEdge: .top)
        userAgeLabel.autoPinEdge(toSuperviewEdge: .right)
        userAgeLabel.autoSetDimension(.width, toSize: userWidth)
        
        userAgeTextField.autoPinEdge(.top, to: .bottom, of: userBirthLabel, withOffset: 8)
        userAgeTextField.autoPinEdge(toSuperviewEdge: .right)
        userAgeTextField.autoSetDimension(.width, toSize: userWidth)
        
        line2View.autoPinEdge(toSuperviewEdge: .left)
        line2View.autoPinEdge(toSuperviewEdge: .right)
        line2View.autoPinEdge(toSuperviewEdge: .bottom)
        line2View.autoSetDimension(.height, toSize: 0.5)
        
        //
        self.view.addSubview(userHeightPanel)
        userHeightPanel.autoPinEdge(.top, to: .bottom, of: userBirthPanel, withOffset: 5)
        userHeightPanel.autoPinEdge(toSuperviewEdge: .left, withInset: 15)
        userHeightPanel.autoPinEdge(toSuperviewEdge: .right, withInset: 15)
        userHeightPanel.autoSetDimension(.height, toSize: 55)
        
        userHeightPanel.addSubview(userHeightLabel)
        userHeightPanel.addSubview(userHeightTextField)
        userHeightPanel.addSubview(userWeightLabel)
        userHeightPanel.addSubview(userWeightTextField)
        userHeightPanel.addSubview(line3View)
        
        userHeightLabel.autoPinEdge(toSuperviewEdge: .top)
        userHeightLabel.autoPinEdge(toSuperviewEdge: .left)
        userHeightLabel.autoSetDimension(.width, toSize: userWidth)
        
        userHeightTextField.autoPinEdge(.top, to: .bottom, of: userHeightLabel, withOffset: 8)
        userHeightTextField.autoPinEdge(toSuperviewEdge: .left)
        userHeightTextField.autoSetDimension(.width, toSize: userWidth)
        userHeightTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        userWeightLabel.autoPinEdge(toSuperviewEdge: .top)
        userWeightLabel.autoPinEdge(toSuperviewEdge: .right)
        userWeightLabel.autoSetDimension(.width, toSize: userWidth)
        
        userWeightTextField.autoPinEdge(.top, to: .bottom, of: userHeightLabel, withOffset: 8)
        userWeightTextField.autoPinEdge(toSuperviewEdge: .right)
        userWeightTextField.autoSetDimension(.width, toSize: userWidth)
        userWeightTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        line3View.autoPinEdge(toSuperviewEdge: .left)
        line3View.autoPinEdge(toSuperviewEdge: .right)
        line3View.autoPinEdge(toSuperviewEdge: .bottom)
        line3View.autoSetDimension(.height, toSize: 0.5)
        
        self.view.addSubview(userBMIPanel)
        userBMIPanel.autoPinEdge(.top, to: .bottom, of: userHeightPanel, withOffset: 5)
        userBMIPanel.autoPinEdge(toSuperviewEdge: .left, withInset: 15)
        userBMIPanel.autoPinEdge(toSuperviewEdge: .right, withInset: 15)
        userBMIPanel.autoSetDimension(.height, toSize: 55)
        
        userBMIPanel.addSubview(userBMILabel)
        userBMIPanel.addSubview(userBMITextField)
        userBMIPanel.addSubview(userObesityLabel)
        userBMIPanel.addSubview(userObesityTextField)
        userBMIPanel.addSubview(line4View)
        
        userBMILabel.autoPinEdge(toSuperviewEdge: .top)
        userBMILabel.autoPinEdge(toSuperviewEdge: .left)
        userBMILabel.autoSetDimension(.width, toSize: userWidth)
        
        userBMITextField.autoPinEdge(.top, to: .bottom, of: userBMILabel, withOffset: 8)
        userBMITextField.autoPinEdge(toSuperviewEdge: .left)
        userBMITextField.autoSetDimension(.width, toSize: userWidth)
        
        userObesityLabel.autoPinEdge(toSuperviewEdge: .top)
        userObesityLabel.autoPinEdge(toSuperviewEdge: .right)
        userObesityLabel.autoSetDimension(.width, toSize: userWidth)
        
        userObesityTextField.autoPinEdge(.top, to: .bottom, of: userBMILabel, withOffset: 8)
        userObesityTextField.autoPinEdge(toSuperviewEdge: .right)
        userObesityTextField.autoSetDimension(.width, toSize: userWidth)
        
        line4View.autoPinEdge(toSuperviewEdge: .left)
        line4View.autoPinEdge(toSuperviewEdge: .right)
        line4View.autoPinEdge(toSuperviewEdge: .bottom)
        line4View.autoSetDimension(.height, toSize: 0.5)
        
        
        self.view.addSubview(resetAlarmButton)
        resetAlarmButton.autoPinEdge(.top, to: .bottom, of: userBMIPanel, withOffset: 10)
        resetAlarmButton.autoPinEdge(toSuperviewEdge: .left, withInset: 15)
        resetAlarmButton.autoPinEdge(toSuperviewEdge: .right, withInset: 15)
        resetAlarmButton.autoSetDimension(.height, toSize: 30)
        
        userBMITextField.rx.tapGesture().when(.recognized).bind{
            [weak self] _ in
            self?.showBMIAlert()
            }.disposed(by: disposeBag)
        
        completeButton.rx.tap.bind {
            [weak self] _ in
            self?.saveUserInfo()
        }.disposed(by: disposeBag)
        
        resetAlarmButton.rx.tap.bind {
            [weak self] _ in
            self?.resetDrugAlarm()
        }.disposed(by: disposeBag)
    }
    
    @objc func touchDown(sender:UIButton) {
        sender.backgroundColor = UIColor(0x97C1C4)
    }
    
    @objc func touchUp(sender:UIButton) {
        sender.backgroundColor = UIColor(0xAFDFE3)
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
        let minDate = dateFormatter.date(from: "1900-01-01")
        
        var defaultDateStr = "1981-01-01"
        if !userBirthTextField.text!.isEmpty {
            defaultDateStr = userBirthTextField.text!
        }
        
        let defaultDate = dateFormatter.date(from: defaultDateStr)
            
        datePicker.date = defaultDate!
        datePicker.maximumDate = maxDate
        datePicker.minimumDate = minDate
        
        datePicker.datePickerMode = .date
        datePicker.timeZone = NSTimeZone.local
        
        userBirthTextField.inputAccessoryView = doneToolBar
        userBirthTextField.inputView = datePicker
        
        datePicker.addTarget(self, action: #selector(updateDate), for: .valueChanged)
    }
    
    @objc func donePressed() {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let userBirthDay = dateFormatter.string(from: datePicker.date)
        userBirthTextField.text = userBirthDay
        
       let age = DatetimeUtils.getUserAge(birth: userBirthDay)
        
        userAgeTextField.text = "\(age)"
        
        userBirthTextField.resignFirstResponder()
    }
    
    @objc func updateDate() {
        
    }
    
    func showBMIAlert() {
        self.showAlertAll(title: Bundle.main.displayName!, "키와 몸무게를 입력하면 자동으로 생성됩니다.", nextFunction: {})
    }
    
    @objc func setDone() {
        
        textFieldResign()
        self.setBMI()
    }
    
    func textFieldResign() {
        userNameTextField.resignFirstResponder()
        userBirthTextField.resignFirstResponder()
        userWeightTextField.resignFirstResponder()
        userHeightTextField.resignFirstResponder()
    }
    
    func setBMI() {
        if !userWeightTextField.text!.isEmpty &&
            !userHeightTextField.text!.isEmpty {
            let userWeight = CGFloat(truncating: NumberFormatter().number(from: userWeightTextField.text!)!)
            let userHeight = CGFloat(truncating: NumberFormatter().number(from: userHeightTextField.text!)!)
            
            if userWeight > 0 && userHeight > 0 {
                let bmiHeight = userHeight * 0.01
                let bmi = userWeight / (bmiHeight * bmiHeight)
                userBMITextField.text = String(format: "%.1f", bmi)
                
                if bmi < 18.5 {
                    userObesityTextField.text = "저체중"
                } else if bmi < 23 {
                    userObesityTextField.text = "정상"
                } else if bmi < 25 {
                    userObesityTextField.text = "과체중"
                } else if bmi < 30 {
                    userObesityTextField.text = "비만"
                } else {
                    userObesityTextField.text = "고도비만"
                }
            }
        } else {
            userBMITextField.text = ""
            userObesityTextField.text = ""
        }
    }

    @IBAction func insertGout(_ sender: Any) {
//        let database = DatabaseManager.init(password: "khstar")
        let datebase = DatabaseManager.sharedInstance()
//        datebase.insertGoutValue()
        
    }
    @IBAction func writeDB(_ sender: Any) {
        print("wirteDBAction")
        
//        let database = DatabaseManager.init(password: "khstar")
//
//        database.createDatabase()
        
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        let value = textField.text!
        
        if value.isEmpty {
            return
        }
        
        //소수점이 두개 연속으로 들어가면 알림
        if value.contains("..") {
            textField.text = String(value.dropLast())
            self.showAlert(".이 두 개 들어갈수 없습니다.", nextFunction: {})
            return
        }
        
        let valueArr = value.split(separator: ".")
        
        //소수점이 하나인가?
        if valueArr.count > 1 {
            //소수점이 하나 더 들어간경우
            if value.last == "." {
                textField.text = String(value.dropLast())
                self.showAlert(".이 두 개 들어갈수 없습니다.", nextFunction: {})
            }
            
            //소수점 두자리인 경우
            if valueArr[1].count > 1 {
                //알림창 띄우기
                textField.text = String(value.dropLast())
                self.showAlert("소수점 두자리 까지 입력할 수 있습니다.", nextFunction: {})
            }
        }
        
    }
    
    func saveUserInfo() {
        
        self.textFieldResign()
        
        //몸무게 데이터가 있는 경우 데이터 범위 검사
        if !userWeightTextField.text!.isEmpty {
            let weight = Float(userWeightTextField.text!)
            if weight! < 30 || weight! > 200 {
                showAlertAll(title: Bundle.main.displayName!, "몸무게 입력 범위가 맞습니까?", nextFunction: {})
                return
            }
        }
        
        //키(신장) 데이터가 있는 경우 데이터 범위 검사
        if !userHeightTextField.text!.isEmpty {
            let height = Float(userHeightTextField.text!)
            if height! < 100 || height! > 250 {
                showAlertAll(title: Bundle.main.displayName!, "키(신장) 입력 범위가 맞습니까?", nextFunction: {})
                return
            }
        }
        
        self.setBMI()
        
        self.userInfo.userName       = userNameTextField.text!
        self.userInfo.userBirthDay   = userBirthTextField.text!
        self.userInfo.userAge        = userAgeTextField.text!
        self.userInfo.userWeight     = userWeightTextField.text!
        self.userInfo.userHeight     = userHeightTextField.text!
        
        let result = DatabaseManager.sharedInstance().upsertUserInfo(userInfo: userInfo)
        
        if result {
            showAlert("사용자 정보가 저장되었습니다.", nextFunction: {})
            
            setUserInfo()
        }
    }
    
    func setUserInfo() {
        if let userInfo = DatabaseManager.sharedInstance().selectUserInfo() {
            self.userInfo = userInfo
            
            userNameTextField.text      = userInfo.userName
            userBirthTextField.text     = userInfo.userBirthDay
            userAgeTextField.text       = userInfo.userAge
            userHeightTextField.text    = userInfo.userHeight
            userWeightTextField.text    = userInfo.userWeight
            
            self.setBMI()
        }
        
        createDatePicker()
    }
    
    /**
     모든 알람 재 설정
    */
    func resetDrugAlarm() {
        let pushManager = LocalPushManager.sharedInstance()
        
        guard let drugInfoAll:[DrugInfo] = DatabaseManager.sharedInstance().selectDrugInfoList() else {
            return
        }
        
        pushManager.removeAlarmAll()
        
        for drugInfo in drugInfoAll {
            pushManager.setDrugAlarm(drugInfo: drugInfo)
        }
        
//        self.showAlert2("알람이 재설정 되었습니다.")
        self.showAlert("알람이 재설정 되었습니다.", nextFunction: {})
        
    }
    
}

