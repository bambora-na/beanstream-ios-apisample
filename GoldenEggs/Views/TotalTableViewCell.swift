//
//  TotalTableViewCell.swift
//  GoldenEggs
//
//  Created by Sven Resch on 2015-12-23.
//  Copyright © 2015 Beanstream Internet Commerce, Inc. All rights reserved.
//

import UIKit
import Money

class TotalTableViewCell: UITableViewCell {

    @IBOutlet private weak var totalLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!
    
    func setTotal(total: Money) {
        totalLabel.text = "Total (\(total.currencyCode))"
        valueLabel.text = "\(total)"
    }
    
}
