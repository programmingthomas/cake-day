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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.users.count + 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.row == 0)
    {
        cell.textLabel.text = @"Add user";
    }
    else if (indexPath.row == self.users.count + 1)
    {
        cell.textLabel.text = @"Rate Cake Day";
    }
    else
    {
        CDUser * user = self.users[indexPath.row - 1];
        cell.textLabel.text = user.username;
    }
    cell.textLabel.font = [UIFont flatFontOfSize:20];
    cell.textLabel.textColor = [UIColor cloudsColor];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
