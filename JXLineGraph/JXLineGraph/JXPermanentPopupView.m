//
//  JXPermanentPopupView.m
//  JXLineGraph
//
//  Created by mac on 17/4/28.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXPermanentPopupView.h"
#import "CAShapeLayer+mask.h"

@implementation JXPermanentPopupView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor lightGrayColor];
        
        CAShapeLayer *layer = [CAShapeLayer createAirMaskLayerWithView:self];
        self.layer.mask = layer;
    }
    return self;
}

@end


@implementation JXPermanentPopupLabel


@end
