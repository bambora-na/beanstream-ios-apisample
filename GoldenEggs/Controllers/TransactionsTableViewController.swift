//
//  TransactionsTableViewController.swift
//  GoldenEggs
//
//  Created by Sven Resch on 2015-12-23.
//  Copyright © 2015 Beanstream Internet Commerce, Inc. All rights reserved.
//
// This controller displays any number of transactions using the Beanstream SDK via its
// searchTransactions API method call. A user can use the table UI and its Pull-to-Refresh
// mechanism to re-execute the search operation at any time.
//

import UIKit
import MBProgressHUD

class TransactionsTableViewController: UITableViewController {

    var request: BICSearchTransactionsRequest?
    var transactionRecords = [BICTransactionDetail]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Tranactions"
        self.tableView.contentInset = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0)
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "sessionChanged:",
            name: Constants.Notifications.sessionChangedNotification,
            object: nil)

        // Implement a Pull-to-Refresh styled table control
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.backgroundColor = Constants.Colors.secondaryColor
        self.refreshControl?.tintColor = Constants.Colors.mainColor
        self.refreshControl?.addTarget(self, action: "refreshTransactions", forControlEvents: UIControlEvents.ValueChanged)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Check to make sure we still have a valid session
        guard let _ = UserData.sharedInstance.session?.isAuthorized else {
            // After a successful login re-execute the originally called method
            LoginHelper.login(self, completion: { self.refreshTransactions() })
            return
        }

        if transactionRecords.count == 0 {
            refreshTransactions()
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionRecords.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TransactionCell")
        let detail = transactionRecords[indexPath.row]
        
        cell!.textLabel?.text = "Txn: \(detail.trnId)"
        cell!.detailTextLabel?.text = "Type: \(detail.trnType) Method: \(detail.trnPaymentMethod) Amount: \(detail.trnAmount) Date: \(detail.trnDateTime)"

        return cell!
    }
    
    // MARK: - Internal methods
    
    internal func refreshTransactions() {
        guard request == nil else {
            // already processing this request
            return
        }
        
        request = BICSearchTransactionsRequest()

        let now = NSDate()
        request?.reportStartDate = now.dateByAddingTimeInterval(-3*24*60*60) // show txn's from up to 3 days ago
        request?.reportEndDate = now
        request?.reportSortOrder = BICSortOrderBy.TransactionId
        
        let api = APIHelper.api
        
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "Processing...";
        
        self.transactionRecords.removeAll()
        
        api.searchTransactions(request!,
            completion: { (response, error) -> Void in
                self.request = nil
                dispatch_async(dispatch_get_main_queue(), {
                    self.refreshControl?.endRefreshing()
                    hud.hide(true)
                    
                    if let error = error {
                        UIAlertController.bic_showAlert(self, title: "Search Transaction error", message: "\(error.localizedDescription)")
                    }
                    else if let response = response {
                        if ( response.code == 1 ) {
                            if response.total > 0 {
                                print("TransactionsTableViewController.refreshTransactions had \(response.total) records")
                                for detail in response.transactionRecords where detail is BICTransactionDetail {
                                    self.transactionRecords.append(detail as! BICTransactionDetail)
                                }
                            }
                        }
                        else {
                            UIAlertController.bic_showAlert(self, title: "Search Transaction issue", message: "\(response.message)")
                        }
                    }
                    
                    self.tableView.reloadData()
                })
            }
        )
    }

    // Ensure that data is cleared when the user session changes.
    internal func sessionChanged(notification: NSNotification?){
        self.transactionRecords.removeAll()
        self.tableView.reloadData()
    }

}
