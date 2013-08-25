//
//  CDViewController.m
//  Cake Day
//
//  Created by Thomas Denney on 25/08/2013.
//  Copyright (c) 2013 Thomas Denney. All rights reserved.
//

#import "CDViewController.h"

@interface CDViewController ()

@end

@implementation CDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.userListViewController = self.childViewControllers[0];
    self.cakeViewController = self.childViewControllers[1];
    self.userListViewController.database = self.database;
    self.cakeViewController.cakeDelegate = self;
    self.menuVisible = YES;
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnCakeViewController:)];
    [self.cakeViewContainer addGestureRecognizer:tapGesture];
    [self shadowsAndCorners:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tapOnCakeViewController:(id)sender
{
    if (self.menuVisible)
    {
        [UIView animateWithDuration:0.25f animations:^{
            self.cakeViewContainer.frame = self.view.bounds;
            [self shadowsAndCorners:NO];
        } completion:^(BOOL finished) {
            self.menuVisible = NO;
        }];
    }
}

-(void)menuTapped
{
    if (!self.menuVisible)
    {
        [UIView animateWithDuration:0.25f animations:^{
            self.cakeViewContainer.frame = CGRectMake(240, 0, CGRectGetHeight(self.view.bounds), CGRectGetHeight(self.view.bounds));
            [self shadowsAndCorners:YES];
        } completion:^(BOOL finished) {
            self.menuVisible = YES;
        }];
    }
}

-(void)shadowsAndCorners:(BOOL)enabled
{
    self.cakeViewContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    self.cakeViewContainer.layer.shadowOpacity = enabled ? 0.5f : 0;
    self.cakeViewContainer.layer.shadowOffset = CGSizeMake(-5, 0);
}

@end
