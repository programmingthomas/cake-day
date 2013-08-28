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

+(void)configureBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    if ([CDUtility systemVersion] < 7)
    {
        [barButtonItem configureFlatButtonWithColor:[UIColor belizeHoleColor] highlightedColor:[UIColor peterRiverColor] cornerRadius:5];
    }
}

+(float)systemVersion
{
    NSArray * versionCompatibility = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    float total = 0;
    int pot = 0;
    for (NSNumber * number in versionCompatibility)
    {
        total += number.intValue * powf(10, pot);
        pot--;
    }
    return total;
}

+(NSDictionary*)redditData:(NSString *)redditURL withError:(NSError *__autoreleasing *)errorPtr
{
    NSString* userAgent = @"cakeday/1.0 by /u/ProgrammingThomas";
    NSURL* url = [NSURL URLWithString:redditURL];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request addValue:userAgent forHTTPHeaderField:@"User-Agent"];
    
    NSURLResponse* response = nil;
    NSError* error = nil;
    NSData* jsonData = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];
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
    return nil;
}

+(NSString*)durationString:(NSTimeInterval)dur
{
    int duration = (int)round((double)dur);
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
