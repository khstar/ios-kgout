//
//  AddPharmAlarmViewController.swift
//  Gout
//
//  Created by khstar on 10/10/2018.
//  Copyright © 2018 khstar. All rights reserved.
//

import UIKit
import RxSwift

protocol AddDrugAlarmInfoDelegate {
    func addDrugAlarmInfo(drugInfo:DrugAlarmInfo, drugAlarmIndex:Int)
}

class AddDrugAlarmViewController: GoutDefaultViewController {
    
    let addButton = AddButton()
    let backButton = AddButton()
    var repeatWeek = RepeatWeek(allDay: false)
    var drugAlarmInfo:DrugAlarmInfo? = nil
    var drugAlarmIndex:Int = -1
    
    var addDrugAlarmDelegate:AddDrugAlarmInfoDelegate?
    
    lazy var datePicker:UIDatePicker! = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        
        return datePicker
    }()
    
    var snoozePicker = UIPickerView()
    var soundPicker = UIPickerView()
    
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
    
    lazy var saveAlarmBtn: UIButton! = {
        let button = UIButton()
        button.setTitle(StringConstants.saveBtn, for: .normal)
        button.backgroundColor = UIColor(0xAFDFE3)
        return button
    }()
    
    lazy var repeatPanel:UIView! = {
        let view = UIView()
        return view
    }()
    
    lazy var weekBtn:repeatButton! = {
        let button = repeatButton()
        button.setTitle("매일", for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 12)
        button.tag = WeekType.week.rawValue
        return button
    }()
    
    lazy var monBtn:repeatButton! = {
        let button = repeatButton()
        button.setTitle("월", for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 12)
        button.tag = WeekType.monday.rawValue
        return button
    }()
    lazy var tueBtn:repeatButton! = {
        let button = repeatButton()
        button.setTitle("화", for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 12)
        button.tag = WeekType.tuesday.rawValue
        return button
    }()
    lazy var wedBtn:repeatButton! = {
        let button = repeatButton()
        button.setTitle("수", for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 12)
        button.tag = WeekType.wednesday.rawValue
        return button
    }()
    lazy var thuBtn:repeatButton! = {
        let button = repeatButton()
        button.setTitle("목", for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 12)
        button.tag = WeekType.thursday.rawValue
        return button
    }()
    lazy var friBtn:repeatButton! = {
        let button = repeatButton()
        button.setTitle("금", for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 12)
        button.tag = WeekType.friday.rawValue
        return button
    }()
    lazy var satBtn:repeatButton! = {
        let button = repeatButton()
        button.setTitle("토", for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 12)
        button.tag = WeekType.saturday.rawValue
        return button
    }()
    lazy var sunBtn:repeatButton! = {
        let button = repeatButton()
        button.titleLabel!.font = UIFont.systemFont(ofSize: 12)
        button.setTitle("일", for: .normal)
        button.tag = WeekType.sunday.rawValue
        return button
    }()
    
    lazy var againAlarmPanel:UIView! = {
        let view = UIView()
        return view
    }()
    
    lazy var againAlarmSwith:DefaultSwitchView! = {
        let switchView = DefaultSwitchView()
        switchView.alarmSwitch.isOn = false
        switchView.titleLabel.text = "다시 알림"
        return switchView
    }()
    
    lazy var descPanel:UIView! = {
        let view = UIView()
        return view
    }()
    
    lazy var descLabel:UILabel! = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15.5, weight: .medium)
        label.textColor = .black
        label.text = "설        명 : "
//        label.text = "다시 알림 : "
        return label
    }()
    
    lazy var descTextField:UITextField! = {
//        let text = UITextField()
//        text.font = UIFont.systemFont(ofSize: 15, weight: .medium)
//        text.textColor = .black
        
        let field = UITextField()
        field.leftViewMode = .always
        field.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        field.textColor = UIColor(0x1c1c1c)
        field.tintColor = .clear
        
        let doneToolBar = UIToolbar()
        let doneBarButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(setDone))
        
        doneToolBar.sizeToFit()
        doneToolBar.items = [doneBarButton]
        field.inputAccessoryView = doneToolBar
        
        return field
    }()
    
    lazy var snoozePanel:UIView! = {
        let view = UIView()
        return view
    }()
    
    lazy var snoozeLabel:UILabel! = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15.5, weight: .medium)
        label.textColor = .black
        label.text = "다시 알림 : "
        return label
    }()
    
    lazy var snoozeTextField:UITextField! = {
        let field = UITextField()
        
        field.leftViewMode = .always
        field.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        field.textColor = UIColor(0x1c1c1c)
        field.text = "0분"
        
        return field
    }()
    
    lazy var soundPanel:UIView! = {
        let view = UIView()
        return view
    }()
    
    lazy var soundLabel:UILabel! = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15.5, weight: .medium)
        label.textColor = .black
        label.text = "사운드 : "
        return label
    }()
    
    lazy var soundNameTextField:UITextField! = {
        let field = UITextField()
        
        field.leftViewMode = .always
        field.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        field.textColor = UIColor(0x1c1c1c)
        field.text = "기본 사운드"
        
        return field
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        self.view.addSubview(naviBar)
        
        naviBar.autoPinEdge(toSuperviewEdge: .top, withInset: 20)
        naviBar.autoPinEdge(toSuperviewEdge: .left)
        naviBar.autoPinEdge(toSuperviewEdge: .right)
        naviBar.autoSetDimension(.height, toSize: 44)
        
        naviBar.title = "알람 등록"
//        naviBar.leftButton = backButton
//        naviBar.rightButton = addButton
        naviBar.rightButton = completeButton
        naviBar.leftButton = cancelButton
        
        self.view.addSubview(datePicker)
        datePicker.autoPinEdge(.top, to: .bottom, of: naviBar)
        datePicker.autoPinEdge(toSuperviewEdge: .left)
        datePicker.autoPinEdge(toSuperviewEdge: .right)
        
//        self.view.addSubview(saveAlarmBtn)
//        saveAlarmBtn.autoPinEdge(toSuperviewEdge: .bottom, withInset: 55)
//        saveAlarmBtn.autoPinEdge(toSuperviewEdge: .left, withInset: 15)
//        saveAlarmBtn.autoPinEdge(toSuperviewEdge: .right, withInset: 15)
//        saveAlarmBtn.autoSetDimension(.height, toSize: 55)
        
        self.view.addSubview(repeatPanel)
        repeatPanel.autoPinEdge(.top, to: .bottom, of: datePicker, withOffset: 15)
        repeatPanel.autoPinEdge(toSuperviewEdge: .left, withInset: 14.5)
        repeatPanel.autoPinEdge(toSuperviewEdge: .right, withInset: 14.5)
        repeatPanel.autoSetDimension(.height, toSize: 35)
        
        let line1 = UIView()
        
        self.view.addSubview(descPanel)
        
        descPanel.addSubview(descLabel)
        descPanel.addSubview(descTextField)
        
        descPanel.autoPinEdge(.top, to: .bottom, of: repeatPanel, withOffset: 5)
        descPanel.autoPinEdge(toSuperviewEdge: .left, withInset: 14.5)
        descPanel.autoPinEdge(toSuperviewEdge: .right, withInset: 14.5)
        descPanel.autoSetDimension(.height, toSize: 30)
        
        descLabel.autoPinEdge(toSuperviewEdge: .left)
        descLabel.autoPinEdge(toSuperviewEdge: .top)
        descLabel.autoPinEdge(toSuperviewEdge: .bottom)
        descLabel.autoSetDimension(.width, toSize: 80)
        
        descTextField.autoPinEdge(.left, to: .right, of: descLabel, withOffset: 5)
        descTextField.autoPinEdge(toSuperviewEdge: .top)
        descTextField.autoPinEdge(toSuperviewEdge: .bottom)
        descTextField.autoPinEdge(toSuperviewEdge: .right)
        
        self.view.addSubview(line1)
        line1.autoPinEdge(.top, to: .bottom, of: descPanel)
        line1.autoPinEdge(toSuperviewEdge: .left, withInset: 14.5)
        line1.autoPinEdge(toSuperviewEdge: .right, withInset: 14.5)
        line1.autoSetDimension(.height, toSize: 1)
        line1.backgroundColor = .gray
        
        self.view.addSubview(snoozePanel)
        
        snoozePanel.autoPinEdge(.top, to: .bottom, of: descPanel, withOffset: 5)
        snoozePanel.autoPinEdge(toSuperviewEdge: .left, withInset: 14.5)
        snoozePanel.autoPinEdge(toSuperviewEdge: .right, withInset: 14.5)
        snoozePanel.autoSetDimension(.height, toSize: 30)
        
//        snoozePanel.addSubview(snoozeLabel)
//        snoozePanel.addSubview(snoozeTextField)
//
//        snoozeLabel.autoPinEdge(toSuperviewEdge: .left)
//        snoozeLabel.autoPinEdge(toSuperviewEdge: .top)
//        snoozeLabel.autoPinEdge(toSuperviewEdge: .bottom)
//        snoozeLabel.autoSetDimension(.width, toSize: 80)
//
//        snoozeTextField.autoPinEdge(.left, to: .right, of: snoozeLabel, withOffset: 5)
//        snoozeTextField.autoPinEdge(toSuperviewEdge: .top)
//        snoozeTextField.autoPinEdge(toSuperviewEdge: .bottom)
//        snoozeTextField.autoPinEdge(toSuperviewEdge: .right)
//
//        let line2 = UIView()
//        self.view.addSubview(line2)
//        line2.autoPinEdge(.top, to: .bottom, of: snoozePanel)
//        line2.autoPinEdge(toSuperviewEdge: .left, withInset: 14.5)
//        line2.autoPinEdge(toSuperviewEdge: .right, withInset: 14.5)
//        line2.autoSetDimension(.height, toSize: 1)
//        line2.backgroundColor = .gray
        
        repeatPanel.addSubview(weekBtn)
        weekBtn.autoPinEdge(toSuperviewEdge: .top)
        weekBtn.autoPinEdge(toSuperviewEdge: .left)
        weekBtn.autoSetDimensions(to: CGSize(width: 30.0, height: 30.0))
        
        repeatPanel.addSubview(monBtn)
        monBtn.autoPinEdge(toSuperviewEdge: .top)
        monBtn.autoPinEdge(.left, to: .right, of: weekBtn, withOffset: 5)
        monBtn.autoSetDimensions(to: CGSize(width: 30.0, height: 30.0))
        
        repeatPanel.addSubview(tueBtn)
        tueBtn.autoPinEdge(toSuperviewEdge: .top)
        tueBtn.autoPinEdge(.left, to: .right, of: monBtn, withOffset: 5)
        tueBtn.autoSetDimensions(to: CGSize(width: 30.0, height: 30.0))
        
        repeatPanel.addSubview(wedBtn)
        wedBtn.autoPinEdge(toSuperviewEdge: .top)
        wedBtn.autoPinEdge(.left, to: .right, of: tueBtn, withOffset: 5)
        wedBtn.autoSetDimensions(to: CGSize(width: 30.0, height: 30.0))
        
        repeatPanel.addSubview(thuBtn)
        thuBtn.autoPinEdge(toSuperviewEdge: .top)
        thuBtn.autoPinEdge(.left, to: .right, of: wedBtn, withOffset: 5)
        thuBtn.autoSetDimensions(to: CGSize(width: 30.0, height: 30.0))
        
        repeatPanel.addSubview(friBtn)
        friBtn.autoPinEdge(toSuperviewEdge: .top)
        friBtn.autoPinEdge(.left, to: .right, of: thuBtn, withOffset: 5)
        friBtn.autoSetDimensions(to: CGSize(width: 30.0, height: 30.0))
        
        repeatPanel.addSubview(satBtn)
        satBtn.autoPinEdge(toSuperviewEdge: .top)
        satBtn.autoPinEdge(.left, to: .right, of: friBtn, withOffset: 5)
        satBtn.autoSetDimensions(to: CGSize(width: 30.0, height: 30.0))
        
        repeatPanel.addSubview(sunBtn)
        sunBtn.autoPinEdge(toSuperviewEdge: .top)
        sunBtn.autoPinEdge(.left, to: .right, of: satBtn, withOffset: 5)
        sunBtn.autoSetDimensions(to: CGSize(width: 30.0, height: 30.0))
        
        //버튼 액션 처리
//        addButton.rx.tap.bind {
//            [weak self] _ in
//            self?.dismissView()
//            }.disposed(by: disposeBag)
        
        cancelButton.rx.tap.bind {
            [weak self] _ in
            self?.dismissView()
            }.disposed(by: disposeBag)
        
        completeButton.rx.tap.bind {
            [weak self] _ in
            self?.saveAlarmInfo()
            }.disposed(by:disposeBag)
        
        setupWeekBtnEvent()
        createSnoozePicker()
        createSoundPicker()
        initSetData()
    }
    
    //초기 데이터 셋팅
    func initSetData() {
        //약 알람 정보가 nil이 아닌 경우 정보 셋팅
        if drugAlarmInfo != nil {
            let alarmTime = drugAlarmInfo?.alarmTime // change to your date format
            
            let dateFormatter = DateFormatter.init()
            dateFormatter.dateFormat = "HH:mm"
            
            let date = dateFormatter.date(from: alarmTime!)
            datePicker.setDate(date!, animated: true)
            
            weekAction(repeatBtnTag: WeekType.monday.rawValue, isSelect:  drugAlarmInfo!.week.monday)
            weekAction(repeatBtnTag: WeekType.tuesday.rawValue, isSelect:  drugAlarmInfo!.week.tuesday)
            weekAction(repeatBtnTag: WeekType.wednesday.rawValue, isSelect:  drugAlarmInfo!.week.wednesday)
            weekAction(repeatBtnTag: WeekType.thursday.rawValue, isSelect:  drugAlarmInfo!.week.thursday)
            weekAction(repeatBtnTag: WeekType.friday.rawValue, isSelect:  drugAlarmInfo!.week.friday)
            weekAction(repeatBtnTag: WeekType.saturday.rawValue, isSelect:  drugAlarmInfo!.week.saturday)
            weekAction(repeatBtnTag: WeekType.sunday.rawValue, isSelect:  drugAlarmInfo!.week.sunday)
            
            descTextField.text = drugAlarmInfo?.alarmDesc
            
        } else {
            drugAlarmInfo = DrugAlarmInfo()
        }
    }
    
    func setupWeekBtnEvent () {
        weekBtn.rx.tap.bind {
            [weak self] _ in
            self?.setWeekAllDay()
            }.disposed(by:disposeBag)

        monBtn.rx.tap.bind {
            [weak self] _ in
            self?.weekAction(repeatBtnTag: WeekType.monday.rawValue, isSelect: !self!.monBtn.isSelected)
            }.disposed(by: disposeBag)
        
        tueBtn.rx.tap.bind {
            [weak self] _ in
            self?.weekAction(repeatBtnTag: WeekType.tuesday.rawValue, isSelect: !self!.tueBtn.isSelected)
        }.disposed(by: disposeBag)

        wedBtn.rx.tap.bind {
            [weak self] _ in
            self?.weekAction(repeatBtnTag: WeekType.wednesday.rawValue, isSelect: !self!.wedBtn.isSelected)
        }.disposed(by: disposeBag)

        thuBtn.rx.tap.bind {
            [weak self] _ in
            self?.weekAction(repeatBtnTag: WeekType.thursday.rawValue, isSelect: !self!.thuBtn.isSelected)
        }.disposed(by: disposeBag)

        friBtn.rx.tap.bind {
            [weak self] _ in
            self?.weekAction(repeatBtnTag: WeekType.friday.rawValue, isSelect: !self!.friBtn.isSelected)
        }.disposed(by: disposeBag)

        satBtn.rx.tap.bind {
            [weak self] _ in
            self?.weekAction(repeatBtnTag: WeekType.saturday.rawValue, isSelect: !self!.satBtn.isSelected)
        }.disposed(by: disposeBag)

        sunBtn.rx.tap.bind {
            [weak self] _ in
            self?.weekAction(repeatBtnTag: WeekType.sunday.rawValue, isSelect: !self!.sunBtn.isSelected)
        }.disposed(by: disposeBag)
    }
    
    @objc func touchDown(sender:UIButton) {
        sender.backgroundColor = UIColor(0x97C1C4)
    }
    
    @objc func touchUp(sender:UIButton) {
        sender.backgroundColor = UIColor(0xAFDFE3)
    }
    
    func dismissView() {
        self.dismiss(animated: true)
    }
    
    func weekAction(repeatBtnTag:Int, isSelect:Bool) {
        switch repeatBtnTag {
        case WeekType.monday.rawValue:
            self.monBtn.isSelected = isSelect
            repeatWeek.monday = self.monBtn.isSelected
            
        case WeekType.tuesday.rawValue:
            self.tueBtn.isSelected = isSelect
            repeatWeek.tuesday = self.tueBtn.isSelected
            
        case WeekType.wednesday.rawValue:
            self.wedBtn.isSelected = isSelect
            repeatWeek.wednesday = self.wedBtn.isSelected
            
        case WeekType.thursday.rawValue:
            self.thuBtn.isSelected = isSelect
            repeatWeek.thursday = self.thuBtn.isSelected
            
        case WeekType.friday.rawValue:
            self.friBtn.isSelected = isSelect
            repeatWeek.friday = self.friBtn.isSelected
            
        case WeekType.saturday.rawValue:
            self.satBtn.isSelected = isSelect
            repeatWeek.saturday = self.satBtn.isSelected
            
        case WeekType.sunday.rawValue:
            self.sunBtn.isSelected = isSelect
            repeatWeek.sunday = self.sunBtn.isSelected
            
        default:
            print("error WeekType")
        }
        
        setRepeatAllDay()
    }
    
    @objc func setSnoozeDone() {
        snoozeTextField.resignFirstResponder()
    }
    
    /**
     항상/아님 을 설정
     */
    func setRepeatAllDay() {
        //모두 true인 경우
        if repeatWeek.monday &&
            repeatWeek.tuesday &&
            repeatWeek.wednesday &&
            repeatWeek.thursday &&
            repeatWeek.friday &&
            repeatWeek.saturday &&
            repeatWeek.sunday {
            
            self.weekBtn.isSelected = true
            
        } else {
            
            self.weekBtn.isSelected = false
        }
        
        repeatWeek.allDay = self.weekBtn.isSelected
    }
    
    func setWeekAllDay() {
        
        if !self.weekBtn.isSelected {
            self.weekBtn.isSelected = true
            self.monBtn.isSelected = true
            self.tueBtn.isSelected = true
            self.wedBtn.isSelected = true
            self.thuBtn.isSelected = true
            self.friBtn.isSelected = true
            self.satBtn.isSelected = true
            self.sunBtn.isSelected = true
            
        } else {
            self.weekBtn.isSelected = false
            self.monBtn.isSelected = false
            self.tueBtn.isSelected = false
            self.wedBtn.isSelected = false
            self.thuBtn.isSelected = false
            self.friBtn.isSelected = false
            self.satBtn.isSelected = false
            self.sunBtn.isSelected = false
        }
        
        repeatWeek.allDay = self.weekBtn.isSelected
        repeatWeek.monday = self.monBtn.isSelected
        repeatWeek.tuesday = self.tueBtn.isSelected
        repeatWeek.wednesday = self.wedBtn.isSelected
        repeatWeek.thursday = self.thuBtn.isSelected
        repeatWeek.friday = self.friBtn.isSelected
        repeatWeek.saturday = self.satBtn.isSelected
        repeatWeek.sunday = self.sunBtn.isSelected
        
    }
    
    func saveAlarmInfo() {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        let mySelectedDate: String = dateFormatter.string(from: datePicker.date)
        
        drugAlarmInfo!.alarmTime = mySelectedDate
        drugAlarmInfo!.week = repeatWeek
        drugAlarmInfo!.alarmDesc = descTextField.text!
        drugAlarmInfo!.enable = 1
        
        addDrugAlarmDelegate?.addDrugAlarmInfo(drugInfo: drugAlarmInfo!, drugAlarmIndex: drugAlarmIndex)
        
        self.dismiss(animated: true)
    }
    
    func createSnoozePicker(){
        
        let doneToolBar = UIToolbar()
        let doneBarButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(doneSnoozePressed))
        doneToolBar.sizeToFit()
        doneToolBar.items = [doneBarButton]
        
        snoozePicker.delegate = self
        snoozePicker.tag = 1
        
        snoozeTextField.inputAccessoryView = doneToolBar
        snoozeTextField.inputView = snoozePicker
    }
    
    func createSoundPicker(){
        
        let doneToolBar = UIToolbar()
        let doneBarButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(donePressed))
        doneToolBar.sizeToFit()
        doneToolBar.items = [doneBarButton]
        
        soundPicker.delegate = self
        soundPicker.tag = 2
        
        soundNameTextField.inputAccessoryView = doneToolBar
        soundNameTextField.inputView = soundPicker
    }
    
    @objc func doneSnoozePressed() {
        snoozeTextField.resignFirstResponder()
        let i = snoozePicker.selectedRow(inComponent: 0)
        
        snoozeTextField.text =  "\(Constants.snoozeTimeList[i]) 분"
        drugAlarmInfo?.snoozeTime = i
    }
    
    @objc func donePressed() {
        soundNameTextField.resignFirstResponder()
    }
    
    @objc func keyboardWillShow(_ sender:Notification) {
        self.view.frame.origin.y = -150
    }
    
    @objc func keyboardWillHide(_ sender:Notification) {
        self.view.frame.origin.y = 0
    }
    
    @objc func setDone() {
        self.descTextField.resignFirstResponder()
    }
}

extension AddDrugAlarmViewController:UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return Constants.snoozeTimeList.count
        } else if pickerView.tag == 2 {
            return Constants.soundList.count
        }
        
        return 0
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView.tag == 1 {
            return String(Constants.snoozeTimeList[row])
        } else if pickerView.tag == 2 {
            return String(Constants.soundList[row])
        }
        
        return "오류"
    }
}
