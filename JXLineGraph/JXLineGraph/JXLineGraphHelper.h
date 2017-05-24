//
//  JXLineGraphHelper.h
//  JXLineGraph
//
//  Created by mac on 17/5/10.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JXLineGraphHelper : NSObject
/**
 *判断点point是否在p0 和 p1两点构成的线段上
 */
- (BOOL)_xw_point:(CGPoint)point isInLineByTwoPoint:(CGPoint)p0 p1:(CGPoint)p1;


@end
