//
//  NotificationManager.swift
//  iTunesApp
//
//  Created by Adrian Zghibarta on 12/22/15.
//  Copyright © 2015 Adrian Zghibarta. All rights reserved.
//

import UIKit

/// Basic Notification methods and keys used with NSNotificationCenter
class NotificationManager: NSObject {

    /// This notification key inform about core data changes
    static let NMCoreDataModelUpdateNotificationKey = "NMCoreDataModelUpdateNotification"
    
    /**
     Inform about core data changes
     */
    class func postCoreDataModelUpdateNotification() {
        NSNotificationCenter.defaultCenter().postNotificationName(NMCoreDataModelUpdateNotificationKey, object: nil)
    }
}
