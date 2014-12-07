//
//  CDUtility.m
//  Cake Day
//
//  Created by Thomas Denney on 25/08/2013.
//  Copyright (c) 2013 Thomas Denney. All rights reserved.
//

#import "CDUtility.h"

static char S(int v) {
    return v == 1 ? 0 : 's';
}

@implementation CDUtility

+ (NSString*)documentsDirectory {
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
}

+ (FMDatabase*)database {
    return [FMDatabase databaseWithPath:[[CDUtility documentsDirectory] stringByAppendingPathComponent:@"database.sqlite"]];
}

+ (AFHTTPRequestOperationManager*)operationManager {
    static AFHTTPRequestOperationManager * operationManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        operationManager = [AFHTTPRequestOperationManager manager];
    });
    return operationManager;
}

+ (NSString*)durationString:(NSTimeInterval)dur {
    int duration = (int)round((double)dur);
    int seconds = duration % 60;
    int minutes = (duration / 60) % 60;
    int hours = (duration / 3600) % 24;
    int days = duration / (3600 * 24);
    
    NSMutableArray * components = [NSMutableArray new];
    
    if (days > 0) {
        [components addObject:[NSString stringWithFormat:@"%d day%c", days, S(days)]];
    }
    if (hours > 0) {
        [components addObject:[NSString stringWithFormat:@"%d hour%c", hours, S(hours)]];
    }
    if (minutes > 0) {
        [components addObject:[NSString stringWithFormat:@"%d minute%c", minutes, S(minutes)]];
    }
    if (seconds > 0) {
        [components addObject:[NSString stringWithFormat:@"%d second%c", seconds, S(seconds)]];
    }
    
    NSMutableString * durationString = [NSMutableString new];
    
    for (int n = 0; n < components.count; n++) {
        [durationString appendString:components[n]];
        if (components.count > 1) {
            if (n == components.count - 2) {
                [durationString appendString:@" and "];
            }
            else if (n < components.count - 1) {
                [durationString appendString:@", "];
            }
        }
    }
    
    return durationString;
}

@end
