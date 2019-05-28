//
//  GoutChartViewController.swift
//  Chart 프레임워크를 이용해 Chart 구현을 위한 ViewCtrl
//  Gout
//
//  Created by khstar on 2018. 8. 30..
//  Copyright © 2018년 khstar. All rights reserved.
//

import UIKit
import Charts
import RxSwift
import RxCocoa
import PureLayout

class GoutChartViewController: BaseChartViewController {
    
    let addButton = AddButton()
    let delButton = AddButton()
    
    let datePicker = UIDatePicker()
    let viewTypePicker = UIPickerView()
    let monthPick = UIPickerView()
    
    var months = ["1"]
    
    ///CollCell이 보여질 때 이전 값을 체크하기 위한
    var showViewIndexRow:Int = 0
    ///CollCell이 사라질 때 이전 값을 체크하기 위한
    var hiddenViewIndexRow:Int = 0
    var isInit:Bool = false
    var dateList:[String] = []
    
    var selectPickerRow:Int = 0
    var selectViewTypeRow:Int = 0
    
    var isRefrash:Bool = false
    var isDeleteMode:Bool = false
    
    var viewTypeList = ["전체","년도별","월별"]
    
    lazy var addUricButton: UIButton! = {
        let button = UIButton()
        button.setTitle("추가", for: .normal)
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
        button.setTitle("완료", for: .normal)
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
        button.setTitle("취소", for: .normal)
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
    
    @objc func touchDown(sender:UIButton) {
        sender.backgroundColor = UIColor(0x97C1C4)
    }
    
    @objc func touchUp(sender:UIButton) {
        sender.backgroundColor = UIColor(0xAFDFE3)
    }
    
    lazy var deleteButton: UIButton! = {
        let button = UIButton()
        button.setTitle("삭제", for: .normal)
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
    
    var chartView:LineChartView = LineChartView()
    
    lazy var topPanel:UIView! = {
        let view = UIView()
        view.backgroundColor = UIColor(0xfafafa)
        return view
    }()
    
    var uricacidDatas: [GoutData] = [] {
        didSet{
            uricacidCollectionView.reloadData()
            updateChartData()
            var yearMonth = Array<String>()
            
            for i in 0..<uricacidDatas.count {
                
                let subStr = uricacidDatas[i].regDate.split(separator: "-")
                yearMonth.append("\(subStr[0])\n\(subStr[1])-\(subStr[2])")
                months = yearMonth
            }
            
            if uricacidDatas.count < 7 || !isInit || isRefrash {
                chartDid()
            }
            
            isRefrash = false
            isInit = true
        }
    }
    
    var delUricacid:[Int:GoutData] = [:]
    
    lazy var dateLabel:UILabel! = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = UIColor(0x1c1c1c)
        label.text = ""
        return label
    }()
    
    lazy var dateTextField:UITextField! = {
        let field = UITextField()
        field.leftViewMode = .always
        field.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        field.textColor = UIColor(0x1c1c1c)
        field.tintColor = .clear
        
        let doneToolBar = UIToolbar()
        let doneBarButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(setDateDone))
        
        doneToolBar.sizeToFit()
        doneToolBar.items = [doneBarButton]
        field.inputAccessoryView = doneToolBar
        
        return field
    }()
    
    lazy var viewTypeLabel:UILabel! = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = UIColor(0x1c1c1c)
        label.text = "전체"
        return label
    }()
    
    lazy var viewTypeTextField:UITextField! = {
        let field = UITextField()
        field.leftViewMode = .always
        field.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        field.textColor = UIColor(0x1c1c1c)
        field.tintColor = .clear
        
        let doneToolBar = UIToolbar()
        let doneBarButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(setViewTypeDone))
        
        doneToolBar.sizeToFit()
        doneToolBar.items = [doneBarButton]
        field.inputAccessoryView = doneToolBar
        
        return field
    }()
    
    lazy var uricacidCollectionView: UICollectionView! = {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        collectionView.backgroundColor = .white
        collectionView.register(EmptyCell.self, forCellWithReuseIdentifier: EmptyCell.className)
        collectionView.register(UricacidCollectionViewCell.self, forCellWithReuseIdentifier: UricacidCollectionViewCell.className)
        collectionView.register(DeleteUricacidViewCell.self, forCellWithReuseIdentifier: DeleteUricacidViewCell.className)
        
        collectionView.bounces = false
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        DatabaseManager.sharedInstance().selectGoutVaule(date: "test")
        setupRXView()
        fetchData()
        
        var test  = NSLocalizedString("Hello", comment: "하이")
        print(test)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //viewType, 년월 선택 Picker 판낼
    lazy var pickerPanel:UIView! = {
        let view = UIView()
        return view
    }()

    let viewTypePickerIcon = PickerIconButton()
    
    //picker판낼의 내부 컨텐츠를 위한 첫번째 판낼
    lazy var firstPanel:UIView! = {
        let view = UIView()
        return view
    }()
    
    lazy var viewTypePanel:UIView! = {
        let view = UIView()
        return view
    }()

    
    
    
    let datePickerIcon = PickerIconButton()
    
    //picker판낼의 내부 컨텐츠를 위한 두번째 판낼
    lazy var secondPanel:UIView! = {
        let view = UIView()
        return view
    }()
    
    ///년, 월 선택 판낼
    lazy var selectMonthPanel:UIView! = {
        let view = UIView()
        return view
    }()
    
    lazy var viewTypePickerBtn:UIButton! = {
        let btn = UIButton()
        return btn
    }()
    
    lazy var datePickerBtn:UIButton! = {
        let btn = UIButton()
        return btn
    }()
    
    ///데이터가 없는 경우 표시할 Panel
    lazy var emptyPanel:UIView! = {
        let view = UIView()
        let label = UILabel()
        
        view.addSubview(label)
        label.autoCenterInSuperview()
        label.text = "데이터가 없습니다."
        
        return view
    }()
    
    func setupRXView() {
        
        #if DEBUG
            print("debug")
        #else
            print("else")
        #endif
            print("release")
        
        self.view.addSubview(naviBar)
        
        naviBar.autoPinEdge(toSuperviewEdge: .top, withInset: Constants.statusHeight())
        naviBar.autoPinEdge(toSuperviewEdge: .left)
        naviBar.autoPinEdge(toSuperviewEdge: .right)
        naviBar.autoSetDimension(.height, toSize: 44)
        
        naviBar.title = "요산 관리"
        naviBar.rightButton = addUricButton
        naviBar.leftButton = deleteButton
        
        let viewTypeTextFieldWidth = Utils.widthOfString("가나다", font: viewTypeLabel.font!) + 8
        
        self.view.addSubview(firstPanel)
        firstPanel.autoPinEdge(.top, to: .bottom, of: naviBar)
        firstPanel.autoPinEdge(toSuperviewEdge: .left)
        firstPanel.autoSetDimensions(to: CGSize(width: screenWidth/2, height: 40))
        
        firstPanel.addSubview(viewTypePanel)
        
        viewTypePanel.autoPinEdge(toSuperviewEdge: .top)
        viewTypePanel.autoSetDimensions(to: CGSize(width: viewTypeTextFieldWidth + 5 + 20, height: 40))
        viewTypePanel.autoAlignAxis(toSuperviewAxis: .vertical)
        
        viewTypePanel.addSubview(viewTypeTextField)
        viewTypePanel.addSubview(viewTypeLabel)
        viewTypePanel.addSubview(viewTypePickerIcon)
        viewTypePanel.addSubview(viewTypePickerBtn)
        
        
        viewTypeTextField.autoPinEdge(toSuperviewEdge: .top)
        viewTypeTextField.autoPinEdge(toSuperviewEdge: .left)
        viewTypeTextField.autoPinEdge(toSuperviewEdge: .bottom)
        viewTypeTextField.autoSetDimension(.width, toSize: viewTypeTextFieldWidth)
        
        viewTypeLabel.autoPinEdge(toSuperviewEdge: .top)
        viewTypeLabel.autoPinEdge(toSuperviewEdge: .left)
        viewTypeLabel.autoPinEdge(toSuperviewEdge: .bottom)
        viewTypeLabel.autoSetDimension(.width, toSize: viewTypeTextFieldWidth)
        
        viewTypePickerIcon.autoPinEdge(.left, to: .right, of: viewTypeTextField, withOffset: 5)
        viewTypePickerIcon.autoSetDimensions(to: CGSize(width: 20, height: 20))
        viewTypePickerIcon.autoAlignAxis(toSuperviewAxis: .horizontal)
        
        viewTypePickerBtn.autoPinEdgesToSuperviewEdges()
        
        let dateTextFieldWidth = Utils.widthOfString("2018-11", font: dateLabel.font!) + 8
        
        self.view.addSubview(secondPanel)
        secondPanel.autoPinEdge(.top, to: .bottom, of: naviBar)
        secondPanel.autoPinEdge(toSuperviewEdge: .right)
        secondPanel.autoSetDimensions(to: CGSize(width: screenWidth/2, height: 40))
        
        secondPanel.addSubview(selectMonthPanel)
        
        selectMonthPanel.autoPinEdge(toSuperviewEdge: .top)
        selectMonthPanel.autoSetDimensions(to: CGSize(width: dateTextFieldWidth + 5 + 20, height: 40))
        selectMonthPanel.autoAlignAxis(toSuperviewAxis: .vertical)
        
        selectMonthPanel.addSubview(dateTextField)
        selectMonthPanel.addSubview(dateLabel)
        selectMonthPanel.addSubview(datePickerIcon)
        selectMonthPanel.addSubview(datePickerBtn)
        
        dateTextField.autoPinEdge(toSuperviewEdge: .top)
        dateTextField.autoPinEdge(toSuperviewEdge: .left)
        dateTextField.autoPinEdge(toSuperviewEdge: .bottom)
        dateTextField.autoSetDimension(.width, toSize: dateTextFieldWidth)
        
        dateLabel.autoPinEdge(toSuperviewEdge: .top)
        dateLabel.autoPinEdge(toSuperviewEdge: .left)
        dateLabel.autoPinEdge(toSuperviewEdge: .bottom)
        dateLabel.autoSetDimension(.width, toSize: dateTextFieldWidth)
        
        datePickerIcon.autoPinEdge(.left, to: .right, of: dateTextField, withOffset: 5)
        datePickerIcon.autoSetDimensions(to: CGSize(width: 20, height: 20))
        datePickerIcon.autoAlignAxis(toSuperviewAxis: .horizontal)
        
        datePickerBtn.autoPinEdgesToSuperviewEdges()
        
        self.view.addSubview(chartView)
        self.view.addSubview(uricacidCollectionView)
        
        chartView.autoPinEdge(.top, to: .bottom, of: selectMonthPanel)
        chartView.autoPinEdge(toSuperviewEdge: .left)
        chartView.autoPinEdge(toSuperviewEdge: .right)
        chartView.autoSetDimension(.height, toSize: 150)
        
        uricacidCollectionView.autoPinEdge(.top, to: .bottom, of: chartView)
        uricacidCollectionView.autoPinEdge(toSuperviewEdge: .left)
        uricacidCollectionView.autoPinEdge(toSuperviewEdge: .right)
        uricacidCollectionView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 53 + Constants.bottomHeight() + 50)
        
        addUricButton.rx.tap.bind {
            [weak self] _ in
            self?.nextAddViewCtrl()
            }.disposed(by: disposeBag)
        
        deleteButton.rx.tap.bind {
            [weak self] _ in
            self?.setDeleteMode()
            }.disposed(by:disposeBag)
        
        cancelButton.rx.tap.bind {
            [weak self] _ in
            self?.setDeleteMode()
            }.disposed(by:disposeBag)
        
        viewTypePickerBtn.addTarget(self, action: #selector(viewTypePickerBtnHighlight), for: [.touchDown])
        viewTypePickerBtn.addTarget(self, action: #selector(showViewTypePicker), for: [.touchUpInside])
        viewTypePickerBtn.addTarget(self, action: #selector(viewTypePickerBtnNormal), for: [.touchDragExit, .touchUpOutside, .touchCancel])
        
        datePickerBtn.addTarget(self, action: #selector(datePickerBtnHighlight), for: [.touchDown])
        datePickerBtn.addTarget(self, action: #selector(showDataPicker), for: [.touchUpInside])
        datePickerBtn.addTarget(self, action: #selector(datePickerBtnNormal), for: [.touchDragExit, .touchUpOutside, .touchCancel])
        
        chartDid()
    }
    
    
    @objc func datePickerBtnHighlight() {
        self.datePickerIcon.isHighlighted = true
    }
    
    @objc func showDataPicker() {
        self.datePickerIcon.isHighlighted = false
        dateTextField.becomeFirstResponder()
    }
    
    @objc func datePickerBtnNormal() {
        self.datePickerIcon.isHighlighted = false
    }
    
    
    @objc func viewTypePickerBtnHighlight() {
        self.viewTypePickerIcon.isHighlighted = true
    }
    
    @objc func showViewTypePicker() {
        self.viewTypePickerIcon.isHighlighted = false
        viewTypeTextField.becomeFirstResponder()
    }
    
    @objc func viewTypePickerBtnNormal() {
        self.viewTypePickerIcon.isHighlighted = false
    }
    
    func setDeleteMode() {
        
        //데이터가 0인데 삭제 버튼을 누른 경우
        if uricacidDatas.count == 0 {
            showAlertAll(title: "통풍 캐어", "삭제 할 데이터가 없습니다.", nextFunction: {})
            return
        }
        
        if isDeleteMode {
            self.delUricacid = [:]
            isDeleteMode = false
        } else {
            isDeleteMode = true
        }
        
        fetchData()
    }
    
    func fetchData(){
        
        showViewIndexRow = 0
        
        let listType = goutListType(rawValue: selectViewTypeRow)!
        var uricacids:[GoutData] = []
        
        // 전체 보기 인경우
        if listType == .all {
            secondPanel.isHidden = true
            uricacids = DatabaseManager.sharedInstance().selectGoutVaule(date: nil, listType: listType) ?? []
        } else {
            secondPanel.isHidden = false
            
            if let getMonthList = DatabaseManager.sharedInstance().selectGoutDateList(listType: listType) {
                self.dateList = getMonthList
                
                if self.dateList.count > 0 {
                    self.dateLabel.text = self.dateList[selectPickerRow]
                    uricacids = DatabaseManager.sharedInstance().selectGoutVaule(date: self.dateList[selectPickerRow], listType: listType) ?? []
                }
            }
        }
        
        //데이터가 있는 경우 처리
        if uricacids.count > 0 {
            uricacidDatas = uricacids
            removeEmptyView()
        } else {
            setEmptyView()
        }
        
        self.delUricacid = [:]
        
        if isDeleteMode {
            addUricButton.titleLabel!.text = "완료"
            
            naviBar.leftButton = cancelButton
            deleteButton.isHidden = true
            cancelButton.isHidden = false
            
        } else {
            addUricButton.titleLabel!.text = "추가"
            
            naviBar.leftButton = deleteButton
            cancelButton.isHidden = true
            deleteButton.isHidden = false
        }
        
        createDatePicker()
        createViewTypePicker()
    }
    
    func setEmptyView() {
        self.view.addSubview(emptyPanel)
        emptyPanel.autoPinEdge(.top, to: .bottom, of: naviBar, withOffset: 40)
        emptyPanel.autoPinEdge(toSuperviewEdge: .left)
        emptyPanel.autoPinEdge(toSuperviewEdge: .right)
        emptyPanel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 53 + Constants.bottomHeight())
        emptyPanel.backgroundColor = .white
        emptyPanel.tag = 1
    }
    
    func removeEmptyView() {
        self.view.viewWithTag(1)?.removeFromSuperview()
    }
    
    func chartDid() {
        // Do any additional setup after loading the view.
        self.title = "Line Chart 2"
        self.options = [.toggleValues,
                        .toggleFilled,
                        .toggleCircles,
                        .toggleCubic,
                        .toggleHorizontalCubic,
                        .toggleStepped,
                        .toggleHighlight,
                        .animateX,
                        .animateY,
                        .animateXY,
                        .saveToGallery,
                        .togglePinchZoom,
                        .toggleAutoScaleMinMax,
                        .toggleData]
        
        chartView.delegate = self
        
        chartView.chartDescription?.enabled = false
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = true
        chartView.rightAxis.enabled = false //듀얼인 경위 왼쪽, 오른쪽 기준석 잡을때 true인 경우 오른쪽 기준이 추가됨
        
        let l = chartView.legend
        l.form = .line
        l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
        l.textColor = .black                    //범례 텍스트 색
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        
        let xAxis = chartView.xAxis
        xAxis.labelFont = .systemFont(ofSize: 9)
        xAxis.labelTextColor = .black
        xAxis.drawAxisLineEnabled = false
        xAxis.labelPosition = .bottom
        xAxis.labelWidth = 100
        
        let labelCount = uricacidDatas.count < 7 ? uricacidDatas.count - 1 : 6
        xAxis.labelCount = labelCount
        
        xAxis.valueFormatter = self
        
        let leftAxis = chartView.leftAxis
//        leftAxis.labelTextColor = UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)
        leftAxis.labelTextColor = UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)
        leftAxis.axisMaximum = 20
        leftAxis.axisMinimum = 0
        leftAxis.drawGridLinesEnabled = true
        leftAxis.granularityEnabled = true
        
        //차트 그려지는 속도
        chartView.animate(xAxisDuration: 0.5)
    }
    
    @objc func valueChanged() {
        print("test")
    }
    
    override func updateChartData() {
        if self.shouldHideData {
            chartView.data = nil
            return
        }
        
        if uricacidDatas.count > 0 {
            self.setDataCount(1, range: 0, changeType: "down")
        }
    }
    
    func setDataCount(_ count: Int, range: Int, changeType:String) {
        
        var dataI = range - (count - 1)
        var c = dataI + count
        
        if changeType == "up" {
            dataI = range - (count - 1)
            c = dataI + count
        } else {
            dataI = range
            c = range + count
        }

        let yVals1 = (dataI..<c).map { (i) -> ChartDataEntry in
            let val = Double(uricacidDatas[i].gout)!
            return ChartDataEntry(x: Double(i), y: val)
        }
        
        setChartViewData(chartDataEntry: yVals1)
    }
    
    func setChartViewData(chartDataEntry: [ChartDataEntry]) {
        
        let set1 = LineChartDataSet(values: chartDataEntry, label: "요산")
        set1.axisDependency = .left
        set1.setColor(UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1))    //그래프 라인 칼라 수정시
        set1.setCircleColor(.black)
        set1.lineWidth = 2
        set1.circleRadius = 3
        set1.fillAlpha = 65/255
        set1.fillColor = UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)  //범례 라인 칼라 수정시
        set1.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
        set1.drawCircleHoleEnabled = false
        let data = LineChartData(dataSets: [set1])
        
        data.setValueTextColor(.gray)
        data.setValueFont(.systemFont(ofSize: 9))
        
        chartView.data = data
    }
    
    override func optionTapped(_ option: Option) {
        switch option {
        case .toggleFilled:
            for set in chartView.data!.dataSets as! [LineChartDataSet] {
                set.drawFilledEnabled = !set.drawFilledEnabled
            }
            chartView.setNeedsDisplay()
            
        case .toggleCircles:
            for set in chartView.data!.dataSets as! [LineChartDataSet] {
                set.drawCirclesEnabled = !set.drawCirclesEnabled
            }
            chartView.setNeedsDisplay()
            
        case .toggleCubic:
            for set in chartView.data!.dataSets as! [LineChartDataSet] {
                set.mode = (set.mode == .cubicBezier) ? .linear : .cubicBezier
            }
            chartView.setNeedsDisplay()
            
        case .toggleStepped:
            for set in chartView.data!.dataSets as! [LineChartDataSet] {
                set.mode = (set.mode == .stepped) ? .linear : .stepped
            }
            chartView.setNeedsDisplay()
            
        case .toggleHorizontalCubic:
            for set in chartView.data!.dataSets as! [LineChartDataSet] {
                set.mode = (set.mode == .cubicBezier) ? .horizontalBezier : .cubicBezier
            }
            chartView.setNeedsDisplay()
            
        default:
            super.handleOption(option, forChartView: chartView)
        }
    }
    
    //}
    // TODO: Declarations in extensions cannot override yet.
    //extension LineChart2ViewController {
    override func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        super.chartValueSelected(chartView, entry: entry, highlight: highlight)
        
        self.chartView.centerViewToAnimated(xValue: entry.x, yValue: entry.y,
                                            axis: self.chartView.data!.getDataSetByIndex(highlight.dataSetIndex).axisDependency,
                                            duration: 1)
        self.chartView.xAxis.valueFormatter?.stringForValue(1, axis: nil)
        //        self.chart
        //        self.chartView.xAxis.setValuesForKeys(<#T##keyedValues: [String : Any]##[String : Any]#>)
        
        //[_chartView moveViewToAnimatedWithXValue:entry.x yValue:entry.y axis:[_chartView.data getDataSetByIndex:dataSetIndex].axisDependency duration:1.0];
        //[_chartView zoomAndCenterViewAnimatedWithScaleX:1.8 scaleY:1.8 xValue:entry.x yValue:entry.y axis:[_chartView.data getDataSetByIndex:dataSetIndex].axisDependency duration:1.0];
    }
    
    func nextAddViewCtrl() {
        
        if isDeleteMode {
            if DatabaseManager.sharedInstance().deleteGoutDataList(uricacidList: delUricacid) {
                self.isDeleteMode = false
                self.delUricacid = [:]
                self.fetchData()
            }
        } else {
            let addViewCtrl = AddValueViewController()
            addViewCtrl.modalPresentationStyle = .overFullScreen
            addViewCtrl.addValueViewDelegate = self
            present(addViewCtrl, animated: true, completion: nil)
        }
    }
    
    func createDatePicker(){
        
        let doneToolBar = UIToolbar()
        let doneBarButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(donePressed))
        doneToolBar.sizeToFit()
        doneToolBar.items = [doneBarButton]

        monthPick.tag = 3
        monthPick.delegate = self
        dateTextField.inputAccessoryView = doneToolBar
        dateTextField.inputView = monthPick
        
    }
    
    /**
     그래프 리스트 단위 Picker 전체, 년도별, 월별
     */
    func createViewTypePicker() {
        let doneToolBar = UIToolbar()
        let doneBarButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(doneViewTypePicker))
        doneToolBar.sizeToFit()
        doneToolBar.items = [doneBarButton]
        
        viewTypePicker.tag = 1
        viewTypePicker.delegate = self
        viewTypeTextField.inputAccessoryView = doneToolBar
        viewTypeTextField.inputView = viewTypePicker
    }
    
    @objc func updateDate() {
        
    }
    
    /**
     월별 데이터 Picker 액션
     */
    @objc func donePressed() {
        let i = monthPick.selectedRow(inComponent: 0)
        
        if dateList.count == 0 {
            dateTextField.resignFirstResponder()
            return
        }
        
        dateLabel.text = dateList[i]
        dateTextField.resignFirstResponder()
        selectPickerRow = i
        isRefrash = true
        fetchData()
    }
    
    /**
     
     */
    @objc func doneViewTypePicker() {
        let i = viewTypePicker.selectedRow(inComponent: 0)
        viewTypeLabel.text = viewTypeList[i]
        viewTypeTextField.resignFirstResponder()
        selectViewTypeRow = i
        isRefrash = true
        fetchData()
    }
    
    @objc func setDateDone() {
        monthPick.selectedRow(inComponent: 0)
    }
    
    @objc func setViewTypeDone() {
        viewTypePicker.selectedRow(inComponent: 0)
    }
}

extension GoutChartViewController: IAxisValueFormatter {
    /**
     그래프의 하단 날짜 텍스트 처리
     */
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
        //데이터가 없는 경우
        if (Int(value) % months.count) < 0 {
            return ""
        }
        
        //데이터가 하나인 경우
        if months.count == 1 {
            let s = months[Int(value) % months.count]
            
            //가운데에만 날짜 보이게
            if value == 0.0 {
                return s
            } else {
                return ""
            }
        }
        
        //데이터가 두개인 경우
        if months.count == 2 {
            let s = months[Int(value) % months.count]
            
            //가운데 하나는 빈 문자열 처리
            if value == 0.5 {
                return ""
            } else {
                return s
            }
        }
        
        let s = months[Int(value) % months.count]
        
        return s
    }
}

extension GoutChartViewController:AddValueViewDelegate {
    func successGoutValue() {
        self.fetchData()
    }
    
    func cancelGoutValue() {
    }
}

extension GoutChartViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return uricacidDatas.count == 0 ? 1 : uricacidDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if uricacidDatas.count == 0 {
            return CGSize(width: collectionView.bounds.width, height: UIScreen.main.bounds.height - 63)
        }
        
        //셀 높이 조정 (전체 높이 - 상단상태바 높이 - 그래프 높이 - 하단 탭바) / 7
        let cellHeight = (UIScreen.main.bounds.height - Constants.statusHeight() - 44 - 200 - 53 - Constants.bottomHeight() - 50) / 7
        
        return CGSize(width: UIScreen.main.bounds.width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if uricacidDatas.count == 0 {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyCell.className, for: indexPath) as? EmptyCell {
                cell.titleLabel.text = "알림이 없습니다."
                cell.subsLabel.isHidden = true
                return cell
            }
        }
        
        let data = uricacidDatas[indexPath.row]
        
        let currGout = CGFloat(Double(data.gout)!)
        var prevGout = CGFloat(0.0)
        
        if indexPath.row == uricacidDatas.count - 1 {
            prevGout = CGFloat(Double(data.gout)!)
        } else {
            prevGout = CGFloat(Double(uricacidDatas[indexPath.row + 1].gout)!)
        }
        
        ///요산 데이터의 업/다운. 이밎
        var signalImage:UIImage = #imageLiteral(resourceName: "valueEqual")
        
        if currGout > prevGout {
            signalImage = #imageLiteral(resourceName: "valueUp")
        } else if currGout < prevGout {
            signalImage = #imageLiteral(resourceName: "valueDown")
        }
        
        if isDeleteMode {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DeleteUricacidViewCell.className, for: indexPath) as? DeleteUricacidViewCell else {
                return UICollectionViewCell()
            }
            
            let data = uricacidDatas[indexPath.row]
            
            cell.deleteCheckIV.image = #imageLiteral(resourceName: "unSelect_Check")
            cell.signalIV.image = signalImage
            cell.dateLabel.text         = "\(data.regDate)\n\(data.regTime)"
            cell.uricacidLabel.text     = data.gout
            cell.uricacidDescLabel.text = data.goutDesc
            
            return cell
    
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UricacidCollectionViewCell.className, for: indexPath) as? UricacidCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let data = uricacidDatas[indexPath.row]
            
            cell.dateLabel.text         = "\(data.regDate)\n\(data.regTime)"
            cell.uricacidLabel.text     = data.gout
            cell.uricacidDescLabel.text = data.goutDesc
            cell.signalIV.image       = signalImage
            
            return cell

        }
    }
    
    ///셀이 보여지기 시작할때 호출
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if uricacidDatas.count == 0 {
            return
        }
        
        let indexRow = indexPath.row
        var uaCount = uricacidDatas.count
        
        if uaCount >= 7 {
            uaCount = 7
        }
        
        if showViewIndexRow < indexRow {
            if indexRow > 6 {
                setDataCount(uaCount, range: indexRow, changeType: "up") //indexPath.row
            }
        } else {
            setDataCount(uaCount, range: indexRow, changeType: "down") //indexPath.row
        }
        
        showViewIndexRow = Int(indexRow)
        
        if 0 <= indexRow - 7 {
            hiddenViewIndexRow = indexRow - 7
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        if isRefrash || isInit {
            return
        }
        
        let indexRow = indexPath.row
        
        //새롭게 보여진 셀과 사라진 셀이 같은 경우
        if showViewIndexRow == indexRow {
            //이전에 사라진 셀의 index가 방금 사라질 셀의 인덱스 보다 작은 경우
            if hiddenViewIndexRow < indexRow {
                setDataCount(7, range: indexRow - 7, changeType: "down")
            }
        }
        
        hiddenViewIndexRow = indexRow
        
        if 0 <= indexRow - 7 {
            showViewIndexRow = indexRow - 7
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isDeleteMode {

            guard let cell = uricacidCollectionView.cellForItem(at: indexPath) as? DeleteUricacidViewCell else { return }
            
            if delUricacid[indexPath.row] == nil {
                cell.deleteCheckIV.image = #imageLiteral(resourceName: "select_Check")
                delUricacid[indexPath.row] = uricacidDatas[indexPath.row]
            } else {
                cell.deleteCheckIV.image = #imageLiteral(resourceName: "unSelect_Check")
                delUricacid.removeValue(forKey: indexPath.row)
            }
            
        } else {
            let goutData = uricacidDatas[indexPath.row]
            
            
            let addViewCtrl = AddValueViewController()
            addViewCtrl.reqView = "Modify"
            
            addViewCtrl.dateTextField.text = goutData.regDate
            addViewCtrl.goutTextField.text = goutData.gout
            addViewCtrl.descTextView.textColor = .black
            addViewCtrl.descTextView.text = goutData.goutDesc
            addViewCtrl.goutId = goutData.id
            addViewCtrl.addValueViewDelegate = self
            
            addViewCtrl.modalPresentationStyle = .overFullScreen
            present(addViewCtrl, animated: true, completion: nil)
            
        }
    }
    
    /**
     탭 이동하여 뷰가 사라질때 처리
     */
    override func viewDidDisappear(_ animated: Bool) {
        isDeleteMode = false
        delUricacid = [:]
        fetchData()
    }
}

extension GoutChartViewController:UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        let pickerTag = pickerView.tag
        
        var listCount = 0
        
        if pickerTag == 1 {
            listCount = viewTypeList.count
        } else if pickerTag == 3 {
            listCount = dateList.count
        }
        
        return listCount
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let pickerTag = pickerView.tag
        
        if pickerTag == 1 {
            return String(viewTypeList[row])
        } else {
            return String(dateList[row])
        }
    }
}
