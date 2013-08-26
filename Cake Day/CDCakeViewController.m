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
    [self.shareButton configureFlatButtonWithColor:[UIColor belizeHoleColor] highlightedColor:[UIColor peterRiverColor] cornerRadius:5];
    self.countdownLabel.font = [UIFont flatFontOfSize:16];
    self.countdownLabel.textColor = [UIColor midnightBlueColor];

    self.menuButton.image = [CDImages imageForSize:CGSizeMake(20, 20) andName:@"hamburger"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)shareTapped:(id)sender
{
    self.shareActionSheet = [[UIActionSheet alloc] initWithTitle:@"Share" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Share text", @"Share cake", nil];
    [self.shareActionSheet showFromBarButtonItem:self.shareButton animated:YES];
    [self.detailViewDelegate showDetailView];
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

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet == self.shareActionSheet)
    {
        NSString * shareString = [NSString stringWithFormat:@"It is %@ until %@ cake day!", [CDUtility durationString:self.user.timeToCakeDay], [self.user usernameWithApostrophe]];
        if (buttonIndex == 0)
        {
            UIActivityViewController * shareController = [[UIActivityViewController alloc] initWithActivityItems:@[shareString] applicationActivities:nil];
            [self presentViewController:shareController animated:YES completion:nil];
        }
        else if (buttonIndex == 1)
        {
            [[NSOperationQueue new] addOperationWithBlock:^{
                //Good size for Instagram
                UIGraphicsBeginImageContextWithOptions(CGSizeMake(612, 612), NO, 0);
                [self.cakeView drawRect:CGRectMake(0, 0, 612, 612)];
                UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    UIActivityViewController * shareController = [[UIActivityViewController alloc] initWithActivityItems:@[shareString, image] applicationActivities:nil];
                    [self presentViewController:shareController animated:YES completion:nil];
                }];
            }];
        }
    }
}

@end
