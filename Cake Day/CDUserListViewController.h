//
//  CDUserListViewController.h
//  Cake Day
//
//  Created by Thomas Denney on 25/08/2013.
//  Copyright (c) 2013 Thomas Denney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDUtility.h"
#import "CDUser.h"
#import "CDImages.h"

@protocol MasterViewDelegate <NSObject>

-(void)userDeleted:(CDUser*)user;
-(void)userSelected:(CDUser*)user;

@end

@interface CDUserListViewController : UITableViewController<UIAlertViewDelegate>

@property (nonatomic) FMDatabase * database;
@property NSMutableArray * users;

@property UIAlertView * addUserAlert;

@property id<MasterViewDelegate> masterViewDelegate;
- (IBAction)addTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rateButton;
- (IBAction)rateAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;

@end
