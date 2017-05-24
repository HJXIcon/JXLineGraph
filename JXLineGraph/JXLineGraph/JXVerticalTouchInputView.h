//
//  JXVerticalTouchInputView.h
//  JXLineGraph
//
//  Created by mac on 17/5/24.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface JXVerticalTouchInputView : UIView


/**
 画图片的Y值
 */
@property(nonatomic, assign) CGFloat drawImageY;

/** 文本*/
@property (nonatomic, strong)NSString *drawText;

@end
