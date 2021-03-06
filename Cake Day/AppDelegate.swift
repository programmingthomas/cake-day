//
//  AppDelegate.swift
//  Cake Day
//
//  Created by Thomas Denney on 07/12/2014.
//  Copyright (c) 2014 Thomas Denney. All rights reserved.
//

import UIKit
import CoreText

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {
    
    var window: UIWindow?
    var userManager: UserManager?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        
        //Register font
        let url = NSBundle.mainBundle().URLForResource("OpenSans-Regular", withExtension: "ttf")!
        CTFontManagerRegisterFontsForURL(url, CTFontManagerScope.None, nil)
        
        let window = self.window!
        //Configure the split view controller
        let splitViewController = window.rootViewController! as! UISplitViewController
        let navigationController = splitViewController.viewControllers.last! as! UINavigationController
        
        navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem()
        splitViewController.delegate = self
        
        let primaryNavController = splitViewController.viewControllers.first! as! UINavigationController
        
        userManager = UserManager.sharedManager
        
        let listVC = primaryNavController.viewControllers.first! as! UserListViewController
        listVC.userManager = userManager
        
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Sound, .Badge], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        
        //Configure appearance
        UINavigationBar.appearance().tintColor = UIColor(hue: 224.0 / 360.0, saturation: 0.56, brightness: 0.51, alpha: 1)
        let titleTextAttributes = [NSFontAttributeName: UIFont(name: "OpenSans", size: 18)!]
        UINavigationBar.appearance().titleTextAttributes = titleTextAttributes
        UILabel.appearance().font = UIFont(name: "OpenSans", size: 17)
        UIBarButtonItem.appearance().setTitleTextAttributes(titleTextAttributes, forState: .Normal)
        //Stupid hack to get the font appearing nicely when contained in table header/footer
        AppearanceBridge.configureLabel()
        
        return true
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        if application.applicationState == .Active {
            let title = NSLocalizedString("notification.title", comment: "")
            let ok = NSLocalizedString("ok", comment: "")
            
            let alert = UIAlertView(title: title, message: notification.alertBody, delegate: nil, cancelButtonTitle: ok)
            alert.show()
        }
    }
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        if secondaryViewController.isKindOfClass(UINavigationController) {
            let secondaryNavController = secondaryViewController as! UINavigationController
            if secondaryNavController.topViewController!.isKindOfClass(CakeViewController) {
                let cakeVC = secondaryNavController.topViewController as! CakeViewController

                if let _ = cakeVC.user {
                    return false
                } else {
                    return true
                }
            }
        }
        return false
    }
}
