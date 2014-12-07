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
    var dataSource: UserListDataSource?
    
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
    
    func update() {
        self.users = sortUsersByCurrentDate(self.userManager!.allUsers())
        
        self.dataSource = UserListDataSource(users: self.users!)
        self.tableView.dataSource = self.dataSource!
        
        self.tableView.reloadData()
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
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let user = users![indexPath.row]
            userManager!.deleteUser(user)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            update()
        }
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
    
    @IBAction func rateTapped(sender: AnyObject) {
        //TODO: - Make sure that this plays nicely on iOS 8
        let url = NSURL(string: "https://itunes.apple.com/us/app/cake-day/id694043166?ls=1&mt=8")!
        UIApplication.sharedApplication().openURL(url)
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let users = users {
            if segue.identifier == "userSegue" {
                let nav = segue.destinationViewController as UINavigationController
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
            self.showUserForName(user.username)
        }, failure: {
            self.usernameError(username)
        }, manager: self.operationManager)
    }
    
    func showUserForName(username: String) -> Bool {
        if let users = self.users {
            for (index, user) in enumerate(users) {
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
