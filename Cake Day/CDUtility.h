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

/**
 This class needs refactoring
 */
@interface CDUtility : NSObject

+ (FMDatabase*)database;
+ (NSString*)documentsDirectory;
+ (NSDictionary*)redditData:(NSString*)redditURL withError:(NSError**)errorPtr;

+ (NSString*)durationString:(NSTimeInterval)dur;

@end
