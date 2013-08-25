//
//  CDUserListViewController.h
//  Cake Day
//
//  Created by Thomas Denney on 25/08/2013.
//  Copyright (c) 2013 Thomas Denney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlatUIKit.h"
#import "CDUtility.h"
#import "CDUser.h"

@interface CDUserListViewController : UITableViewController

@property (nonatomic) FMDatabase * database;
@property NSArray * users;

@end
