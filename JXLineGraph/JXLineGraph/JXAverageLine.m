//
//  JXAverageLine.m
//  JXLineGraph
//
//  Created by mac on 17/4/27.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXAverageLine.h"

@implementation JXAverageLine

- (instancetype)init {
    self = [super init];
    if (self) {
        _enableAverageLine = NO;
        _color = [UIColor whiteColor];
        _alpha = 1.0;
        _width = 3.0;
        _yValue = 0.0;
    }
    
    return self;
}

@end
