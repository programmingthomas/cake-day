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
        
        database = Database(path)
        
        userTable = database["users"]
        columnID = Expression<Int>("id")
        columnUsername = Expression<String>("username")
        columnCakeDay = Expression<Int>("cakeday")
        
        super.init()
        
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
            users.append(userFromRow(user))
        }
        
        users.sort { (left, right) -> Bool in
            let order = left.originalCakeDay.compareOrderInYear(right.originalCakeDay)
            return order == .OrderedAscending || order == .OrderedSame
        }
        
        return users
    }
    
    func userWithUsername(username: String) -> User? {
        let query = userQuery(username)
        
        if let firstRow = query.first {
            return userFromRow(firstRow)
        }
        
        return nil
    }
    
    func userFromRow(user: Row) -> User {
        let id = user[columnID]
        let username = user[columnUsername]
        let cakeDay = Double(user[columnCakeDay])
        return User(databaseID: id, username: username, cakeDay: NSDate(timeIntervalSince1970: cakeDay))
    }
    
    func userQuery(username: String) -> Query {
        return userTable.filter(columnUsername == username)
    }
    
    func insert(user: User) {
        let cakeday = Int(user.originalCakeDay.timeIntervalSince1970)
        if let insertedID = userTable.insert(columnUsername <- user.username, columnCakeDay <- cakeday) {
            user.databaseID = insertedID
        }
    }
    
    func deleteUser(user: User) {
        user.cancelLocalNotification()
        userQuery(user.username).delete()?
    }
    
    func userFromReddit(username: String, success: User -> Void, failure: Void -> Void, manager: AFHTTPRequestOperationManager) {
        //Firstly check to see if the user exists
        if let user = userWithUsername(username) {
            success(user)
            return
        }
        
        //Now just do the JSON request to reddit using AFNetworking
        let userAgent = "cakeday/1.0 by /u/ProgrammingThomas"
        let urlString = "http://reddit.com/user/\(username)/about.json"
        let url = NSURL(string: urlString)!
        
        let request = NSMutableURLRequest(URL: url)
        request.addValue(userAgent, forHTTPHeaderField: "User-Agent")
        
        let operation = AFHTTPRequestOperation(request: request)
        operation.responseSerializer = AFJSONResponseSerializer()
        
        operation.setCompletionBlockWithSuccess({ (operation, responseObject) -> Void in
            let json = responseObject as NSDictionary
            if json["error"] != nil {
                failure()
            } else {
                let data = json["data"]! as NSDictionary
                let username = data["name"]! as String
                let createdUTC = data["created_utc"] as NSNumber
                
                var user = User(databaseID: 0, username: username, cakeDay: NSDate(timeIntervalSince1970: createdUTC.doubleValue))
                self.insert(user)
                
                success(user)
            }
        }, failure: { (operation, error) in
            failure()
        })
        
        manager.operationQueue.addOperation(operation)
    }
}

class User: NSObject, DebugPrintable {
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
    
    private func existingLocalNotification() -> UILocalNotification? {
        return NotificationManager.manager()[notificationID]
    }
    
    var localNotification: UILocalNotification {
        get {
            if let note = existingLocalNotification() {
                return note
            } else {
                return scheduleNewNotification()
            }
        }
    }
    
    private func scheduleNewNotification() -> UILocalNotification {
        let manager = NotificationManager.manager()
        
        //Create new notification obejct
        var notification = UILocalNotification()
        
        //Test to see if we can get an existing notification instead
        if let n = existingLocalNotification() {
            notification = n
        }
        
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
    
    override var debugDescription: String {
        get {
            return "\(username) \(originalCakeDay)"
        }
    }
}
