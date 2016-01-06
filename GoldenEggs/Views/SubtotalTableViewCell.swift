//
//  SubtotalTableViewCell.swift
//  GoldenEggs
//
//  Created by Sven Resch on 2015-12-23.
//  Copyright © 2015 Beanstream Internet Commerce, Inc. All rights reserved.
//

import UIKit
import Money

class SubtotalTableViewCell: UITableViewCell {

    @IBOutlet private weak var subtotalLabel: UILabel!

    func setSubtotal(subtotal: Money) {
        subtotalLabel.text = "\(subtotal)"
    }
}
