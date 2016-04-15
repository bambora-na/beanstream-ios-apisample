//
//  ReceiptViewController.swift
//  GoldenEggs
//
//  Created by Sven Resch on 2016-01-18.
//  Copyright © 2016 Beanstream Internet Commerce, Inc. All rights reserved.
//
// When a user taps on a transaction in the TransactionsTableViewController this controller is
// loaded. Here we simply execute the Beanstream SDK API to getPrintReceipt and display the 
// merchants copy in a web view.
//

import UIKit
import MBProgressHUD

class ReceiptViewController: UIViewController {
    
    @IBOutlet weak var webview: UIWebView!
    
    private var htmlString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Receipt"
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(ReceiptViewController.sessionChanged(_:)),
            name: Constants.Notifications.sessionChangedNotification,
            object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        requestReceipt()
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    // MARK: - Internal methods
    
    internal func sessionChanged(notification: NSNotification?){
        guard let _ = UserData.sharedInstance.session else {
            // No user session
            if ( self.navigationController?.topViewController == self ) {
                self.htmlString = nil
                self.navigationController?.popViewControllerAnimated(true);
            }
            return
        }
    }
    
    // MARK: Private methods
    
    private func requestReceipt() {
        let api = APIHelper.api
        
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "Processing...";
        self.htmlString = nil;
        
        api.getPrintReceipt("12345677",
            language: "en",
            completion: { (response, error) -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    hud.hide(true)
                    if let error = error {
                        UIAlertController.bic_showAlert(self, title: "Get Receipt Error", message: "\(error.localizedDescription)")
                    }
                    else if let response = response {
                        print("ReceiptViewController.requestReceipt() code: \(response.code)")
                        if response.code == 1 {
                            self.htmlString = response.receiptMerchantCopy
                        }
                        else {
                            UIAlertController.bic_showAlert(self, title: "Get Receipt Issue", message: "\(response.message)")
                        }
                        self.loadHTML()
                    }
                })
        })
    }

    private func loadHTML() {
        if let htmlString = htmlString {
            webview.loadHTMLString(htmlString, baseURL: nil)
        }
        else {
            webview.loadHTMLString("<html><body>no receipt</body></html>", baseURL: nil)
        }
    }
}
