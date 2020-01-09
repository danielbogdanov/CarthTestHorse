//  AppDelegate.swift
//  TestHorse
//
//  Created by Daniel Bogdanov on 14.03.19.
//  Copyright © 2019 Daniel Bogdanov. All rights reserved.
//

import UIKit
#if DEBUG
import AdSupport
#endif
import Leanplum
import LeanplumLocation
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, CLLocationManagerDelegate {
    
    var window: UIWindow?
    var customLabel = LPVar.define("customLabel", with: "change the text from the LP admin")
    var crazyPopsy = LPVar.define("TestVariable", with: "testVar")
//    var testVar = LPVar.define("testVariable2", with: "test2")
//    var authStatus = LPVar.define("AuthStatus", with: "undefined")
    var authStatus : Int?
    var authParam : NSDictionary?
    var varStructure = LPVar.define("Powerups.POWER", with: [
        "Price": 20,
        "Duration": 10,
        "Value" : 9000
        ])
    let inbox = AppInboxViewViewController()
    let locationManager = CLLocationManager()

    func enableBasicLocationServices() {
        locationManager.delegate = self
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            authStatus = 0
            // Request when-in-use authorization initially
//            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
            break

        case .restricted, .denied:
            // Disable location features
            authStatus = 1
            Leanplum.disableLocationCollection()
            break

        case .authorizedWhenInUse :
            authStatus = 2
            break
            //Enable location features
        case .authorizedAlways:
            authStatus = 3
            break
        }
    }

    
//    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//       if(url.host == "second") {
//            window?.rootViewController?.performSegue(withIdentifier: "showWithDeepLink", sender: nil)
//        }
//        return true
//    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        UIApplication.shared.open(url, options: [:], completionHandler: nil)
            if(url.host == "second") {
                // parse the url and handle the webhook
                print("YAY")
                window?.rootViewController?.performSegue(withIdentifier: "showWithDeepLink", sender: nil)
            } else {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
                return true
    }
//
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // We've inserted your Test API keys here for you :)
        //iOS-10
//        enableBasicLocationServices()
        Leanplum.disableLocationCollection()
       
//        UIApplication.shared.registerForRemoteNotifications()
        askForPushPerm()
        
     #if DEBUG
       // Leanplum.setDeviceId(ASIdentifierManager.shared().advertisingIdentifier.uuidString)
                Leanplum.setAppId("APP_ID",withDevelopmentKey:"DEV_KEY")
        //        Leanplum.setAppId("app_pcmFvHK68H7FmJhOVjxHQQr4G5C8CIv2AhSIDiDo5ek",withDevelopmentKey:"prod_cP6Yf1V6Qx4kUEH6VAbcDePKrzt8sAJuA3qAyboh364")
        //       Leanplum.setAppId("app_q0H8bAHnrtgLjW9FqW2XNwR0ToTMyCAMrulbH7UgFaM", withProductionKey: "prod_eJyk2uL2Lt0bLd5jmoYSOVdtDMdCchPZ7jhzIiP3Ya4")
        
     #else

     #endif
        
        // Optional: Tracks in-app purchases automatically as the "Purchase" event.
        // To require valid receipts upon purchase or change your reported
        // currency code from USD, update your app settings.
        // Leanplum.trackInAppPurchases()
        
        // Optional: Tracks all screens in your app as states in Leanplum.
        Leanplum.trackAllAppScreens()
//        Leanplum.socket
        // Sets the app version, which otherwise defaults to
        // the build number (CFBundleVersion).
//        Leanplum.setAppVersion("2.4.3")
        LPMessageTemplatesClass.sharedTemplates()
        // Starts a new session and updates the app content from Leanplum.
//        Leanplum.setDeviceId("13deviceId_2204201900")
//        Leanplum.forceContentUpdate()
//        print("FCU")
        
       
        Leanplum.start()
        Leanplum.setDeviceLocationWithLatitude( 42.6052, longitude: 23.0378, city:"Pernik", region:"22", country: "BG", type: LPLocationAccuracyGPS)
//        authParam = ["authParam" : authStatus!]
//        print(authParam!)
//        Leanplum.track("authorization_status", withParameters: authParam as? [AnyHashable : Any])
        print(Leanplum.version())
//        inbox.setUnread()
        print(inbox.getUnread())
//        Leanplum.setDeviceLocationWithLatitude(35.7276, longitude: 139.7443)
        UIApplication.shared.applicationIconBadgeNumber = inbox.getUnread()
        
        return true
    }
    
    func askForPushPerm() {
        if #available(iOS 12.0, *){
            UIApplication.shared.registerForRemoteNotifications()
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.provisional, .alert,  .badge, .sound]) { (granted, error) in
            
                if granted
                {
                    print("Notifications permission granted.")
                }
                else
                {
                    print("Notifications permission denied because: \(error?.localizedDescription).")
                }
            }
            UIApplication.shared.registerForRemoteNotifications()
           
        }
            //iOS 8-9
        else if #available(iOS 8.0, *){
            let settings = UIUserNotificationSettings.init(types: [UIUserNotificationType.alert,UIUserNotificationType.badge,UIUserNotificationType.sound],categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()
        } else if #available(iOS 10.0, *){
            UIApplication.shared.registerForRemoteNotifications()
//       UNUserNotificationCenter.current().requestAuthorization(options: [.provisional, .alert, .badge, .sound]) { (granted, error) in
//                if granted
//                {
//                    print("Notifications permission granted.")
//                }
//                else
//                {
//                    print("Notifications permission denied because: \(error?.localizedDescription).")
//                }
//            }
        }
            //iOS 7
        else{
            UIApplication.shared.registerForRemoteNotifications(matching:
                [UIRemoteNotificationType.alert,
                 UIRemoteNotificationType.badge,
                 UIRemoteNotificationType.sound])
        }
    }
    

    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // payload
        print("Payload: \(userInfo)")
        print("Custom_Payload: \(userInfo)")

        //send to bkg
//        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
        if application.applicationState == .background {
            UIApplication.shared.applicationIconBadgeNumber += 1
    }

        completionHandler(.newData)

    }
    

    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Response:\(response)")
        completionHandler()
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Shoot me")
        completionHandler([.alert, .badge, .sound])
        
    }
    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        print("Hoi mates")
//
//        defer {
//            completionHandler()
//        }
//
//        print("Notification Response: \(response)")
//        let userInfo = response.notification.request.content.userInfo
//        print("Notification Response: \(userInfo)")
//        if userInfo.isEmpty { return }
//        if let dict = userInfo as? [String : Any] {
//            if let urlString = dict["URL"] as? String {
//                guard let url = URL(string: urlString) else { return }
//                guard let urlScheme = url.scheme else { return }
//                if urlScheme == "horsey" {
//                    //                    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//                    //                    appDelegate.parseAction(url)
//                    print("I don't know what I'm doing")
//                } else {
//                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                }
//            }
//        }
//    }
    
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
        if (inbox.getUnread() == 0){
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        Leanplum.setUserAttributes(["logged": NSNull()])
        print("Bye")
        print(Leanplum.userId())
        print("HEHE")
        
    }
    

}
