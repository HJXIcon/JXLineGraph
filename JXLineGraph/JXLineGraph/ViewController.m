//
//  ViewController.m
//  JXLineGraph
//
//  Created by mac on 17/4/27.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "ViewController.h"
#import "JXLine.h"
#import "JXAverageLine.h"
#import "JXCircle.h"
#import "JXLineGraphView.h"

@interface ViewController ()<JXLineGraphDataSource,JXLineGraphDelegate>

@property(nonatomic, strong) JXAverageLine *averageLine;

@property(nonatomic, strong) JXLineGraphView *myGraph;

@property(nonatomic,strong) NSArray *datas;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"曲线图表";
    
    self.averageLine = [[JXAverageLine alloc]init];
    self.averageLine.enableAverageLine = YES;
    
    self.datas = @[@(20),@(100),@(60),@(200),@(160),@(167),@(180)];
    [self drawGraphView];
    
    [self.myGraph reloadGraph];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (self.view.subviews.count) {
        for (UIView *view in self.view.subviews) {
            
            if ([view isKindOfClass:[JXLine class]]) {
                [view removeFromSuperview];
            }
        }
    }
//     [self drawLine];
//    [self drawCircle];
    
//    [self.myGraph reloadGraph];
    
}


/*!
 
 
 
 
 line.lineDashPatternForReferenceYAxisLines = self.lineDashPatternForReferenceYAxisLines;
 line.lineDashPatternForReferenceXAxisLines = self.lineDashPatternForReferenceXAxisLines;
 line.interpolateNullValues = self.interpolateNullValues;
 
 line.enableRefrenceFrame = self.enableReferenceAxisFrame;
 line.enableRightReferenceFrameLine = self.enableRightReferenceAxisFrameLine;
 line.enableTopReferenceFrameLine = self.enableTopReferenceAxisFrameLine;
 line.enableLeftReferenceFrameLine = self.enableLeftReferenceAxisFrameLine;
 line.enableBottomReferenceFrameLine = self.enableBottomReferenceAxisFrameLine;
 
 
 if (self.enableReferenceXAxisLines || self.enableReferenceYAxisLines) {
 line.enableRefrenceLines = YES;
 line.refrenceLineColor = self.colorReferenceLines;
 //        line.verticalReferenceHorizontalFringeNegation = xAxisHorizontalFringeNegationValue;
 //        line.arrayOfVerticalRefrenceLinePoints = self.enableReferenceXAxisLines ? xAxisLabelPoints : nil;
 //        line.arrayOfHorizontalRefrenceLinePoints = self.enableReferenceYAxisLines ? yAxisLabelPoints : nil;
 }
 
 line.color = self.colorLine;
 line.lineGradient = self.gradientLine;
 line.lineGradientDirection = self.gradientLineDirection;
 line.animationTime = self.animationGraphEntranceTime;
 line.animationType = self.animationGraphStyle;
 
 if (self.averageLine.enableAverageLine == YES) {
 //        if (self.averageLine.yValue == 0.0) self.averageLine.yValue = [self calculatePointValueAverage].floatValue;
 //        line.averageLineYCoordinate = [self yPositionForDotValue:self.averageLine.yValue];
 line.averageLine = self.averageLine;
 } else line.averageLine = self.averageLine;
 
 line.disableMainLine = self.displayDotsOnly;
 
 */

- (void)drawGraphView{
    self.myGraph = [[JXLineGraphView alloc]initWithFrame:CGRectMake(10, 64, self.view.bounds.size.width - 20, 300)];
    
    
    
    /*
     *第一个参数：颜色空间
     *第二个参数：CGFloat数组，指定渐变的开始颜色，终止颜色，以及过度色（如果有的话）
     *第三个参数：指定每个颜色在渐变色中的位置，值介于0.0-1.0之间
     *                      0.0表示最开始的位置，1.0表示渐变结束的位置
     *第四个参数：渐变中使用的颜色数
     */
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = {
        1.0, 1.0, 1.0, 1.0,
        1.0, 1.0, 1.0, 0.0
    };
    
    // Apply the gradient to the bottom portion of the graph
    self.myGraph.gradientBottom = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
    
    self.myGraph.colorLine = [UIColor orangeColor];
    self.myGraph.widthLine = 3;
    self.myGraph.alphaTop = 1;
    self.myGraph.alphaBottom = 1;
    self.myGraph.alphaLine = 1;
    self.myGraph.animationGraphEntranceTime = 3;
    
    self.myGraph.widthReferenceLines = 2;
    self.myGraph.colorReferenceLines = [UIColor blueColor];
    self.myGraph.enableReferenceAxisFrame = YES;
    self.myGraph.enableReferenceXAxisLines = NO;
    self.myGraph.enableReferenceYAxisLines = NO;

    
    self.myGraph.enableRightReferenceAxisFrameLine = NO;
    self.myGraph.enableTopReferenceAxisFrameLine = NO;
    self.myGraph.enableLeftReferenceAxisFrameLine = YES;
    self.myGraph.enableBottomReferenceAxisFrameLine = YES;
    
    
    // Enable and disable various graph properties and axis displays
    self.myGraph.enableTouchReport = YES;
    self.myGraph.enablePopUpReport = YES;
    self.myGraph.enableYAxisLabel = YES;
    self.myGraph.autoScaleYAxis = YES;
    
//    self.myGraph.alwaysDisplayDots = NO;
    self.myGraph.enableBezierCurve = YES;
    
    // 平均线
    // Draw an average line
    self.myGraph.averageLine.enableAverageLine = NO;
    self.myGraph.averageLine.alpha = 0.6;
    self.myGraph.averageLine.color = [UIColor darkGrayColor];
    self.myGraph.averageLine.width = 2.5;
    self.myGraph.averageLine.dashPattern = @[@(2),@(2)];
    
    
    /// 画线方式
    // Set the graph's animation style to draw, fade, or none
    self.myGraph.animationGraphStyle = JXLineAnimationDraw;
    
    
    // 参考
    // Dash the y reference lines
    self.myGraph.lineDashPatternForReferenceYAxisLines = @[@(2),@(2)];
    self.myGraph.lineDashPatternForReferenceXAxisLines = @[@(5),@(2)];
    
    // Show the y axis values with this format string
//    self.myGraph.formatStringForValues = @"%.1f";
    
    
    // Setup initial(最初的) curve(弧线) selection segment
//    self.curveChoice.selectedSegmentIndex = self.myGraph.enableBezierCurve;
    
    // The labels to report the values of the graph when the user touches it
//    self.labelValues.text = [NSString stringWithFormat:@"%i", [[self.myGraph calculatePointValueSum] intValue]];
    
//    self.labelDates.text = @"between now and later";
    
    
    self.myGraph.dataSource = self;
    self.myGraph.delegate = self;
    
//    self.myGraph.alwaysDisplayPopUpLabels = YES;
    
    self.myGraph.graphValuesForDataPoints = self.datas;
    self.myGraph.colorBackgroundPopUplabel = [UIColor lightGrayColor];
    self.myGraph.labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:9];
    self.myGraph.widthTouchInputLine = 60;
    
    UIColor *color = [UIColor colorWithRed:31.0/255.0 green:187.0/255.0 blue:166.0/255.0 alpha:1.0];
    color = [UIColor whiteColor];
    self.myGraph.backgroundColor = color;
    self.myGraph.colorTop = color;
    self.myGraph.colorBottom = color;
    
    [self.view addSubview:self.myGraph];
}

- (void)drawCircle{
    JXCircle *circle = [[JXCircle alloc]initWithFrame:CGRectMake(60, 260, 50, 50)];
    circle.Pointcolor = [UIColor redColor];
    [self.view addSubview:circle];
}

/// 画曲线
- (void)drawLine {
    for (UIView *subview in [self.view subviews]) {
        if ([subview isKindOfClass:[JXLine class]])
            [subview removeFromSuperview];
    }
    
    JXLine *line = [[JXLine alloc] initWithFrame:CGRectMake(10, 64, self.view.bounds.size.width - 20, 300)];
    
    // 不透明
    line.opaque = NO;
    line.alpha = 1;
    line.backgroundColor = [UIColor clearColor];
    
    line.topColor = [UIColor redColor];
    line.bottomColor = [UIColor orangeColor];
    line.topAlpha = 1;
    line.bottomAlpha = 1;
    
    size_t gradLocationNum = 2;
    CGFloat gradLocation[2] = {0.0f, 1.0f};
    CGFloat gradColors[8] = {
        0.0f,0.0f,0.0f,0.0f,
        0.0f,0.0f,0.0f,0.9f
    };
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef topGradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocation, gradLocationNum);
    
    line.topGradient = topGradient;
    
    
    
    CGColorSpaceRef myColorspace;
    size_t num_locations = 2;
    CGFloat locations[2] = {0.0, 1.0};
    CGFloat components[8] = {
        1.0, 0.5, 0.4, 1.0,  //开始颜色(RGB)
        0.8, 0.8, 0.3, 1.0   //终止颜色(RGB)
    };
    myColorspace = CGColorSpaceCreateDeviceRGB();
    /*
     *第一个参数：颜色空间
     *第二个参数：CGFloat数组，指定渐变的开始颜色，终止颜色，以及过度色（如果有的话）
     *第三个参数：指定每个颜色在渐变色中的位置，值介于0.0-1.0之间
     *                      0.0表示最开始的位置，1.0表示渐变结束的位置
     *第四个参数：渐变中使用的颜色数
     */
  CGGradientRef bottomGradient = CGGradientCreateWithColorComponents(myColorspace, components, locations, num_locations);
    
    line.bottomGradient = bottomGradient;
    
    
    line.lineWidth = 5;
    
    line.referenceLineWidth = 3;
    
    line.lineAlpha = 1;
    
    line.bezierCurveIsEnabled = YES;
    
    line.arrayOfPoints = @[@(20),@(100),@(60),@(200),@(160)];
    line.arrayOfValues = @[@(20),@(60),@(100),@(160),@(200)];
    
    line.lineDashPatternForReferenceYAxisLines = @[@(10),@(5)];
    line.lineDashPatternForReferenceXAxisLines = @[@(10),@(5)];
    
    line.interpolateNullValues = NO;
    
    line.enableRefrenceFrame = YES;
    line.enableRightReferenceFrameLine = NO;
    line.enableTopReferenceFrameLine = NO;
    line.enableLeftReferenceFrameLine = YES;
    line.enableBottomReferenceFrameLine = YES;
    
    
    
    line.enableRefrenceLines = YES;
    
    line.refrenceLineColor = [UIColor blueColor];
    
    /// 参考线X | Y
    line.arrayOfVerticalRefrenceLinePoints = @[@(10),@(20),@(40),@(80),@(100),@(120)];
    line.arrayOfHorizontalRefrenceLinePoints = @[@(20),@(60),@(100),@(160),@(200)];
    
    
    line.color = [UIColor purpleColor];
    line.lineGradient = nil;
    line.lineGradientDirection = 0;
    line.animationTime = 3;
    line.animationType = 0;
    

    /// 平均线
    line.averageLine = self.averageLine;
    line.averageLineYCoordinate = 80;
    line.averageLine.enableAverageLine = YES;
    line.averageLine.alpha = 1;
    line.averageLine.color = [UIColor darkGrayColor];
    line.averageLine.width = 2.5;
    line.averageLine.dashPattern = @[@(10),@(2)];
    
    line.disableMainLine = NO;
    
    
    
    [self.view addSubview:line];
    
    //  下面这行代码能够将line  调整到父视图的最下面
//    [self.view sendSubviewToBack:line];
//    [self sendSubviewToBack:self.backgroundXAxis];
//    
//    // 画
//    [self didFinishDrawingIncludingYAxis:NO];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - JXLineGraphDataSource
/** 多少个点 */
- (NSInteger)numberOfPointsInLineGraph:(JXLineGraphView *)graph{
    
    return self.datas.count;
}

- (CGFloat)lineGraph:(JXLineGraphView *)graph valueForPointAtIndex:(NSInteger)index{
    
    return [self.datas[index] floatValue];
    
}


/// X轴的文字
- (NSString *)lineGraph:(JXLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index{
    
    NSLog(@"index == %ld",index);
    NSMutableArray *tmpArray = [NSMutableArray array];
    for (int i = 0; i < self.datas.count; i ++) {
        
        [tmpArray addObject:[NSString stringWithFormat:@"%d%d:%d%d",i,i,i,i]];
        
    }
    
    
    return tmpArray[index];
}



#pragma mark - JXLineGraphDelegate

/// Y轴label个数
- (NSInteger)numberOfYAxisLabelsOnLineGraph:(JXLineGraphView *)graph{
    
    return self.datas.count;
}

- (NSInteger)numberOfGapsBetweenLabelsOnLineGraph:(JXLineGraphView *)graph{
    return self.datas.count - 1;
}


/// Y轴文本前缀
- (NSString *)yAxisPrefixOnLineGraph:(JXLineGraphView *)graph{
 
    return @"";
}
/// Y轴文本后缀
- (NSString *)yAxisSuffixOnLineGraph:(JXLineGraphView *)graph{
    return @"°";
    
}

- (NSString *)noDataLabelTextForLineGraph:(JXLineGraphView *)graph{
    
    return @"暂无数据";
}

/*!----- PopuLabel的前缀后缀 ----- */
- (NSString *)popUpSuffixForlineGraph:(JXLineGraphView *)graph{
    return @"\n m/h";
   
}
- (NSString *)popUpPrefixForlineGraph:(JXLineGraphView *)graph{
    
     return @"满潮 \n";
}




@end
