//
//  UserListDataSource.swift
//  Cake Day
//
//  Created by Thomas Denney on 07/12/2014.
//  Copyright (c) 2014 Thomas Denney. All rights reserved.
//

import UIKit

class UserListDataSource: NSObject, UITableViewDataSource {
    private var _users: [User]
    
    var users: [User] {
        get {
            return _users
        }
    }
    
    init(users: [User]) {
        _users = users
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
    
        //Inefficient to recreate this every time
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .NoStyle
        
        let user = users[indexPath.row]
        
        cell.textLabel.text = user.username
        cell.detailTextLabel?.text = dateFormatter.stringFromDate(user.originalCakeDay)
        
        return cell
    }
}
