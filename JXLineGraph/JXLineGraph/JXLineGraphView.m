//
//  JXLineGraphView.m
//  JXLineGraph
//
//  Created by mac on 17/4/28.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXLineGraphView.h"
#import "JXLine.h"
#import "JXCircle.h"
#import "JXPermanentPopupView.h"
#import "JXVerticalTouchInputView.h"


#define DEFAULT_FONT_NAME @"HelveticaNeue-Light"

typedef NS_ENUM(NSInteger, BEMInternalTags)
{
    DotFirstTag100 = 100,
    DotLastTag1000 = 1000, /// 每一个X轴的label的tag
    LabelYAxisTag2000 = 2000, /// 每一个Y轴的label的tag
    BackgroundYAxisTag2100 = 2100,
    BackgroundXAxisTag2200 = 2200,// X轴的背景范围View的tag
    PermanentPopUpViewTag3100 = 3100, // 弹出View的tag
};


@interface JXLineGraphView ()<UIGestureRecognizerDelegate>

@property(nonatomic, strong) NSMutableArray *xAxisValues;
@property(nonatomic, assign) CGFloat xAxisHorizontalFringeNegationValue;
@property(nonatomic, strong) NSMutableArray *xAxisLabelPoints;
@property(nonatomic, strong) NSMutableArray *yAxisLabelPoints;
/// 所有点值
@property(nonatomic, strong) NSMutableArray *dataPoints;
@property(nonatomic, strong) NSMutableArray *xAxisLabels;

/// 所有点的Y轴值
@property(nonatomic, strong) NSMutableArray *yAxisValues;




/** noData*/
@property (nonatomic, strong)UILabel *noDataLabel;

/** 点的个数*/
@property (nonatomic, assign)NSInteger numberOfPoints;

@property(nonatomic, assign) CGFloat minValue;
@property(nonatomic, assign) CGFloat maxValue;
// Y轴最长文本宽度
@property (nonatomic) CGFloat YAxisLabelXOffset;
// 绘制X轴的背景View
@property (nonatomic) UIView *backgroundXAxis;

/// The Y offset necessary（必要的） to compensate（补偿） the labels on the X-Axis
@property (nonatomic) CGFloat XAxisLabelYOffset;

/// The X position (center) of the view for the popup label
@property (nonatomic) CGFloat xCenterPopupLabel;

@property (nonatomic) CGFloat yCenterPopupLabel;


/// JXline
@property (nonatomic, weak) JXLine *line;

#pragma mark - ****** 触摸事件属性
/// 垂直的线
//@property (strong, nonatomic) UIView *verticalTouchInputLine;
@property (strong, nonatomic) JXVerticalTouchInputView *verticalTouchInputLine;


/// 水平的线
//@property (strong, nonatomic) UIView *horizontalTouchInputLine;


/// 触发拖拽的view
@property (strong, nonatomic, readwrite) UIView *panView;

/// The gesture recognizer picking up the pan in the graph view
@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;

/// This gesture recognizer picks up the initial touch on the graph view
@property (nonatomic) UILongPressGestureRecognizer *longPressGesture;

/// The view used for the background of the popup label
@property (strong, nonatomic) UIView *popUpView;

// Tracks whether the popUpView is custom or default
@property (nonatomic) BOOL usingCustomPopupView;

/// The label displayed when enablePopUpReport is set to YES
@property (strong, nonatomic) UILabel *popUpLabel;

/** 最新的原点*/
@property (nonatomic, strong) JXCircle *closestDot;
/** 最近的点 */
@property(nonatomic, assign) CGFloat currentlyCloser;

/** 遮盖mask*/
@property (nonatomic, strong)CAShapeLayer *maskLayer;

@end

@implementation JXLineGraphView

#pragma mark - lazy loading
- (CAShapeLayer *)maskLayer{
    if (_maskLayer == nil) {
        _maskLayer = [CAShapeLayer layer];
        _maskLayer.backgroundColor = [UIColor clearColor].CGColor;
    }
    return _maskLayer;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        [self commonInit];
        
    }
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) [self commonInit];
    return self;
}



- (void)drawRect:(CGRect)rect {
    
}

#pragma mark - 公用方法
- (void)reloadGraph{
    
    // 1.移除所有
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    // 2.绘制
    [self drawGraph];
    
}


#pragma mark - 私有方法
/// 初始化属性
- (void)commonInit{
    
    // Set the X Axis label font
    _labelFont = [UIFont fontWithName:DEFAULT_FONT_NAME size:13];
    
    
    // Set Animation Values
    _animationGraphEntranceTime = 1.5;
    
    // Set Color Values
    _colorXaxisLabel = [UIColor blackColor];
    _colorYaxisLabel = [UIColor blackColor];
    
    _colorTop = [UIColor colorWithRed:0 green:122.0/255.0 blue:255/255 alpha:1];
    _colorLine = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1];
    _colorBottom = [UIColor colorWithRed:0 green:122.0/255.0 blue:255/255 alpha:1];
    _colorPoint = [UIColor colorWithWhite:1.0 alpha:0.7];
    _colorTouchInputLine = [UIColor clearColor];
    _colorBackgroundPopUplabel = [UIColor whiteColor];
    _alphaTouchInputLine = 1;
    _widthTouchInputLine = 60;
    
    _colorBackgroundXaxis = nil;
    _alphaBackgroundXaxis = 1.0;
    _colorBackgroundYaxis = nil;
    _alphaBackgroundYaxis = 1.0;
    _displayDotsWhileAnimating = YES;
    
    // Set Alpha Values
    _alphaTop = 1.0;
    _alphaBottom = 1.0;
    _alphaLine = 1.0;
    
    // Set Size Values
    _widthLine = 1.0;
    _widthReferenceLines = 1.0;
    _sizePoint = 10.0;
    
    // Set Default Feature Values
    _enableTouchReport = NO;
    _touchReportFingersRequired = 1;
    _enablePopUpReport = NO;
    _enableBezierCurve = NO;
    _enableXAxisLabel = YES;
    _enableYAxisLabel = NO;
    _YAxisLabelXOffset = 0;
    
    _autoScaleYAxis = YES;
    _alwaysDisplayDots = NO;
    _alwaysDisplayPopUpLabels = NO;
    _enableLeftReferenceAxisFrameLine = YES;
    _enableBottomReferenceAxisFrameLine = YES;
    _formatStringForValues = @"%.0f";
    _interpolateNullValues = YES;
    _displayDotsOnly = NO;
    
    // Initialize the various arrays
    _xAxisValues = [NSMutableArray array];
    _xAxisHorizontalFringeNegationValue = 0.0;
    _xAxisLabelPoints = [NSMutableArray array];
    _yAxisLabelPoints = [NSMutableArray array];
    _dataPoints = [NSMutableArray array];
    _xAxisLabels = [NSMutableArray array];
    _yAxisValues = [NSMutableArray array];
    
    // Initialize
    _averageLine = [[JXAverageLine alloc] init];
    
}

- (void)drawGraph{
    
    // 1.获取所有的点
    [self layoutNumberOfPoints];
    
    // 2.画图
    if (self.numberOfPoints <= 1) {
        return;
    }else {
        // 3. 绘画整个图表
        [self drawEntireGraph];
        
        // 4.添加长按，拖拽事件
        [self layoutTouchReport];
        
        // Let the delegate know that the graph finished updates
        if ([self.delegate respondsToSelector:@selector(lineGraphDidFinishLoading:)])
            [self.delegate lineGraphDidFinishLoading:self];
    }
    
    
}



#pragma mark - ****** 图表添加长按，拖拽事件
- (void)layoutTouchReport{

    
    // 1.是否有触摸事件
    if (self.enableTouchReport == YES || self.enablePopUpReport == YES) {
        
        // 1.1垂直 | 水平 的线
        // 垂直
        self.verticalTouchInputLine = [[JXVerticalTouchInputView alloc] initWithFrame:CGRectMake(0, 0, self.widthTouchInputLine, self.frame.size.height)];
        self.verticalTouchInputLine.backgroundColor = self.colorTouchInputLine;
        self.verticalTouchInputLine.alpha = 0;
        [self addSubview:self.verticalTouchInputLine];
        
        
        // 水平
        /*!
        self.horizontalTouchInputLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.widthTouchInputLine)];
        self.horizontalTouchInputLine.backgroundColor = self.colorTouchInputLine;
        self.horizontalTouchInputLine.alpha = 0;
        [self addSubview:self.horizontalTouchInputLine];
        */
         
        // 1.2拖拽的view
        self.panView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width, self.frame.size.height)];
        self.panView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.panView];
        
        // 1.3添加拖拽手势
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGestureAction:)];
        self.panGesture.delegate = self;
        [self.panGesture setMaximumNumberOfTouches:1];
        [self.panView addGestureRecognizer:self.panGesture];
        
        // 1.4添加长按手势
        self.longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleGestureAction:)];
        self.longPressGesture.minimumPressDuration = 0.1f;
        [self.panView addGestureRecognizer:self.longPressGesture];
        
        // 1.5 判读
        if (self.enablePopUpReport == YES && self.alwaysDisplayPopUpLabels == NO) {
            
            // 1.6是否自定义popView
            if ([self.delegate respondsToSelector:@selector(popUpViewForLineGraph:)]) {
                self.popUpView = [self.delegate popUpViewForLineGraph:self];
                self.usingCustomPopupView = YES;
//                self.popUpView.alpha = 0;
                [self addSubview:self.popUpView];

            } else {
                NSString *maxValueString = [NSString stringWithFormat:self.formatStringForValues, [self calculateMaximumPointValue].doubleValue];
                NSString *minValueString = [NSString stringWithFormat:self.formatStringForValues, [self calculateMinimumPointValue].doubleValue];
                
                NSString *longestString = @"";
                if (maxValueString.length > minValueString.length) {
                    longestString = maxValueString;
                } else {
                    longestString = minValueString;
                }
                
                NSString *prefix = @"";
                NSString *suffix = @"";
                if ([self.delegate respondsToSelector:@selector(popUpSuffixForlineGraph:)]) {
                    suffix = [self.delegate popUpSuffixForlineGraph:self];
                }
                if ([self.delegate respondsToSelector:@selector(popUpPrefixForlineGraph:)]) {
                    prefix = [self.delegate popUpPrefixForlineGraph:self];
                }
                
                NSString *fullString = [NSString stringWithFormat:@"%@%@%@", prefix, longestString, suffix];
                
                NSString *mString = [fullString stringByReplacingOccurrencesOfString:@"[0-9-]" withString:@"N" options:NSRegularExpressionSearch range:NSMakeRange(0, [longestString length])];
                
                self.popUpLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
                self.popUpLabel.text = mString;
                self.popUpLabel.textAlignment = 1;
                self.popUpLabel.numberOfLines = 0;
                self.popUpLabel.font = self.labelFont;
                self.popUpLabel.backgroundColor = [UIColor clearColor];
                [self.popUpLabel sizeToFit];
                self.popUpLabel.alpha = 0;
                
                self.popUpView = [[JXPermanentPopupView alloc] initWithFrame:CGRectMake(0, 0, self.popUpLabel.frame.size.width + 10, self.popUpLabel.frame.size.height + 12)];
                self.popUpView.backgroundColor = self.colorBackgroundPopUplabel;
                self.popUpView.alpha = 0;
                self.popUpView.layer.cornerRadius = 3;
                [self addSubview:self.popUpView];
                [self addSubview:self.popUpLabel];
            }
        }
    }
}





- (void)drawEntireGraph{
    
    // 1.移除
    for (UIView *subview in [self subviews]) {
        if ([subview isKindOfClass:[JXLine class]])
            [subview removeFromSuperview];
    }
    
    // 2.获取Y轴最大最小值
    self.maxValue = [self getMaximumValue];
    self.minValue = [self getMinimumValue];
    
    // 3.是否显示Y轴
    if (self.enableYAxisLabel) {
        
        NSDictionary *attributes = @{NSFontAttributeName: self.labelFont};
        
        // 3.1Y轴文本是否自动适应
        if (self.autoScaleYAxis == YES) {
            
            // 3.2formatStringForValues -- 格式化
            NSString *maxValueString = [NSString stringWithFormat:self.formatStringForValues, self.maxValue];
            NSString *minValueString = [NSString stringWithFormat:self.formatStringForValues, self.minValue];
            
            
            // 3.3取得最长的字符串
            NSString *longestString = @"";
            if (maxValueString.length > minValueString.length) longestString = maxValueString;
            else longestString = minValueString;
            
            NSString *prefix = @"";
            NSString *suffix = @"";
            
            // 3.4Y轴的前缀
            if ([self.delegate respondsToSelector:@selector(yAxisPrefixOnLineGraph:)]) {
                prefix = [self.delegate yAxisPrefixOnLineGraph:self];
            }
            // 3.5Y轴的后缀
            if ([self.delegate respondsToSelector:@selector(yAxisSuffixOnLineGraph:)]) {
                suffix = [self.delegate yAxisSuffixOnLineGraph:self];
            }
            
            // 3.6计算宽度
            // [0-9-] 正则 0-9 替换 N
            NSString *mString = [longestString stringByReplacingOccurrencesOfString:@"[0-9-]" withString:@"N" options:NSRegularExpressionSearch range:NSMakeRange(0, [longestString length])];
            NSString *fullString = [NSString stringWithFormat:@"%@%@%@", prefix, mString, suffix];
            
            // 计算文字的宽度
            self.YAxisLabelXOffset = [fullString sizeWithAttributes:attributes].width + 2;
            
            
        }else {
            
            // 3.7如果不自动适应高度，宽度 == self的实际高度
            NSString *longestString = [NSString stringWithFormat:@"%i", (int)self.frame.size.height];
            self.YAxisLabelXOffset = [longestString sizeWithAttributes:attributes].width + 5;
        }
    }else self.YAxisLabelXOffset = 0;// 不显示Y轴文本 offset == 0
    
    // 4.绘制X轴
    [self drawXAxis];
    
    
    // 5.绘制控制点跟曲线（graph）
    [self drawDots];
    
    
    // 6.绘制Y轴
    if (self.enableYAxisLabel) [self drawYAxis];
    
}



// 画图范围
- (CGRect)drawableGraphArea{
    
    NSInteger xAxisHeight = 20;
    CGFloat xOrigin = self.YAxisLabelXOffset;
    CGFloat viewWidth = self.frame.size.width - self.YAxisLabelXOffset;
    CGFloat adjustedHeight = self.bounds.size.height - xAxisHeight;
    
    CGRect rect = CGRectMake(xOrigin, 0, viewWidth, adjustedHeight);
    return rect;
    
}



/// 获取所有的点
- (void)layoutNumberOfPoints{
    
    // 1.数据源获取
    if ([self.dataSource respondsToSelector:@selector(numberOfPointsInLineGraph:)]) {
        self.numberOfPoints = [self.dataSource numberOfPointsInLineGraph:self];
        
    }else self.numberOfPoints = 0;
    
    // 2.没有点
    if (self.numberOfPoints == 0) {
        // 看代理有没有实现
        // 展示没有数据
        // 2.1
        if ([self.delegate respondsToSelector:@selector(noDataLabelEnableForLineGraph:)] &&
            ![self.delegate noDataLabelEnableForLineGraph:self]) {
            return;
        }
        
         self.noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-(self.frame.size.height/4))];
        self.noDataLabel.backgroundColor = [UIColor clearColor];
        self.noDataLabel.textAlignment = NSTextAlignmentCenter;
        
        // 2.2没有数据的显示文字
        NSString *noDataText;
        if ([self.delegate respondsToSelector:@selector(noDataLabelTextForLineGraph:)]) {
            noDataText = [self.delegate noDataLabelTextForLineGraph:self];
        }
        self.noDataLabel.text = noDataText ?: NSLocalizedString(@"No Data", nil);
        
        self.noDataLabel.font = self.noDataLabelFont ?: [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
        self.noDataLabel.textColor = self.noDataLabelColor ?: self.colorLine;
        
        [self addSubview:self.noDataLabel];
        return;
        
        // 3.只有一个点
    }else if(self.numberOfPoints == 1){
        
        
        JXCircle *circleDot = [[JXCircle alloc] initWithFrame:CGRectMake(0, 0, self.sizePoint, self.sizePoint)];
        circleDot.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        circleDot.Pointcolor = self.colorPoint;
        circleDot.alpha = 1;
        [self addSubview:circleDot];
        return;
        
    }else {
        
        // Remove all dots that were previously on the graph
        for (UILabel *subview in [self subviews]) {
            if ([subview isEqual:self.noDataLabel])
                [subview removeFromSuperview];
        }
    }
        
}

#pragma mark ****** Max Min
/// 获取Y轴的最大值
- (CGFloat)getMaximumValue{
    
    CGFloat dotValue;
    CGFloat maxValue = -FLT_MAX;// 最大浮点数
    
    for (int i = 0; i < self.numberOfPoints; i++) {
        
        if ([self.dataSource respondsToSelector:@selector(lineGraph:valueForPointAtIndex:)]) {
            dotValue = [self.dataSource lineGraph:self valueForPointAtIndex:i];
            
        }else {
            dotValue = 0;
        }
        
        if (dotValue == CGFLOAT_MAX) {
            continue;
        }
        
        if (dotValue > maxValue) {
            maxValue = dotValue;
        }
        
    }
    
        return maxValue;
        
}
/// 获取Y轴的最小值
- (CGFloat)getMinimumValue{
    
    CGFloat dotValue;
    CGFloat minValue = INFINITY;
    
    for (int i = 0; i < self.numberOfPoints; i++) {
        
        if ([self.dataSource respondsToSelector:@selector(lineGraph:valueForPointAtIndex:)]) {
            dotValue = [self.dataSource lineGraph:self valueForPointAtIndex:i];
            
        }else {
            dotValue = 0;
        }
        
        if (dotValue == CGFLOAT_MAX) {
            continue;
        }
        
        if (dotValue < minValue) {
            minValue = dotValue;
        }
        
    }
    
    return minValue;
    
    
}

#pragma mark ****** Calculations


/// 计算最小的
- (NSNumber *)calculateMinimumPointValue {
    NSArray *filteredArray = [self calculationDataPoints];
    if (filteredArray.count == 0) return [NSNumber numberWithInt:0];
    
    NSExpression *expression = [NSExpression expressionForFunction:@"min:" arguments:@[[NSExpression expressionForConstantValue:filteredArray]]];
    NSNumber *value = [expression expressionValueWithObject:nil context:nil];
    
    
    return value;
}

- (NSNumber *)calculateMaximumPointValue {
    NSArray *filteredArray = [self calculationDataPoints];
    if (filteredArray.count == 0) return [NSNumber numberWithInt:0];
    
    NSExpression *expression = [NSExpression expressionForFunction:@"max:" arguments:@[[NSExpression expressionForConstantValue:filteredArray]]];
    NSNumber *value = [expression expressionValueWithObject:nil context:nil];
    
    return value;
}

- (NSNumber *)calculatePointValueAverage {
    NSArray *filteredArray = [self calculationDataPoints];
    if (filteredArray.count == 0) return [NSNumber numberWithInt:0];
    
    NSExpression *expression = [NSExpression expressionForFunction:@"average:" arguments:@[[NSExpression expressionForConstantValue:filteredArray]]];
    NSNumber *value = [expression expressionValueWithObject:nil context:nil];
    
    return value;
}


- (NSArray *)calculationDataPoints {
    NSPredicate *filter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        NSNumber *value = (NSNumber *)evaluatedObject;
        BOOL retVal = ![value isEqualToNumber:@(CGFLOAT_MAX)];
        return retVal;
    }];
    
//    NSArray *filteredArray = [self.dataPoints filteredArrayUsingPredicate:filter];
    
    NSArray *filteredArray = [self.graphValuesForDataPoints filteredArrayUsingPredicate:filter];
    
    return filteredArray;
}





#pragma mark - ***** draw
- (void)drawDots{
    
    
    // X轴坐标
    CGFloat positionOnXAxis;
    // Y轴坐标
    CGFloat positionOnYAxis;
    
    /// 1.移除JXLine图表跟JXCircle
    for (UIView *subview in [self subviews]) {
        if ([subview isKindOfClass:[JXCircle class]] || [subview isKindOfClass:[JXPermanentPopupView class]] || [subview isKindOfClass:[JXPermanentPopupLabel class]])
            [subview removeFromSuperview];
    }
    
    /// 2.数组清空
    [_dataPoints removeAllObjects];
    [_yAxisValues removeAllObjects];
    
    /// 3.计算X、Y轴坐标的值
    for (int i = 0;  i < self.numberOfPoints; i ++) {
        CGFloat dotValue = 0;
        if ([self.dataSource respondsToSelector:@selector(lineGraph:valueForPointAtIndex:)]) {
            dotValue = [self.dataSource lineGraph:self valueForPointAtIndex:i];
        }
        
        /// 保存所有的点
        [self.dataPoints addObject:@(dotValue)];
        
        positionOnXAxis = (((self.frame.size.width - self.YAxisLabelXOffset) / (self.numberOfPoints - 1)) * i) + self.YAxisLabelXOffset;
        
        positionOnYAxis = [self yPositionForDotValue:dotValue];
        
        [_yAxisValues addObject:@(positionOnYAxis)];
        
        /// 4.处理空值
        if (dotValue != CGFLOAT_MAX) {
            // 4.1创建JXCircle
            JXCircle *circleDot = [[JXCircle alloc] initWithFrame:CGRectMake(0, 0, self.sizePoint, self.sizePoint)];
            circleDot.center = CGPointMake(positionOnXAxis, positionOnYAxis);
            circleDot.tag = i+ DotFirstTag100;
            circleDot.alpha = 0;
            circleDot.absoluteValue = dotValue;
            circleDot.Pointcolor = self.colorPoint;
            [self addSubview:circleDot];

            
            // 4.2 是否展示PopLabel
            if (self.alwaysDisplayPopUpLabels == YES) {
                
                [self displayPermanentLabelForPoint:circleDot];
            }
            
            if (self.animationGraphEntranceTime == 0) {
                if (self.displayDotsOnly == YES) circleDot.alpha = 1.0;
                else {
                    if (self.alwaysDisplayDots == NO) circleDot.alpha = 0;
                    else circleDot.alpha = 1.0;
                }
            } else {
                if (self.displayDotsWhileAnimating) {
                    //间隔,延迟,动画参数,界面更改块,结束块
                    [UIView animateWithDuration:(float)self.animationGraphEntranceTime / self.numberOfPoints delay:(float)i*((float)self.animationGraphEntranceTime / self.numberOfPoints) options:UIViewAnimationOptionCurveLinear animations:^{
                        circleDot.alpha = 1.0;
                        
                    } completion:^(BOOL finished) {
                        if (self.alwaysDisplayDots == NO && self.displayDotsOnly == NO) {
                            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                                circleDot.alpha = 0;
                            } completion:nil];
                        }
                    }];
                }
            }
            
        }
        
    }
    
    /// 画曲线
    [self drawLine];
}

/// 画JXLine
- (void)drawLine{
    /// 1.移除
    for (UIView *subview in [self subviews]) {
        if ([subview isKindOfClass:[JXLine class]])
            [subview removeFromSuperview];
    }
    
    
    // 2.绘制
    JXLine *line = [[JXLine alloc] initWithFrame:[self drawableGraphArea]];
    _line = line;
    
    line.opaque = NO;
    line.alpha = 1;
    line.backgroundColor = [UIColor clearColor];
    line.topColor = self.colorTop;
    line.bottomColor = self.colorBottom;
    line.topAlpha = self.alphaTop;
    line.bottomAlpha = self.alphaBottom;
    line.topGradient = self.gradientTop;
    line.bottomGradient = self.gradientBottom;
    line.lineWidth = self.widthLine;
    line.referenceLineWidth = self.widthReferenceLines ? self.widthReferenceLines:(self.widthLine/2);
    line.lineAlpha = self.alphaLine;
    line.bezierCurveIsEnabled = self.enableBezierCurve;
    line.arrayOfPoints = _yAxisValues;
    line.arrayOfValues = self.graphValuesForDataPoints;
    
    // 虚线
    line.lineDashPatternForReferenceYAxisLines = self.lineDashPatternForReferenceYAxisLines;
    line.lineDashPatternForReferenceXAxisLines = self.lineDashPatternForReferenceXAxisLines;
    
    line.interpolateNullValues = self.interpolateNullValues;
    
    /// 参考线
    line.enableRefrenceFrame = self.enableReferenceAxisFrame;
    line.enableRightReferenceFrameLine = self.enableRightReferenceAxisFrameLine;
    line.enableTopReferenceFrameLine = self.enableTopReferenceAxisFrameLine;
    line.enableLeftReferenceFrameLine = self.enableLeftReferenceAxisFrameLine;
    line.enableBottomReferenceFrameLine = self.enableBottomReferenceAxisFrameLine;
    
    
    if (self.enableReferenceXAxisLines || self.enableReferenceYAxisLines) {
        line.enableRefrenceLines = YES;
        line.refrenceLineColor = self.colorReferenceLines;
        line.verticalReferenceHorizontalFringeNegation = _xAxisHorizontalFringeNegationValue;
        line.arrayOfVerticalRefrenceLinePoints = self.enableReferenceXAxisLines ? _xAxisLabelPoints : nil;
        line.arrayOfHorizontalRefrenceLinePoints = self.enableReferenceYAxisLines ? _yAxisLabelPoints : nil;
        
    }
    
    
    line.color = self.colorLine;
    line.lineGradient = self.gradientLine;
    line.lineGradientDirection = self.gradientLineDirection;
    line.animationTime = self.animationGraphEntranceTime;
    line.animationType = self.animationGraphStyle;
    
    /// 平均值线
    if (self.averageLine.enableAverageLine == YES) {
        if (self.averageLine.yValue == 0.0) self.averageLine.yValue = [self calculatePointValueAverage].floatValue;
        line.averageLineYCoordinate = [self yPositionForDotValue:self.averageLine.yValue];
        line.averageLine = self.averageLine;
    } else line.averageLine = self.averageLine;
    
    line.disableMainLine = self.displayDotsOnly;
    
    
    
    
    [self addSubview:line];
    //  下面这行代码能够将line  调整到父视图的最下面
    [self sendSubviewToBack:line];
    [self sendSubviewToBack:self.backgroundXAxis];
    

    
    
    
    
}

/// 绘制Y轴
- (void)drawYAxis{
    // 1.移除所有的Y轴文本label跟Y轴背景View
    for (UIView *subview in [self subviews]) {
        if ([subview isKindOfClass:[UILabel class]] && subview.tag == LabelYAxisTag2000 ) {
            [subview removeFromSuperview];
        } else if ([subview isKindOfClass:[UIView class]] && subview.tag == BackgroundYAxisTag2100 ) {
            [subview removeFromSuperview];
        }
    }
    
    // 2.计算Y轴背景View的frame
    CGRect frameForBackgroundYAxis;
    CGRect frameForLabelYAxis;
    CGFloat xValueForCenterLabelYAxis;
    NSTextAlignment textAlignmentForLabelYAxis;
    
    
    frameForBackgroundYAxis = CGRectMake(0, 0, self.YAxisLabelXOffset, self.frame.size.height);
    frameForLabelYAxis = CGRectMake(0, 0, self.YAxisLabelXOffset - 5, 15);
    xValueForCenterLabelYAxis = self.YAxisLabelXOffset/2;
    textAlignmentForLabelYAxis = NSTextAlignmentRight;
    
    
    UIView *backgroundYaxis = [[UIView alloc] initWithFrame:frameForBackgroundYAxis];
    backgroundYaxis.tag = BackgroundYAxisTag2100;
    if (self.colorBackgroundYaxis == nil) backgroundYaxis.backgroundColor = self.colorTop;
    else backgroundYaxis.backgroundColor = self.colorBackgroundYaxis;
    backgroundYaxis.alpha = self.alphaBackgroundYaxis;
    [self addSubview:backgroundYaxis];
    
    
    // 3.添加每一个Y轴的文本
    NSMutableArray *yAxisLabels = [NSMutableArray arrayWithCapacity:0];
    [_yAxisLabelPoints removeAllObjects];
    
    NSString *yAxisSuffix = @"";
    NSString *yAxisPrefix = @"";
    
    // 前缀
    if ([self.delegate respondsToSelector:@selector(yAxisPrefixOnLineGraph:)]) yAxisPrefix = [self.delegate yAxisPrefixOnLineGraph:self];
    // 后缀
    if ([self.delegate respondsToSelector:@selector(yAxisSuffixOnLineGraph:)]) yAxisSuffix = [self.delegate yAxisSuffixOnLineGraph:self];
    
    // Y轴的值自动适应
    if (self.autoScaleYAxis) {
        // Plot according to min-max range
        NSNumber *minimumValue;
        NSNumber *maximumValue;
        
        minimumValue = [self calculateMinimumPointValue];
        maximumValue = [self calculateMaximumPointValue];
        
        CGFloat numberOfLabels = 3;
        
        // Y轴label个数
        if ([self.delegate respondsToSelector:@selector(numberOfYAxisLabelsOnLineGraph:)]) {
            numberOfLabels = [self.delegate numberOfYAxisLabelsOnLineGraph:self];
        }
        
        /// Y轴label值的数组
        NSMutableArray *dotValues = [[NSMutableArray alloc] initWithCapacity:numberOfLabels];
        
        if (numberOfLabels <= 0) return;
        
        else if (numberOfLabels == 1) {
            [dotValues removeAllObjects];
            [dotValues addObject:[NSNumber numberWithInt:(minimumValue.intValue + maximumValue.intValue) / 2]];
            
        } else {
            [dotValues addObject:minimumValue];
            [dotValues addObject:maximumValue];
            for (int i = 1; i< numberOfLabels - 1; i++) {
                [dotValues addObject:[NSNumber numberWithFloat:(minimumValue.doubleValue + ((maximumValue.doubleValue - minimumValue.doubleValue) / (numberOfLabels - 1)) * i)]];
            }
        }
        
        for (NSNumber *dotValue in dotValues) {
            // Y轴的位置
            CGFloat yAxisPosition = [self yPositionForDotValue:dotValue.floatValue];
            
            // 创建label
            UILabel *labelYAxis = [[UILabel alloc] initWithFrame:frameForLabelYAxis];
            /// 文本格式
            NSString *formattedValue = [NSString stringWithFormat:self.formatStringForValues, dotValue.doubleValue];
            
            labelYAxis.text = [NSString stringWithFormat:@"%@%@%@", yAxisPrefix, formattedValue, yAxisSuffix];
            
            labelYAxis.textAlignment = textAlignmentForLabelYAxis;
            
            labelYAxis.font = self.labelFont;
            labelYAxis.textColor = self.colorYaxisLabel;
            labelYAxis.backgroundColor = [UIColor clearColor];
            labelYAxis.tag = LabelYAxisTag2000;
            
            labelYAxis.center = CGPointMake(xValueForCenterLabelYAxis, yAxisPosition);
            
            [self addSubview:labelYAxis];
            [yAxisLabels addObject:labelYAxis];
            
            ///保存Y轴坐标
            NSNumber *yAxisLabelCoordinate = @(labelYAxis.center.y);
            [_yAxisLabelPoints addObject:yAxisLabelCoordinate];
        }
    } else {
        NSInteger numberOfLabels;
        if ([self.delegate respondsToSelector:@selector(numberOfYAxisLabelsOnLineGraph:)]) numberOfLabels = [self.delegate numberOfYAxisLabelsOnLineGraph:self];
        else numberOfLabels = 3;
        
        CGFloat graphHeight = self.frame.size.height;
        CGFloat graphSpacing = (graphHeight - self.XAxisLabelYOffset) / numberOfLabels;
        
        CGFloat yAxisPosition = graphHeight - self.XAxisLabelYOffset + graphSpacing/2;
        
        for (NSInteger i = numberOfLabels; i > 0; i--) {
            yAxisPosition -= graphSpacing;
            
            UILabel *labelYAxis = [[UILabel alloc] initWithFrame:frameForLabelYAxis];
            labelYAxis.center = CGPointMake(xValueForCenterLabelYAxis, yAxisPosition);
            labelYAxis.text = [NSString stringWithFormat:self.formatStringForValues, (graphHeight - self.XAxisLabelYOffset - yAxisPosition)];
            labelYAxis.font = self.labelFont;
            labelYAxis.textAlignment = textAlignmentForLabelYAxis;
            labelYAxis.textColor = self.colorYaxisLabel;
            labelYAxis.backgroundColor = [UIColor clearColor];
            labelYAxis.tag = LabelYAxisTag2000;
            
            [self addSubview:labelYAxis];
            
            [yAxisLabels addObject:labelYAxis];
            
            NSNumber *yAxisLabelCoordinate = @(labelYAxis.center.y);
            [_yAxisLabelPoints addObject:yAxisLabelCoordinate];
        }
    }
    
    // Detect overlapped labels
    __block NSUInteger lastMatchIndex = 0;
    NSMutableArray *overlapLabels = [NSMutableArray arrayWithCapacity:0];
    
    [yAxisLabels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
        
        if (idx==0) lastMatchIndex = 0;
        else { // Skip first one
            UILabel *prevLabel = yAxisLabels[lastMatchIndex];
            CGRect r = CGRectIntersection(prevLabel.frame, label.frame);
            if (CGRectIsNull(r)) lastMatchIndex = idx;
            else [overlapLabels addObject:label]; // overlapped
        }
        
        // Axis should fit into our own view
        BOOL fullyContainsLabel = CGRectContainsRect(self.bounds, label.frame);
        if (!fullyContainsLabel) {
            [overlapLabels addObject:label];
            [_yAxisLabelPoints removeObject:@(label.center.y)];
        }
    }];
    
    for (UILabel *label in overlapLabels) {
        [label removeFromSuperview];
    }
    
}

/// 绘制X轴
- (void)drawXAxis {
    
    // 1.是否显示X轴
    if (!self.enableXAxisLabel) return;
    
    // 2.每个控制点的X轴对应的文本
    if (![self.dataSource respondsToSelector:@selector(lineGraph:labelOnXAxisForIndex:)]) return;
    
    // 3.移除最后一个X轴的文本Label跟BackgroundXAxis
    for (UIView *subview in [self subviews]) {
        if ([subview isKindOfClass:[UILabel class]] && subview.tag == DotLastTag1000) [subview removeFromSuperview];
        else if ([subview isKindOfClass:[UIView class]] && subview.tag == BackgroundXAxisTag2200) [subview removeFromSuperview];
    }
    
    // 4.在添加新X轴的labels之前移除之前所有的X轴的labels
    // Remove all X-Axis Labels before adding them to the array
    [_xAxisValues removeAllObjects];
    [_xAxisLabels removeAllObjects];
    [_xAxisLabelPoints removeAllObjects];
    // 水平X轴边缘反面值
    _xAxisHorizontalFringeNegationValue = 0.0;
    
    // 5.画背景范围View
    // Draw X-Axis Background Area
    self.backgroundXAxis = [[UIView alloc] initWithFrame:[self drawableXAxisArea]];
    
    self.backgroundXAxis.tag = BackgroundXAxisTag2200;
    
    if (self.colorBackgroundXaxis == nil) self.backgroundXAxis.backgroundColor = self.colorBottom;
    else self.backgroundXAxis.backgroundColor = self.colorBackgroundXaxis;
    
    self.backgroundXAxis.alpha = self.alphaBackgroundXaxis;
    [self addSubview:self.backgroundXAxis];
    
    
    // 6.X轴的label应该画的indexs
    // 默认等于点的个数
        NSInteger numberOfGaps = self.numberOfPoints;
    
    // 通过代理赋值
        if ([self.delegate respondsToSelector:@selector(numberOfGapsBetweenLabelsOnLineGraph:)]) {
            numberOfGaps = [self.delegate numberOfGapsBetweenLabelsOnLineGraph:self] + 1;
        }

    
    
    // 添加每一个X轴的文本label
        for (int i = 0; i < numberOfGaps; i++) {
            
            // 1>每一个X轴的文本
            NSString *xAxisLabelText = [self xAxisTextForIndex:i];
            [self.xAxisValues addObject:xAxisLabelText];
            
            // 2>返回每一个label
            UILabel *labelXAxis = [self xAxisLabelWithText:xAxisLabelText atIndex:i numberOfGaps:numberOfGaps];
            // 3>添加到数组
            [self.xAxisLabels addObject:labelXAxis];
            
            // 4>文本的坐标
            NSNumber *xAxisLabelCoordinate = [NSNumber numberWithFloat:labelXAxis.center.x - self.YAxisLabelXOffset];
            [self.xAxisLabelPoints addObject:xAxisLabelCoordinate];
            
            
            [self addSubview:labelXAxis];
            
        }
    
    
//    
//    /// 8.获取相交或者超出的label
//    /// 匹配索引
//    __block NSUInteger lastMatchIndex;
//    
//    // 相交的label数组
//    NSMutableArray *overlapLabels = [NSMutableArray arrayWithCapacity:0];
//    [self.xAxisLabels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
//        if (idx == 0) {
//            lastMatchIndex = 0;
//        } else { // Skip（跳） first one
//            UILabel *prevLabel = [self.xAxisLabels objectAtIndex:lastMatchIndex];
//            // 获取2个矩形的相交区域
//            CGRect r = CGRectIntersection(prevLabel.frame, label.frame);
//            // 可以通过CGRectIsNull函数判断一个CGRect类型的变量是否为CGRectNull
//            if (CGRectIsNull(r)) lastMatchIndex = idx;
//            
//            else [overlapLabels addObject:label]; // Overlapped
//        }
//        
//        // 判断一个rect是否在另一个rect中
//        BOOL fullyContainsLabel = CGRectContainsRect(self.bounds, label.frame);
//        if (!fullyContainsLabel) {
//            [overlapLabels addObject:label];
//        }
//    }];
//    
//    
//    // 9.移除所有的相交或者超出的label
//    for (UILabel *l in overlapLabels) {
//        [l removeFromSuperview];
//    }
}


/// 获取X轴的范围背景View的Frame
- (CGRect)drawableXAxisArea {
    // X轴的高度
    NSInteger xAxisHeight = 20;
    // 宽度
    NSInteger xAxisWidth = [self drawableGraphArea].size.width + 1;
    // X轴的起始点 = Y轴上最长文本
    CGFloat xAxisXOrigin = self.YAxisLabelXOffset;
    // Y轴起始点
    CGFloat xAxisYOrigin = self.bounds.size.height - xAxisHeight;
    
    return CGRectMake(xAxisXOrigin, xAxisYOrigin, xAxisWidth, xAxisHeight);
}


#pragma mark - ******

/**
 展示曲线上Label

 @param circleDot 原点
 */
- (void)displayPermanentLabelForPoint:(JXCircle *)circleDot {
    self.enablePopUpReport = NO;
    self.xCenterPopupLabel = circleDot.center.x;
    
    JXPermanentPopupLabel *permanentPopUpLabel = [[JXPermanentPopupLabel alloc] init];
    permanentPopUpLabel.textAlignment = NSTextAlignmentCenter;
    permanentPopUpLabel.numberOfLines = 0;
    
    NSString *prefix = @"";
    NSString *suffix = @"";
    
    if ([self.delegate respondsToSelector:@selector(popUpSuffixForlineGraph:)])
        suffix = [self.delegate popUpSuffixForlineGraph:self];
    
    if ([self.delegate respondsToSelector:@selector(popUpPrefixForlineGraph:)])
        prefix = [self.delegate popUpPrefixForlineGraph:self];
    
    int index = (int)(circleDot.tag - DotFirstTag100);
    
    NSNumber *value = self.dataPoints[index]; // @((NSInteger) circleDot.absoluteValue)
    
    NSString *formattedValue = [NSString stringWithFormat:self.formatStringForValues, value.doubleValue];
    permanentPopUpLabel.text = [NSString stringWithFormat:@"%@%@%@", prefix, formattedValue, suffix];
    
    permanentPopUpLabel.font = self.labelFont;
    permanentPopUpLabel.backgroundColor = [UIColor clearColor];
    [permanentPopUpLabel sizeToFit];
    permanentPopUpLabel.center = CGPointMake(self.xCenterPopupLabel, circleDot.center.y - circleDot.frame.size.height/2 - 15);
    permanentPopUpLabel.alpha = 0;
    
    JXPermanentPopupView *permanentPopUpView = [[JXPermanentPopupView alloc] initWithFrame:CGRectMake(0, 0, permanentPopUpLabel.frame.size.width + 7, permanentPopUpLabel.frame.size.height + 10)];
    
    permanentPopUpView.backgroundColor = self.colorBackgroundPopUplabel;
    permanentPopUpView.alpha = 0;
    permanentPopUpView.layer.cornerRadius = 3;
    permanentPopUpView.tag = PermanentPopUpViewTag3100;
    permanentPopUpView.center = permanentPopUpLabel.center;
    
    if (permanentPopUpLabel.frame.origin.x <= 0) {
        self.xCenterPopupLabel = permanentPopUpLabel.frame.size.width/2 + 4;
        permanentPopUpLabel.center = CGPointMake(self.xCenterPopupLabel, circleDot.center.y - circleDot.frame.size.height/2 - 15);
    } else if (self.enableYAxisLabel == YES && permanentPopUpLabel.frame.origin.x <= self.YAxisLabelXOffset) {
        self.xCenterPopupLabel = permanentPopUpLabel.frame.size.width/2 + 4;
        permanentPopUpLabel.center = CGPointMake(self.xCenterPopupLabel + self.YAxisLabelXOffset, circleDot.center.y - circleDot.frame.size.height/2 - 15);
    } else if ((permanentPopUpLabel.frame.origin.x + permanentPopUpLabel.frame.size.width) >= self.frame.size.width) {
        self.xCenterPopupLabel = self.frame.size.width - permanentPopUpLabel.frame.size.width/2 - 4;
        permanentPopUpLabel.center = CGPointMake(self.xCenterPopupLabel, circleDot.center.y - circleDot.frame.size.height/2 - 15);
    }
    
    if (permanentPopUpLabel.frame.origin.y <= 2) {
        permanentPopUpLabel.center = CGPointMake(self.xCenterPopupLabel, circleDot.center.y + circleDot.frame.size.height/2 + 15);
    }
    
    if ([self checkOverlapsForView:permanentPopUpView] == YES) {
        permanentPopUpLabel.center = CGPointMake(self.xCenterPopupLabel, circleDot.center.y + circleDot.frame.size.height/2 + 15);
    }
    
    permanentPopUpView.center = permanentPopUpLabel.center;
    
    
    permanentPopUpLabel.numberOfLines = 0;
    [self addSubview:permanentPopUpView];
    [self addSubview:permanentPopUpLabel];
    
    if (self.animationGraphEntranceTime == 0) {
        permanentPopUpLabel.alpha = 1;
        permanentPopUpView.alpha = 0.7;
        
    } else {
        [UIView animateWithDuration:0.5 delay:self.animationGraphEntranceTime options:UIViewAnimationOptionCurveLinear animations:^{
            permanentPopUpLabel.alpha = 1;
            permanentPopUpView.alpha = 0.7;
        } completion:nil];
    }
}

- (BOOL)checkOverlapsForView:(UIView *)view {
    for (UIView *viewForLabel in [self subviews]) {
        if ([viewForLabel isKindOfClass:[UIView class]] && viewForLabel.tag == PermanentPopUpViewTag3100 ) {
            
            if ((viewForLabel.frame.origin.x + viewForLabel.frame.size.width) >= view.frame.origin.x) {
                
                if (viewForLabel.frame.origin.y >= view.frame.origin.y && viewForLabel.frame.origin.y <= view.frame.origin.y + view.frame.size.height) return YES;
                else if (viewForLabel.frame.origin.y + viewForLabel.frame.size.height >= view.frame.origin.y && viewForLabel.frame.origin.y + viewForLabel.frame.size.height <= view.frame.origin.y + view.frame.size.height) return YES;
            }
        }
    }
    return NO;
}




/// 获取每个index的X轴的Text
- (NSString *)xAxisTextForIndex:(NSInteger)index {
    NSString *xAxisLabelText = @"";
    
    if ([self.dataSource respondsToSelector:@selector(lineGraph:labelOnXAxisForIndex:)]) {
        xAxisLabelText = [self.dataSource lineGraph:self labelOnXAxisForIndex:index];
        
    }  else  {
        xAxisLabelText = @"";
    }
    
    
    return xAxisLabelText;
}


/**
 返回X轴每一Label

 @param text 文字
 @param index 索引
 @param numberOfGaps X轴缺口个数 = X轴的文本个数 - 1
 @return label
 */
- (UILabel *)xAxisLabelWithText:(NSString *)text atIndex:(NSInteger)index  numberOfGaps:(NSUInteger)numberOfGaps{
    UILabel *labelXAxis = [[UILabel alloc] init];
    labelXAxis.text = text;
    labelXAxis.font = self.labelFont;
    labelXAxis.textAlignment = NSTextAlignmentCenter;
    labelXAxis.textColor = self.colorXaxisLabel;
    labelXAxis.backgroundColor = [UIColor clearColor];
    labelXAxis.tag = DotLastTag1000;
    
    // Add support multi-line, but this might（可以） overlap（重叠） with the graph line if text have too many lines
    
    labelXAxis.numberOfLines = 0;
    
    // 文本高度计算方式如下
    CGRect lRect = [labelXAxis.text boundingRectWithSize:self.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:labelXAxis.font} context:nil];
    
    
    CGPoint center;
    
    // 水平转换量
    CGFloat horizontalTranslation;
    
    // 第一个向右移动
    if (index == 0) {
        horizontalTranslation = lRect.size.width / 2;
        
        // 最后一个向左移动
    } else if (index + 1 == numberOfGaps) {
        horizontalTranslation = -lRect.size.width/2;
        
        // 其余的不变
    } else horizontalTranslation = 0;
    
    
    self.xAxisHorizontalFringeNegationValue = horizontalTranslation;
    
    // Determine（决定） the final x-axis position
    CGFloat positionOnXAxis;
    
    // 每个label的X起点
    positionOnXAxis = (((self.frame.size.width - self.YAxisLabelXOffset) / (numberOfGaps - 1)) * index) + self.YAxisLabelXOffset + horizontalTranslation;
    
    
    // Set the final center point of the x-axis labels
    center = CGPointMake(positionOnXAxis, self.frame.size.height - lRect.size.height/2);
   
    
    CGRect rect = labelXAxis.frame;
    rect.size = lRect.size;
    labelXAxis.frame = rect;
    labelXAxis.center = center;
    return labelXAxis;
}


/// Y轴位置
- (CGFloat)yPositionForDotValue:(CGFloat)dotValue {
    if (dotValue == CGFLOAT_MAX) {
        return CGFLOAT_MAX;
    }
    
    CGFloat positionOnYAxis; // The position on the Y-axis of the point currently being created.
    CGFloat padding = self.frame.size.height / 2;
    if (padding > 90.0) {
        padding = 90.0;
    }

    
    /// X轴的文字的高度 + 线宽 == XAxisLabelYOffset（Y轴的偏移量）
    if (self.enableXAxisLabel) {
        if ([self.dataSource respondsToSelector:@selector(lineGraph:labelOnXAxisForIndex:)]) {
            if ([_xAxisLabels count] > 0) {
                UILabel *label = [_xAxisLabels objectAtIndex:0];
                self.XAxisLabelYOffset = label.frame.size.height + self.widthLine;
            }
        }
    }
    
    if (self.minValue == self.maxValue && self.autoScaleYAxis == YES) positionOnYAxis = self.frame.size.height/2;
    
    else if (self.autoScaleYAxis == YES) positionOnYAxis = ((self.frame.size.height - padding/2) - ((dotValue - self.minValue) / ((self.maxValue - self.minValue) / (self.frame.size.height - padding)))) + self.XAxisLabelYOffset/2;
    
    else positionOnYAxis = ((self.frame.size.height) - dotValue);
    
    positionOnYAxis -= self.XAxisLabelYOffset;
    
    return positionOnYAxis;
}



#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isEqual:self.panGesture]) {
        
        //numberOfTouches识别到的手势对象中包含 UITouch对象的个数
        if (gestureRecognizer.numberOfTouches >= self.touchReportFingersRequired) {
            
            /// velocityInView：在指定坐标系统中pan gesture拖动的速度
            CGPoint translation = [self.panGesture velocityInView:self.panView];
            NSLog(@"translation.y == %f,translation.x == %f",translation.y,translation.x);
            
            return fabs(translation.y) < fabs(translation.x);
        } else return NO;
        return YES;
    } else return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}

#pragma mark - ******* Actions

- (void)handleGestureAction:(UIGestureRecognizer *)recognizer {
    // 1.检测touch速度
    CGPoint translation = [recognizer locationInView:self];
    
    // 2.判断在不在范围内
    if (!((translation.x + self.frame.origin.x) <= self.frame.origin.x) && !((translation.x + self.frame.origin.x) >= self.frame.origin.x + self.frame.size.width)) {
        
        /// 垂直的线
        self.verticalTouchInputLine.frame = CGRectMake(translation.x - self.widthTouchInputLine/2, 0, self.widthTouchInputLine, self.frame.size.height);
        
        
        
        /// 计算水平线在Y轴的的位置
//         UIBezierPath *path = [UIBezierPath bezierPath];
//        
//        [path moveToPoint:CGPointMake(translation.x, 0)];
//        [path addLineToPoint:CGPointMake(translation.x, self.frame.size.height)];
//        
//        self.maskLayer.path = path.CGPath;
//        self.line.layer.mask = self.maskLayer;
        
        
//         CGRect r = CGRectIntersection(self.verticalTouchInputLine.frame, self.line.frame);
        
        
        
        /// 水平的线与曲线的交点
//        self.horizontalTouchInputLine.frame = CGRectMake(0, translation.y - self.widthTouchInputLine/2, self.frame.size.width, self.widthTouchInputLine);
    }
    
    self.verticalTouchInputLine.alpha = self.alphaTouchInputLine;
//    self.verticalTouchInputLine.backgroundColor = [UIColor redColor];
    
//    self.horizontalTouchInputLine.alpha = self.alphaTouchInputLine;
//    self.horizontalTouchInputLine.backgroundColor = [UIColor redColor];
    
    // 3.计算最近的圆点
    _closestDot = [self closestDotFromtouchInputLine:self.verticalTouchInputLine];
    _closestDot.alpha = 0.8;
    
    
    if (self.enablePopUpReport == YES && _closestDot.tag >= DotFirstTag100 && _closestDot.tag < DotLastTag1000 && [_closestDot isKindOfClass:[JXCircle class]] && self.alwaysDisplayPopUpLabels == NO) {
        // 4.展示
        [self setUpPopUpLabelAbovePoint:_closestDot];
    }
    
    if (_closestDot.tag >= DotFirstTag100 && _closestDot.tag < DotLastTag1000 && [_closestDot isMemberOfClass:[JXCircle class]]) {
        if ([self.delegate respondsToSelector:@selector(lineGraph:didTouchGraphWithClosestIndex:)] && self.enableTouchReport == YES) {
            [self.delegate lineGraph:self didTouchGraphWithClosestIndex:((NSInteger)_closestDot.tag - DotFirstTag100)];
            
        }
    }
    
    /// 鱼图片的Y轴起点
    self.verticalTouchInputLine.drawImageY = CGRectGetMaxY(_closestDot.frame);
    /// 文本
    if ([self.dataSource respondsToSelector:@selector(lineGraph:labelOnXAxisForIndex:)]) {
        
        NSString *string = [self.dataSource lineGraph:self labelOnXAxisForIndex:((NSInteger)_closestDot.tag - DotFirstTag100)];
        self.verticalTouchInputLine.drawText = string;
    }
    
    
    // ON RELEASE
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if ([self.delegate respondsToSelector:@selector(lineGraph:didReleaseTouchFromGraphWithClosestIndex:)]) {
            [self.delegate lineGraph:self didReleaseTouchFromGraphWithClosestIndex:(_closestDot.tag - DotFirstTag100)];
            
        }
        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            if (self.alwaysDisplayDots == NO && self.displayDotsOnly == NO) {
                 _closestDot.alpha = 0;
            }
            
            self.verticalTouchInputLine.alpha = 0;
//            self.horizontalTouchInputLine.alpha = 0;
            if (self.enablePopUpReport == YES) {
                self.popUpView.alpha = 0;
                self.popUpLabel.alpha = 0;
                //                self.customPopUpView.alpha = 0;
            }
        } completion:nil];
    }
}


/// 计算最近的圆点
- (JXCircle *)closestDotFromtouchInputLine:(UIView *)touchInputLine {
    _currentlyCloser = CGFLOAT_MAX;
    for (JXCircle *point in self.subviews) {
        if (point.tag >= DotFirstTag100 && point.tag < DotLastTag1000 && [point isMemberOfClass:[JXCircle class]]) {
            if (self.alwaysDisplayDots == NO && self.displayDotsOnly == NO) {
                point.alpha = 0;
            }
            if (pow(((point.center.x) - touchInputLine.center.x), 2) < _currentlyCloser) {
                _currentlyCloser = pow(((point.center.x) - touchInputLine.center.x), 2);
                _closestDot = point;
            }
        }
    }
    return _closestDot;
}


/// 设置
- (void)setUpPopUpLabelAbovePoint:(JXCircle *)closestPoint {
    self.xCenterPopupLabel = _closestDot.center.x;
    self.yCenterPopupLabel = _closestDot.center.y - _closestDot.frame.size.height/2 - 15;
    self.popUpView.center = CGPointMake(self.xCenterPopupLabel, self.xCenterPopupLabel);
    self.popUpLabel.center = self.popUpView.center;
    int index = (int)(_closestDot.tag - DotFirstTag100);
    
    if ([self.delegate respondsToSelector:@selector(lineGraph:modifyPopupView:forIndex:)]) {
        [self.delegate lineGraph:self modifyPopupView:self.popUpView forIndex:index];
    }
    self.xCenterPopupLabel = _closestDot.center.x;
    self.yCenterPopupLabel = _closestDot.center.y - _closestDot.frame.size.height/2 - 15;
    self.popUpView.center = CGPointMake(self.xCenterPopupLabel, self.yCenterPopupLabel);
    
    self.popUpView.alpha = 1.0;
    
    CGPoint popUpViewCenter = CGPointZero;
    
    if ([self.delegate respondsToSelector:@selector(popUpSuffixForlineGraph:)])
        self.popUpLabel.text = [NSString stringWithFormat:@"%li%@", (long)[self.dataPoints[(NSInteger) _closestDot.tag - DotFirstTag100] integerValue], [self.delegate popUpSuffixForlineGraph:self]];
    else
        self.popUpLabel.text = [NSString stringWithFormat:@"%li", (long)[self.dataPoints[(NSInteger) _closestDot.tag - DotFirstTag100] integerValue]];
    
    if (self.enableYAxisLabel == YES && self.popUpView.frame.origin.x <= self.YAxisLabelXOffset) {
        self.xCenterPopupLabel = self.popUpView.frame.size.width/2;
        popUpViewCenter = CGPointMake(self.xCenterPopupLabel + self.YAxisLabelXOffset + 1, self.yCenterPopupLabel);
        
    } else if ((self.popUpView.frame.origin.x + self.popUpView.frame.size.width) >= self.frame.size.width - self.YAxisLabelXOffset&&NO) {
        self.xCenterPopupLabel = self.frame.size.width - self.popUpView.frame.size.width/2;
        popUpViewCenter = CGPointMake(self.xCenterPopupLabel - self.YAxisLabelXOffset, self.yCenterPopupLabel);
        
    } else if (self.popUpView.frame.origin.x <= 0) {
        self.xCenterPopupLabel = self.popUpView.frame.size.width/2;
        popUpViewCenter = CGPointMake(self.xCenterPopupLabel, self.yCenterPopupLabel);
        
    } else if ((self.popUpView.frame.origin.x + self.popUpView.frame.size.width) >= self.frame.size.width) {
        self.xCenterPopupLabel = self.frame.size.width - self.popUpView.frame.size.width/2;
        popUpViewCenter = CGPointMake(self.xCenterPopupLabel, self.yCenterPopupLabel);
    }
    
    if (self.popUpView.frame.origin.y <= 2) {
        self.yCenterPopupLabel = _closestDot.center.y + _closestDot.frame.size.height/2 + 15;
        popUpViewCenter = CGPointMake(self.xCenterPopupLabel, _closestDot.center.y + _closestDot.frame.size.height/2 + 15);
    }
    
    if (!CGPointEqualToPoint(popUpViewCenter, CGPointZero)) {
        self.popUpView.center = popUpViewCenter;
    }
    
    if (!self.usingCustomPopupView) {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.popUpView.alpha = 0.7;
            self.popUpLabel.alpha = 1;
        } completion:nil];
        NSString *prefix = @"";
        NSString *suffix = @"";
        if ([self.delegate respondsToSelector:@selector(popUpSuffixForlineGraph:)]) {
            suffix = [self.delegate popUpSuffixForlineGraph:self];
        }
        if ([self.delegate respondsToSelector:@selector(popUpPrefixForlineGraph:)]) {
            prefix = [self.delegate popUpPrefixForlineGraph:self];
        }
        NSNumber *value = self.dataPoints[index];
        NSString *formattedValue = [NSString stringWithFormat:self.formatStringForValues, value.doubleValue];
        self.popUpLabel.text = [NSString stringWithFormat:@"%@%@%@", prefix, formattedValue, suffix];
        self.popUpLabel.center = self.popUpView.center;
    }
    
    
   
}








@end
