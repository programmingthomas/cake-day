//
//  CDCakeView.h
//  Cake Day
//
//  Created by Thomas Denney on 26/08/2013.
//  Copyright (c) 2013 Thomas Denney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cake.h"
#import "Candle.h"

@interface CDCakeView : UIView
{
    int _candles;
}

@property (nonatomic) int candles;

@end
