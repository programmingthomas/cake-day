//
//  User.swift
//  Cake Day
//
//  Created by Thomas Denney on 07/12/2014.
//  Copyright (c) 2014 Thomas Denney. All rights reserved.
//

import UIKit
import SQLite

class UserManager: NSObject {
    var database: Database
    var userTable: Query
    var columnID: Expression<Int>
    var columnUsername: Expression<String>
    var columnCakeDay: Expression<Int>
    
    override init() {
        let directories = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documents = directories[0] as String
        let path = documents.stringByAppendingPathComponent("database.sqlite")
        
        println("Init at \(path)")
        
        database = Database(path)
        
        userTable = database["users"]
        columnID = Expression<Int>("id")
        columnUsername = Expression<String>("username")
        columnCakeDay = Expression<Int>("cakeday")
        
        super.init()
        
        database.trace(println)
        
        database.create(table:userTable, ifNotExists: true) { t in
            t.column(self.columnID, primaryKey: true)
            t.column(self.columnUsername)
            t.column(self.columnCakeDay)
        }
    }
    
    class var sharedManager: UserManager {
        struct Static {
            static let manager = UserManager()
        }
        
        return Static.manager
    }
    
    func allUsers() -> [User] {
        var users = [User]()
        
        for user in userTable {
            let id = user[columnID]
            let username = user[columnUsername]
            let cakeDay = Double(user[columnCakeDay])
            let userObject = User(databaseID: id, username: username, cakeDay: NSDate(timeIntervalSince1970: cakeDay))
            users.append(userObject)
        }
        
        return users
    }
    
    func insert(user: User) {
        let cakeday = Int(user.originalCakeDay.timeIntervalSince1970)
        if let insertedID = userTable.insert(columnUsername <- user.username, columnCakeDay <- cakeday) {
            user.databaseID = insertedID
        }
    }
    
    func deleteUser(user: User) {
        user.cancelLocalNotification()
        userTable.filter(columnID == user.databaseID).delete()?
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
    
    var yearsOld: Int {
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
        let components = calendar.components(NSCalendarUnit.CalendarUnitYear, fromDate: originalCakeDay, toDate: NSDate(), options: NSCalendarOptions.allZeros)
        return components.year
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
    
    func cancelLocalNotification() {
        NotificationManager.manager().cancelNotificationWithUID(notificationID)
    }
}
