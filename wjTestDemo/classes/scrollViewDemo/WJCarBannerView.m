//
//  WJCarBannerView.m
//  wjTestDemo
//
//  Created by jerry on 2017/9/7.
//  Copyright © 2017年 wangjun. All rights reserved.
//

#import "WJCarBannerView.h"

@implementation WJCarBannerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}


- (void)setSubviewsWithSuperViewBounds:(CGRect)superViewBounds {
    if (CGRectEqualToRect(self.mainImageView.frame, superViewBounds)) {
        return;
    }
    self.mainImageView.frame = superViewBounds;
}

@end
