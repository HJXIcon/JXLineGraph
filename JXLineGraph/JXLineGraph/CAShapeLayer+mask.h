//
//  CAShapeLayer+mask.h
//  JXLineGraph
//
//  Created by mac on 17/5/16.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface CAShapeLayer (mask)

/**
 创建气泡遮盖
 
 @param view 目标View
 @return CAShapeLayer
 */
+ (instancetype)createAirMaskLayerWithView : (UIView *)view;

@end
