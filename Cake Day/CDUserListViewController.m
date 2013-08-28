//
//  CDUserListViewController.m
//  Cake Day
//
//  Created by Thomas Denney on 25/08/2013.
//  Copyright (c) 2013 Thomas Denney. All rights reserved.
//

#import "CDUserListViewController.h"

@interface CDUserListViewController ()

@end

@implementation CDUserListViewController

#pragma mark - Initialization

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor wetAsphaltColor];
    [self.navigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor midnightBlueColor]];
    if ([CDUtility systemVersion] >= 7)
    {
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    }
    else
    {
        [CDUtility configureBarButtonItem:self.rateButton];
        [CDUtility configureBarButtonItem:self.addButton];
    }
    [self.navigationController.navigationBar setTitleTextAttributes:@{UITextAttributeFont: [UIFont boldFlatFontOfSize:0],UITextAttributeTextColor: [UIColor whiteColor], UITextAttributeTextShadowColor: [UIColor clearColor], UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero]}];
    self.rateButton.image = [CDImages imageForSize:CGSizeMake(20, 20) andName:@"rate"];
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

-(void)update
{
    self.users = [NSMutableArray new];
    if ([self.database open])
    {
        FMResultSet * results = [self.database executeQuery:@"select * from users"];
        while ([results next])
        {
            CDUser * user = [[CDUser alloc] initWithUsername:[results stringForColumn:@"username"] andCakeDay:[results intForColumn:@"cakeday"] andDatabaseID:[NSNumber numberWithInt:[results intForColumn:@"id"]]];
            [user createLocalNotification];
            [self.users addObject:user];
        }
    }
    [self.database close];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = self.tableView.backgroundColor;
    CDUser * user = self.users[indexPath.row];
    cell.textLabel.text = user.username;
    cell.imageView.image = [CDImages imageForSize:CGSizeMake(30, 30) andName:@"face"];
    cell.textLabel.font = [UIFont flatFontOfSize:20];
    cell.textLabel.textColor = [UIColor cloudsColor];
    return cell;
}

-(float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

#pragma mark - Table view delegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        CDUser * user = self.users[indexPath.row];
        if ([self.database open])
        {
            if (![self.database executeUpdate:@"delete from users where id = ?", user.databaseId])
            {
                NSLog(@"Error deleting = %@", self.database.lastErrorMessage);
            }
            [self.database close];
        }
        [user deleteLocalNotification];
        [self.users removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [self.masterViewDelegate userDeleted:user];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.masterViewDelegate userSelected:self.users[indexPath.row]];
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

-(BOOL)showUserWithName:(NSString*)username
{
    for (CDUser * user in self.users)
    {
        if ([user.username isEqualToString:username])
        {
            [self.masterViewDelegate userSelected:user];
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

@end
