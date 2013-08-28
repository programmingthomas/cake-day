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
    
    self.menuVisible = YES;
    self.view.backgroundColor = [UIColor midnightBlueColor];
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnCakeViewController:)];
    [self.cakeViewContainer addGestureRecognizer:tapGesture];
    
    UINavigationController * firstChildNavigationController = (UINavigationController*)self.childViewControllers[0];
    UINavigationController * secondChildNavigationController = (UINavigationController*)self.childViewControllers[1];
    
    self.userListViewController = firstChildNavigationController.childViewControllers[0];
    self.cakeViewController = secondChildNavigationController.childViewControllers[0];
    
    self.userListViewController.masterViewDelegate = self;
    self.userListViewController.database = self.database;
    
    self.cakeViewController.detailViewDelegate = self;
}

-(void)viewDidAppear:(BOOL)animated
{
    if (self.userListViewController.users.count > 0 && self.menuVisible)
    {
        [self userSelected:self.userListViewController.users[0]];
    }
    else
    {
        [self hideDetailView];
    }
}

-(void)viewDidLayoutSubviews
{
    if (self.menuVisible)
    {
        [self showMenu];
    }
    else
    {
        self.cakeViewContainer.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
        self.menuVisible = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Model update methods

-(void)userDeleted:(CDUser*)user
{
    if (user == self.cakeViewController.user)
    {
        [self hideDetailView];
    }
}

-(void)userSelected:(CDUser *)user
{
    self.cakeViewController.user = user;
    [self showDetailView];
}

#pragma mark - View update methods

//This will completely show the detail view (i.e. only thing visible)
-(void)showDetailView
{
    [UIView animateWithDuration:0.25f animations:^{
        self.cakeViewContainer.frame = self.view.bounds;
        self.menuVisible = NO;
    }];
}

//This will completely hide the detail view (i.e. menu is only thing visible)
-(void)hideDetailView
{
    [UIView animateWithDuration:0.25f animations:^{
        self.cakeViewContainer.frame = CGRectMake(CGRectGetWidth(self.view.bounds), 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
        self.listViewContainer.frame = self.view.bounds;
        self.menuVisible = YES;
    }];
}

//This will show the menu, however a small section of the detail view will still be visible
-(void)showMenu
{
    [UIView animateWithDuration:0.25f animations:^{
        self.cakeViewContainer.frame = CGRectMake(CGRectGetWidth(self.view.bounds) - 40, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
        self.listViewContainer.frame  = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds) - 40, CGRectGetHeight(self.view.bounds));
        self.menuVisible = YES;
    }];
}

//If the menu is visible show the detail view
-(void)tapOnCakeViewController:(id)sender
{
    if (self.menuVisible)
    {
        [self showDetailView];
    }
}

@end
