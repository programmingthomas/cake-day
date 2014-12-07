//
//  CDUtility.h
//  Cake Day
//
//  Created by Thomas Denney on 25/08/2013.
//  Copyright (c) 2013 Thomas Denney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FMDatabase.h>
#import <Chameleon.h>
#import <AFNetworking.h>

/**
 This class needs refactoring
 */
@interface CDUtility : NSObject

/**
 I don't like the fact that I'm using singletons here
 */
+ (FMDatabase*)database;
+ (NSString*)documentsDirectory;
+ (AFHTTPRequestOperationManager*)operationManager;

+ (NSString*)durationString:(NSTimeInterval)dur;

@end
