//
//  CDImages.m
//  Cake Day
//
//  Created by Thomas Denney on 26/08/2013.
//  Copyright (c) 2013 Thomas Denney. All rights reserved.
//

#import "CDImages.h"

@implementation CDImages

+(UIImage*)imageForSize:(CGSize)size andName:(NSString *)name
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect bounds = CGRectMake(0, 0, size.width, size.height);
    if ([name isEqualToString:@"add"])
    {
        AddDrawingFunction(context, bounds);
    }
    else if ([name isEqualToString:@"hamburger"])
    {
        HamburgerDrawingFunction(context, bounds);
    }
    else if ([name isEqualToString:@"rate"])
    {
        RateDrawingFunction(context, bounds);
    }
    else if ([name isEqualToString:@"alien"])
    {
        AlienDrawingFunction(context, bounds);
    }
    else if ([name isEqualToString:@"face"])
    {
        FaceDrawingFunction(context, bounds);
    }
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
