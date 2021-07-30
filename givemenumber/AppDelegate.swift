//
//  AppDelegate.swift
//  givemenumber
//
//  Created by BGMacMIni2 on 27/08/19.
//  Copyright © 2019 BGMacMIni2. All rights reserved.
//com.giveme.number

import UIKit
import CoreData
import Alamofire
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate,MessagingDelegate {

    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        UNUserNotificationCenter.current().delegate = self
        
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(self.tokenRefreshNotification), name: NSNotification.Name.InstanceIDTokenRefresh, object: nil)
        self.login()
        return true
    }
    func login(){
        if(((UserDefaults.standard.value(forKey: "userid")) != nil)){
            
//            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//            let view = storyBoard.instantiateViewController(withIdentifier: "MainController") as! MainController
//            let nav = UINavigationController.init(rootViewController: view)
//            self.window?.rootViewController = nav
//            nav.navigationBar.isHidden = true
//            self.window?.makeKeyAndVisible()
            if (((UserDefaults.standard.value(forKey: "terms")) != nil)) {
                
           
            let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let navigationController:UINavigationController = storyboard.instantiateInitialViewController() as! UINavigationController
            let rootViewController:UIViewController = storyboard.instantiateViewController(withIdentifier: "tabBar") as! TabbarController
            navigationController.viewControllers = [rootViewController]
            self.window?.rootViewController = navigationController
            }
            else{
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let view = storyBoard.instantiateViewController(withIdentifier: "Howitwork") as! Howitwork
                let nav = UINavigationController.init(rootViewController: view)
                self.window?.rootViewController = nav
                nav.navigationBar.isHidden = true
                self.window?.makeKeyAndVisible()
            }
            
        }else{
            let center = UNUserNotificationCenter.current()
            center.removeAllDeliveredNotifications()
            center.removeAllPendingNotificationRequests()
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let view = storyBoard.instantiateViewController(withIdentifier: "LoginController") as! LoginController
            let nav = UINavigationController.init(rootViewController: view)
            self.window?.rootViewController = nav
            nav.navigationBar.isHidden = true
            self.window?.makeKeyAndVisible()
        }
    }
    
    
    @objc func tokenRefreshNotification(_ notification: Notification) {
        print(#function)
        
        if let refreshedToken = InstanceID.instanceID().token() {
            print("Notification: refresh token from FCM -> \(refreshedToken)")
        }
        
       
        
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }
    
    func connectToFcm() {
        // Won't connect since there is no token
        guard InstanceID.instanceID().token() != nil else {
            print("FCM: Token does not exist.")
            return
        }
        
        // Disconnect previous FCM connection if it exists.
        Messaging.messaging().disconnect()
        
        Messaging.messaging().connect { (error) in
            if error != nil {
                print("FCM: Unable to connect with FCM. \(error.debugDescription)")
            } else {
                print("Connected to FCM.")
                let token = InstanceID.instanceID().token()
                print("tokens",token as Any)
                UserDefaults.standard.set(token, forKey: "devicetoken")
                UserDefaults.standard.synchronize()
            }
        }
        
        
    }
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    private func application(application: UIApplication,
                             didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        Messaging.messaging().apnsToken = deviceToken as Data
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
        connectToFcm()
        UNUserNotificationCenter.current().getDeliveredNotifications(completionHandler: { notification in
            var count = notification.count
             while count > 0 {
                count -= 1
                let userInfo = notification[count].request.content.userInfo as NSDictionary
                print("\(String(describing: userInfo))")
                let aps = userInfo.value(forKey: "gcm.notification.content") as! NSString
                let data = aps.data(using: String.Encoding.utf8.rawValue)
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
                    let resultArray = json! as NSDictionary
                    print(resultArray)
                    let center = UNUserNotificationCenter.current()
                    center.delegate = self
                    
                    if(resultArray.value(forKey: "status") as! String == "0"){
                        var str = UserDefaults.standard.integer(forKey: "usercount")
                        if(str == 0){
                            UserDefaults.standard.setValue(1, forKey: "usercount")
                            UserDefaults.standard.synchronize()
                        }else{
                            str = str + 1
                            UserDefaults.standard.setValue(str, forKey: "usercount")
                            UserDefaults.standard.synchronize()
                        }
                    
                    }
                    if(resultArray.value(forKey: "status") as! String == "1"){
                        var str = UserDefaults.standard.integer(forKey: "contactcount")
                        if(str == 0){
                            UserDefaults.standard.setValue(1, forKey: "contactcount")
                            UserDefaults.standard.synchronize()
                        }else{
                            str = str + 1
                            UserDefaults.standard.setValue(str, forKey: "contactcount")
                            UserDefaults.standard.synchronize()
                            
                        }
                      
                    }
                }catch{
                    
                }
                

                
            }
        })

        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,  willPresent notification: UNNotification, withCompletionHandler   completionHandler: @escaping (_ options:   UNNotificationPresentationOptions) -> Void) {
        
        //Called when a notification is delivered to a foreground app.
        
        let userInfo = notification.request.content.userInfo as NSDictionary
        print("\(String(describing: userInfo))")
        let aps = userInfo.value(forKey: "gcm.notification.content") as! NSString
        let data = aps.data(using: String.Encoding.utf8.rawValue)
        do{
            let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
            let resultArray = json! as NSDictionary
            print(resultArray)
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            
            if(resultArray.value(forKey: "status") as! String == "0"){
                var str = UserDefaults.standard.integer(forKey: "usercount")
                if(str == 0){
                    UserDefaults.standard.setValue(1, forKey: "usercount")
                    UserDefaults.standard.synchronize()
                }else{
                    str = str + 1
                    UserDefaults.standard.setValue(str, forKey: "usercount")
                    UserDefaults.standard.synchronize()
                }
                

               NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: "sendrequestuser") , object: nil)
              NotificationCenter.default.post(name: Notification.Name(rawValue: "sendrequestuser"), object: nil, userInfo: (resultArray as! [String : Any]))
            }
            if(resultArray.value(forKey: "status") as! String == "1"){
                var str = UserDefaults.standard.integer(forKey: "contactcount")
                if(str == 0){
                    UserDefaults.standard.setValue(1, forKey: "contactcount")
                    UserDefaults.standard.synchronize()
                }else{
                    str = str + 1
                    UserDefaults.standard.setValue(str, forKey: "contactcount")
                    UserDefaults.standard.synchronize()
                    
                }
                //  self.tabBarController?.selectedIndex = 2
              NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: "sendrequestcontact") , object: nil)
               NotificationCenter.default.post(name: Notification.Name(rawValue: "sendrequestcontact"), object: nil, userInfo: (resultArray as! [String : Any]))
                
            }
        }catch{
            
        }
        
        completionHandler(UNNotificationPresentationOptions.alert)
        
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // Called to let your app know which action was selected by the user for a given notification.
        let userInfo = response.notification.request.content.userInfo as NSDictionary
        print("\(String(describing: userInfo))")
        
        let aps = userInfo.value(forKey: "gcm.notification.content") as! NSString
        let data = aps.data(using: String.Encoding.utf8.rawValue)
        do{
            let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
            let resultArray = json! as NSDictionary
            print(resultArray)
            let center = UNUserNotificationCenter.current()
            center.delegate = self

            if(resultArray.value(forKey: "status") as! String == "0"){
               var str = UserDefaults.standard.integer(forKey: "usercount")
                if(str == 0){
                   UserDefaults.standard.setValue(1, forKey: "usercount")
                     UserDefaults.standard.synchronize()
                }else{
                    str = str + 1
                    UserDefaults.standard.setValue(str, forKey: "usercount")
                     UserDefaults.standard.synchronize()
                }
                NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: "sendrequestuser") , object: nil)
                NotificationCenter.default.post(name: Notification.Name(rawValue: "sendrequestuser"), object: nil, userInfo: (resultArray as! [String : Any]))
            }
            if(resultArray.value(forKey: "status") as! String == "1"){
                var str = UserDefaults.standard.integer(forKey: "contactcount")
                if(str == 0){
                    UserDefaults.standard.setValue(1, forKey: "contactcount")
                     UserDefaults.standard.synchronize()
                }else{
                    str = str + 1
                    UserDefaults.standard.setValue(str, forKey: "contactcount")
                    UserDefaults.standard.synchronize()
                    
                }
              //  self.tabBarController?.selectedIndex = 2
                NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: "sendrequestcontact") , object: nil)
                NotificationCenter.default.post(name: Notification.Name(rawValue: "sendrequestcontact"), object: nil, userInfo: (resultArray as! [String : Any]))
                
            }
        }catch{
            
        }
        
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "givemenumber")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

typealias JSONDictionary = [String:Any]
var brownColor =  UIColor(red: 204/255.0, green: 133/255.0, blue: 81/255.0, alpha: 1.0)
var errorMsgColor = UIColor(red: 206/255.0, green: 87/255.0, blue: 36/255.0, alpha: 1.0)
var defaultborderColor = UIColor(red: 232/255.0, green: 232/255.0, blue: 232/255.0, alpha: 1.0)
var defaultValidborderColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
