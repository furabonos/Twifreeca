//
//  AppDelegate.swift
//  TwifreecaTV
//
//  Created by 엄태형 on 2019. 5. 19..
//  Copyright © 2019년 엄태형. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        if Auth.auth().currentUser != nil {
            let appDelegate = UIApplication.shared.delegate! as! AppDelegate
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "TwitchViewController")
            appDelegate.window?.rootViewController = initialViewController

//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let root = storyboard.instantiateViewController(withIdentifier: "TwitchViewController")
//            var nvc = UINavigationController(rootViewController: root)
//            window?.rootViewController = nvc
            
            window?.makeKeyAndVisible()
        }else {
            print("nonononononononononononononononono")
        }
//        UITabBar.appearance().tintColor = UIColor(red: 0/255, green: 0/255, blue: 255/255, alpha: 1.0)
        UITabBar.appearance().barTintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
//        UITabBar.appearance().unselectedItemTintColor = UIColor(red: 0/255, green: 255/255, blue: 0/255, alpha: 1.0)
        
        
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
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

