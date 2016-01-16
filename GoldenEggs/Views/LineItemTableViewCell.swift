//
//  LineItemTableViewCell.swift
//  GoldenEggs
//
//  Created by Sven Resch on 2015-12-23.
//  Copyright © 2015 Beanstream Internet Commerce, Inc. All rights reserved.
//

import UIKit

class LineItemTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var productLabel: UILabel!
    @IBOutlet private weak var quantityLabel: UILabel!
    @IBOutlet private weak var unitPriceLabel: UILabel!
    @IBOutlet private weak var totalLabel: UILabel!
    
    func setLineItem(lineItem: LineItem) {
        productLabel.text = lineItem.product?.name
        quantityLabel.text = String(format: "%i", lineItem.quantity)
        
        if let price = lineItem.product?.price {
            unitPriceLabel.text = "\(price)"
        }
        else {
            unitPriceLabel.text = ""
        }
        
        totalLabel.text = "\(lineItem.total)"
    }

}
