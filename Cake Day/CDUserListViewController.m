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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setTintColor:FlatWhite];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setBarTintColor:FlatBlueDark];
    
    [self update];
}

-(void)setDatabase:(FMDatabase *)database
{
    if (database != _database)
    {
        _database = database;
        [self update];
    }
}

#pragma mark - Model

- (void)update {
    NSMutableArray * users = [NSMutableArray new];
    if ([self.database open]) {
        FMResultSet * results = [self.database executeQuery:@"select * from users"];
        while ([results next]) {
            NSString * username = [results stringForColumn:@"username"];
            double cakeDay = [results doubleForColumn:@"cakeday"];
            NSUInteger databaseID = [results unsignedLongLongIntForColumn:@"id"];
            CDUser * user = [[CDUser alloc] initWithUsername:username cakeDay:cakeDay databaseID:databaseID];
            [user createLocalNotification];
            [users addObject:user];
        }
    }
    [self.database close];
    
    self.users = users;
    
    self.userDataSource = [[CDUserListDataSource alloc] initWithUsers:users];
    self.tableView.dataSource = self.userDataSource;
    
    [self.tableView reloadData];
}


#pragma mark - Table view delegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        CDUser * user = self.users[indexPath.row];
        if ([self.database open]) {
            if (![self.database executeUpdate:@"delete from users where id = ?", @(user.databaseID)]) {
                NSLog(@"Error deleting = %@", self.database.lastErrorMessage);
            }
            [self.database close];
        }
        [user deleteLocalNotification];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [self update];
    }
}

#pragma mark - Alert view delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == self.addUserAlert && buttonIndex == 1)
    {
        NSString * username = [self.addUserAlert textFieldAtIndex:0].text;
        username = [username stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [self addUserForName:username];
    }
}

-(void)addUserForName:(NSString*)username
{
    NSString * usernameURLString = [NSString stringWithFormat:@"http://reddit.com/user/%@/about.json", username];
    [[NSOperationQueue new] addOperationWithBlock:^{
        NSError * error;
        NSDictionary * data = [CDUtility redditData:usernameURLString withError:&error];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (error == nil)
            {
                NSString * username = data[@"name"];
                NSNumber * createdUTC = data[@"created_utc"];
                [self createNewUser:username andCreationDate:createdUTC];
            }
            else
            {
                NSLog(@"Failed to get Reddit data = %@", error.localizedDescription);
                [self usernameError:username];
            }
        }];
    }];
}

-(void)createNewUser:(NSString*)username andCreationDate:(NSNumber*)created
{
    //Check if the username has already been added
    if (![self showUserWithName:username])
    {
        if ([self.database open])
        {
            if ([self.database executeUpdate:@"insert into users(username, cakeday) values (?,?)", username, created])
            {
                [self update];
                [self showUserWithName:username];
            }
            else
            {
                NSLog(@"Failed to insert user = %@", self.database.lastErrorMessage);
            }
            [self.database close];
        }
    }
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

-(void)usernameError:(NSString*)username
{
    [[[UIAlertView alloc] initWithTitle:@"Failed to find user" message:[NSString stringWithFormat:@"Sorry, the user %@ could not be found", username] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

#pragma mark - Bar button actions

- (IBAction)addTapped:(id)sender
{
    self.addUserAlert = [[UIAlertView alloc] initWithTitle:@"Add user" message:@"Enter reddit username here:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
    self.addUserAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [self.addUserAlert show];
}

- (IBAction)rateAction:(id)sender
{
    NSURL * url = [NSURL URLWithString:@"https://itunes.apple.com/us/app/cake-day/id694043166?ls=1&mt=8"];
    [[UIApplication sharedApplication] openURL:url];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"userSegue"]) {
        UINavigationController * nav = (UINavigationController*)segue.destinationViewController;
        CDCakeViewController * detailVC = (CDCakeViewController*)[nav.childViewControllers firstObject];
        detailVC.user = self.users[self.tableView.indexPathForSelectedRow.row];
    }
}

@end
