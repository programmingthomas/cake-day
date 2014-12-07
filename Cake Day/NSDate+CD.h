//
//  CDDate.h
//  Cake Day
//
//  Created by Thomas Denney on 07/12/2014.
//  Copyright (c) 2014 Thomas Denney. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (CD)

- (NSDate*)cd_nextDate;

- (NSComparisonResult)cd_compareOrderInYear:(NSDate*)date2;

@end
