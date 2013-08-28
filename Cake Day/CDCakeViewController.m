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
    [self.navigationController.navigationBar setTintColor:[UIColor belizeHoleColor]];
    [self.navigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor cloudsColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{UITextAttributeFont: [UIFont boldFlatFontOfSize:0],UITextAttributeTextColor: [UIColor belizeHoleColor],UITextAttributeTextShadowColor: [UIColor clearColor],UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero]}];
    [CDUtility configureBarButtonItem:self.menuButton];
    [CDUtility configureBarButtonItem:self.shareButton];
    
    self.countdownLabel.font = [UIFont flatFontOfSize:16];
    self.countdownLabel.textColor = [UIColor midnightBlueColor];

    self.menuButton.image = [CDImages imageForSize:CGSizeMake(20, 20) andName:@"hamburger"];
}

- (IBAction)shareTapped:(id)sender
{
    self.shareActionSheet = [[UIActionSheet alloc] initWithTitle:@"Share" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Share text", @"Share cake", nil];
    [self.shareActionSheet showFromBarButtonItem:self.shareButton animated:YES];
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
        self.title = self.navigationItem.title = user.username;
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
        self.countdownLabel.text = [NSString stringWithFormat:@"%@\n%@ to next cake day!\nredditor since %@", self.user.username, [CDUtility durationString:[self.user timeToCakeDay]], [NSDateFormatter localizedStringFromDate:self.user.cakeDay dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle]];
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
