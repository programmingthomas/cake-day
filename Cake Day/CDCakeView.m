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
    if (_candles != candles)
    {
        _candles = candles;
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CakeDrawingFunction(context, rect);
    
    float distanceBetweenCandles = 190.0f / (float)_candles;
    float leftMostCandle = -distanceBetweenCandles * (float)_candles / 2.0f;
    
    for (int n = 0; n < _candles; n++)
    {
        float offset = 0, yOffset = 0;
        if (_candles > 1)
        {
            offset = ((float)n ) / ((float)(_candles-1) / 2.0f) * M_PI / 2.0f;
            yOffset = sinf(offset);
        }
        CGRect offsetRect = CGRectOffset(rect, leftMostCandle + ((float)n + 0.5f) * distanceBetweenCandles, yOffset * 10);
        CandleDrawingFunction(context, offsetRect);
    }
}

@end
