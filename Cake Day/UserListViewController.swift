//
//  UserListViewController.swift
//  Cake Day
//
//  Created by Thomas Denney on 07/12/2014.
//  Copyright (c) 2014 Thomas Denney. All rights reserved.
//

import UIKit

class UserListViewController: UITableViewController {
    
    var userManager: UserManager?
    var users: [User]?
    
    lazy var operationManager: AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var rateButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = NSLocalizedString("app.name", comment:"")
        self.addButton.accessibilityLabel = NSLocalizedString("user.add", comment: "")
        self.rateButton.accessibilityLabel = NSLocalizedString("app.rate", comment: "")
        
        
        update()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.users?.count == 0 {
//            addTapped(self)
        }
    }
    
    func update() {
        self.users = sortUsersByCurrentDate(self.userManager!.allUsers())
    }
    
    /**
    When we show the list of users we want to display them in order they are coming up. For example, if the date is the 7th December, we want to display users with cake days between December 7th and December 31st first, and then the remainder from January onwards through the year. To do this you just do a simple binary search to find the first cake day >= the current day in the year
    */
    func sortUsersByCurrentDate(users: [User]) -> [User] {
        let start = 0
        let partitionIndex = positionOfFirstCakeDayAfterCurrentDate(users)
        let end = users.count
        let datesAfter = Array(users[partitionIndex..<end])
        let datesBefore = Array(users[start..<partitionIndex])
        return datesAfter + datesBefore
    }
    
    func positionOfFirstCakeDayAfterCurrentDate(users: [User]) -> Int {
        if users.count == 0 {
            return 0
        }
        
        var low = 0
        var high = users.count - 1
        let current = NSDate()
        
        while low <= high {
            let mid = (low + high) / 2;
            
            let user = users[mid]
            
            let compare = user.originalCakeDay.compareOrderInYear(current)
            if compare == .OrderedDescending || compare == .OrderedSame {
                high = mid - 1
            }
            else {
                low = mid + 1
            }
        }
        
        return low
    }
    
    // MARK: - Table view delegate
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        //Inefficient to recreate this every time
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM d"
        
        let user = users![indexPath.row]
        
        cell.textLabel.text = user.username
        cell.detailTextLabel?.text = dateFormatter.stringFromDate(user.originalCakeDay).uppercaseString
        
        //Fonts
        cell.textLabel.font = UIFont(name: "OpenSans", size: 17)
        cell.detailTextLabel?.font = UIFont(name: "OpenSans", size: 14)
        
        //Colors
        cell.detailTextLabel?.textColor = UIColor.darkGrayColor()
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let user = users![indexPath.row]
            userManager!.deleteUser(user)
            update()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    @IBAction func addTapped(sender: AnyObject) {
        let title = NSLocalizedString("user.add", comment: "")
        let message = NSLocalizedString("user.add.message", comment: "")
        let add = NSLocalizedString("add", comment: "")
        let cancel = NSLocalizedString("cancel", comment: "")
        
        let addUser = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        addUser.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = NSLocalizedString("username", comment: "")
        }
        
        addUser.addAction(UIAlertAction(title: cancel, style: .Cancel, handler: { _ in }))
        
        addUser.addAction(UIAlertAction(title: add, style: .Default, handler: { _ in
            let textfield = addUser.textFields![0] as UITextField
            self.addUserForName(textfield.text)
        }))
        
        presentViewController(addUser, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let users = users {
            if segue.identifier == "userSegue" {
                let nav = segue.destinationViewController as! UINavigationController
                //Won't work in Swift yet
                let detailVC = nav.childViewControllers.first! as CakeViewController
                detailVC.user = users[tableView.indexPathForSelectedRow()!.row]
                
                detailVC.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                detailVC.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    // MARK: - Add users
    
    func addUserForName(username: String) {
        let username = username.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        userManager?.userFromReddit(username, success: { user in
            self.update()
            self.tableView.reloadData()
            self.showUserForName(user.username)
        }, failure: {
            self.usernameError(username)
        }, manager: self.operationManager)
    }
    
    func showUserForName(username: String) -> Bool {
        if let users = self.users {
            for (index, user) in users.enumerate() {
                if user.username == username {
                    let indexPath = NSIndexPath(forRow: index, inSection: 0)
                    self.tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: .Middle)
                    self.performSegueWithIdentifier("userSegue", sender: self)
                    return true
                }
            }
        }
        return false
    }
    
    func usernameError(username: String) {
        let title = NSLocalizedString("user.failed", comment: "")
        let formatString = NSLocalizedString("user.failed.message", comment: "")
        let message = String(format: formatString, arguments: [username])
        let ok = NSLocalizedString("ok", comment: "");
        
        let alert = UIAlertView(title:title, message:message, delegate:nil, cancelButtonTitle:ok)
        alert.show()
    }
}
