//
//  SessionExtensions.swift
//  GoldenEggs
//
//  Created by Sven Resch on 2015-12-30.
//  Copyright © 2015 Beanstream Internet Commerce, Inc. All rights reserved.
//

extension Session {
    // Implements a Decorator to help represent a Session data model 
    // in a more end user & table friendly manner.
    func bic_tableRepresentation() -> (titles:[String], values:[String]) {
        return (
            ["Username", "Email", "Company", "Company Phone", "Currency"],
            [username, userEmail, companyName, companyPhone, currencyType])
    }
}
