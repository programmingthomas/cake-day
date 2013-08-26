//
//  Add.m
//  New Image
//
//  Created by Thomas Denney on 26/08/2013
//  Copyright 2013 Thomas Denney
//  This code was generated by Opacity Express. You may use or modify it in any way.
//

#include "Add.h"

#include <math.h>

const CGFloat kAddDrawingFunctionWidth = 44.0f;
const CGFloat kAddDrawingFunctionHeight = 44.0f;

void AddDrawingFunction(CGContextRef context, CGRect bounds)
{
    CGRect imageBounds = CGRectMake(0.0f, 0.0f, kAddDrawingFunctionWidth, kAddDrawingFunctionHeight);
    CGFloat alignStroke;
    CGFloat resolution;
    CGFloat stroke;
    CGMutablePathRef path;
    CGPoint point;
    CGColorRef color;
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGAffineTransform transform;
    CGFloat components[4];
    
    transform = CGContextGetUserSpaceToDeviceSpaceTransform(context);
    resolution = sqrtf(fabsf(transform.a * transform.d - transform.b * transform.c)) * 0.5f * (bounds.size.width / imageBounds.size.width + bounds.size.height / imageBounds.size.height);
    
    CGContextSaveGState(context);
    CGContextClipToRect(context, bounds);
    CGContextTranslateCTM(context, bounds.origin.x, bounds.origin.y);
    CGContextScaleCTM(context, (bounds.size.width / imageBounds.size.width), (bounds.size.height / imageBounds.size.height));
    
    // Layer 1
    
    stroke = 10.0f;
    stroke *= resolution;
    if (stroke < 1.0f) {
        stroke = ceilf(stroke);
    } else {
        stroke = roundf(stroke);
    }
    stroke /= resolution;
    alignStroke = fmodf(0.5f * stroke * resolution, 1.0f);
    path = CGPathCreateMutable();
    point = CGPointMake(22.0f, 0.0f);
    point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
    point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
    CGPathMoveToPoint(path, NULL, point.x, point.y);
    point = CGPointMake(22.0f, 44.5f);
    point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
    point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
    CGPathAddLineToPoint(path, NULL, point.x, point.y);
    components[0] = 1.0f;
    components[1] = 1.0f;
    components[2] = 1.0f;
    components[3] = 1.0f;
    color = CGColorCreate(space, components);
    CGContextSetStrokeColorWithColor(context, color);
    CGColorRelease(color);
    CGContextSetLineWidth(context, stroke);
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextAddPath(context, path);
    CGContextStrokePath(context);
    CGPathRelease(path);
    
    // Layer 2
    
    stroke = 10.0f;
    stroke *= resolution;
    if (stroke < 1.0f) {
        stroke = ceilf(stroke);
    } else {
        stroke = roundf(stroke);
    }
    stroke /= resolution;
    alignStroke = fmodf(0.5f * stroke * resolution, 1.0f);
    path = CGPathCreateMutable();
    point = CGPointMake(44.25f, 22.25f);
    point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
    point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
    CGPathMoveToPoint(path, NULL, point.x, point.y);
    point = CGPointMake(-0.25f, 22.25f);
    point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
    point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
    CGPathAddLineToPoint(path, NULL, point.x, point.y);
    components[0] = 1.0f;
    components[1] = 1.0f;
    components[2] = 1.0f;
    components[3] = 1.0f;
    color = CGColorCreate(space, components);
    CGContextSetStrokeColorWithColor(context, color);
    CGColorRelease(color);
    CGContextAddPath(context, path);
    CGContextStrokePath(context);
    CGPathRelease(path);
    
    CGContextRestoreGState(context);
    CGColorSpaceRelease(space);
}
