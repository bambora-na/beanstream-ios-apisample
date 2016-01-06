//
//  TaxItemTableViewCell.swift
//  GoldenEggs
//
//  Created by Sven Resch on 2015-12-23.
//  Copyright © 2015 Beanstream Internet Commerce, Inc. All rights reserved.
//

import UIKit
import Money

class TaxItemTableViewCell: UITableViewCell {

    @IBOutlet private weak var taxNameLabel: UILabel!
    @IBOutlet private weak var taxTotalLabel: UILabel!
 
    func setTaxTotal(taxLabel labelText: String, total: Money) {
        taxNameLabel.text = labelText
        taxTotalLabel.text = "\(total)"
    }

}
