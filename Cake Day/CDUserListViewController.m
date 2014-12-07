//
//  CDUserListViewController.m
//  Cake Day
//
//  Created by Thomas Denney on 25/08/2013.
//  Copyright (c) 2013 Thomas Denney. All rights reserved.
//

#import "CDUserListViewController.h"
#import "CDCakeViewController.h"

@interface CDUserListViewController ()

@property CDUserListDataSource * userDataSource;

@end

@implementation CDUserListViewController

#pragma mark - Initialization

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTintColor:FlatWhite];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setBarTintColor:FlatBlueDark];
    
    self.navigationItem.title = NSLocalizedString(@"app.name", nil);
    self.addButton.accessibilityLabel = NSLocalizedString(@"user.add", nil);
    self.rateButton.accessibilityLabel = NSLocalizedString(@"app.rate", nil);
    
    [self update];
}

- (void)setDatabase:(FMDatabase *)database {
    if (database != _database) {
        _database = database;
        [self update];
    }
}

#pragma mark - Model

- (void)update {
    self.users = [self sortUsersByCurrentDate:[CDUser allUsersInDatabase:self.database]];
    
    self.userDataSource = [[CDUserListDataSource alloc] initWithUsers:self.users];
    self.tableView.dataSource = self.userDataSource;
    
    [self.tableView reloadData];
}

/**
 When we show the list of users we want to display them in order they are coming up. For example, if the date is the 7th December, we want to display users with cake days between December 7th and December 31st first, and then the remainder from January onwards through the year. To do this you just do a simple binary search to find the first cake day >= the current day in the year
 */
- (NSArray*)sortUsersByCurrentDate:(NSArray*)users {
    NSInteger partitionIndex = [self positionOfFirstCakeDayAfterCurrent:users];
    NSArray * datesAfter = [users subarrayWithRange:NSMakeRange(partitionIndex, users.count - partitionIndex)];
    NSArray * datesBefore = [users subarrayWithRange:NSMakeRange(0, partitionIndex)];
    return [datesAfter arrayByAddingObjectsFromArray:datesBefore];
}

/**
 Does the binary search for the above function
 */
- (NSInteger)positionOfFirstCakeDayAfterCurrent:(NSArray*)users {
    NSUInteger low = 0;
    NSUInteger high = users.count - 1;
    NSDate * current = [NSDate date];
    
    while (low <= high) {
        NSUInteger mid = (low + high) / 2;
        
        CDUser * user = (CDUser*)users[mid];
        
        NSComparisonResult compare = [user.originalCakeDay cd_compareOrderInYear:current];
        if (compare == NSOrderedDescending || compare == NSOrderedSame) {
            high = mid - 1;
        }
        else {
            low = mid + 1;
        }
    }
    
    return low;
}

#pragma mark - Table view delegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        CDUser * user = self.users[indexPath.row];
        
        [user deleteFromDatabase:self.database];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [self update];
    }
}

#pragma mark - Alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView == self.addUserAlert && buttonIndex == 1) {
        NSString * username = [self.addUserAlert textFieldAtIndex:0].text;
        username = [username stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [self addUserForName:username];
    }
}

- (void)addUserForName:(NSString*)username {
    [CDUser createNewUser:username
                  success:^(CDUser * user) {
                      [self update];
                      [self showUserWithName:user.username];
                  } failure:^(NSError * error){
                      [self usernameError:username];
                  } database:self.database operationManager:[CDUtility operationManager]];
}

- (BOOL)showUserWithName:(NSString*)username {
    for (CDUser * user in self.users) {
        if ([user.username isEqualToString:username]) {
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:[self.users indexOfObject:user] inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
            [self performSegueWithIdentifier:@"userSegue" sender:self];
            return YES;
        }
    }
    return NO;
}

- (void)usernameError:(NSString*)username {
    NSString * title = NSLocalizedString(@"user.failed", nil);
    NSString * message = [NSString stringWithFormat:NSLocalizedString(@"user.failed.message", nil), username];
    NSString * ok = NSLocalizedString(@"ok", nil);
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:ok otherButtonTitles:nil];
    [alert show];
}

#pragma mark - Bar button actions

- (IBAction)addTapped:(id)sender {
    NSString * title = NSLocalizedString(@"user.add", nil);
    NSString * message = NSLocalizedString(@"user.add.message", nil);
    NSString * add = NSLocalizedString(@"add", nil);
    NSString * cancel = NSLocalizedString(@"cancel", nil);
    
    self.addUserAlert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancel otherButtonTitles:add, nil];
    self.addUserAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [self.addUserAlert show];
}

- (IBAction)rateAction:(id)sender {
    NSURL * url = [NSURL URLWithString:@"https://itunes.apple.com/us/app/cake-day/id694043166?ls=1&mt=8"];
    [[UIApplication sharedApplication] openURL:url];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"userSegue"]) {
        UINavigationController * nav = (UINavigationController*)segue.destinationViewController;
        //Won't work in Swift yet
//        CDCakeViewController * detailVC = (CDCakeViewController*)[nav.childViewControllers firstObject];
//        detailVC.user = self.users[self.tableView.indexPathForSelectedRow.row];
    }
}

@end
