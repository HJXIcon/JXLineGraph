//
//  JXCircle.m
//  JXLineGraph
//
//  Created by mac on 17/4/28.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXCircle.h"

@implementation JXCircle


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //画椭圆
    CGContextAddEllipseInRect(ctx, rect);
     [self.Pointcolor set];
    // 来填充形状内的颜色.
    // 使用非零绕数规则填充当前路径 
    CGContextFillPath(ctx);
    
    
}


@end
