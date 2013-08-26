//
//  CDCakeViewController.h
//  Cake Day
//
//  Created by Thomas Denney on 25/08/2013.
//  Copyright (c) 2013 Thomas Denney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDUtility.h"
#import "FlatUIKit.h"
#import "CDUser.h"
#import "Hamburger.h"

@protocol DetailViewDelegate <NSObject>

-(void)showMenu;
-(void)hideDetailView;

@end

@interface CDCakeViewController : UIViewController

@property (nonatomic) CDUser * user;

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButton;
@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;

- (IBAction)menuTapped:(id)sender;

@property NSTimer * timer;
@property id<DetailViewDelegate> detailViewDelegate;



@end
