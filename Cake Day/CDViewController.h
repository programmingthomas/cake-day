//
//  CDViewController.h
//  Cake Day
//
//  Created by Thomas Denney on 25/08/2013.
//  Copyright (c) 2013 Thomas Denney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDUtility.h"
#import "CDUserListViewController.h"
#import "CDCakeViewController.h"

@interface CDViewController : UIViewController<CakeDelegate>

@property FMDatabase * database;

@property BOOL menuVisible;

@property (weak, nonatomic) IBOutlet UIView *cakeViewContainer;

@property CDUserListViewController * userListViewController;
@property CDCakeViewController * cakeViewController;

@end
