//
//  AppDelegate.swift
//  GeriatricHelper
//
//  Created by felgueiras on 13/04/2017.
//  Copyright © 2017 felgueiras. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let themeColor = #colorLiteral(red: 0.01176470588, green: 0.5215686275, blue: 0.6392156863, alpha: 1)

    let currencyCode = "eur"


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FIRApp.configure()
//        let splitViewController = self.window!.rootViewController as! UISplitViewController
//        
//        let leftNavController = splitViewController.viewControllers.first as! UINavigationController
//        let masterViewController = leftNavController.topViewController as! MasterViewController
//        
//        let rightNavController = splitViewController.viewControllers.last as! UINavigationController
//        let detailViewController = rightNavController.topViewController as! DetailViewController
//        
//        let firstMonster = masterViewController.patients.first
//        detailViewController.patient = firstMonster
//        
//        masterViewController.delegate = detailViewController
//        
//        detailViewController.navigationItem.leftItemsSupplementBackButton = true
//        detailViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
        
        // set window color
        window?.tintColor = themeColor
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
    
    class func getAppDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    
    func getStringValueFormattedAsCurrency(value: String) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.currency
        numberFormatter.currencyCode = currencyCode
        numberFormatter.maximumFractionDigits = 2
        
        let formattedValue = numberFormatter.string(from: NumberFormatter().number(from: value)!)
        return formattedValue!
    }
    
    
    func getDocDir() -> String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }


}

