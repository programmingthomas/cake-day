//
//  CDUtility.h
//  Cake Day
//
//  Created by Thomas Denney on 25/08/2013.
//  Copyright (c) 2013 Thomas Denney. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FlatUIKit.h"

@interface CDUtility : NSObject

+(FMDatabase*)database;
+(NSString*)documentsDirectory;
+(NSDictionary*)redditData:(NSString*)redditURL withError:(NSError**)errorPtr;

+(void)configureBarButtonItem:(UIBarButtonItem*)barButtonItem;

+(float)systemVersion;
+(NSString*)durationString:(NSTimeInterval)dur;

@end
