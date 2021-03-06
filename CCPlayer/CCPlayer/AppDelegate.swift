//
//  AppDelegate.swift
//  CCPlayer
//
//  Created by 崔玉冠 on 2020/11/17.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let store = StoreUserDefaultManager.init()
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if #available(iOS 13.0, *) {
        } else {
            let VC = ViewController()
            self.window?.rootViewController = VC
        }
        
        if store.getValueWithKey(key: FirstLive) != "1" {
            SLLive.sharedInstance().requestAppControllSwitch { (switchApp, error) in
                if error == nil {
                    if switchApp {
                        self.store.setValueForKey(key: FirstLive, value: "1")
                        SLLive.sharedInstance().startSDK(launchOptions ?? [:])
                    } else {
                        let VC = ViewController()
                        self.window?.rootViewController = VC
                    }
                } else {
                    let VC = ViewController()
                    self.window?.rootViewController = VC
                }
            }
        } else {
            SLLive.sharedInstance().startSDK(launchOptions ?? [:])
        }
        
        return true
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if store.getValueWithKey(key: FirstLive) == "1" {
            var newOption = [String : Any]()
            for (key, value) in options {
                let newKey = key.rawValue
                newOption[newKey] = value
            }
            return SLLive.sharedInstance().application(app, open: url, options: newOption)
        }
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if store.getValueWithKey(key: FirstLive) == "1" {
            return SLLive.sharedInstance().application(application, continue: userActivity, restorationHandler: restorationHandler)
        }
        return true
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        if store.getValueWithKey(key: FirstLive) == "1" {
            SLLive.sharedInstance().application(application, performActionFor: shortcutItem, completionHandler: completionHandler)
        }
    }

}

