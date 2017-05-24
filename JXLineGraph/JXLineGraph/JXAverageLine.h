//
//  JXAverageLine.h
//  JXLineGraph
//
//  Created by mac on 17/4/27.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 平均线
 */
@interface JXAverageLine : UIView


/// YES --> 有平均线 Default : NO
@property (nonatomic) BOOL enableAverageLine;


/// 颜色
@property (strong, nonatomic) UIColor *color;


/// The Y-Value of the average line. This could be an average, a median, a mode, sum, etc.
/// Default == 0.0
@property (nonatomic) CGFloat yValue;


/// 透明度 Default == 1.0
@property (nonatomic) CGFloat alpha;


/// 线宽 Default == 3.0
@property (nonatomic) CGFloat width;

/*!
 // 3=线的宽度 1=每条线的间距
 [shapeLayer setLineDashPattern:
 [NSArray arrayWithObjects:[NSNumber numberWithInt:3],
 [NSNumber numberWithInt:1],nil]];
 
 */
@property (strong, nonatomic) NSArray *dashPattern;


@end
