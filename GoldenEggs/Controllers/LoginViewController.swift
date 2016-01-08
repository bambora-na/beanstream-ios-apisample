//
//  LoginViewController.swift
//  GoldenEggs
//
//  Created by Sven Resch on 2015-12-23.
//  Copyright © 2015 Beanstream Internet Commerce, Inc. All rights reserved.
//
// When shown this controller will be presented as a modal view. It will only be 
// dismissed when a user Login completes successfully. A successful login will
// result in the UserData session being updated and related NSNotifications to
// be generated.
//

import UIKit
import ReactiveCocoa

class LoginViewController: UIViewController {
    
    @IBOutlet weak var companyTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: GoldenButton!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var loginCompletionHandler: (() -> Void)?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.modalPresentationStyle = UIModalPresentationStyle.FormSheet
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let validCompany = companyTextField.rac_textSignal().map { (name) -> NSNumber! in
            (name as! String).characters.count > 0
        }
        
        let validUsername = usernameTextField.rac_textSignal().map { (name) -> NSNumber! in
            (name as! String).characters.count > 0
        }
        
        let validPassword = passwordTextField.rac_textSignal().map { (name) -> NSNumber! in
            (name as! String).characters.count > 0
        }
        
        RACSignal.combineLatest([validCompany, validUsername, validPassword]).map {
            let tuple = $0 as! RACTuple
            let bools = tuple.allObjects() as! [Bool]
            let result: Bool = bools.reduce(true) {$0 && $1}
            return result
        }.subscribeNext { (valid) -> Void in
            self.loginButton.enabled = (valid as! Bool)
            self.loginButton.borderColor = (valid as! Bool) ? UIColor.whiteColor() : UIColor.lightGrayColor()
        }
    }

    @IBAction func loginButtonAction(sender: AnyObject) {
        self.loginButton.enabled = false
        activityIndicatorView.startAnimating()
        
        let company = companyTextField.text
        let username = usernameTextField.text
        let password = passwordTextField.text
        
        let api = APIHelper.api
        
        NSUserDefaults.standardUserDefaults().setObject("stableweb01", forKey: "bicSubdomainDev")
        
        api.createSession(company, username: username, password: password,
            success: { (response) -> Void in
                self.loginButton.enabled = true
                self.activityIndicatorView.stopAnimating()
                if ( response.errorCode != "0" || !response.isAuthorized ) {
                    let session = Session(response: response)
                    UserData.sharedInstance.session = session
                    self.presentingViewController?.dismissViewControllerAnimated(true, completion: { () -> Void in
                        self.loginCompletionHandler?()
                    })
                }
                else {
                    let alert = UIAlertController(title: "Bad response", message: "Code: \(response.errorCode) Message:\(response.responseMessage)", preferredStyle: .Alert)
                    let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alert.addAction(okAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            },
            failure: { (error) -> Void in
                self.loginButton.enabled = true
                self.activityIndicatorView.stopAnimating()
                let alert = UIAlertController(title: "Error", message: "Code: \(error.code) Message:\(error.localizedDescription)", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alert.addAction(okAction)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        )
    }
    
}
