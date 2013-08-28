//
//  CDUser.h
//  Cake Day
//
//  Created by Thomas Denney on 25/08/2013.
//  Copyright (c) 2013 Thomas Denney. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDUser : NSObject

@property NSNumber * databaseId;
@property NSString * username;
@property NSDate * cakeDay;

-(NSDate*)nextCakeDay;
-(NSTimeInterval)timeToCakeDay;
-(int)yearsOld;
-(NSString*)usernameWithApostrophe;

-(void)createLocalNotification;
-(void)deleteLocalNotification;

-(id)initWithUsername:(NSString*)username andCakeDay:(int)cakeDay andDatabaseID:(NSNumber*)databaseId;


@end
