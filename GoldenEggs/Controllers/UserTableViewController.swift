//
//  UserTableViewController.swift
//  GoldenEggs
//
//  Created by Sven Resch on 2015-12-23.
//  Copyright © 2015 Beanstream Internet Commerce, Inc. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {
    
    var titles = [String]()
    var values = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "Cell")
        }
        
        cell!.textLabel?.text = titles[indexPath.row]
        cell!.detailTextLabel?.text = values[indexPath.row]

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
        
        self.tableView.reloadData()
    }
}
