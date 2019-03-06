//
//  AppDelegate.swift
//  KGout
//
//  Created by khstar on 25/02/2019.
//  Copyright © 2019 khstar. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var databaseManager:DatabaseManager?
    var fileManager:GoutFileManager = GoutFileManager.sharedInstance()
    var ref:DatabaseReference!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        databaseManager = DatabaseManager.sharedInstance()
        
        let baseKey = "gout_khstar"
        ref = Database.database().reference()
        let databaseKey = baseKey.toBase64()
        //키의 복원
        //        let fromKey = databaseKey.fromBase64()
        
        databaseManager?.setPassword(password: databaseKey)
//        GADMobileAds.configure(withApplicationID: "ca-app-pub-8837395530354963~2877983665")
        
        //DB 파일이 존재하지 않으면
        if(!fileManager.isDatabaseFile()) {
            databaseManager?.createDatabase()
        }
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        
        let firstTab = GoutChartViewController()
        let secondTab = DrugListViewController()
        let thirdTab = UserInfoViewController()
        
        let mainViewController = GoutTabbarViewController()
        mainViewController.viewControllers = [firstTab, secondTab, thirdTab]
        window!.rootViewController = mainViewController
        
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {[weak self] valid, _ in
            
            //Device Push수신 여부 응답 로그
            if valid {
                print("Device push enable")
            } else {
                print("Device push disable")
            }
        })
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        ref?.child("ios/version").observe(.value, with: { [weak self] snapshot in
            print("version snapshot \(snapshot.description)")
            self?.checkUpdatePopup(data: snapshot)
        })
        
        ref?.child("notice").observe(.value, with: { [weak self] snapshot in
            print("version snapshot \(snapshot.description)")
            self?.checkEnablePopup(data: snapshot)
        })
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func updateVersion() {
        
    }
    
    //Important Notice By Realtime DB on Firebase!
    func checkUpdatePopup(data: DataSnapshot) {
        
        guard let topController = window?.rootViewController as? GoutDefaultViewController else { return }
        
        guard let value = data.value as? NSDictionary else { return }
        
        guard let forceUpdate = value["forceupdate"] as? Int64 else { return }
        guard let buildNumber = value["number"] as? Int64 else { return }
        guard let Version = value["string"] as? String else { return }
        guard let tempUrl = value["url"] as? String else { return }
        guard let url = URL(string: tempUrl) else { return }
        //guard let url = URL(string: "https://itunes.apple.com/app/id1290140254") else { return }
        
        
        guard let currentBuildNumber = Bundle.main.infoDictionary!["CFBundleVersion"] as? String else { return }
        guard let currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String else { return }
        let intCurrentBuildNumber = Int(currentBuildNumber)
        
        if (Int(forceUpdate) > intCurrentBuildNumber!) {
            topController.showUpdatePopup(url: url, force: true)
            return
        } else if (Int(buildNumber) > intCurrentBuildNumber!) {
            //            topController.showUpdatePopup(url: url, force: false, nextFunction: { _ in
            //                if let topVC =  topController as? SplashViewController {
            //                    topVC.launchMainViewController()
            //                }
            //            })
            
            return
        }
        //
        //        //여기까지 내려오면 Version이 유효한 것으로 처리
        //        UserDefaults.standard.set(false, forKey: Constants.versionUpdatePush)
        
    }
    
    func checkEnablePopup(data: DataSnapshot) {
        
        guard let topController = window?.rootViewController as? GoutDefaultViewController else { return }
        
        guard let value = data.value as? NSDictionary else { return }
        
        guard let enabled = value["enabled"] as? Bool, !enabled else { return } // is Enabled?
        guard let title = value["title"] as? String else { return }
        guard let msg = value["mesg"] as? String else { return }
        guard let datemsg = value["datemesg"] as? String else { return }
        guard let start = value["start"] as? String , let startDate = Utils.stringToDate(start) else { return }
        guard let end = value["end"] as? String, let endDate = Utils.stringToDate(end) else { return }
        
        let currentDate = Date()
        
        if startDate > currentDate || endDate < currentDate { return } // correct Date?
        
        topController.showAlertAll(title: title, "\n\(msg)\n\n\(datemsg)", nextFunction: { [weak self] in
            
            guard let v = value["forceexit"] as? Bool else { return }
            
            if v {
                exit(0)
            } else {
                //                if let topVC =  topController as? SplashViewController {
                //                    topVC.launchMainViewController()
                //                }
            }
        })
        
        
    }
    
}

extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        //Get Notification On Foreground // (Local Homecare! && FCM) FCM은 fetchcompleteHandler 이후에 들어옴
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        
        // Print full message.
        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([.alert, .badge, .sound])
        
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // Launch From Notification Message in StatusBar!
        // TODO: MOVE THE CORRECT VIEWCONTROLLER. DO NOT SAVE COREDATA!
        
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        
        //        launchViewController(data: userInfo, reqViewType: ReqViewType.NOTI)
        // Print full message.
        print(userInfo)
        
        completionHandler()
    }
}

