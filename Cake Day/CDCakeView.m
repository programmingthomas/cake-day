//
//  CDCakeView.m
//  Cake Day
//
//  Created by Thomas Denney on 26/08/2013.
//  Copyright (c) 2013 Thomas Denney. All rights reserved.
//

#import "CDCakeView.h"

@implementation CDCakeView

- (void)setCandles:(NSUInteger)candles {
    if (_candles != candles) {
        _candles = candles;
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CakeDrawingFunction(context, rect);

    for (NSUInteger n = 0; n < _candles; n++) {
        CGFloat radius = 1;
        CGFloat angle = (CGFloat)n / (CGFloat)_candles * 2.0f * M_PI;
        if (_candles == 1) {
            radius = 0;
        }
        else if (_candles == 2) {
            radius = 0.5;
        }
        else if (_candles % 2 == 1 && _candles < 8) {
            angle += M_PI / 2;
        }
        CGFloat circleX = cosf(angle) * radius;
        CGFloat circleY = -sinf(angle) / 3 * radius;
        CGFloat x = circleX * 0.6 * CGRectGetMidX(rect);
        CGFloat y = circleY * 0.6 * CGRectGetMidY(rect);
        CGRect offsetRect = CGRectOffset(rect, x, y);
        CandleDrawingFunction(context, offsetRect);
    }
}

@end
