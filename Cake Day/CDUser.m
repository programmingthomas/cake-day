//
//  CDUser.m
//  Cake Day
//
//  Created by Thomas Denney on 25/08/2013.
//  Copyright (c) 2013 Thomas Denney. All rights reserved.
//

#import "CDUser.h"

@implementation CDUser

-(id)initWithUsername:(NSString *)username andCakeDay:(NSNumber *)cakeDay andDatabaseID:(NSNumber *)databaseId
{
    self = [super init];
    if (self)
    {
        self.username = username;
        self.cakeDay = [NSDate dateWithTimeIntervalSince1970:cakeDay.integerValue];
        self.databaseId = databaseId;
    }
    return self;
}

-(NSDate*)nextCakeDay
{
    
}

-(NSTimeInterval)timeToCakeDay
{
    NSDate * nextCakeDay = [self nextCakeDay];
    NSDate * today = [NSDate date];
    return [nextCakeDay timeIntervalSinceDate:today];
}

@end
