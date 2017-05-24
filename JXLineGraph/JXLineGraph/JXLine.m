//
//  JXLine.m
//  JXLineGraph
//
//  Created by mac on 17/4/27.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXLine.h"
#if CGFLOAT_IS_DOUBLE
#define CGFloatValue doubleValue
#else
#define CGFloatValue floatValue
#endif


@interface JXLine ()

/**
 CGPoint的数组
 */
@property (nonatomic, strong) NSMutableArray  <NSValue *>*points;


@end
@implementation JXLine


#pragma mark - lazy loading
/// 底部的Point数组
- (NSArray *)bottomPointsArray {
    
    CGPoint bottomPointZero = CGPointMake(0, self.frame.size.height);
    CGPoint bottomPointFull = CGPointMake(self.frame.size.width, self.frame.size.height);
    NSMutableArray *bottomPoints = [NSMutableArray arrayWithArray:self.points];
    [bottomPoints insertObject:[NSValue valueWithCGPoint:bottomPointZero] atIndex:0];
    [bottomPoints addObject:[NSValue valueWithCGPoint:bottomPointFull]];
    return bottomPoints;
}

/// 顶部
- (NSArray *)topPointsArray {
    CGPoint topPointZero = CGPointMake(0,0);
    CGPoint topPointFull = CGPointMake(self.frame.size.width, 0);
    NSMutableArray *topPoints = [NSMutableArray arrayWithArray:self.points];
    [topPoints insertObject:[NSValue valueWithCGPoint:topPointZero] atIndex:0];
    [topPoints addObject:[NSValue valueWithCGPoint:topPointFull]];
    return topPoints;
}


#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame: frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        _enableLeftReferenceFrameLine = YES;
        _enableBottomReferenceFrameLine = YES;
        _interpolateNullValues = YES;
    }
    return self;
}


#pragma mark - draw
- (void)drawRect:(CGRect)rect {
    
    /*! 画参考线 */
    // 1.三种路径
    UIBezierPath *verticalReferenceLinesPath = [UIBezierPath bezierPath];
    UIBezierPath *horizontalReferenceLinesPath = [UIBezierPath bezierPath];
    UIBezierPath *referenceFramePath = [UIBezierPath bezierPath];
    
    
    /*!
     kCGLineCapButt,该属性值指定不绘制端点，
     线条结尾处直接结束。这是默认值。
     kCGLineCapRound,线条拐角
     kCGLineCapSquare 终点处理
     */
    verticalReferenceLinesPath.lineCapStyle = kCGLineCapButt;
    verticalReferenceLinesPath.lineWidth = 0.7;
    
    horizontalReferenceLinesPath.lineCapStyle = kCGLineCapButt;
    horizontalReferenceLinesPath.lineWidth = 0.7;
    
    referenceFramePath.lineCapStyle = kCGLineCapButt;
    referenceFramePath.lineWidth = 0.7;
    
    /// 2.判断是否有参考(外框)
    if (self.enableRefrenceFrame == YES) {
        
        /// 2.1底部参考线（X轴坐标）
        if (self.enableBottomReferenceFrameLine) {
            // Bottom Line
            [referenceFramePath moveToPoint:CGPointMake(0, self.frame.size.height)];
            [referenceFramePath addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
        }
        
        // 2.2左边参考线（Y轴坐标）
        if (self.enableLeftReferenceFrameLine) {
            // Left Line
            [referenceFramePath moveToPoint:CGPointMake(0 + self.referenceLineWidth / 4, self.frame.size.height)];
            [referenceFramePath addLineToPoint:CGPointMake(0 + self.referenceLineWidth / 4, 0)];
        }
        
        // 2.3顶部参考线
        if (self.enableTopReferenceFrameLine) {
            // Top Line
            [referenceFramePath moveToPoint:CGPointMake(0 + self.referenceLineWidth / 4, 0)];
            [referenceFramePath addLineToPoint:CGPointMake(self.frame.size.width, 0)];
        }
        
        // 2.4右边参考线
        if (self.enableRightReferenceFrameLine) {
            // Right Line
            [referenceFramePath moveToPoint:CGPointMake(self.frame.size.width - self.referenceLineWidth/4, self.frame.size.height)];
            [referenceFramePath addLineToPoint:CGPointMake(self.frame.size.width - self.referenceLineWidth/4, 0)];
        }
        
        
    }
    
    /// 3.参考线(框内)
    if (self.enableRefrenceLines == YES) {
        
         // 3.1根据X轴的参考线
        if (self.arrayOfVerticalRefrenceLinePoints.count > 0) {
            
            for (NSNumber *xNumber in self.arrayOfVerticalRefrenceLinePoints) {
                CGFloat xValue;
                
                /// 3.2距离边缘的距离不为0
                if (self.verticalReferenceHorizontalFringeNegation != 0.0) {
                    
                    // 3.2.1 xNumber == 0
                    if ([self.arrayOfVerticalRefrenceLinePoints indexOfObject:xNumber] == 0) { // far left reference line
                        xValue = [xNumber floatValue] + self.verticalReferenceHorizontalFringeNegation;
                        
                        // 3.2.2 最后一个index的值 == X轴的坐标数组.count - 1
                    } else if ([self.arrayOfVerticalRefrenceLinePoints indexOfObject:xNumber] == [self.arrayOfVerticalRefrenceLinePoints count] - 1) { // far right reference line
                        xValue = [xNumber floatValue] - self.verticalReferenceHorizontalFringeNegation;
                        
                        // 3.2.3
                    } else xValue = [xNumber floatValue];
                    
                    
                   // 3.3距离边缘的距离为0
                } else xValue = [xNumber floatValue];
                
                
                // 3.4开始的点
                CGPoint initialPoint = CGPointMake(xValue, self.frame.size.height);
                // 3.4结束的点
                CGPoint finalPoint = CGPointMake(xValue, 0);
                
                [verticalReferenceLinesPath moveToPoint:initialPoint];
                [verticalReferenceLinesPath addLineToPoint:finalPoint];
                }
            }
        
        // 3.2根据Y轴的参考线
        if (self.arrayOfHorizontalRefrenceLinePoints.count > 0) {
            for (NSNumber *yNumber in self.arrayOfHorizontalRefrenceLinePoints) {
                CGPoint initialPoint = CGPointMake(0, [yNumber floatValue]);
                CGPoint finalPoint = CGPointMake(self.frame.size.width, [yNumber floatValue]);
                
                [horizontalReferenceLinesPath moveToPoint:initialPoint];
                [horizontalReferenceLinesPath addLineToPoint:finalPoint];
            }
        }
        
        }
    
    

    
    /// 4.平均线
    UIBezierPath *averageLinePath = [UIBezierPath bezierPath];
    
    if (self.averageLine.enableAverageLine == YES) {
        averageLinePath.lineCapStyle = kCGLineCapButt;
        averageLinePath.lineWidth = self.averageLine.width;
        
        CGPoint initialPoint = CGPointMake(0, self.averageLineYCoordinate);
        
        CGPoint finalPoint = CGPointMake(self.frame.size.width, self.averageLineYCoordinate);
        
        [averageLinePath moveToPoint:initialPoint];
        [averageLinePath addLineToPoint:finalPoint];
    }

    
    /// 5.主曲线
    UIBezierPath *linePath = [UIBezierPath bezierPath]; // line的填充路径
    
    
    UIBezierPath *fillTopPath; // 上半部填充path
    UIBezierPath *fillBottomPath; // 下半部填充path
    
    // 5.1X轴的缩放范围求出X等间距的点
    CGFloat xIndexScale = self.frame.size.width / ([self.arrayOfPoints count] - 1);
    
    self.points = [NSMutableArray arrayWithCapacity:self.arrayOfPoints.count];
    
    for (int i = 0; i < self.arrayOfPoints.count; i++) {
        CGPoint value = CGPointMake(xIndexScale * i, [self.arrayOfPoints[i] CGFloatValue]);
        
        if (value.y != CGFLOAT_MAX || !self.interpolateNullValues) {
            [self.points addObject:[NSValue valueWithCGPoint:value]];
        }
    }
    
    /// 5.2是曲线还是直线
    BOOL bezierStatus = self.bezierCurveIsEnabled;
    
    /// 如果点数小于等于2  强制--->直线
    if (self.arrayOfPoints.count <= 2 && self.bezierCurveIsEnabled == YES) bezierStatus = NO;
    
    /// 是否隐藏主线
    if (!self.disableMainLine && bezierStatus) {
        
        linePath = [JXLine quadCurvedPathWithPoints:self.points];
        fillBottomPath = [JXLine quadCurvedPathWithPoints:self.bottomPointsArray];
        fillTopPath = [JXLine quadCurvedPathWithPoints:self.topPointsArray];
        
    } else if (!self.disableMainLine && !bezierStatus) {
        linePath = [JXLine linesToPoints:self.points];
        fillBottomPath = [JXLine linesToPoints:self.bottomPointsArray];
        fillTopPath = [JXLine linesToPoints:self.topPointsArray];
        
    } else {
        fillBottomPath = [JXLine linesToPoints:self.bottomPointsArray];
        fillTopPath = [JXLine linesToPoints:self.topPointsArray];
    }
    
    // 5.3设置Top颜色
     [self.topColor set];
    
    // 5.4top指定
    /**
     *  用指定的混合模式和透明度来填充路径包围的区域
     *
     *  @param blendMode 混合模式,枚举值
     *  @param alpha     透明度
     */
    [fillTopPath fillWithBlendMode:kCGBlendModeNormal alpha:self.topAlpha];

    // 5.5 bottom
    [self.bottomColor set];
    [fillBottomPath fillWithBlendMode:kCGBlendModeNormal alpha:self.bottomAlpha];
    
    
    /*!
     
     首先,来总结下绘图的基本流程：
     1.获得图形上下文:
     let context = UIGraphicsGetCurrentContext();
     2.设置图形上下文属性:(比如线条的起点,终点 ,线条的width ,线条的color 等等)
     CGContextSetLineWidth(context, 20);
     CGContextMoveToPoint(context, 282, 298);
     3.绘制(渲染)设置好的图形上下文状态;
     CGContextStrokePath(context);
     
     
     以上,就是基本绘图流程,如果你只是在一个view上, 只画一条线段,
     或者只画一个圆, 那么这个流程也就没有问题,对于图形上下文来说,也只进行一次操作,
     但是问题是,如果我们想要画比较复杂的图形,对于我们的创建的图形上下文来说,显然改图形上下文(context)的状态将会被多次改变,后面的绘制将对前面的绘制造成影响~~
     (因为图形上下文的对象只有一个,每次通过CGCOntext命令的时候, 都是不断在修改图形上下文的属性,这个属性对于图形上下文来讲,就是唯一的,比如说设置线段的粗细为1,那么此刻图形上下文里 所有的线段 都是1粗细)*
     对此,苹果设置一个保存图形上下文的栈,来随时存储当前你的图形上下文(个人感觉有点像NSUserdefault,)
     通过 CGContextSaveGState(context); 来保存(推入)图形上下文到栈顶
     在绘制(渲染之后),通过 CGContextRestoreGState(context);来更新(将之前入栈的图形上下文状态出栈,将当前的图形上下文状态入栈)图形上下到栈顶
     注意:这两个代码一般成对出现, 这样既保护了图形上下文状态的唯一性,也方便了在需要的地方修改图形上下状态
     
     总结:
     绘图的一般流程补完:
     1. 获得图形上下文(let context = UIGraphicsGetCurrentContext();)
     2.CGContextSaveGState(context); //保存当前图形上下文(入栈)
     3.设置上下文状态;
     4.绘制(渲染);
     5.CGContextRestoreGState(context); //跟新图形上下文()
     
     
     
     */
    
    
    /// 6.绘制top跟bottom
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 6.1判断颜色梯度
    if (self.topGradient != nil) {
        // 保存当前图形上下文(入栈)
        CGContextSaveGState(ctx);
        // 把刚刚创建的路径依次添加到上下文对象中
        CGContextAddPath(ctx, [fillTopPath CGPath]);
        //剪切自定义指定区域意外的部分
        CGContextClip(ctx);
        // 绘制渐变
        CGContextDrawLinearGradient(ctx, self.topGradient, CGPointZero, CGPointMake(0, CGRectGetMaxY(fillTopPath.bounds)), 0);
        // 跟新图形上下文
        CGContextRestoreGState(ctx);
    }
    
    if (self.bottomGradient != nil) {
        CGContextSaveGState(ctx);
        CGContextAddPath(ctx, fillBottomPath.CGPath);
        CGContextClip(ctx);
        CGContextDrawLinearGradient(ctx, self.bottomGradient, CGPointZero, CGPointMake(0, CGRectGetMaxY(fillBottomPath.bounds)), 0);
        CGContextRestoreGState(ctx);
    }
    
    
    /// 7.是否动画绘制
    // 7.1是否有半透明参考线
    if (self.enableRefrenceLines == YES) {
        // 7.1.1垂直线(根据X轴坐标)
        CAShapeLayer *verticalReferenceLinesPathLayer = [CAShapeLayer layer];
        verticalReferenceLinesPathLayer.frame = self.bounds;
        verticalReferenceLinesPathLayer.path = verticalReferenceLinesPath.CGPath;
        verticalReferenceLinesPathLayer.opacity = self.lineAlpha == 0 ? 0.1 : self.lineAlpha * 0.5;
        verticalReferenceLinesPathLayer.fillColor = nil;
        verticalReferenceLinesPathLayer.lineWidth = self.referenceLineWidth * 0.5;
        
        // 是否是虚线
        if (self.lineDashPatternForReferenceYAxisLines) {
            /*!
             // 3=线的宽度 1=每条线的间距
             [shapeLayer setLineDashPattern:
             [NSArray arrayWithObjects:[NSNumber numberWithInt:3],
             [NSNumber numberWithInt:1],nil]];
             */
            /// 画虚线
            verticalReferenceLinesPathLayer.lineDashPattern = self.lineDashPatternForReferenceYAxisLines;
            //            verticalReferenceLinesPathLayer.lineDashPattern = @[@(10),@(5)];
        }
        
        // 参考线颜色
        if (self.refrenceLineColor) {
            verticalReferenceLinesPathLayer.strokeColor = self.refrenceLineColor.CGColor;
            
            
        } else {
            verticalReferenceLinesPathLayer.strokeColor = self.color.CGColor;
        }
        
        // 是否动画
        if (self.animationTime > 0){
            
            // 动画处理
            [self animateForLayer:verticalReferenceLinesPathLayer withAnimationType:self.animationType isAnimatingReferenceLine:YES];
        }
        
        // 添加layer
        [self.layer addSublayer:verticalReferenceLinesPathLayer];
        
        
        // 7.1.2水平线（根据Y轴坐标）
        CAShapeLayer *horizontalReferenceLinesPathLayer = [CAShapeLayer layer];
        
        horizontalReferenceLinesPathLayer.frame = self.bounds;
        horizontalReferenceLinesPathLayer.path = horizontalReferenceLinesPath.CGPath;
        horizontalReferenceLinesPathLayer.opacity = self.lineAlpha == 0 ? 0.1 : self.lineAlpha/2;
        horizontalReferenceLinesPathLayer.fillColor = nil;
        horizontalReferenceLinesPathLayer.lineWidth = self.referenceLineWidth/2;
        
        if(self.lineDashPatternForReferenceXAxisLines) {
            horizontalReferenceLinesPathLayer.lineDashPattern = self.lineDashPatternForReferenceXAxisLines;
        }
        
        if (self.refrenceLineColor) {
            horizontalReferenceLinesPathLayer.strokeColor = self.refrenceLineColor.CGColor;
        } else {
            horizontalReferenceLinesPathLayer.strokeColor = self.color.CGColor;
        }
        
        if (self.animationTime > 0)
            
            [self animateForLayer:horizontalReferenceLinesPathLayer withAnimationType:self.animationType isAnimatingReferenceLine:YES];
        
        [self.layer addSublayer:horizontalReferenceLinesPathLayer];
        
    }
    
    
    // 7.1.3 X轴和Y轴
    CAShapeLayer *referenceLinesPathLayer = [CAShapeLayer layer];
    referenceLinesPathLayer.frame = self.bounds;
    referenceLinesPathLayer.path = referenceFramePath.CGPath;
    referenceLinesPathLayer.opacity = self.lineAlpha == 0 ? 0.1 : self.lineAlpha/2;
    referenceLinesPathLayer.fillColor = nil;
    referenceLinesPathLayer.lineWidth = self.referenceLineWidth/2;
    
    if (self.refrenceLineColor) referenceLinesPathLayer.strokeColor = self.refrenceLineColor.CGColor;
    else referenceLinesPathLayer.strokeColor = self.color.CGColor;
    
    
    //    referenceLinesPathLayer.strokeColor = [UIColor purpleColor].CGColor;
    if (self.animationTime > 0)
        [self animateForLayer:referenceLinesPathLayer withAnimationType:self.animationType isAnimatingReferenceLine:YES];
    [self.layer addSublayer:referenceLinesPathLayer];
    
    
    // 7.1.4主线
    if (self.disableMainLine == NO) {
        CAShapeLayer *pathLayer = [CAShapeLayer layer];
        pathLayer.frame = self.bounds;
        pathLayer.path = linePath.CGPath;
        pathLayer.strokeColor = self.color.CGColor;
        pathLayer.fillColor = nil;
        pathLayer.opacity = self.lineAlpha;
        pathLayer.lineWidth = self.lineWidth;
        pathLayer.lineJoin = kCALineJoinBevel;
        pathLayer.lineCap = kCALineCapRound;
        if (self.animationTime > 0) [self animateForLayer:pathLayer withAnimationType:self.animationType isAnimatingReferenceLine:NO];
        
        pathLayer.strokeColor = [UIColor orangeColor].CGColor;
        
        if (self.lineGradient) [self.layer addSublayer:[self backgroundGradientLayerForLayer:pathLayer]];
        
        else [self.layer addSublayer:pathLayer];
    
    }
    
    // 7.1.5平均线
    if (self.averageLine.enableAverageLine == YES) {
        
        CAShapeLayer *averageLinePathLayer = [CAShapeLayer layer];
        
        averageLinePathLayer.frame = self.bounds;
        averageLinePathLayer.path = averageLinePath.CGPath;
        averageLinePathLayer.opacity = self.averageLine.alpha;
        averageLinePathLayer.fillColor = nil;
        averageLinePathLayer.lineWidth = self.averageLine.width;
        
        if (self.averageLine.dashPattern) averageLinePathLayer.lineDashPattern = self.averageLine.dashPattern;
        
        if (self.averageLine.color) averageLinePathLayer.strokeColor = self.averageLine.color.CGColor;
        
        else averageLinePathLayer.strokeColor = self.color.CGColor;
        
        if (self.animationTime > 0)
            [self animateForLayer:averageLinePathLayer withAnimationType:self.animationType isAnimatingReferenceLine:NO];
        
        [self.layer addSublayer:averageLinePathLayer];
    }
    
    
    NSMutableArray *points = [NSMutableArray array];
    CGPathApply(linePath.CGPath, (__bridge void * _Nullable)(points), MyCGPathApplierFunc);
    
//    NSLog(@"bezierPoints == %@",points);
//    NSLog(@"count == %ld",points.count);
    
    self.bezierPoints = points;
  
    self.linePath = linePath;
}


#pragma mark - 背景颜色处理
/// 是否颜色渐变梯度
- (CALayer *)backgroundGradientLayerForLayer:(CAShapeLayer *)shapeLayer {
    // 1.创建一个基于位图的上下文（context）,并将其设置为当前上下文(context)
    UIGraphicsBeginImageContext(self.bounds.size);
    
    CGContextRef imageCtx = UIGraphicsGetCurrentContext();
    
    CGPoint start, end;
    
    // 2.水平 | 垂直
    if (self.lineGradientDirection == JXLineGradientDirectionHorizontal) {
        start = CGPointMake(0, CGRectGetMidY(shapeLayer.bounds));
        end = CGPointMake(CGRectGetMaxX(shapeLayer.bounds), CGRectGetMidY(shapeLayer.bounds));
    } else {
        start = CGPointMake(CGRectGetMidX(shapeLayer.bounds), 0);
        end = CGPointMake(CGRectGetMidX(shapeLayer.bounds), CGRectGetMaxY(shapeLayer.bounds));
    }
    
    // 3.渐变绘制
    CGContextDrawLinearGradient(imageCtx, self.lineGradient, start, end, 0);
    
    // 4.获取图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 5.关闭上下文
    UIGraphicsEndImageContext();
    
    // 6.返回图片layer
    CALayer *gradientLayer = [CALayer layer];
    gradientLayer.frame = self.bounds;
    gradientLayer.contents = (id)image.CGImage;
    gradientLayer.mask = shapeLayer; // 遮罩层
    return gradientLayer;
}




#pragma mark - 动画处理
/// 添加动画样式
- (void)animateForLayer:(CAShapeLayer *)shapeLayer withAnimationType:(JXLineAnimation)animationType isAnimatingReferenceLine:(BOOL)shouldHalfOpacity {
    
    // 1.无动画
    if (animationType == JXLineAnimationNone) return;
    
    else if (animationType == JXLineAnimationFade) {
        
        /// 2.透明度动画
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        pathAnimation.duration = self.animationTime;
        pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        if (shouldHalfOpacity == YES) pathAnimation.toValue = [NSNumber numberWithFloat:self.lineAlpha == 0 ? 0.1 : self.lineAlpha * 0.5];
        else pathAnimation.toValue = [NSNumber numberWithFloat:self.lineAlpha];
        [shapeLayer addAnimation:pathAnimation forKey:@"opacity"];
        
        return;
    } else if (animationType == JXLineAnimationExpand) {
        
        /// 3.宽度动画
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
        pathAnimation.duration = self.animationTime;
        pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        pathAnimation.toValue = [NSNumber numberWithFloat:shapeLayer.lineWidth];
        [shapeLayer addAnimation:pathAnimation forKey:@"lineWidth"];
        
        return;
    } else {
        
        /// 4.进度动画
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = self.animationTime;
        pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        [shapeLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
        
        return;
    }
}




#pragma mark - 类方法
/// 返回曲线的path
+ (UIBezierPath *)quadCurvedPathWithPoints:(NSArray *)points {
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    NSValue *value = points[0];
    CGPoint p1 = [value CGPointValue];
    [path moveToPoint:p1];
    
    if (points.count == 2) {
        value = points[1];
        CGPoint p2 = [value CGPointValue];
        [path addLineToPoint:p2];
        return path;
    }
    
    for (NSUInteger i = 1; i < points.count; i++) {
        value = points[i];
        CGPoint p2 = [value CGPointValue];
        
        /// 中点
        CGPoint midPoint = midPointForPoints(p1, p2);
        
        /*!画二元曲线，一般和moveToPoint配合使用
         endPoint:曲线的终点
         controlPoint:画曲线的基准点
         */
        [path addQuadCurveToPoint:midPoint controlPoint:controlPointForPoints(midPoint, p1)];
        
        [path addQuadCurveToPoint:p2 controlPoint:controlPointForPoints(midPoint, p2)];
        
        p1 = p2;
    }
    return path;
}

///  返回直线的path
+ (UIBezierPath *)linesToPoints:(NSArray *)points {
    UIBezierPath *path = [UIBezierPath bezierPath];
    NSValue *value = points[0];
    CGPoint p1 = [value CGPointValue];
    [path moveToPoint:p1];
    
    for (NSUInteger i = 1; i < points.count; i++) {
        value = points[i];
        CGPoint p2 = [value CGPointValue];
        [path addLineToPoint:p2];
    }
    return path;
}


#pragma mark - 自定义结构体
/// 返回中点
static CGPoint midPointForPoints(CGPoint p1, CGPoint p2) {
    return CGPointMake((p1.x + p2.x) / 2, (p1.y + p2.y) / 2);
}

/// 曲线控制点
static CGPoint controlPointForPoints(CGPoint p1, CGPoint p2) {
    CGPoint controlPoint = midPointForPoints(p1, p2);
    // 绝对值
    CGFloat diffY = fabs(p2.y - controlPoint.y);
    
    if (p1.y < p2.y)
        controlPoint.y += diffY;
    else if (p1.y > p2.y)
        controlPoint.y -= diffY;
    
    return controlPoint;
}




void MyCGPathApplierFunc (void *info, const CGPathElement *element) {
    NSMutableArray *bezierPoints = (__bridge NSMutableArray *)info;
    
    CGPoint *points = element->points;
    CGPathElementType type = element->type;
    
    switch(type) {
        case kCGPathElementMoveToPoint: // contains 1 point
            [bezierPoints addObject:[NSValue valueWithCGPoint:points[0]]];
            break;
            
        case kCGPathElementAddLineToPoint: // contains 1 point
            [bezierPoints addObject:[NSValue valueWithCGPoint:points[0]]];
            break;
            
        case kCGPathElementAddQuadCurveToPoint: // contains 2 points
            [bezierPoints addObject:[NSValue valueWithCGPoint:points[0]]];
            [bezierPoints addObject:[NSValue valueWithCGPoint:points[1]]];
            break;
            
        case kCGPathElementAddCurveToPoint: // contains 3 points
            [bezierPoints addObject:[NSValue valueWithCGPoint:points[0]]];
            [bezierPoints addObject:[NSValue valueWithCGPoint:points[1]]];
            [bezierPoints addObject:[NSValue valueWithCGPoint:points[2]]];
            break;
            
        case kCGPathElementCloseSubpath: // contains no point
            break;
    }
}







@end
