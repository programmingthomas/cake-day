//
//  CDImages.h
//  Cake Day
//
//  Created by Thomas Denney on 26/08/2013.
//  Copyright (c) 2013 Thomas Denney. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Add.h"
#import "Alien.h"
#import "Hamburger.h"
#import "Rate.h"
#import "Face.h"

@interface CDImages : NSObject

+(UIImage*)imageForSize:(CGSize)size andName:(NSString*)name;

@end
