//
//  MainViewController.swift
//  GoldenEggs
//
//  Created by Sven Resch on 2015-12-22.
//  Copyright © 2015 Beanstream Internet Commerce, Inc. All rights reserved.
//
// The main view controller displays a running total of the number of desired Golden Eggs to 
// be purchased that is converted to a local currency using the Swift Money library. When a 
// user chooses to "checkout" we then execute a Beanstream API processTransaction request.
//
// This controller also takes care of displaying the current EMV Accessory (Pin Pad device) 
// current connection status and allow the user to simulate connecting and disconnecting the
// device by exercising any related Beanstream SDK API method calls.
//

import UIKit
import Money
import MBProgressHUD

class MainViewController: UIViewController {
    
    @IBOutlet weak var emvConnectButton: UIButton!
    
    private var cartController: CartTableViewController? = nil
    private var lineItems = [LineItem]()
    private var eggPrice: Money?
    private var emvConnected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sellPrice: CAD = 1.00
        
        // In a real app could do a foreign exchange check and conversion here.
        eggPrice = Money(sellPrice.floatValue)

        let api = APIHelper.api
        emvConnected = api.isPinPadConnected()
        
        if emvConnected {
            emvConnectButton.setImage(UIImage(named: "pinpad_connected"), forState: .Normal)
        }
        else {
            emvConnectButton.setImage(UIImage(named: "pinpad_disconnected"), forState: .Normal)
        }
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "embedCartTable" {
            cartController = segue.destinationViewController as? CartTableViewController
        }
    }
    
    // MARK: - Custom action methods

    @IBAction func addButtonAction(sender: AnyObject?) {
        var lineItem: LineItem
        
        if lineItems.count == 0 {
            lineItem = createLineItem()
            lineItems.append(lineItem)
        }
        else {
            lineItem = lineItems.first!
        }
        
        lineItem.quantity += 1
        lineItems[0] = lineItem

        cartController?.setLineItems(lineItems)
    }
    
    @IBAction func removeButtonAction(sender: AnyObject) {
        if var lineItem = lineItems.first where lineItem.quantity > 0 {
            lineItem.quantity -= 1
            lineItems[0] = lineItem
            cartController?.setLineItems(lineItems)
        }
    }
    
    @IBAction func checkoutButtonAction(sender: AnyObject) {
        // Check to make sure we have a line item with a quantity of 1 or more
        guard let lineItem = lineItems.first where lineItem.quantity > 0 else {
            UIAlertController.bic_showAlert(self, title: nil, message: "Add at least one egg first!")
            return
        }
        
        // Check to make sure we still have a valid session
        guard let _ = UserData.sharedInstance.session?.isAuthorized else {
            // After a successful login re-execute the originally called method
            LoginHelper.login(self, completion: { self.checkoutButtonAction(sender) })
            return
        }
        
        let actionSheet: UIAlertController = UIAlertController(title: "Choose a payment option", message: nil, preferredStyle: .ActionSheet)
        
        let cashAction: UIAlertAction = UIAlertAction(title: "Cash", style: .Default) { action -> Void in
            self.processTransaction(BIC_CASH_PAYMENT_METHOD)
        }
        actionSheet.addAction(cashAction)

        let chequeAction: UIAlertAction = UIAlertAction(title: "Cheque", style: .Default) { action -> Void in
            self.processTransaction(BIC_CHECK_PAYMENT_METHOD)
        }
        actionSheet.addAction(chequeAction)

        let emvAction: UIAlertAction = UIAlertAction(title: "Credit or Debit Card", style: .Default) { action -> Void in
            self.processTransaction(BIC_EMV_PAYMENT_METHOD)
        }
        actionSheet.addAction(emvAction)

        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        
        if let button = sender as? UIButton {
            if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                actionSheet.popoverPresentationController?.sourceView = button
                actionSheet.popoverPresentationController?.sourceRect = button.bounds
            }
        }

        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func emvConnectButtonAction(sender: AnyObject) {
        let api = APIHelper.api

        if !emvConnected {
            api.connectToPinPad()
            
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.labelText = "Initializing Pin Pad...";
            
            api.initializePinPad({ (response, error) -> Void in
                // Need to call MBProgressHUD on the main thread
                dispatch_async(dispatch_get_main_queue(), {
                    hud.hide(true)
                    
                    if let error = error {
                        UIAlertController.bic_showAlert(self, title: "Initialize Pin Pad error", message: "\(error.localizedDescription)")
                    }
                })
            })
            
            emvConnectButton.setImage(UIImage(named: "pinpad_connected"), forState: .Normal)
        }
        else {
            api.closePinPadConnection()
            emvConnectButton.setImage(UIImage(named: "pinpad_disconnected"), forState: .Normal)
        }
        
        emvConnected = !emvConnected
    }
    
    // MARK: - Private methods
    
    private func processTransaction(bicPaymentMethod: String) {
        // Start processing a new transaction
        if let subtotal = cartController?.subtotalAsMoney() {
            let request = BICTransactionRequest()
            request.paymentMethod = bicPaymentMethod
            request.amount = cartController?.subtotalAsMoney().amount
            request.tax1Price = cartController?.taxAsMoney(subtotal).amount
            request.transType = "P"
            request.emvEnabled = bicPaymentMethod == BIC_EMV_PAYMENT_METHOD ? true : false;
            
            let bicLineItems = NSMutableArray()
            for item in lineItems {
                if let product = item.product {
                    let bicItem = BICLineItem()
                    bicItem.productId = product.sku
                    bicItem.productCost = product.price.amount
                    bicItem.productQuantity = item.quantity
                    bicLineItems.addObject(bicItem)
                }
            }
            request.lineItems = bicLineItems
            
            let api = APIHelper.api

            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.labelText = "Processing...";
            
            api.processTransaction(request,
                emvEnableTips: false,
                emvTipPresets: nil,
                completion: { (response, error, updateKeyfile) -> Void in
                    // Need to call MBProgressHUD on the main thread
                    dispatch_async(dispatch_get_main_queue(), {
                        hud.hide(true)
                        
                        if let error = error {
                            UIAlertController.bic_showAlert(self, title: "Process Transaction error", message: "\(error.localizedDescription)")
                        }
                        else if let response = response {
                            if response.trnApproved {
                                UIAlertController.bic_showAlert(self, title: nil, message: "Transaction completed!")
                                self.lineItems.removeAll()
                                self.cartController?.setLineItems(self.lineItems)
                            }
                            else {
                                if let message = response.responseMessage {
                                    UIAlertController.bic_showAlert(self, title: nil, message: "Transaction did not succeed: \(message)")
                                }
                                else if let message = response.messageText {
                                    UIAlertController.bic_showAlert(self, title: nil, message: "Transaction did not succeed: \(message)")
                                }
                            }
                        }
                    })
                }
            )
        }
    }
    
    private func createLineItem() -> LineItem {
        var product: Product
        product = Product()
        product.name = "Golden Egg"
        product.price = eggPrice!
        product.sku = "GE100001"
        
        var lineItem = LineItem()
        lineItem.product = product
        
        return lineItem
    }
    
}
