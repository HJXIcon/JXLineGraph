//
//  CAShapeLayer+mask.m
//  JXLineGraph
//
//  Created by mac on 17/5/16.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "CAShapeLayer+mask.h"

@implementation CAShapeLayer (mask)

/**
 创建气泡遮盖
 
 @param view 目标View
 @return CAShapeLayer
 */
+ (instancetype)createAirMaskLayerWithView : (UIView *)view{
    
    
    CGFloat viewWidth = CGRectGetWidth(view.frame);
    CGFloat viewHeight = CGRectGetHeight(view.frame);
    
    /// 气泡宽度
    CGFloat airWidth = 10.;
    CGFloat airHeigt = 4;
    
    CGPoint point1 = CGPointMake(0, 0);
    CGPoint point2 = CGPointMake(viewWidth, 0);
    CGPoint point3 = CGPointMake(viewWidth, viewHeight - airHeigt);
    CGPoint point4 = CGPointMake(viewWidth * 0.5 + airWidth * 0.5, viewHeight - airHeigt);
    CGPoint point5 = CGPointMake(viewWidth * 0.5, viewHeight);
    CGPoint point6 = CGPointMake(viewWidth* 0.5 - airWidth * 0.5, viewHeight - airHeigt);
    CGPoint point7 = CGPointMake(0, viewHeight - airHeigt);
    
    
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:point1];
    [path addLineToPoint:point2];
    [path addLineToPoint:point3];
    [path addLineToPoint:point4];
    [path addLineToPoint:point5];
    [path addLineToPoint:point6];
    [path addLineToPoint:point7];
    [path closePath];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    
    return layer;
}

@end
