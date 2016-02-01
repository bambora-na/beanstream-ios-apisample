//
//  AppDelegate.swift
//  GoldenEggs
//
//  Created by Sven Resch on 2015-12-22.
//  Copyright © 2015 Beanstream Internet Commerce, Inc. All rights reserved.
//

import UIKit

@UIApplicationMain

/**
 * The demo apps purpose is to serve as an example of how to use the Beanstream SDK for iOS. Here we have
 * a simple 'e-commerce' style app that facilitates the sale of any number of golden eggs the only
 * available product. A user indicates the number of golden eggs to be purchased at a price of $USD 1.00
 * and a running total that is converted to the devices locale specific country currency is displayed along
 * with a fictitious sales tax of 5%.
 *
 * To be able to compile this project you can clone the git source repo to a working directory. As dependencies
 * you will also need to clone the Beanstream API Simulator repo and then ensure all other dependencies are
 * installed via CocoaPods.
 *
 * This demo app has dependencies (check the Podfile) on public 3rd party libraries that include ReactiveCocoa,
 * Money and MBProgressHUD. There is also a dependency on the non-public Beanstream SDK. These
 * dependencies are installed via CocoaPods.
 *
 * Note that the Beanstream SDK itself has CocoaPods specified dependencies that include AFNetworking v2.6.0.
 *
 * > git clone https://github.com/Beanstream-DRWP/beanstream-ios-apisimulator.git
 * > git clone https://github.com/Beanstream-DRWP/beanstream-ios-apisample.git
 * > cd beanstream-ios-apisimulator
 * > pod install
 * > open GoldenEggs.xcworkspace
 *
 */
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
        
        //APIHelper.api.rootViewController = tabBarController
        
        return true
    }

}
