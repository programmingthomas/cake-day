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
    
    cell.textLabel.text = user.username;
    
    return cell;
}

@end
