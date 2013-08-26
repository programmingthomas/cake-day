//
//  CDCakeViewController.m
//  Cake Day
//
//  Created by Thomas Denney on 25/08/2013.
//  Copyright (c) 2013 Thomas Denney. All rights reserved.
//

#import "CDCakeViewController.h"

@interface CDCakeViewController ()

@end

@implementation CDCakeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationBar configureFlatNavigationBarWithColor:[UIColor wetAsphaltColor]];
    [self.menuButton configureFlatButtonWithColor:[UIColor belizeHoleColor] highlightedColor:[UIColor peterRiverColor] cornerRadius:5];
    self.countdownLabel.font = [UIFont flatFontOfSize:16];
    self.countdownLabel.textColor = [UIColor midnightBlueColor];

    self.menuButton.image = [CDImages imageForSize:CGSizeMake(20, 20) andName:@"hamburger"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)menuTapped:(id)sender
{
    [self.detailViewDelegate showMenu];
}

-(void)setUser:(CDUser *)user
{
    if (_user != user)
    {
        _user = user;
        if (_user == nil)
        {
            [self.detailViewDelegate hideDetailView];
        }
        self.title = self.navItem.title = user.username;
        [self updateTime];
        if (self.timer == nil)
        {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
        }
    }
}

-(void)updateTime
{
    if (self.user != nil)
    {
        //This wins the award for the most readable line of code ever written!
        self.cakeView.candles = self.user.yearsOld;
        NSTimeInterval timeToNextCakeDay = [self.user timeToCakeDay];
        self.countdownLabel.text = [NSString stringWithFormat:@"%@\n%@ to next cake day!\nredditor since %@", self.user.username, [CDUtility durationString:timeToNextCakeDay], [NSDateFormatter localizedStringFromDate:self.user.cakeDay dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle]];
    }
}

@end
