//
//  UIBezierPath+Points.m
//  JXLineGraph
//
//  Created by mac on 17/4/29.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "UIBezierPath+Points.h"

#define VALUE(_INDEX_) [NSValue valueWithCGPoint:points[_INDEX_]]
@implementation UIBezierPath (Points)

void getPointsFromBezier(void *info,const CGPathElement *element){
    
    NSMutableArray *bezierPoints = (__bridge NSMutableArray *)info;
    CGPathElementType type = element->type;
    CGPoint *points = element->points;
    
    
    if (type != kCGPathElementCloseSubpath) {
        [bezierPoints addObject:VALUE(0)];
        if ((type != kCGPathElementAddLineToPoint) && (type != kCGPathElementMoveToPoint)) {
            [bezierPoints addObject:VALUE(1)];
        }
    }
    
    if (type == kCGPathElementAddCurveToPoint) {
        [bezierPoints addObject:VALUE(2)];
    }
    
}

- (NSArray *)points
{
    NSMutableArray *points = [NSMutableArray array];
    CGPathApply(self.CGPath, (__bridge void *)points, getPointsFromBezier);
    return points;
    
}

@end
