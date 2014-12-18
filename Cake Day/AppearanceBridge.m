//
//  AppearanceBridge.m
//  Cake Day
//
//  Created by Thomas Denney on 11/12/2014.
//  Copyright (c) 2014 Thomas Denney. All rights reserved.
//

#import "AppearanceBridge.h"

@implementation AppearanceBridge

+ (void)configureLabel {
    [[UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] setFont:[UIFont fontWithName:@"OpenSans" size:14]];
}

@end
