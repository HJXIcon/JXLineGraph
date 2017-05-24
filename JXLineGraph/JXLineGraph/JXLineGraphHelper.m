//
//  JXLineGraphHelper.m
//  JXLineGraph
//
//  Created by mac on 17/5/10.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXLineGraphHelper.h"

@implementation JXLineGraphHelper



/**
 *判断点point是否在p0 和 p1两点构成的线段上
 */
- (BOOL)_xw_point:(CGPoint)point isInLineByTwoPoint:(CGPoint)p0 p1:(CGPoint)p1{
    //先设置一个所允许的最大值，点到线段的最短距离小于该值说明点在线段上
    CGFloat maxAllowOffsetLength = 15;
    //通过直线方程的两点式计算出一般式的ABC参数，具体可以自己拿起笔换算一下，很容易
    CGFloat A = p1.y - p0.y;
    CGFloat B = p0.x - p1.x;
    CGFloat C = p1.x * p0.y - p0.x * p1.y;
    //带入点到直线的距离公式求出点到直线的距离dis
    CGFloat dis = fabs((A * point.x + B * point.y + C) / sqrt(pow(A, 2) + pow(B, 2)));
    //如果该距离大于允许值说明则不在线段上
    if (dis > maxAllowOffsetLength || isnan(dis)) {
        return NO;
    }else{
        //否则我们要进一步判断，投影点是否在线段上，根据公式求出投影点的X坐标jiaoX
        CGFloat D = (A * point.y - B * point.x);
        CGFloat jiaoX = -(A * C + B *D) / (pow(B, 2) + pow(A, 2));
        //判断jiaoX是否在线段上，t如果在0~1之间说明在线段上，大于1则说明不在线段且靠近端点p1，小于0则不在线段上且靠近端点p0，这里用了插值的思想
        CGFloat t = (jiaoX - p0.x) / (p1.x - p0.x);
        if (t > 1  || isnan(t)) {
            //最小距离为到p1点的距离
            dis = XWLengthOfTwoPoint(p1, point);
        }else if (t < 0){
            //最小距离为到p2点的距离
            dis = XWLengthOfTwoPoint(p0, point);
        }
        //再次判断真正的最小距离是否小于允许值，小于则该点在直线上，反之则不在
        if (dis <= maxAllowOffsetLength) {
            return YES;
        }else{
            return NO;
        }
    }
}

//这里是求两点距离公式
static inline CGFloat XWLengthOfTwoPoint(CGPoint point1, CGPoint point2){
    return sqrt(pow(point1.x - point2.x, 2) + pow(point1.y - point2.y, 2));
}


@end
