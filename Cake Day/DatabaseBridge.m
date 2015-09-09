//
//  DatabaseBridge.m
//  Cake Day
//
//  Created by Thomas Denney on 09/09/2015.
//  Copyright © 2015 Thomas Denney. All rights reserved.
//

#import "DatabaseBridge.h"
#import <FMDB.h>
#import "Cake_Day-Swift.h"

@interface DatabaseBridge ()

@property FMDatabase * database;
@property (nonatomic) NSString * databasePath;

@end

@implementation DatabaseBridge

- (instancetype)init {
    self = [super init];
    if (self) {
        self.databasePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"database.sqlite"];
        self.database = [FMDatabase databaseWithPath:self.databasePath];
        if ([self.database open]) {
            [self.database executeUpdate:@"CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY, username TEXT, cakeday INTEGER)"];
        }
    }
    return self;
}

- (void)dealloc {
    [self.database close];
}

- (NSArray<User*>*)allUsers {
    NSMutableArray<User*> * users = [NSMutableArray new];
    FMResultSet * row = [self.database executeQuery:@"SELECT * FROM users"];
    while ([row next]) {
        [users addObject:[self _userFromRow:row]];
    }
    return users;
}

- (User* _Nonnull)_userFromRow:(FMResultSet*)row {
    User * user = [[User alloc] initWithDatabaseID:[row intForColumn:@"id"]
                                          username:[row stringForColumn:@"username"]
                                           cakeDay:[row dateForColumn:@"cakeday"]];
    return user;
}

- (User*)userForUsername:(NSString *)username {
    FMResultSet * row = [self.database executeQuery:@"SELECT * FROM users WHERE username = ?", username];
    if ([row next]) {
        return [self _userFromRow:row];
    }
    return nil;
}

- (void)insertUser:(User *)user {
    if ([self.database executeUpdate:@"INSERT INTO users(username,cakeday) VALUES (?,?)", user.username, user.originalCakeDay]) {
        user.databaseID = self.database.lastInsertRowId;
    }
}

- (void)deleteUser:(User *)user {
    if ([self.database executeUpdate:@"DELETE FROM users WHERE id = ?", @(user.databaseID)]) {
        [user cancelLocalNotification];
    }
}

@end
