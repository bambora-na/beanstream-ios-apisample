//
//  UserData.swift
//  GoldenEggs
//
//  Created by Sven Resch on 2015-12-30.
//  Copyright © 2015 Beanstream Internet Commerce, Inc. All rights reserved.
//
// Some application data needs to be shared app wide, like the users
// session, and so it makes sense to use a Singleton for this use case.
//

class UserData {
    
    static let sharedInstance = UserData()
    
    var session: Session? {
        didSet {
            NSNotificationCenter.defaultCenter().postNotificationName(
                Constants.Notifications.sessionChangedNotification, object: self.session)
        }
    }
    
    // Made private to enforce Singleton pattern usage
    private init() {
        
    }

}
