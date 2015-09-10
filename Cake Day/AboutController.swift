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
let sectionTitles = [["Cake Day", "AFNetworking", "FormatterKit", "FMDB"], ["Developer site", "Support"], ["Rate this app"]]
let sectionURLs = [["https://github.com/programmingthomas/cake-day", "https://github.com/afnetworking/afnetworking", "https://github.com/mattt/FormatterKit", "https://github.com/ccgus/fmdb"], ["http://programmingthomas.com", "http://programmingthomas.com/contact"],
    ["https://itunes.apple.com/us/app/cake-day/id694043166?ls=1&mt=8"]]


class AboutController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionTitles[section].count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel!.text = sectionTitles[indexPath.section][indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NSLocalizedString(sectionHeaders[section], comment: "")
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return NSLocalizedString(sectionFooters[section], comment: "")
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        openURL(sectionURLs[indexPath.section][indexPath.row])
    }
    
    func openURL(address: String) {
        let url = NSURL(string: address)!
        UIApplication.sharedApplication().openURL(url)
    }
    
    @IBAction func doneTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
