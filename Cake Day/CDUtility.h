//
//  CDUtility.h
//  Cake Day
//
//  Created by Thomas Denney on 25/08/2013.
//  Copyright (c) 2013 Thomas Denney. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface CDUtility : NSObject

+(FMDatabase*)database;
+(NSString*)documentsDirectory;
+(float)systemVersion;
+(NSDictionary*)redditData:(NSString*)redditURL withError:(NSError**)errorPtr;
+(NSString*)durationString:(NSTimeInterval)dur;

@end
