//
//  AboutController.swift
//  Cake Day
//
//  Created by Thomas Denney on 11/12/2014.
//  Copyright (c) 2014 Thomas Denney. All rights reserved.
//

import UIKit

let sectionHeaders = ["Open Source", "Support", "Share"]
let sectionFooters = ["footer.opensource", "footer.support", "footer.share"]
let sections = [
    ["Cake Day": "https://github.com/programmingthomas/cake-day",
        "AFNetworking": "https://github.com/afnetworking/afnetworking",
        "FormatterKit": "https://github.com/mattt/FormatterKit",
        "SQLite.swift": "https://github.com/stephencelis/SQLite.swift"],
    ["Developer site":"http://programmingthomas.com",
     "Support":"http://programmingthomas.com/contact"],
    ["Rate this app": "https://itunes.apple.com/us/app/cake-day/id694043166?ls=1&mt=8"]
]

class AboutController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel.text = sections[indexPath.section].keys.array[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NSLocalizedString(sectionHeaders[section], comment: "")
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return NSLocalizedString(sectionFooters[section], comment: "")
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        openURL(sections[indexPath.section].values.array[indexPath.row])
    }
    
    func openURL(address: String) {
        let url = NSURL(string: address)!
        UIApplication.sharedApplication().openURL(url)
    }
    
    @IBAction func doneTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
