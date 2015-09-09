//
//  DatabaseBridge.h
//  Cake Day
//
//  Created by Thomas Denney on 09/09/2015.
//  Copyright © 2015 Thomas Denney. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

@interface DatabaseBridge : NSObject

@property (readonly, nonatomic) NSString * databasePath;

- (NSArray*)allUsers;

- (User*)userForUsername:(NSString*)username;

- (void)insertUser:(User*)user;

- (void)deleteUser:(User*)user;

@end
