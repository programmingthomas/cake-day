//
//  CDUtility.m
//  Cake Day
//
//  Created by Thomas Denney on 25/08/2013.
//  Copyright (c) 2013 Thomas Denney. All rights reserved.
//

#import "CDUtility.h"

static char S(int v)
{
    return v == 1 ? 0 : 's';
}

@implementation CDUtility

+(NSString*)documentsDirectory
{
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
}

+(FMDatabase*)database
{
    return [FMDatabase databaseWithPath:[[CDUtility documentsDirectory] stringByAppendingPathComponent:@"database.sqlite"]];
}

+(NSDictionary*)redditData:(NSString *)redditURL withError:(NSError *__autoreleasing *)errorPtr
{
    NSURL * url = [NSURL URLWithString:redditURL];
    if (url != nil)
    {
        NSError * error;
        NSData * jsonData = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:&error];
            if (error != nil)
            {
                *errorPtr = error;
            }
            else
            {
                NSError * jsonError;
                NSDictionary * json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&jsonError];
                if (jsonError != nil)
                {
                    *errorPtr = jsonError;
                }
                else
                {
                    if ([json objectForKey:@"error"] != nil)
                    {
                        *errorPtr = [NSError errorWithDomain:@"" code:404 userInfo:@{NSLocalizedDescriptionKey: [json objectForKey:@"error"]}];
                    }
                    else
                    {
                        NSDictionary * data = json[@"data"];
                        if (data)
                        {
                            return data;
                        }
                        else
                        {
                            *errorPtr = [NSError errorWithDomain:@"" code:404 userInfo:@{NSLocalizedDescriptionKey: [json objectForKey:@"error"]}];
                        }
                    }
                }
            }
    }
    else
    {
        *errorPtr = [NSError errorWithDomain:@"" code:0 userInfo:@{NSLocalizedDescriptionKey: @"Couldn't create URL"}];
    }
    return nil;
}

+(NSString*)durationString:(NSTimeInterval)dur
{
    int duration = (int)round((double)dur);
    NSLog(@"%d", duration);
    int seconds = duration % 60;
    int minutes = (duration / 60) % 60;
    int hours = (duration / 3600) % 24;
    int days = duration / (3600 * 24);
    
    NSMutableArray * components = [NSMutableArray new];
    
    if (days > 0)
    {
        [components addObject:[NSString stringWithFormat:@"%d day%c", days, S(days)]];
    }
    if (hours > 0)
    {
        [components addObject:[NSString stringWithFormat:@"%d hour%c", hours, S(hours)]];
    }
    if (minutes > 0)
    {
        [components addObject:[NSString stringWithFormat:@"%d minute%c", minutes, S(minutes)]];
    }
    if (seconds > 0)
    {
        [components addObject:[NSString stringWithFormat:@"%d second%c", seconds, S(seconds)]];
    }
    
    NSMutableString * durationString = [NSMutableString new];
    
    for (int n = 0; n < components.count; n++)
    {
        [durationString appendString:components[n]];
        if (components.count > 1)
        {
            if (n == components.count - 2)
            {
                [durationString appendString:@" and "];
            }
            else if (n < components.count - 1)
            {
                [durationString appendString:@", "];
            }
        }
    }
    
    return durationString;
}

@end
