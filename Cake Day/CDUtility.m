//
//  CDUtility.m
//  Cake Day
//
//  Created by Thomas Denney on 25/08/2013.
//  Copyright (c) 2013 Thomas Denney. All rights reserved.
//

#import "CDUtility.h"

@implementation CDUtility

+(NSString*)documentsDirectory
{
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
}

+(FMDatabase*)database
{
    return [FMDatabase databaseWithPath:[[CDUtility documentsDirectory] stringByAppendingPathComponent:@"database.sqlite"]];
}

@end
