//
//  CDCakeViewController.h
//  Cake Day
//
//  Created by Thomas Denney on 25/08/2013.
//  Copyright (c) 2013 Thomas Denney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDUtility.h"
#import "CDUser.h"
#import "CDImages.h"
#import "CDCakeView.h"

@protocol DetailViewDelegate <NSObject>

-(void)showMenu;
-(void)showDetailView;
-(void)hideDetailView;

@end

@interface CDCakeViewController : UIViewController<UIActionSheetDelegate>

@property (nonatomic) CDUser * user;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButton;
@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;
@property (weak, nonatomic) IBOutlet CDCakeView *cakeView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;

@property UIActionSheet * shareActionSheet;

- (IBAction)shareTapped:(id)sender;
- (IBAction)menuTapped:(id)sender;

@property NSTimer * timer;
@property id<DetailViewDelegate> detailViewDelegate;



@end
