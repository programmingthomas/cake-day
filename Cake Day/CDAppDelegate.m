//
//  CDAppDelegate.m
//  Cake Day
//
//  Created by Thomas Denney on 25/08/2013.
//  Copyright (c) 2013 Thomas Denney. All rights reserved.
//

#import "CDAppDelegate.h"
#import "CDUserListViewController.h"
#import "CDCakeViewController.h"

@interface CDAppDelegate () <UISplitViewControllerDelegate>

@end

@implementation CDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.database = [CDUtility database];
    if ([self.database open]) {
        if (![self.database executeUpdate:@"create table users (id integer primary key autoincrement, username string, cakeday int)"]) {
            NSLog(@"Database create failed = %@", self.database.lastErrorMessage);
        }
        [self.database close];
    }
    
    //Configuration of split view controller
    UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
    UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
    navigationController.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem;
    splitViewController.delegate = self;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    UINavigationController * primaryNavController = [splitViewController.viewControllers firstObject];
    
    CDUserListViewController * viewController = (CDUserListViewController*)[primaryNavController.childViewControllers firstObject];
    viewController.database = self.database;
    
    //In iOS 8 and above you have to first get permission from the user to send notifications
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings * settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    if ([application applicationState] == UIApplicationStateActive) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Cake day!" message:notification.alertBody delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [self.database close];
}

#pragma mark - Split view

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    if ([secondaryViewController isKindOfClass:[UINavigationController class]] && [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[CDCakeViewController class]] && ([(CDCakeViewController *)[(UINavigationController *)secondaryViewController topViewController] user] == nil)) {
        // Return YES to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
        return YES;
    }
    else {
        return NO;
    }
}

@end
