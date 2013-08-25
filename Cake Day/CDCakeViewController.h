//
//  CDCakeViewController.h
//  Cake Day
//
//  Created by Thomas Denney on 25/08/2013.
//  Copyright (c) 2013 Thomas Denney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlatUIKit.h"

@protocol CakeDelegate <NSObject>

-(void)menuTapped;

@end

@interface CDCakeViewController : UIViewController

@property id<CakeDelegate> cakeDelegate;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButton;
@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;
- (IBAction)menuTapped:(id)sender;

@end
