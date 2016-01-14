//
//  LineItem.swift
//  GoldenEggs
//
//  Created by Sven Resch on 2015-12-23.
//  Copyright © 2015 Beanstream Internet Commerce, Inc. All rights reserved.
//

import Money

struct LineItem {
    
    var product: Product?
    var quantity = 0
    var total: Money {
        if let product = product {
            return product.price * quantity;
        }
        else {
            return 0
        }
    }
    
}
