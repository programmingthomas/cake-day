//
//  CDUser.h
//  Cake Day
//
//  Created by Thomas Denney on 25/08/2013.
//  Copyright (c) 2013 Thomas Denney. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDatabase.h>
#import <AFNetworking.h>

#import "NSDate+CD.h"

@interface CDUser : NSObject

+ (void)createNewUser:(NSString*)username success:(void(^)(CDUser*))success failure:(void(^)(NSError*))failure database:(FMDatabase*)database operationManager:(AFHTTPRequestOperationManager*)opManager;

- (instancetype)initWithUsername:(NSString*)username cakeDay:(double)cakeDay databaseID:(NSUInteger)databaseID;
- (instancetype)initWithDatabaseResult:(FMResultSet*)result;

@property (nonatomic, readonly) NSUInteger databaseID;
@property (nonatomic, readonly) NSString * username;
@property (nonatomic, readonly) NSDate * originalCakeDay;

- (NSDate*)nextCakeDay;
- (NSTimeInterval)timeToCakeDay;
- (NSUInteger)yearsOld;
- (NSString*)usernameWithApostrophe;

- (void)createLocalNotification;
- (void)deleteLocalNotification;



@end
