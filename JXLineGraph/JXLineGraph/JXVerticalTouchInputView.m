//
//  JXVerticalTouchInputView.m
//  JXLineGraph
//
//  Created by mac on 17/5/24.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXVerticalTouchInputView.h"

static NSString * const kFontName = @"HelveticaNeue-Light";
@implementation JXVerticalTouchInputView


- (void)drawRect:(CGRect)rect {
    
    
    
    // 1.画垂直线
    [self drawLine:rect];
    
    // 2.画图片
    [self drawImage:rect];
    
    // 3.画文本框
    [self drawText:rect];
    
}

// 3.画文本框
- (void)drawText:(CGRect)rect{
    
    
    //1.获取当前上下文
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    //2.创建文字
    NSString * str = self.drawText;
    
    //设置字体样式
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    //NSFontAttributeName:字体大小
    dict[NSFontAttributeName] = [UIFont fontWithName:kFontName size:10];
    //字体前景色
    dict[NSForegroundColorAttributeName] = [UIColor blackColor];
    //字体背景色
//    dict[NSBackgroundColorAttributeName] = [UIColor redColor];
    //字体阴影
//    NSShadow * shadow = [[NSShadow alloc]init];
    //阴影偏移量
//    shadow.shadowOffset = CGSizeMake(2, 2);
    //阴影颜色
//    shadow.shadowColor = [UIColor greenColor];
    //高斯模糊
//    shadow.shadowBlurRadius = 5;
//    dict[NSShadowAttributeName] = shadow;
    //字体间距
    dict[NSKernAttributeName] = @0.03;
    // 11.1设置段落风格
    NSMutableParagraphStyle * paragraph = [[NSMutableParagraphStyle alloc]init];
        paragraph.alignment = NSTextAlignmentCenter;
    dict[NSParagraphStyleAttributeName] = paragraph;
    
    
    CGFloat w = CGRectGetWidth(rect) * 0.85;
    CGRect frame = CGRectMake((CGRectGetWidth(rect) - w) * 0.5, self.drawImageY + 4 + CGRectGetWidth(rect) * 0.5, w, 20);
    
    [str drawInRect:frame withAttributes:dict];
    
    
    CGContextStrokePath(contextRef);
    
    
}

// 2.画图片
- (void)drawImage:(CGRect)rect{
    
    
    
    //1.获取当前的上下文
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    //2.加载图片
    //这里顺便咯嗦一句：使用imageNamed加载图片是会有缓存的
    //我们这里只需要加载一次就够了，不需要多次加载，所以不应该保存这个缓存
    //    UIImage * image = [UIImage imageNamed:@"222"]; //所以可以换一种方式去加载
    UIImage * image = [UIImage imageNamed:@"fish"]; //所以可以换一种方式去加载
    //    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"222.png" ofType:nil]];
    
    //    //绘制的大小位置
    //    [image drawInRect:rect];
    
    
    //    //从某个点开始绘制
    //    [image drawAtPoint:CGPointMake(0, 0)];
    
    CGFloat Y = self.drawImageY == 0 ? CGRectGetMidY(rect) : self.drawImageY;
    
    CGRect drawRect = CGRectMake(0, Y, CGRectGetWidth(rect), CGRectGetWidth(rect) * 0.5);
    
    //绘制一个多大的图片，并且设置他的混合模式以及透明度
    //Rect：大小位置
    //blendModel：混合模式
    //alpha：透明度
    [image drawInRect:drawRect blendMode:kCGBlendModeNormal alpha:1];
    
    
    //从某一点开始绘制图片，并设置混合模式以及透明度
    //point:开始位置
    //blendModel：混合模式
    //alpha：透明度
    //    [image drawAtPoint:CGPointMake(0, 0) blendMode:kCGBlendModeNormal alpha:1];
    
    //添加到上下文
    CGContextFillPath(contextRef);
    
}

// 1.画垂直线
- (void)drawLine:(CGRect)rect{
    
    if (self.layer.sublayers.count) {
        for (CALayer *layer in self.layer.sublayers) {
            [layer removeFromSuperlayer];
        }
    }
    
    UIBezierPath *verticalReferenceLinesPath = [UIBezierPath bezierPath];
    
    verticalReferenceLinesPath.lineCapStyle = kCGLineCapButt;
    verticalReferenceLinesPath.lineWidth = 0.7;
    
    CGPoint initialPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint finalPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    [verticalReferenceLinesPath moveToPoint:initialPoint];
    [verticalReferenceLinesPath addLineToPoint:finalPoint];

    // 垂直线(根据X轴坐标)
    CAShapeLayer *verticalReferenceLinesPathLayer = [CAShapeLayer layer];
    verticalReferenceLinesPathLayer.frame = rect;
    verticalReferenceLinesPathLayer.path = verticalReferenceLinesPath.CGPath;
    verticalReferenceLinesPathLayer.opacity = 0.2;
    verticalReferenceLinesPathLayer.strokeColor = [UIColor blueColor].CGColor;
    verticalReferenceLinesPathLayer.lineWidth = 1;
    
    // 添加layer
    [self.layer addSublayer:verticalReferenceLinesPathLayer];
    
    
}



- (void)setDrawImageY:(CGFloat)drawImageY{
    _drawImageY = drawImageY;
    [self setNeedsDisplay];
}

- (void)setDrawText:(NSString *)drawText{
    _drawText = drawText;
    [self setNeedsDisplay];
}

@end
