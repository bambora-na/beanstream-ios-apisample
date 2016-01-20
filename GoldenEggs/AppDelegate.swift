//
//  AppDelegate.swift
//  GoldenEggs
//
//  Created by Sven Resch on 2015-12-22.
//  Copyright © 2015 Beanstream Internet Commerce, Inc. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        UIView.appearance().tintColor = Constants.Colors.mainColor
        UINavigationBar.appearance().barTintColor = Constants.Colors.secondaryColor
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        UINavigationBar.appearance().barStyle = .Black
        
        // idk: Force update the selection related L&F of every item
        let tabBarController = self.window!.rootViewController as! UITabBarController
        tabBarController.selectedIndex = 2
        tabBarController.selectedIndex = 1
        tabBarController.selectedIndex = 0
        
        return true
    }

}
