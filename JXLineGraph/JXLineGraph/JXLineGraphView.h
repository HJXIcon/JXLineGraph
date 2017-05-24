//
//  JXLineGraphView.h
//  JXLineGraph
//
//  Created by mac on 17/4/28.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXLine.h"

@class JXLineGraphView;

@protocol JXLineGraphDataSource <NSObject>
@required

/** 多少个点 */
- (NSInteger)numberOfPointsInLineGraph:(JXLineGraphView *)graph;

/** The vertical position for a point at the given index. It corresponds to the Y-axis value of the Graph.
 @param graph The graph object requesting the point value.
 @param index The index from left to right of a given point (X-axis). The first value for the index is 0.
 @return The Y-axis value at a given index. */
- (CGFloat)lineGraph:(JXLineGraphView *)graph valueForPointAtIndex:(NSInteger)index;


@optional
//------- X AXIS -------//
// 每个X轴的index的Text
/** The string to display on the label on the X-axis at a given index.
 @discussion The number of strings to be returned should be equal to the number of points in the graph (returned in \p numberOfPointsInLineGraph). Otherwise, an exception may be thrown.
 @param graph The graph object which is requesting the label on the specified X-Axis position.
 @param index The index from left to right of a given label on the X-axis. Is the same index as the one for the points. The first value for the index is 0. */
- (NSString *)lineGraph:(JXLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index;

@end




@protocol JXLineGraphDelegate <NSObject>

@optional
/// 是否展示无数据label
- (BOOL)noDataLabelEnableForLineGraph:(JXLineGraphView *)graph;
/// 无数据展示的数据 Default：NO Data
- (NSString *)noDataLabelTextForLineGraph:(JXLineGraphView *)graph;

/// 加载完毕
- (void)lineGraphDidFinishLoading:(JXLineGraphView *)graph;



/// X轴缺口个数 = X轴的文本个数 - 1
- (NSInteger)numberOfGapsBetweenLabelsOnLineGraph:(JXLineGraphView *)graph;

/*!----- Y轴 ----- */
/// Y轴文本前缀
- (NSString *)yAxisPrefixOnLineGraph:(JXLineGraphView *)graph;
/// Y轴文本后缀
- (NSString *)yAxisSuffixOnLineGraph:(JXLineGraphView *)graph;
/// Y轴label个数 Default：3
- (NSInteger)numberOfYAxisLabelsOnLineGraph:(JXLineGraphView *)graph;

/*!----- PopuLabel的前缀后缀 ----- */
- (NSString *)popUpSuffixForlineGraph:(JXLineGraphView *)graph;
- (NSString *)popUpPrefixForlineGraph:(JXLineGraphView *)graph;

/// 返回Pop的自定义View
- (UIView *)popUpViewForLineGraph:(JXLineGraphView *)graph;


/**
 当展示自定义View回调
 @param popupView 弹出的View
 @param index 索引
 */
- (void)lineGraph:(JXLineGraphView *)graph modifyPopupView:(UIView *)popupView forIndex:(NSUInteger)index;


/*!----- 触摸 ----- */

/// 开始触摸
- (void)lineGraph:(JXLineGraphView *)graph didTouchGraphWithClosestIndex:(NSInteger)index;

/** 停止触摸的时候 */
- (void)lineGraph:(JXLineGraphView *)graph didReleaseTouchFromGraphWithClosestIndex:(CGFloat)index;


@end





@interface JXLineGraphView : UIView

#pragma mark - JXLine属性
#pragma mark - ==========================
#pragma mark - ***** color
/// 顶部颜色
@property(nonatomic,strong) UIColor *colorTop;
/** 底部颜色*/
@property (nonatomic, strong)UIColor *colorBottom;
/** 参考线颜色*/
@property (nonatomic, strong)UIColor *colorReferenceLines;
/** 线的颜色*/
@property (nonatomic, strong)UIColor *colorLine;

/** 顶部颜色渐变梯度*/
@property (nonatomic, assign)CGGradientRef gradientTop;
/** 底部颜色渐变梯度*/
@property (nonatomic, assign)CGGradientRef gradientBottom;
/** 线颜色渐变梯度*/
@property (nonatomic, assign)CGGradientRef gradientLine;


#pragma mark - ***** alpha
/** 顶部透明度*/
@property (nonatomic, assign)CGFloat alphaTop;
/** 底部透明度*/
@property (nonatomic, assign)CGFloat alphaBottom;
/** 线的透明度*/
@property (nonatomic, assign)CGFloat alphaLine;

#pragma mark - ***** Size
/** 线宽*/
@property (assign, nonatomic)CGFloat widthLine;
/** 参考线宽*/
@property (nonatomic, assign)CGFloat widthReferenceLines;

#pragma mark - ***** 线样式
/** 是否曲线*/
@property (nonatomic, assign)BOOL enableBezierCurve;
/// X:虚线pattern
@property (nonatomic, strong) NSArray *lineDashPatternForReferenceXAxisLines;
/// Y:虚线pattern like: @[@(10),@(5)]
@property (nonatomic, strong) NSArray *lineDashPatternForReferenceYAxisLines;

/** If a null value is present, interpolation would draw a best fit line through the null point bound by its surrounding points.  Default: YES */
@property (assign, nonatomic) BOOL interpolateNullValues;


#pragma mark - ***** 参考线
/// 是否显示X轴Y轴的坐标
@property (assign, nonatomic) BOOL enableReferenceAxisFrame;
/** 最左边的参考线（Y轴）  Default: YES */
@property (assign, nonatomic) BOOL enableLeftReferenceAxisFrameLine;
/** 最底部的参考线（X轴）  Default: YES */
@property (assign, nonatomic) BOOL enableBottomReferenceAxisFrameLine;
/** 最右边的参考线 Default: NO*/
@property (assign, nonatomic) BOOL enableRightReferenceAxisFrameLine;
/** 最上面的参考线  Default: NO*/
@property (assign, nonatomic) BOOL enableTopReferenceAxisFrameLine;

/** 垂直方向的参考线（穿过X轴）*/
@property (nonatomic, assign)BOOL enableReferenceXAxisLines;
/** 水平方向的参考线（穿过Y轴）*/
@property (nonatomic, assign)BOOL enableReferenceYAxisLines;

#pragma mark - ***** 方向
/// 颜色绘画梯度方向
@property (nonatomic,assign) JXLineGradientDirection gradientLineDirection;

#pragma mark - ***** 动画
/// 动画时间  Default：1.5
@property (nonatomic,assign) CGFloat animationGraphEntranceTime;
@property(nonatomic, assign) JXLineAnimation animationGraphStyle;

#pragma mark - ***** 平均线
@property (strong, nonatomic) JXAverageLine *averageLine;

#pragma mark - ***** 原点
/// Default:NO, 如果是Yes，只展示原点，不展示穿过圆点的线
@property (nonatomic) BOOL displayDotsOnly;

/// 是否原点一直展示 Default:NO
@property (nonatomic) BOOL alwaysDisplayDots;

/// Default:YES 动画的时候显示圆点的动画
@property (nonatomic) BOOL displayDotsWhileAnimating;


#pragma mark - 其他属性
#pragma mark - ==========================
/** 文字大小*/
@property(nonatomic, strong) UIFont *labelFont;
@property(nonatomic, strong) UIFont *noDataLabelFont;
@property(nonatomic, strong) UIColor *noDataLabelColor;

/** X轴文字颜色 */
@property (nonatomic, strong)UIColor *colorXaxisLabel; // Default:black
/** Y轴文字颜色 */
@property (nonatomic, strong)UIColor *colorYaxisLabel; // Default:black
// Default:NO
@property (nonatomic) IBInspectable BOOL enableYAxisLabel;
// Y轴的值自动分配
@property (nonatomic, assign) BOOL autoScaleYAxis;
// Default:Yes
@property (nonatomic) IBInspectable BOOL enableXAxisLabel;

/// XY轴显示的文本格式 Default：@"%.0f"
@property (nonatomic, strong) NSString *formatStringForValues;



/** 圆点颜色 */
@property(nonatomic, strong) UIColor *colorPoint;
/// The size of the circles that represent each point. Default is 10.0.
@property (nonatomic) IBInspectable CGFloat sizePoint;

/** 触摸时候的线的颜色*/ //
@property (nonatomic, strong)UIColor *colorTouchInputLine;
/** 触摸时候的线透明度*/ // Default:1
@property (nonatomic, assign)CGFloat alphaTouchInputLine;
/** 触摸时候的线宽*/ // Default:60
@property (nonatomic, assign)CGFloat widthTouchInputLine;

/** 弹出的label的背景颜色*/
@property (nonatomic, strong)UIColor *colorBackgroundPopUplabel;
/// X轴的背景View颜色
@property (strong, nonatomic) UIColor *colorBackgroundXaxis;
/// X轴的背景View的透明度
@property (nonatomic,assign) CGFloat alphaBackgroundXaxis;
/// Y轴的背景View颜色
@property (strong, nonatomic) UIColor *colorBackgroundYaxis;
/// Y轴的背景View的透明度
@property (nonatomic,assign) CGFloat alphaBackgroundYaxis;


/// Default:NO, 是否一直显示PopLabel
@property (nonatomic, assign) BOOL alwaysDisplayPopUpLabels;

/// 如果是YES，弹出一个label随着用户触摸，在最近的原点 Default：NO.
@property (nonatomic, assign) BOOL enablePopUpReport;

/// 所有点的值，like:@[@(20),@(100),@(60),@(200),@(160),@(167),@(180)]
@property(nonatomic, strong) NSArray <NSValue *>*graphValuesForDataPoints;


/// 触摸时候展示最近的点，如果设置YES，必须实现下面两个方法
@property (nonatomic, assign) BOOL enableTouchReport; // Default:NO
/** 
 触摸手指的个数 Default:1
 */
@property (nonatomic) NSInteger touchReportFingersRequired;


#pragma mark - 数据源代理
@property(nonatomic, weak) id<JXLineGraphDataSource> dataSource;
@property (nonatomic, weak) id <JXLineGraphDelegate> delegate;

- (void)reloadGraph;

@end
