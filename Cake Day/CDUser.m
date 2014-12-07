//
//  CDUser.m
//  Cake Day
//
//  Created by Thomas Denney on 25/08/2013.
//  Copyright (c) 2013 Thomas Denney. All rights reserved.
//

#import "CDUser.h"

@implementation CDUser

#pragma mark - Initialisation

- (instancetype)initWithUsername:(NSString *)username cakeDay:(double)cakeDay databaseID:(NSUInteger)databaseID {
    self = [super init];
    if (self) {
        _username = username;
        _originalCakeDay = [NSDate dateWithTimeIntervalSince1970:cakeDay];
        _databaseID = databaseID;
    }
    return self;
}

- (instancetype)initWithDatabaseResult:(FMResultSet *)results {
    NSString * username = [results stringForColumn:@"username"];
    double cakeDay = [results doubleForColumn:@"cakeday"];
    NSUInteger databaseID = [results unsignedLongLongIntForColumn:@"id"];
    return [self initWithUsername:username cakeDay:cakeDay databaseID:databaseID];
}

+ (void)createNewUser:(NSString *)username success:(void (^)(CDUser *))success failure:(void (^)(NSError*))failure database:(FMDatabase*)database operationManager:(AFHTTPRequestOperationManager *)opManager {
    //Firstly we need to check to see if the user already exists
    FMResultSet * existingUserQuery = [database executeQuery:@"select * from users where username = ?", username];
    if ([existingUserQuery next]) {
        CDUser * user = [[CDUser alloc] initWithDatabaseResult:existingUserQuery];
        success(user);
    }
    else {
        //Now just do the JSON request to reddit using AFNetworking
        NSString * userAgent = @"cakeday/1.0 by /u/ProgrammingThomas";
        NSString * urlString = [NSString stringWithFormat:@"http://reddit.com/user/%@/about.json", username];
        NSURL * url = [NSURL URLWithString:urlString];
        NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
        [request addValue:userAgent forHTTPHeaderField:@"User-Agent"];
        
        AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.responseSerializer = [AFJSONResponseSerializer serializer];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary * json = (NSDictionary*)responseObject;
            
            //Handle reddit errors
            if (json[@"error"]) {
                failure([NSError errorWithDomain:@"reddit" code:404 userInfo:@{@"message":json[@"error"]}]);
            }
            else {
                NSDictionary * userData = json[@"data"];
                
                NSString * username = userData[@"name"];
                NSNumber * createdUTC = userData[@"created_utc"];
                
                if ([database executeUpdate:@"insert into users(username, cakeday) values (?,?)", username, createdUTC]) {
                    CDUser * user = [[CDUser alloc] initWithUsername:username cakeDay:createdUTC.doubleValue databaseID:(NSUInteger)database.lastInsertRowId];
                    success(user);
                }
                else {
                    failure([NSError errorWithDomain:@"database" code:1 userInfo:@{@"message":@"Insert failed"}]);
                }
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(error);
        }];
        
        [opManager.operationQueue addOperation:operation];
    }
}

#pragma mark - Removing from database

- (void)deleteFromDatabase:(FMDatabase *)database {
    if (![database executeUpdate:@"delete from users where id = ?", @(self.databaseID)]) {
        NSLog(@"Error deleting = %@", database.lastErrorMessage);
    }
    [self deleteLocalNotification];
}

#pragma mark - Date handling

- (NSDate*)nextCakeDay {
    return [self.originalCakeDay cd_nextDate];
}

- (NSTimeInterval)timeToCakeDay {
    NSDate * nextCakeDay = [self nextCakeDay];
    NSDate * today = [NSDate date];
    return [nextCakeDay timeIntervalSinceDate:today];
}

- (NSUInteger)yearsOld {
    NSDate * birthCakeDay = self.originalCakeDay;
    NSDate * today = [NSDate date];
    NSCalendar * gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents * components = [gregorian components:NSYearCalendarUnit fromDate:birthCakeDay toDate:today options:0];
    return [components year];
}

- (NSString*)usernameWithApostrophe {
    return [NSString stringWithFormat:@"%@'%c", self.username, [self.username hasSuffix:@"s"] ? 0 : 's'];
}

#pragma mark - Notification scheduling

- (void)createLocalNotification {
    UILocalNotification * notification = [self localNotification];
    notification.fireDate = self.nextCakeDay;
    notification.repeatInterval = NSYearCalendarUnit;
    notification.alertBody = [NSString stringWithFormat:@"It's %@ cake day!", self.usernameWithApostrophe];
    //I'm not sure if this is going to fuck up notifications for foreigners - it shouldn't (I am testing in BST)
    notification.timeZone = [NSTimeZone systemTimeZone];
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.userInfo = @{@"uid": [self localNotificationUID]};
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (UILocalNotification*)localNotification {
    NSArray * localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    UILocalNotification * notification;
    BOOL foundNotification = NO;
    for (UILocalNotification * localNotification in localNotifications) {
        NSString * uid = localNotification.userInfo[@"uid"];
        if ([uid isEqualToString:[self localNotificationUID]]) {
            if (!foundNotification) {
                notification = localNotification;
                foundNotification = YES;
            }
            else {
                [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
            }
        }
    }
    return foundNotification ? notification : [UILocalNotification new];
}

- (NSString*)localNotificationUID {
    return [NSString stringWithFormat:@"cakeday-%ud", (uint32_t)self.databaseID];
}

- (void)deleteLocalNotification {
    NSArray * localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification * notification in localNotifications) {
        NSString * uid = notification.userInfo[@"uid"];
        if ([uid isEqualToString:[self localNotificationUID]]) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }
}

@end
