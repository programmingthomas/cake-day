//
//  NotificationManager.swift
//  Cake Day
//
//  Created by Thomas Denney on 07/12/2014.
//  Copyright (c) 2014 Thomas Denney. All rights reserved.
//

import UIKit

private let _sharedNotificationManager = NotificationManager()

/**
This class provides an easy way to access notifications with a given identifier
*/
class NotificationManager: NSObject {
    class func manager() -> NotificationManager {
        return _sharedNotificationManager
    }
    
    func allScheduledNotifications() -> [UILocalNotification] {
        return UIApplication.sharedApplication().scheduledLocalNotifications! as [UILocalNotification]
    }
    
    func notificationsWithUID(uid: String) -> [UILocalNotification] {
        return allScheduledNotifications().filter{ note in
            let userInfo = note.userInfo!
            let notificationUID = userInfo["uid"] as! String
            return notificationUID == uid
        }
    }
    
    func cancelNotificationWithUID(uid: String) {
        for note in notificationsWithUID(uid) {
            UIApplication.sharedApplication().cancelLocalNotification(note)
        }
    }
    
    subscript(uid: String) -> UILocalNotification? {
        get {
            return notificationsWithUID(uid).first
        }
        set (newNotification) {
            if let note = newNotification {
                //Cancel any existing notifications so it can be replaced nicely
                cancelNotificationWithUID(uid)
                
                note.userInfo = ["uid":uid]
                UIApplication.sharedApplication().scheduleLocalNotification(note)
            }
        }
    }
}
