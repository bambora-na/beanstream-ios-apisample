//
//  CartTableViewController.swift
//  GoldenEggs
//
//  Created by Sven Resch on 2015-12-22.
//  Copyright © 2015 Beanstream Internet Commerce, Inc. All rights reserved.
//

import UIKit
import Money

class CartTableViewController: UITableViewController {
    
    private var lineItems : [LineItem]? = nil
    
    // MARK: - Public methods
    
    func setLineItems(lineItems: [LineItem]) {
        self.lineItems = lineItems
        self.tableView.reloadData()
    }
    
    func subtotalAsMoney() -> Money {
        var subtotal: Money = 0.0
        
        if let aSubtotal = (lineItems?.reduce(0.0) { $0! + $1.total }) {
            subtotal = aSubtotal
        }

        return subtotal
    }
    
    func taxAsMoney(cost: Money) -> Money {
        let tax = cost * 0.05
        return tax
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numItems = lineItems?.count ?? 0
        // add 3 for the subtotal, tax and total cells
        return numItems + 3
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Cell init must occur or error case will occur!
        var cell : UITableViewCell? = nil

        let numItems = lineItems?.count ?? 0
        
        if numItems > 0 && indexPath.row < numItems {
            let aCell = tableView.dequeueReusableCellWithIdentifier("LineItemCell", forIndexPath: indexPath) as! LineItemTableViewCell
            if let lineItems = lineItems {
                aCell.setLineItem(lineItems[indexPath.row])
            }
            cell = aCell
        }
        else {
            let subtotal = subtotalAsMoney()
            let row = indexPath.row - numItems
            
            switch (row) {
            case 0:
                let aCell = tableView.dequeueReusableCellWithIdentifier("SubtotalCell", forIndexPath: indexPath) as! SubtotalTableViewCell
                aCell.setSubtotal(subtotal)
                cell = aCell
                
            case 1:
                let aCell = tableView.dequeueReusableCellWithIdentifier("TaxItemCell", forIndexPath: indexPath) as! TaxItemTableViewCell
                aCell.setTaxTotal(taxLabel: "GST", total:taxAsMoney(subtotal))
                cell = aCell

            case 2:
                let aCell = tableView.dequeueReusableCellWithIdentifier("TotalCell", forIndexPath: indexPath) as! TotalTableViewCell
                aCell.setTotal(subtotal +  taxAsMoney(subtotal))
                cell = aCell
                
            default:
                assert(cell != nil, "CartTableViewController was not able to create a table cell!!!")
                break
            }
        }
        
        return cell!
    }

    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height: CGFloat = 0.0
        let numItems = lineItems?.count ?? 0

        if numItems > 0 && indexPath.row < numItems {
            // Line item row
            height = 50
        }
        else {
            // Subtotal, tax and total rows
            height = 30
        }

        return height
    }
    
}
