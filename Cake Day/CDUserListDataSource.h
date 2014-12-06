//
//  CDUserListDataSource.h
//  Cake Day
//
//  Created by Thomas Denney on 06/12/2014.
//  Copyright (c) 2014 Thomas Denney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDUser.h"

/**
 Immutable data source for the user list
 */
@interface CDUserListDataSource : NSObject<UITableViewDataSource>

@property (nonatomic, readonly) NSArray * users;

- (instancetype)initWithUsers:(NSArray*)users;

@end
