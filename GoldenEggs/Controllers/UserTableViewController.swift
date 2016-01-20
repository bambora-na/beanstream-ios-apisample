//
//  UserTableViewController.swift
//  GoldenEggs
//
//  Created by Sven Resch on 2015-12-23.
//  Copyright © 2015 Beanstream Internet Commerce, Inc. All rights reserved.
//
// This controller displays the current users session related data and for a logged-in
// user will display a Logout button in the navigation bar. When a user selects Logout,
// the Beanstream SDK abandonSession API call will be executed.
//

import UIKit
import MBProgressHUD

class UserTableViewController: UITableViewController {
    
    var titles = [String]()
    var values = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Profile"
        self.tableView.contentInset = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0)
        self.sessionChanged(nil)
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "sessionChanged:",
            name: Constants.Notifications.sessionChangedNotification,
            object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Check to make sure we still have a valid session
        guard let _ = UserData.sharedInstance.session?.isAuthorized else {
            // After a successful login re-execute the originally called method
            LoginHelper.login(self, completion: nil)
            return
        }
        
        checkLogoutButton()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserCell")
        cell!.textLabel?.text = titles[indexPath.row]
        
        if indexPath.row < values.count {
            cell!.detailTextLabel?.text = values[indexPath.row]
        }
        else {
            cell!.detailTextLabel?.text = ""
        }

        return cell!
    }

    // MARK: - Internal methods
    
    internal func sessionChanged(notification: NSNotification?){
        let session = UserData.sharedInstance.session
        
        if let titles = session?.bic_tableRepresentation().titles {
            self.titles = titles
        }
        
        if let values = session?.bic_tableRepresentation().values {
            self.values = values
        }
        else {
            self.values.removeAll()
        }
        
        self.tableView.reloadData()
    }
    
    internal func logout() {
        let api = APIHelper.api
        
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "Processing...";
        
        api.abandonSession({ (response) -> Void in
            // Need to call MBProgressHUD on the main thread
            dispatch_async(dispatch_get_main_queue(), {
                hud.hide(true)
                print("UserTableViewController.logout() code: \(response.code)")
                UserData.sharedInstance.session = nil
                self.checkLogoutButton()
            })
        }) { (error) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                hud.hide(true)
                UIAlertController.bic_showAlert(self, title: "Abandon Transaction error", message: "\(error.localizedDescription)")
                UserData.sharedInstance.session = nil
                self.checkLogoutButton()
            })
        }
    }
    
    // MARK: Private methods
    
    func checkLogoutButton() {
        if let _ = UserData.sharedInstance.session {
            let logoutButton = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: self, action: "logout")
            self.navigationItem.setRightBarButtonItem(logoutButton, animated: true)
        }
        else {
            self.navigationItem.setRightBarButtonItem(nil, animated: true)
        }
    }
}
