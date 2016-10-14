//
//  APIHelper.swift
//  GoldenEggs
//
//  Created by Sven Resch on 2016-01-07.
//  Copyright © 2016 Beanstream Internet Commerce, Inc. All rights reserved.
//

class APIHelper {
    
    /* Comment out one of the lines below to switch between simulator and api */
    
    //static let api: BICBeanstreamAPI = BICBeanstreamAPI()
    static let api = BICBeanstreamAPISimulator()
}
