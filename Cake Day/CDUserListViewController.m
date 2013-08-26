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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor midnightBlueColor];
}

-(void)setDatabase:(FMDatabase *)database
{
    if (database != _database)
    {
        _database = database;
        [self update];
    }
}

-(void)update
{
    NSMutableArray * users = [NSMutableArray new];
    if ([self.database open])
    {
        FMResultSet * results = [self.database executeQuery:@"select * from users"];
        while ([results next])
        {
            NSString * username = [results stringForColumn:@"username"];
            NSNumber * cakeday = [NSNumber numberWithInt:[results intForColumn:@"cakeday"]];
            NSNumber * databaseId = [NSNumber numberWithInt:[results intForColumn:@"id"]];
            CDUser * user = [[CDUser alloc] initWithUsername:username andCakeDay:cakeday andDatabaseID:databaseId];
            [users addObject:user];
        }
    }
    [self.database close];
    self.users = users;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 1 ? self.users.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.section == 0)
    {
        cell.textLabel.text = @"Add user";
    }
    else if (indexPath.section == 2)
    {
        cell.textLabel.text = @"Rate Cake Day";
    }
    else
    {
        CDUser * user = self.users[indexPath.row];
        cell.textLabel.text = user.username;
    }
    cell.textLabel.font = [UIFont flatFontOfSize:20];
    cell.textLabel.textColor = [UIColor cloudsColor];
    return cell;
}

-(float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == 1;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        CDUser * user = self.users[indexPath.row];
        if ([self.database open])
        {
            if (![self.database executeUpdate:@"delete from users where id = ?", user.databaseId])
            {
                NSLog(@"Error deleting = %@", self.database.lastErrorMessage);
            }
            [self.database close];
        }
        [self.users removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [self.masterViewDelegate userDeleted:user];
    }
}

-(void)addUser
{
    self.addUserAlert = [[UIAlertView alloc] initWithTitle:@"Add user" message:@"Enter Reddit username here:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
    self.addUserAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [self.addUserAlert show];
}

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
    UIAlertView * failedAlert = [[UIAlertView alloc] initWithTitle:@"Failed to find user" message:[NSString stringWithFormat:@"Sorry, the user %@ could not be found", username] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [failedAlert show];
}

-(void)rate
{
    NSURL * url = [NSURL URLWithString:@"some app store URL"];
    [[UIApplication sharedApplication] openURL:url];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        [self addUser];
    }
    else if (indexPath.section == 2)
    {
        [self rate];
    }
    else
    {
        CDUser * user = self.users[indexPath.row];
        [self.masterViewDelegate userSelected:user];
    }
}

@end
