//
//  User.swift
//  Cake Day
//
//  Created by Thomas Denney on 07/12/2014.
//  Copyright (c) 2014 Thomas Denney. All rights reserved.
//

import UIKit

class UserManager: NSObject {
    var dbBridge: DatabaseBridge
    
    override init() {
        self.dbBridge = DatabaseBridge()
        super.init()
    }
    
    class var sharedManager: UserManager {
        struct Static {
            static let manager = UserManager()
        }
        
        return Static.manager
    }
    
    func allUsers() -> [User] {
        var users = dbBridge.allUsers() as! [User]
        
        users.sortInPlace { (left, right) -> Bool in
            let order = left.originalCakeDay.compareOrderInYear(right.originalCakeDay)
            return order == .OrderedAscending || order == .OrderedSame
        }
        
        return users
    }
    
    func userWithUsername(username: String) -> User? {
        return dbBridge.userForUsername(username)
    }
    
    func insert(user: User) {
        dbBridge.insertUser(user);
    }
    
    func deleteUser(user: User) {
        dbBridge.deleteUser(user);
    }
    
    func userFromReddit(username: String, success: User -> Void, failure: Void -> Void, manager: AFHTTPRequestOperationManager) {
        //Firstly check to see if the user exists
        if let user = userWithUsername(username) {
            success(user)
            return
        }
        
        //Now just do the JSON request to reddit using AFNetworking
        let userAgent = "cakeday/1.0 by /u/ProgrammingThomas"
        let urlString = "https://reddit.com/user/\(username)/about.json"
        let url = NSURL(string: urlString)!
        
        let request = NSMutableURLRequest(URL: url)
        request.addValue(userAgent, forHTTPHeaderField: "User-Agent")
        
        let operation = AFHTTPRequestOperation(request: request)
        operation.responseSerializer = AFJSONResponseSerializer()
        
        operation.setCompletionBlockWithSuccess({ (operation, responseObject) -> Void in
            let json = responseObject as! NSDictionary
            if json["error"] != nil {
                failure()
            } else {
                let data = json["data"]! as! NSDictionary
                let username = data["name"]! as! String
                let createdUTC = data["created_utc"] as! NSNumber
                
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

@objc class User: NSObject, CustomDebugStringConvertible {
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
        let components = calendar.components(NSCalendarUnit.Year, fromDate: originalCakeDay, toDate: NSDate(), options: NSCalendarOptions())
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
        notification.repeatInterval = NSCalendarUnit.NSYearCalendarUnit
        
        //Used localised notification body
        notification.alertBody = NSString(format: NSLocalizedString("notification.message", tableName: nil, bundle: NSBundle.mainBundle(), value: "", comment: ""), usernameWithApostrophe) as String
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
