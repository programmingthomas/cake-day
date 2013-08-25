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
        } completion:^(BOOL finished) {
            self.menuVisible = YES;
        }];
    }
}

@end
