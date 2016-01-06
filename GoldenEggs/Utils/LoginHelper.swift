//
//  LoginHelper.swift
//  GoldenEggs
//
//  Created by Sven Resch on 2016-01-04.
//  Copyright © 2016 Beanstream Internet Commerce, Inc. All rights reserved.
//

import UIKit

class LoginHelper: NSObject {

    static func login(controller: UIViewController, completion: (() -> Void)?) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: NSBundle.mainBundle())
        let loginController = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        if let completion = completion {
            loginController.loginCompletionHandler = { completion() }
        }
        controller.presentViewController(loginController, animated: true, completion: nil)
    }

}
