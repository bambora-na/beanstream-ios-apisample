//
//  APIHelper.swift
//  GoldenEggs
//
//  Created by Sven Resch on 2016-01-07.
//  Copyright © 2016 Beanstream Internet Commerce, Inc. All rights reserved.
//

class APIHelper {
    
    //static let api = BICBeanstreamAPI()
    static let api = BICBeanstreamAPISimulator()

    private var once = dispatch_once_t()
    
    init () {
        dispatch_once(&once) {
            //NSUserDefaults.standardUserDefaults().setObject("stableweb01", forKey: "bicSubdomainDev")
        }
    }
    
}
