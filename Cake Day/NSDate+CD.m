//
//  CDDate.m
//  Cake Day
//
//  Created by Thomas Denney on 07/12/2014.
//  Copyright (c) 2014 Thomas Denney. All rights reserved.
//

#import "NSDate+CD.h"

@implementation NSDate (CD)

- (NSDate*)cd_nextDate {
    static NSCalendar * calendar;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    });
    
    NSDate * cakeday = self;
    
    while ([cakeday compare:[NSDate date]] != NSOrderedDescending) {
        NSDateComponents * offset = [NSDateComponents new];
        [offset setYear:1];
        cakeday = [calendar dateByAddingComponents:offset toDate:cakeday options:0];
    }
    
    return cakeday;
}

@end
