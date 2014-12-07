//
//  CakeViewController.swift
//  Cake Day
//
//  Created by Thomas Denney on 07/12/2014.
//  Copyright (c) 2014 Thomas Denney. All rights reserved.
//

import UIKit

class CakeViewController: UIViewController, UIActionSheetDelegate {

    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cakeView: CDCakeView!
    @IBOutlet weak var countdownLabel: UILabel!
    
    var user: User?
    
    var shareActionSheet: UIActionSheet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTimer()
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateTimer"), userInfo: nil, repeats: true)
        title = user?.username
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func shareTapped(sender: AnyObject) {
        let title = NSLocalizedString("share", comment: "")
        let shareText = NSLocalizedString("share.text", comment: "")
        let shareCake = NSLocalizedString("share.cake", comment: "")
        let cancel = NSLocalizedString("cancel", comment: "")
        
        let actionSheet = UIActionSheet(title: title, delegate: self, cancelButtonTitle: cancel, destructiveButtonTitle: nil)
        actionSheet.addButtonWithTitle(shareText)
        actionSheet.addButtonWithTitle(shareCake)
        
        shareActionSheet = actionSheet
        
        actionSheet.showFromBarButtonItem(self.shareButton, animated: true)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if actionSheet == shareActionSheet {
            let formatString = NSLocalizedString("share.string", comment: "");
            let interval = formatDurationString(user!.timeIntervalToNextCakeDay());
            let usernameWithApostrophe = user!.usernameWithApostrophe;
            
            let shareString = NSString(format:formatString, [interval, usernameWithApostrophe]);
            
            if buttonIndex == 1 {
                let shareController = UIActivityViewController(activityItems: [shareString], applicationActivities: nil)
                presentViewController(shareController, animated: true, completion: nil)
            }
            else if buttonIndex == 2 {
                NSOperationQueue().addOperationWithBlock {
                    //Good size for Instagram
                    UIGraphicsBeginImageContextWithOptions(CGSizeMake(612, 612), false, 0);
                    self.cakeView.drawRect(CGRect(x: 0, y: 0, width: 612, height: 612));
                    let image = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    
                    NSOperationQueue.mainQueue().addOperationWithBlock {
                        let shareController = UIActivityViewController(activityItems: [shareString, image], applicationActivities: nil)
                        self.presentViewController(shareController, animated: true, completion: nil)
                    }
                }
            }
        }
    }

    func updateTimer() {
        if let user = self.user {
            //This wins the award for the most readable line of code ever written!
            cakeView.candles = UInt(user.yearsOld)
            
            let formatString = NSLocalizedString("cakeday.next", comment: "")
            let toNext = String(format: formatString, arguments: [formatDurationString(user.timeIntervalToNextCakeDay())])
            
            let formattedCakeDay = NSDateFormatter.localizedStringFromDate(user.originalCakeDay, dateStyle: .ShortStyle, timeStyle: .NoStyle)
            
            let sinceFormatString = NSLocalizedString("user.age", comment: "")
            let since = String(format: sinceFormatString, arguments: [formattedCakeDay])
            
            let message = toNext + "\n" + since
            
            countdownLabel.text = message
        }
    }
    
    lazy var intervalFormatter = TTTTimeIntervalFormatter()
    
    func formatDurationString(duration: NSTimeInterval) -> String {
        intervalFormatter.numberOfSignificantUnits = 0
        return intervalFormatter.stringForTimeInterval(duration)
    }
}
