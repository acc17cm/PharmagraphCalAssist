//
//  AppDelegate.swift
//  PharamgraphApp
//
//  Created by Cameron McWilliam on 18/07/2018.
//  Copyright © 2018 Cameron McWilliam. All rights reserved.
//
import Foundation
import UIKit

@UIApplicationMain


class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var viewController: ViewController!
    var homeVC: CalAssistViewController!
    var editVC: EditViewController!
    var s2VC: ViewController!
    var tabBarController: UITabBarController!
    var homeItem: UITabBarItem!
    var editItem: UITabBarItem!
    var presetItem: UITabBarItem!
    var scannerItem: UITabBarItem!
    var calItem: UITabBarItem!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow()
        window.makeKeyAndVisible()
        self.window = window
    
        homeVC = CalAssistViewController()
        homeVC.title = "Home"
        
        editVC = EditViewController()
        editVC.title = "Edit"
        
        s2VC = ViewController()
        s2VC.title = "Series 2000 Test Client"
        
        let presetsVC = PresetViewController()
        presetsVC.title = "Presets"
        
        let scannerVC = ScannerViewController()
        scannerVC.title = "Scanner"
        
        
        tabBarController = UITabBarController()
        window.rootViewController = tabBarController
        
        homeItem = UITabBarItem(title: "Home", image: UIImage(named: "home"), selectedImage: UIImage(named: "home"))
        editItem = UITabBarItem(title: "Edit", image: UIImage(named: "save"), selectedImage: UIImage(named: "save"))
        calItem = UITabBarItem(title: "Series2000Client", image: UIImage(named: "calassist"), selectedImage: UIImage(named: "calassist"))
        presetItem = UITabBarItem(title: "Presets", image: UIImage(named: "preset"), selectedImage: UIImage(named: "preset"))
        scannerItem = UITabBarItem(title: "Scanner", image: UIImage(named: "qr"), selectedImage: UIImage(named: "qr"))

        homeItem.tag = 0
        editItem.tag = 1
        calItem.tag = 2
        presetItem.tag = 3
        scannerItem.tag = 4
        
        homeVC.tabBarItem = homeItem
        
        editVC.tabBarItem = editItem
        
        s2VC.tabBarItem = calItem
        
        presetsVC.tabBarItem = presetItem
        
        scannerVC.tabBarItem = scannerItem
        
       
        
        let controllers = [homeVC, editVC, s2VC, presetsVC, scannerVC]
        tabBarController.viewControllers = controllers as! [UIViewController]
        
        tabBarController.viewControllers = controllers.map { UINavigationController(rootViewController: $0 as! UIViewController)}
        
        
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

