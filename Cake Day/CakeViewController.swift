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
    @IBOutlet weak var cakeView: CDCakeView!
    @IBOutlet weak var countdownLabel: UILabel!
    
    var user: User?
    
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
    }

    func updateTimer() {
        if let user = self.user {
            //This wins the award for the most readable line of code ever written!
            cakeView.candles = UInt(user.yearsOld)
            
            let formatString = NSLocalizedString("cakeday.next", comment: "")
            let toNext = String(format: formatString, arguments: [CDUtility.durationString(user.timeIntervalToNextCakeDay())])
            
            let formattedCakeDay = NSDateFormatter.localizedStringFromDate(user.originalCakeDay, dateStyle: .ShortStyle, timeStyle: .NoStyle)
            
            let sinceFormatString = NSLocalizedString("user.age", comment: "")
            let since = String(format: sinceFormatString, arguments: [formattedCakeDay])
            
            let message = toNext + "\n" + since
            
            countdownLabel.text = message
        }
    }
}
