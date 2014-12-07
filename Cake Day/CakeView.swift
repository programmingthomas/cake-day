//
//  CakeView.swift
//  Cake Day
//
//  Created by Thomas Denney on 07/12/2014.
//  Copyright (c) 2014 Thomas Denney. All rights reserved.
//

import UIKit

class CakeView: UIView {
    var candles: UInt = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext();
        
        CakeDrawingFunction(context, rect);
        
        for n in 0..<candles {
            var radius = 1.0
            var angle = Double(n) / Double(candles) * 2.0 * M_PI
            
            if candles == 1 {
                radius = 0
            } else if candles == 2 {
                radius = 0.5
            } else if candles % 2 == 1 && candles < 8 {
                angle += M_PI / 2.0
            }
            
            let circleX = cos(angle) * radius
            let circleY = -sin(angle) / 3.0 * radius
            
            let x = circleX * 0.6 * Double(CGRectGetMidX(rect))
            let y = circleY * 0.6 * Double(CGRectGetMidY(rect))
            let offsetRect = CGRectOffset(rect, CGFloat(x), CGFloat(y))
            CandleDrawingFunction(context, offsetRect);
        }
    }
}
