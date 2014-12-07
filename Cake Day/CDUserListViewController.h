//
//  CDUserListViewController.h
//  Cake Day
//
//  Created by Thomas Denney on 25/08/2013.
//  Copyright (c) 2013 Thomas Denney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDUtility.h"

#import "CDUserListDataSource.h"

#import "Cake_Day-Swift.h"

@interface CDUserListViewController : UITableViewController<UIAlertViewDelegate>

@property (nonatomic) UserManager * userManager;
@property NSArray * users;

@property UIAlertView * addUserAlert;

- (IBAction)addTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rateButton;
- (IBAction)rateAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;

@end
