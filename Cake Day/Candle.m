//
//  Candle.m
//  New Image
//
//  Created by Thomas Denney on 26/08/2013
//  Copyright 2013 Thomas Denney
//  This code was generated by Opacity Express. You may use or modify it in any way.
//

#include "Candle.h"

#include <math.h>

const CGFloat kCandleDrawingFunctionWidth = 1024.0f;
const CGFloat kCandleDrawingFunctionHeight = 1024.0f;

void CandleDrawingFunction(CGContextRef context, CGRect bounds)
{
    CGRect imageBounds = CGRectMake(0.0f, 0.0f, kCandleDrawingFunctionWidth, kCandleDrawingFunctionHeight);
    CGFloat alignStroke;
    CGFloat resolution;
    CGFloat stroke;
    CGMutablePathRef path;
    CGPoint point;
    CGPoint controlPoint1;
    CGPoint controlPoint2;
    CGGradientRef gradient;
    CFMutableArrayRef colors;
    CGColorRef color;
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGPoint point2;
    CGAffineTransform transform;
    CGMutablePathRef tempPath;
    CGRect pathBounds;
    CGFloat components[4];
    CGFloat locations[2];
    
    transform = CGContextGetUserSpaceToDeviceSpaceTransform(context);
    resolution = sqrtf(fabsf(transform.a * transform.d - transform.b * transform.c)) * 0.5f * (bounds.size.width / imageBounds.size.width + bounds.size.height / imageBounds.size.height);
    
    CGContextSaveGState(context);
    CGContextClipToRect(context, bounds);
    CGContextTranslateCTM(context, bounds.origin.x, bounds.origin.y);
    CGContextScaleCTM(context, (bounds.size.width / imageBounds.size.width), (bounds.size.height / imageBounds.size.height));
    
    // Cake
    
    // Candle
    
    // Candle
    
    stroke = 1.0f;
    stroke *= resolution;
    if (stroke < 1.0f) {
        stroke = ceilf(stroke);
    } else {
        stroke = roundf(stroke);
    }
    stroke /= resolution;
    alignStroke = fmodf(0.5f * stroke * resolution, 1.0f);
    path = CGPathCreateMutable();
    point = CGPointMake(480.5f, 417.5f);
    point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
    point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
    CGPathMoveToPoint(path, NULL, point.x, point.y);
    point = CGPointMake(512.0f, 433.25f);
    point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
    point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
    controlPoint1 = CGPointMake(480.5f, 417.5f);
    controlPoint2 = CGPointMake(480.5f, 433.25f);
    CGPathAddCurveToPoint(path, NULL, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, point.x, point.y);
    point = CGPointMake(543.5f, 417.5f);
    point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
    point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
    controlPoint1 = CGPointMake(543.5f, 433.25f);
    controlPoint2 = CGPointMake(543.5f, 417.5f);
    CGPathAddCurveToPoint(path, NULL, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, point.x, point.y);
    point = CGPointMake(543.5f, 260.0f);
    point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
    point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
    controlPoint1 = CGPointMake(543.5f, 417.5f);
    controlPoint2 = CGPointMake(527.75f, 275.75f);
    CGPathAddCurveToPoint(path, NULL, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, point.x, point.y);
    point = CGPointMake(510.425f, 260.0f);
    point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
    point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
    controlPoint1 = CGPointMake(559.25f, 244.25f);
    controlPoint2 = CGPointMake(541.925f, 260.0f);
    CGPathAddCurveToPoint(path, NULL, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, point.x, point.y);
    point = CGPointMake(480.5f, 260.0f);
    point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
    point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
    controlPoint1 = CGPointMake(478.925f, 260.0f);
    controlPoint2 = CGPointMake(464.75f, 244.25f);
    CGPathAddCurveToPoint(path, NULL, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, point.x, point.y);
    point = CGPointMake(480.5f, 417.5f);
    point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
    point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
    controlPoint1 = CGPointMake(496.25f, 275.75f);
    controlPoint2 = CGPointMake(480.5f, 417.5f);
    CGPathAddCurveToPoint(path, NULL, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, point.x, point.y);
    CGPathCloseSubpath(path);
    colors = CFArrayCreateMutable(NULL, 2, &kCFTypeArrayCallBacks);
    components[0] = 0.6f;
    components[1] = 0.6f;
    components[2] = 0.6f;
    components[3] = 1.0f;
    color = CGColorCreate(space, components);
    CFArrayAppendValue(colors, color);
    CGColorRelease(color);
    locations[0] = 0.0f;
    components[0] = 1.0f;
    components[1] = 1.0f;
    components[2] = 1.0f;
    components[3] = 1.0f;
    color = CGColorCreate(space, components);
    CFArrayAppendValue(colors, color);
    CGColorRelease(color);
    locations[1] = 1.0f;
    gradient = CGGradientCreateWithColors(space, colors, locations);
    CGContextAddPath(context, path);
    CGContextSaveGState(context);
    CGContextEOClip(context);
    transform = CGAffineTransformMakeRotation(1.571f);
    tempPath = CGPathCreateMutable();
    CGPathAddPath(tempPath, &transform, path);
    pathBounds = CGPathGetPathBoundingBox(tempPath);
    point = pathBounds.origin;
    point2 = CGPointMake(CGRectGetMaxX(pathBounds), CGRectGetMinY(pathBounds));
    transform = CGAffineTransformInvert(transform);
    point = CGPointApplyAffineTransform(point, transform);
    point2 = CGPointApplyAffineTransform(point2, transform);
    CGPathRelease(tempPath);
    CGContextDrawLinearGradient(context, gradient, point, point2, (kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation));
    CGContextRestoreGState(context);
    CFRelease(colors);
    CGGradientRelease(gradient);
    components[0] = 0.0f;
    components[1] = 0.0f;
    components[2] = 0.0f;
    components[3] = 1.0f;
    color = CGColorCreate(space, components);
    CGContextSetStrokeColorWithColor(context, color);
    CGColorRelease(color);
    CGContextSetLineWidth(context, stroke);
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextAddPath(context, path);
    CGContextStrokePath(context);
    CGPathRelease(path);
    
    stroke = 1.0f;
    stroke *= resolution;
    if (stroke < 1.0f) {
        stroke = ceilf(stroke);
    } else {
        stroke = roundf(stroke);
    }
    stroke /= resolution;
    alignStroke = fmodf(0.5f * stroke * resolution, 1.0f);
    path = CGPathCreateMutable();
    point = CGPointMake(508.85f, 250.55f);
    point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
    point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
    CGPathMoveToPoint(path, NULL, point.x, point.y);
    point = CGPointMake(477.35f, 219.05f);
    point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
    point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
    controlPoint1 = CGPointMake(493.1f, 250.55f);
    controlPoint2 = CGPointMake(477.35f, 234.8f);
    CGPathAddCurveToPoint(path, NULL, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, point.x, point.y);
    point = CGPointMake(508.85f, 140.3f);
    point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
    point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
    controlPoint1 = CGPointMake(477.35f, 203.3f);
    controlPoint2 = CGPointMake(508.85f, 140.3f);
    CGPathAddCurveToPoint(path, NULL, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, point.x, point.y);
    point = CGPointMake(540.35f, 219.05f);
    point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
    point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
    controlPoint1 = CGPointMake(508.85f, 140.3f);
    controlPoint2 = CGPointMake(540.35f, 187.55f);
    CGPathAddCurveToPoint(path, NULL, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, point.x, point.y);
    point = CGPointMake(508.85f, 250.55f);
    point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
    point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
    controlPoint1 = CGPointMake(540.35f, 250.55f);
    controlPoint2 = CGPointMake(524.6f, 250.55f);
    CGPathAddCurveToPoint(path, NULL, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, point.x, point.y);
    CGPathCloseSubpath(path);
    colors = CFArrayCreateMutable(NULL, 2, &kCFTypeArrayCallBacks);
    components[0] = 0.595f;
    components[1] = 0.375f;
    components[2] = 0.021f;
    components[3] = 1.0f;
    color = CGColorCreate(space, components);
    CFArrayAppendValue(colors, color);
    CGColorRelease(color);
    locations[0] = 0.0f;
    components[0] = 0.926f;
    components[1] = 0.576f;
    components[2] = 0.032f;
    components[3] = 1.0f;
    color = CGColorCreate(space, components);
    CFArrayAppendValue(colors, color);
    CGColorRelease(color);
    locations[1] = 1.0f;
    gradient = CGGradientCreateWithColors(space, colors, locations);
    CGContextAddPath(context, path);
    CGContextSaveGState(context);
    CGContextEOClip(context);
    transform = CGAffineTransformMakeRotation(1.571f);
    tempPath = CGPathCreateMutable();
    CGPathAddPath(tempPath, &transform, path);
    pathBounds = CGPathGetPathBoundingBox(tempPath);
    point = pathBounds.origin;
    point2 = CGPointMake(CGRectGetMaxX(pathBounds), CGRectGetMinY(pathBounds));
    transform = CGAffineTransformInvert(transform);
    point = CGPointApplyAffineTransform(point, transform);
    point2 = CGPointApplyAffineTransform(point2, transform);
    CGPathRelease(tempPath);
    CGContextDrawLinearGradient(context, gradient, point, point2, (kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation));
    CGContextRestoreGState(context);
    CFRelease(colors);
    CGGradientRelease(gradient);
    components[0] = 0.0f;
    components[1] = 0.0f;
    components[2] = 0.0f;
    components[3] = 1.0f;
    color = CGColorCreate(space, components);
    CGContextSetStrokeColorWithColor(context, color);
    CGColorRelease(color);
    CGContextAddPath(context, path);
    CGContextStrokePath(context);
    CGPathRelease(path);
    
    alignStroke = 0.0f;
    path = CGPathCreateMutable();
    point = CGPointMake(508.85f, 250.55f);
    point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
    point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
    CGPathMoveToPoint(path, NULL, point.x, point.y);
    point = CGPointMake(486.8f, 228.5f);
    point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
    point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
    controlPoint1 = CGPointMake(497.825f, 250.55f);
    controlPoint2 = CGPointMake(486.8f, 239.525f);
    CGPathAddCurveToPoint(path, NULL, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, point.x, point.y);
    point = CGPointMake(508.85f, 173.375f);
    point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
    point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
    controlPoint1 = CGPointMake(486.8f, 217.475f);
    controlPoint2 = CGPointMake(508.85f, 173.375f);
    CGPathAddCurveToPoint(path, NULL, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, point.x, point.y);
    point = CGPointMake(530.9f, 228.5f);
    point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
    point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
    controlPoint1 = CGPointMake(508.85f, 173.375f);
    controlPoint2 = CGPointMake(530.9f, 206.45f);
    CGPathAddCurveToPoint(path, NULL, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, point.x, point.y);
    point = CGPointMake(508.85f, 250.55f);
    point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
    point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
    controlPoint1 = CGPointMake(530.9f, 250.55f);
    controlPoint2 = CGPointMake(519.875f, 250.55f);
    CGPathAddCurveToPoint(path, NULL, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, point.x, point.y);
    CGPathCloseSubpath(path);
    colors = CFArrayCreateMutable(NULL, 2, &kCFTypeArrayCallBacks);
    components[0] = 0.586f;
    components[1] = 0.487f;
    components[2] = 0.05f;
    components[3] = 1.0f;
    color = CGColorCreate(space, components);
    CFArrayAppendValue(colors, color);
    CGColorRelease(color);
    locations[0] = 0.0f;
    components[0] = 0.995f;
    components[1] = 0.76f;
    components[2] = 0.037f;
    components[3] = 1.0f;
    color = CGColorCreate(space, components);
    CFArrayAppendValue(colors, color);
    CGColorRelease(color);
    locations[1] = 1.0f;
    gradient = CGGradientCreateWithColors(space, colors, locations);
    CGContextAddPath(context, path);
    CGContextSaveGState(context);
    CGContextEOClip(context);
    transform = CGAffineTransformMakeRotation(1.571f);
    tempPath = CGPathCreateMutable();
    CGPathAddPath(tempPath, &transform, path);
    pathBounds = CGPathGetPathBoundingBox(tempPath);
    point = pathBounds.origin;
    point2 = CGPointMake(CGRectGetMaxX(pathBounds), CGRectGetMinY(pathBounds));
    transform = CGAffineTransformInvert(transform);
    point = CGPointApplyAffineTransform(point, transform);
    point2 = CGPointApplyAffineTransform(point2, transform);
    CGPathRelease(tempPath);
    CGContextDrawLinearGradient(context, gradient, point, point2, (kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation));
    CGContextRestoreGState(context);
    CFRelease(colors);
    CGGradientRelease(gradient);
    CGPathRelease(path);
    
    CGContextRestoreGState(context);
    CGColorSpaceRelease(space);
}