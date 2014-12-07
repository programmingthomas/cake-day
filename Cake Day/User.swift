//
//  User.swift
//  Cake Day
//
//  Created by Thomas Denney on 07/12/2014.
//  Copyright (c) 2014 Thomas Denney. All rights reserved.
//

import UIKit
import SQLite

class UserManager {
    var database: Database
    var users: Query
    var ID: Expression<Int>
    var username: Expression<String?>
    var cakeDay: Expression<Double?>
    
    init() {
        let directories = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documents = directories[0] as String
        
        database = Database(documents.stringByAppendingPathComponent("database.db"))
        
        users = database["users"]
        ID = Expression<Int>("id")
        username = Expression<String?>("username")
        cakeDay = Expression<Double?>("cakeday")
        
        database.create(table:users) { t in
            t.column(self.ID, primaryKey: true)
            t.column(self.username)
            t.column(self.cakeDay)
        }
    }
    
    class var sharedManager: UserManager {
        struct Static {
            static let manager = UserManager()
        }
        
        return Static.manager
    }
}

class User: NSObject {
    var databaseID: Int
    var username: String
    var originalCakeDay: NSDate
    
    init(databaseID: Int, username: String, cakeDay: NSDate) {
        self.databaseID = databaseID
        self.username = username
        self.originalCakeDay = cakeDay
        
        super.init()
        
        scheduleNewNotification()
    }
    
    func nextCakeDay() -> NSDate {
        return self.originalCakeDay.nextDate()
    }
    
    func timeIntervalToNextCakeDay() -> NSTimeInterval {
        return self.nextCakeDay().timeIntervalSinceNow
    }
    
    var usernameWithApostrophe: String {
        get {
            if self.username.hasSuffix("s") {
                return self.username + "'"
            } else {
                return self.username + "'s"
            }
        }
    }
    
    // MARK: - Notification management
    
    var notificationID: String {
        get {
            return "cakeday-\(databaseID)"
        }
    }
    
    var localNotification: UILocalNotification {
        get {
            if let note = NotificationManager.manager()[notificationID] {
                return note
            } else {
                return scheduleNewNotification()
            }
        }
    }
    
    private func scheduleNewNotification() -> UILocalNotification {
        let manager = NotificationManager.manager()
        
        //Cancel any existing notifications
        manager.cancelNotificationWithUID(notificationID)
        
        //Create new notification obejct
        let notification = UILocalNotification()
        notification.fireDate = nextCakeDay()
        notification.repeatInterval = .YearCalendarUnit
        
        //Used localised notification body
        notification.alertBody = NSString(format: NSLocalizedString("notification.message", tableName: nil, bundle: NSBundle.mainBundle(), value: "", comment: ""), usernameWithApostrophe)
        notification.timeZone = NSTimeZone.systemTimeZone()
        notification.soundName = UILocalNotificationDefaultSoundName
        
        //Schedules the notification
        manager[notificationID] = notification
        
        return notification
    }
}
