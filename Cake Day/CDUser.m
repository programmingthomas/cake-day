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
    //This is inefficient as fuck, but it works
    NSDate * cakeday = self.cakeDay;
    while (YES) {
        //Cakeday is after today
        if ([cakeday compare:[NSDate date]] == NSOrderedDescending)
        {
            return cakeday;
        }
        NSCalendar * gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents * offset = [NSDateComponents new];
        [offset setYear:1];
        cakeday = [gregorian dateByAddingComponents:offset toDate:cakeday options:0];
    }
}

-(NSTimeInterval)timeToCakeDay
{
    NSDate * nextCakeDay = [self nextCakeDay];
    NSDate * today = [NSDate date];
    return [nextCakeDay timeIntervalSinceDate:today];
}

-(void)createLocalNotification
{
    UILocalNotification * notification = [self localNotification];
    notification.fireDate = self.nextCakeDay;
    notification.repeatInterval = NSYearCalendarUnit;
    notification.alertBody = [NSString stringWithFormat:@"It's %@'%c cake day!", self.username, [self.username hasSuffix:@"s"] ? 0 : 's'];
    //I'm not sure if this is going to fuck up notifications for foreigners - it shouldn't (I am testing in BST)
    notification.timeZone = [NSTimeZone systemTimeZone];
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.userInfo = @{@"uid": [self localNotificationUID]};
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    NSLog(@"Configured local notification to repeat regularly");
}

-(UILocalNotification*)localNotification
{
    NSArray * localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification * localNotification in localNotifications)
    {
        NSString * uid = localNotification.userInfo[@"uid"];
        if ([uid isEqualToString:[self localNotificationUID]])
        {
            return localNotification;
        }
    }
    return [[UILocalNotification alloc] init];
}

-(NSString*)localNotificationUID
{
    return [NSString stringWithFormat:@"cakeday-%d", self.databaseId.intValue];
}

-(void)deleteLocalNotification
{
    [[UIApplication sharedApplication] cancelLocalNotification:[self localNotification]];
    NSLog(@"Removed notification");
}

@end
