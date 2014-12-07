//
//  CDUserListDataSource.m
//  Cake Day
//
//  Created by Thomas Denney on 06/12/2014.
//  Copyright (c) 2014 Thomas Denney. All rights reserved.
//

#import "CDUserListDataSource.h"

@implementation CDUserListDataSource

- (instancetype)initWithUsers:(NSArray *)users {
    self = [super init];
    if (self) {
        _users = users;
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.users.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    CDUser * user = self.users[indexPath.row];
    
    static NSDateFormatter * formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [NSDateFormatter new];
        formatter.dateStyle = NSDateFormatterMediumStyle;
        formatter.timeStyle = NSDateFormatterNoStyle;
    });
    
    cell.textLabel.text = user.username;
    cell.detailTextLabel.text = [formatter stringFromDate:user.originalCakeDay];
    
    return cell;
}

@end
