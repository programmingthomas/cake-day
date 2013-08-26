//
//  CDCakeView.m
//  Cake Day
//
//  Created by Thomas Denney on 26/08/2013.
//  Copyright (c) 2013 Thomas Denney. All rights reserved.
//

#import "CDCakeView.h"

@implementation CDCakeView

-(void)setCandles:(int)candles
{
    _candles = candles;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    NSLog(@"There are %d candles", _candles);
    
    CakeDrawingFunction(UIGraphicsGetCurrentContext(), rect);
}

@end
