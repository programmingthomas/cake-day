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
#import "CDCakeView.h"

@interface CDCakeViewController : UIViewController<UIActionSheetDelegate>

@property (nonatomic) CDUser * user;

@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;
@property (weak, nonatomic) IBOutlet CDCakeView *cakeView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;

@property UIActionSheet * shareActionSheet;

- (IBAction)shareTapped:(id)sender;

@property NSTimer * timer;



@end
