//
//  AppDelegate.swift
//  3DtouchDemo
//
//  Created by 陈健 on 20/03/2017.
//  Copyright © 2017 陈健. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        if shortcutItem.type == "demo.dynamic" {
            if let d = shortcutItem.userInfo {
                if let name = d["name"] as? String {
                    // ... do something with time ...
                    print(name)
                    completionHandler(true)
                }
            }
        }
        completionHandler(false)
    }


}

