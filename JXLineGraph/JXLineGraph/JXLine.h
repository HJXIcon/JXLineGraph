//
//  JXLine.h
//  JXLineGraph
//
//  Created by mac on 17/4/27.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXAverageLine.h"


/// The type of animation used to display the graph
typedef NS_ENUM(NSInteger, JXLineAnimation) {
    /// 从左带到右，从下到上
    JXLineAnimationDraw,
    /// 褪去
    JXLineAnimationFade,
    /// 伸展
    JXLineAnimationExpand,
    /// 无动画
    JXLineAnimationNone
};

/// The drawing direction of the gradient used to draw the graph line (if any)
typedef NS_ENUM(NSUInteger, JXLineGradientDirection) {
    /// The gradient is drawn from left to right
    JXLineGradientDirectionHorizontal = 0,
    /// The gradient is drawn from top to bottom
    JXLineGradientDirectionVertical = 1
};



@interface JXLine : UIView

#pragma mark - *****  POINTS

/// 所有的Y轴的值
/// All of the Y-axis values for the points
@property (strong, nonatomic) NSArray *arrayOfPoints;



/// 距离边缘的距离
/// The value used to offset the fringe vertical reference lines when the x-axis labels are on the edge
@property (assign, nonatomic) CGFloat verticalReferenceHorizontalFringeNegation;

/// X轴的坐标，竖着穿过
@property (strong, nonatomic) NSArray *arrayOfVerticalRefrenceLinePoints;

/// Y轴的坐标，横着穿过
@property (strong, nonatomic) NSArray *arrayOfHorizontalRefrenceLinePoints;

/// All of the point values
@property (strong, nonatomic) NSArray *arrayOfValues;


/// 绘制半透明的参看lines
/** Draw thin, translucent(半透明的), reference lines using the provided X-Axis and Y-Axis coordinates.
 @see Use \p arrayOfVerticalRefrenceLinePoints to specify vertical reference lines' positions. Use \p arrayOfHorizontalRefrenceLinePoints to specify horizontal reference lines' positions. */
@property (assign, nonatomic) BOOL enableRefrenceLines;

/// 是否显示X轴Y轴的坐标
/** Draw a thin, translucent, frame on the edge of the graph to separate it from the labels on the X-Axis and the Y-Axis. */
@property (assign, nonatomic) BOOL enableRefrenceFrame;


/** If reference(参考) frames are enabled, this will enable/disable specific borders.  Default: YES */
@property (assign, nonatomic) BOOL enableLeftReferenceFrameLine;

/** If reference frames are enabled, this will enable/disable specific borders.  Default: YES */
@property (assign, nonatomic) BOOL enableBottomReferenceFrameLine;

/** If reference frames are enabled, this will enable/disable specific borders.  Default: NO */
@property (assign, nonatomic) BOOL enableRightReferenceFrameLine;

/** If reference frames are enabled, this will enable/disable specific borders.  Default: NO */
@property (assign, nonatomic) BOOL enableTopReferenceFrameLine;

/// X:虚线pattern
@property (nonatomic, strong) NSArray *lineDashPatternForReferenceXAxisLines;

/// Y:虚线pattern like: @[@(10),@(5)]
@property (nonatomic, strong) NSArray *lineDashPatternForReferenceYAxisLines;

/** If a null value is present, interpolation would draw a best fit line through the null point bound by its surrounding points.  Default: YES */
@property (assign, nonatomic) BOOL interpolateNullValues;


/// 隐藏主线 Default: NO
/** Draws everything but the main line on the graph; correlates（有相关性） to the \p displayDotsOnly property.  Default: NO */
@property (assign, nonatomic) BOOL disableMainLine;



//----- COLORS -----//

/// The line color. A single, solid color which is applied to the entire line. If the \p gradient property is non-nil this property will be ignored.
@property (strong, nonatomic) UIColor *color;

/// The color of the area above the line, inside of its superview
@property (strong, nonatomic) UIColor *topColor;


// 顶部颜色渐变梯度
@property (assign, nonatomic) CGGradientRef topGradient;

/// The color of the area below the line, inside of its superview
@property (strong, nonatomic) UIColor *bottomColor;

// 底部颜色渐变梯度
@property (assign, nonatomic) CGGradientRef bottomGradient;

/// 线的颜色渐变梯度
@property (assign, nonatomic) CGGradientRef lineGradient;

/// 颜色绘画梯度
/// The drawing direction of the line gradient color
@property (nonatomic) JXLineGradientDirection lineGradientDirection;

/// 参考线颜色 Defaults：自身颜色color
@property (strong, nonatomic) UIColor *refrenceLineColor;



//----- ALPHA -----//

/// 线的透明度
@property (assign, nonatomic) float lineAlpha;

/// 顶部透明度
@property (assign, nonatomic) float topAlpha;

/// 底部透明度
@property (assign, nonatomic) float bottomAlpha;



//----- SIZE -----//

/// 主线宽度
@property (assign, nonatomic) float lineWidth;

/// 参考线线宽
@property (nonatomic) float referenceLineWidth;



/// 是否是光滑的曲线
//----- BEZIER CURVE -----//
/// YES --> 曲线  NO --> 直线
@property (assign, nonatomic) BOOL bezierCurveIsEnabled;



//----- 动画 -----//
/// 动画时间
@property (assign, nonatomic) CGFloat animationTime;

/// 动画方式.
@property (assign, nonatomic) JXLineAnimation animationType;



//----- 平均 -----//

/// 平均线
@property (strong, nonatomic) JXAverageLine *averageLine;


/// 平均线Y的坐标
@property (assign, nonatomic) CGFloat averageLineYCoordinate;


//----- UIBezierPath -----//
/// 主线的路径
@property(nonatomic, strong) UIBezierPath *linePath;
@property(nonatomic, strong) NSArray *bezierPoints;


@end
