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

@property (readonly, nonatomic) NSString * _Nonnull databasePath;

- (NSArray<User*>* _Nonnull)allUsers;

- (User* _Nullable)userForUsername:(NSString* _Nonnull)username;

- (void)insertUser:(User* _Nonnull)user;

- (void)deleteUser:(User* _Nonnull)user;

@end
