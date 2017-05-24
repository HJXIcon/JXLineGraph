//
//  JXCircle.h
//  JXLineGraph
//
//  Created by mac on 17/4/28.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JXCircle : UIView

/// Set to YES if the data point circles should be constantly displayed. NO if they should only appear when relevant.
@property (assign, nonatomic) BOOL shouldDisplayConstantly;

/// The point color
@property (strong, nonatomic) UIColor *Pointcolor;

/// The value of the point
@property (nonatomic) CGFloat absoluteValue;


@end
