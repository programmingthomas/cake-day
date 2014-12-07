//
//  CDUtility.m
//  Cake Day
//
//  Created by Thomas Denney on 25/08/2013.
//  Copyright (c) 2013 Thomas Denney. All rights reserved.
//

#import "CDUtility.h"

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

+ (NSString*)durationString:(NSTimeInterval)duration {
    static TTTTimeIntervalFormatter * intervalFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        intervalFormatter = [TTTTimeIntervalFormatter new];
        intervalFormatter.numberOfSignificantUnits = 0;
    });
    
    return [intervalFormatter stringForTimeInterval:duration];
}

@end
