//
//  GoutDefaultViewController.swift
//  Gout
//
//  Created by khstar on 2018. 9. 6..
//  Copyright © 2018년 khstar. All rights reserved.
//

import UIKit
import RxSwift
import SwiftyJSON
import FirebaseMessaging
import UserNotifications
import Moya
import Crashlytics
import Fabric
import RxGesture

class GoutDefaultViewController: UIViewController {
    let logger:Logger = Logger.sharedInstance()
    
    let SCROLL_TOP = false
    ///홈 화면의 아이템에서 직접 메뉴화면으로 이동시 딜레이에 따른 엑션이 발생하여 두번 선택되는 현상이 발생
    ///이러한 현상을 막기위해 false일때만 액션 수행
    var bNextVC:Bool = false
    let lodingViewTag = ViewTags.lodingViewTag.rawValue
    let disposeBag = DisposeBag()
    
    lazy var naviBar: BaseNaviBar! = {
        return BaseNaviBar()
    }()
    
    lazy var noticeLabel: UILabel! = {
        let label = UILabel()
        
        label.text = "Label!"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 11)
        
        return label
    }()
    
    lazy var noticePanel: UIView! = {
        let view = UIView()
        view.alpha = 0
        view.addSubview(self.noticeLabel)
        
        self.noticeLabel.autoCenterInSuperview()
        
        view.backgroundColor = UIColor(0x2C2C2C)
        
        return view
    }()
    
    lazy var refreshButton: UIButton! = {
        let button = UIButton()
        button.setTitle("재시도", for: .normal)
        button.setTitleColor(UIColor(0xF2F2F2), for: .normal)
        button.setTitleColor(UIColor(0xF2F2F2, alpha: 0.5), for: .highlighted)
        button.setBackgroundImage(#imageLiteral(resourceName: "btn_bg_3_dis"), for: .normal)
        button.setBackgroundImage(#imageLiteral(resourceName: "btn_bg_3_pre"), for: .highlighted)
        button.setBackgroundImage(#imageLiteral(resourceName: "btn_bg_3_nor"), for: .disabled)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return button
    }()
    
    lazy var networkErrorPanel: UIView! = {
        let view = UIView()
        let wrapView = UIView()
        let introLabel = UILabel()
        
        view.backgroundColor = .white
        
        view.addSubview(wrapView)
        wrapView.addSubview(introLabel)
        wrapView.addSubview(self.refreshButton)
        
        wrapView.autoPinEdge(toSuperviewEdge: .left)
        wrapView.autoPinEdge(toSuperviewEdge: .right)
        wrapView.autoAlignAxis(toSuperviewAxis: .horizontal)
        
        introLabel.autoPinEdge(toSuperviewEdge: .top)
        introLabel.autoAlignAxis(toSuperviewAxis: .vertical)
        introLabel.text = "인터넷 연결 상태를 확인해주세요"
        introLabel.textColor = UIColor(0x2C2C2C)
        introLabel.font = UIFont.systemFont(ofSize: 17)
        
        self.refreshButton.autoSetDimensions(to: CGSize(width: 175, height: 46))
        self.refreshButton.autoAlignAxis(toSuperviewAxis: .vertical)
        self.refreshButton.autoPinEdge(.top, to: .bottom, of: introLabel, withOffset: 27)
        self.refreshButton.autoPinEdge(toSuperviewEdge: .bottom)
        view.isHidden = true
        return view
    }()
    
    let ratio = UIScreen.main.bounds.width / 375
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    let tabbarHeight:CGFloat = 53
    let statusHeight:CGFloat = Constants.statusHeight()
    
    //iPhoneX의 buttom 높이 : buttom 탭바 등을 사용하는 경우 22Point를 띄어준다.
    let xBottomHeight:CGFloat = 22
    
    var naviTopConstraint: NSLayoutConstraint?
    var direction: Bool = true
    
    var noticeTopConsraint: NSLayoutConstraint?
    
    var isFull: Bool = false
    var refreshFunction: (() -> Void)?
    var isNoticeViewing = false
    
    var isLoading = false
    
    var willDismissVC: UIViewController?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = .white
        addNoticeView()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //        self.view.bringSubview(toFront: networkErrorPanel)
        //        networkErrorPanel가 보일때만 bringSubview해주기 아닌 경우 AR마사지, 에시테티션's, 3일 플랜에서 상단 화면이 이상하게 나오는 현상 발생
//        if !networkErrorPanel!.isHidden {
//            self.view.bringSubview(toFront: networkErrorPanel)
//        }
        
//        self.view.bringSubview(toFront: noticePanel)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    /**
     - LodingView Show하기
     */
    func showLodingView() {
        
//        //현재 화면에 LodingView가 없는 경우 view 추가
//        if self.view.viewWithTag(lodingViewTag) == nil {
//            self.view.addSubview(lodingView)
//            lodingView.autoPinEdgesToSuperviewEdges()
//            lodingView.tag = lodingViewTag
//
//            //의도치 않게 오래걸리는 경우 아무런 액션도 수행할수 없으니 10초후 lodingView자동제거
//            let time = DispatchTime.now() + .seconds(10)
//            DispatchQueue.main.asyncAfter(deadline: time) {
//                self.hideLodingView()
//            }
//        }
    }
    
    /**
     - LodingView hide하기
     */
    func hideLodingView() {
        
        if self.view.viewWithTag(lodingViewTag) != nil {
            self.view.viewWithTag(lodingViewTag)?.removeFromSuperview()
        }
    }
    
    func toggleNaviBar(_ isShow: Bool){
        if direction == isShow { return }
        
        direction = isShow
        
        if isShow {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
                self?.naviTopConstraint?.constant = (self?.statusHeight)!
                self?.view.layoutIfNeeded()
                }, completion: nil)
            
        }else {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
                self?.naviTopConstraint?.constant = -44
                self?.view.layoutIfNeeded()
                }, completion: nil)
            
        }
        
    }
    
    func addNoticeView(){
        if let navi = navigationController {
            navi.navigationBar.addSubview(noticePanel)
            noticePanel.autoPinEdge(toSuperviewEdge: .left)
            noticePanel.autoPinEdge(toSuperviewEdge: .right)
            noticeTopConsraint = noticePanel.autoPinEdge(toSuperviewEdge: .top, withInset: -20)
            noticePanel.autoSetDimension(.height, toSize: 20)
        } else {
            self.view.addSubview(noticePanel)
            noticePanel.autoPinEdge(toSuperviewEdge: .left)
            noticePanel.autoPinEdge(toSuperviewEdge: .right)
            noticeTopConsraint = noticePanel.autoPinEdge(toSuperviewEdge: .top, withInset: -20)
            noticePanel.autoSetDimension(.height, toSize: 20)
        }   
    }
    
    func showNotice(_ message: String){
        noticeLabel.text = message
        if !isNoticeViewing {
            isNoticeViewing = true
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
                self?.noticePanel.alpha = 1
                self?.noticeTopConsraint?.constant = 0
                self?.view.layoutIfNeeded()
                self?.isFull = true
                self?.setNeedsStatusBarAppearanceUpdate()
                }, completion: nil)
            
            UIView.animate(withDuration: 0.3, delay: 2.3, options: .curveEaseInOut, animations: { [weak self] in
                self?.noticePanel.alpha = 0
                
                self?.noticeTopConsraint?.constant = -20
                
                self?.view.layoutIfNeeded()
                self?.isFull = false
                self?.setNeedsStatusBarAppearanceUpdate()
            }){[weak self] f in
                if f { self?.isNoticeViewing = false }
            }
        }
    }
    
    func showAlert(_ message: String, nextFunction: @escaping () -> Void){
        let alert = UIAlertController(title: "통풍 캐어", message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "확인", style: .default, handler: {_ in
            nextFunction()
        })
        alert.addAction(defaultAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func showAlertAll(title: String,_ message: String, nextFunction: @escaping () -> Void){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "확인", style: .default, handler: {_ in
            nextFunction()
        })
        alert.addAction(defaultAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func showAlert2(_ message: String, yes: String = "재시도", no: String = "닫기", nextFunction: (() -> Void)? = nil, closeFunction: (() -> Void)? = nil){
        let alert = UIAlertController(title: "통풍 캐어", message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: yes, style: .default, handler: {_ in
            if let _ = nextFunction {
                nextFunction!()
            }
        })
        let closeAction = UIAlertAction(title: no, style: .default, handler: {_ in
            if let _ = closeFunction {
                closeFunction!()
            }
        })
        
        alert.addAction(closeAction)
        alert.addAction(defaultAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func showAlert2All(title: String, _ message: String, yes: String = "재시도", no: String = "닫기", nextFunction: (() -> Void)? = nil, closeFunction: (() -> Void)? = nil){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: yes, style: .default, handler: {_ in
            if let _ = nextFunction {
                nextFunction!()
            }
        })
        let closeAction = UIAlertAction(title: no, style: .default, handler: {_ in
            if let _ = closeFunction {
                closeFunction!()
            }
        })
        
        alert.addAction(closeAction)
        alert.addAction(defaultAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func showAlertDestructive(_ message: String, destructive: String = StringConstants.delBtn, nextFunction: (() -> Void)? = nil, closeFunction: (() -> Void)? = nil){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: StringConstants.cancelBtn, style: .cancel, handler: {_ in
            if let _ = closeFunction {
                closeFunction!()
            }
        })
        let destructiveAction = UIAlertAction(title: destructive, style: .destructive, handler: {_ in
            
            if let _ = nextFunction {
                nextFunction!()
            }
        })
        
        alert.addAction(cancelAction)
        alert.addAction(destructiveAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    /**
     App Update 필요 여부 알려주기
     - Parameter url : 업데이트 App Store 주소
     - Parameter force : 강제 업데이트 여부
     - Parameter nextFunction : 업데이트 권고인 경우 나중에 할께요 선택시 다음 엑션 처리
     */
    func showUpdatePopup(url: URL, force: Bool, nextFunction: (() -> Void)? = nil){
        var title: String? = nil
        var message: String? = nil
        
        //앱이 백그라운드 진입시 Update Local Push 요청을 위한 플래그 설정
        UserDefaults.standard.set(true, forKey: Constants.versionUpdatePush)
        
        //필수(강제) 업데이트 필요 여부
//        if (force) {
//            title = "필수 업데이트"
//            message = "\nSKIN10이 더 나은 서비스를 위해 업데이트 되었습니다. 이용하시려면 최신 버전으로 업데이트가 필요합니다.\n\n업데이트하시겠습니까?"
//        } else {
//            title = "업데이트"
//            message = "\nSKIN10이 더 나은 서비스를 위해 업데이트 되었습니다.\n\n업데이트하시겠습니까?"
//        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        //업데이트 하기를 선택한 경우 업데이트를 하러 간 거니까. Push 보내지 않기
        let updateAction = UIAlertAction(title: "업데이트 하기", style: .default, handler: { _ in
            UserDefaults.standard.set(false, forKey: Constants.versionUpdatePush)
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        })
        
        let cancelAction = UIAlertAction(title: "나중에 할깨요", style: .default, handler: {_ in
            if let _ = nextFunction {
                nextFunction!()
            }
        })
        
        alert.addAction(updateAction)
        if (!force) {
            alert.addAction(cancelAction)
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    func moveTap(type: TapType){
        if let tabBarController = tabBarController {
            tabBarController.selectedIndex = type.rawValue
        }
    }
    
    func launchWeb(addr: String) {
        if let url = URL(string: addr) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        
        return isFull
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    /**
     Token 유효성 검사후 만료시간이 3시간 미만으로 남아 있는 경우 token refresh
     */
    func refreshAccessToken(token: String){
//        let jwt = Utils.decodeJWT(jwtToken: token)
//
//        guard let expire = jwt["exp"] as? Int64 else { return }
//
//        let base = 60 * 60
//
//        let currentMills = Int64(NSDate().timeIntervalSince1970)
//
//        let diffHours =  (expire - currentMills) / base
//
//
//        if diffHours < 3 {
//
//            requestEvent(request: .userRefreshToken(), success: {response in
//
//                if let data = ResponseLoginItem(jsonData: JSON(response))?.data {
//                    UserDefaults.standard.set(data.token, forKey: Constants.AccessToken)
//                }
//            })
//        }
//
//        let fommetter = DateFormatter()
//        fommetter.dateFormat = "yyyy년 M월 d일 hh : mm"
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        willDismissVC?.dismiss(animated: false, completion: nil)
        
    }
    
    //BaseViewController의 하위 Navigation에서 Pop할때 공통호출
    func naviPopViewController(animated: Bool) {
        navigationController?.popViewController(animated: animated)
    }
    
    //BaseViewController의 하위 Navigation에서 RootViewController까지 이동할때
    func naviPopRootViewController(animated: Bool, bReflash: Bool) {
        
        //bReflash가 true인 경우 메인화면 리플레쉬
        if bReflash {
            let vcList = navigationController?.children
            
            //네비게이션의 child컨트럴러에서 first 꺼내서 확인
            if vcList?.first is UserInfoViewController {
                let mainVC = vcList?.first as! UserInfoViewController
            }
        }
        
        navigationController?.popToRootViewController(animated: animated)
    }
    
    //네비게이션 스택에서 뒤에서 부터 at까지 지우고 navigation 교체하기
    //네비게이션의 특정 위치까지 이동하는 효과
    func naviRemoveLastViewControlls(at:Int, animate:Bool) {
        var viewControlls = navigationController?.children
        viewControlls?.removeLast(at)
        navigationController?.setViewControllers(viewControlls!, animated: animate)
    }
    
    func onFailureGetInfo(_ errorCode: Int){
        
    }
    
    func dismissSelf(_ anmiated: Bool = true){
        
        if let naviController = navigationController {
            
            if naviController.viewControllers[0] == naviController.topViewController {
                dismiss(animated: anmiated)
            } else {
                navigationController?.popViewController(animated: anmiated)
                //                navigationController?.move
            }
            
        } else {
            dismiss(animated: anmiated)
        }
    }
    
    /**
     iOS 디바이스의 설정 화면 오픈하기
     */
    func openSettingURL() -> Void{
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

extension GoutDefaultViewController: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        if let id = userInfo["gcm.message_id"] {
            
        }
        
        completionHandler([.alert])
    }
    
}


