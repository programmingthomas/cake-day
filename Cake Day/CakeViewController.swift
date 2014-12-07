//
//  CakeViewController.swift
//  Cake Day
//
//  Created by Thomas Denney on 07/12/2014.
//  Copyright (c) 2014 Thomas Denney. All rights reserved.
//

import UIKit

class CakeViewController: UIViewController {

    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cakeView: CakeView!
    @IBOutlet weak var countdownLabel: UILabel!
    
    var user: User?
    
    var shareActionSheet: UIActionSheet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = user {
            title = user.username
            cakeView.hidden = false
            countdownLabel.hidden = false
            
            updateTimer()
            NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateTimer"), userInfo: nil, repeats: true)
        } else {
            title = ""
            cakeView.hidden = true
            countdownLabel.hidden = true
            
            //Do navigation
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func shareTapped(sender: AnyObject) {
        if let user = user {
            let title = NSLocalizedString("share", comment: "")
            let shareText = NSLocalizedString("share.text", comment: "")
            let shareCake = NSLocalizedString("share.cake", comment: "")
            let cancel = NSLocalizedString("cancel", comment: "")
            
            let controller = UIAlertController(title: title, message: nil, preferredStyle: .ActionSheet)
            
            let formatString = NSLocalizedString("share.string", comment: "");
            let interval = formatDurationString(user.timeIntervalToNextCakeDay())
            let usernameWithApostrophe = user.usernameWithApostrophe;
            
            var shareString = String(format:formatString, arguments: [interval, usernameWithApostrophe])
            
            controller.addAction(UIAlertAction(title: shareText, style: .Default, handler: { action in
                let shareController = UIActivityViewController(activityItems: [shareString], applicationActivities: nil)
                shareController.popoverPresentationController?.barButtonItem = self.shareButton
                self.presentViewController(shareController, animated: true, completion: nil)
            }))
            
            controller.addAction(UIAlertAction(title: shareCake, style: .Default, handler: { action in
                NSOperationQueue().addOperationWithBlock {
                    //Good size for Instagram
                    UIGraphicsBeginImageContextWithOptions(CGSizeMake(612, 612), false, 0);
                    self.cakeView.drawRect(CGRect(x: 0, y: 0, width: 612, height: 612));
                    let image = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    
                    NSOperationQueue.mainQueue().addOperationWithBlock {
                        let shareController = UIActivityViewController(activityItems: [shareString, image], applicationActivities: nil)
                        shareController.popoverPresentationController?.barButtonItem = self.shareButton
                        self.presentViewController(shareController, animated: true, completion: nil)
                    }
                }
            }))
            
            controller.addAction(UIAlertAction(title: cancel, style: .Cancel, handler: { (action) in }))
            
            controller.popoverPresentationController?.barButtonItem = self.shareButton
            
            presentViewController(controller, animated: true, completion: nil)
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
