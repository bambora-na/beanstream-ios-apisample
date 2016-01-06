//
//  UIAlertControllerExtensions.swift
//  GoldenEggs
//
//  Created by Sven Resch on 2016-01-04.
//  Copyright © 2016 Beanstream Internet Commerce, Inc. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    static func bic_showAlert(controller: UIViewController, title: String?, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(okAction)
        
        controller.presentViewController(alert, animated: true, completion: nil)
    }

}
