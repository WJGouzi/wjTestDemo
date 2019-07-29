//
//  UIView+WJCornerView.h
//  wjTestDemo
//
//  Created by gouzi on 2019/7/29.
//  Copyright © 2019 wangjun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (WJCornerView)

/**
 在View上添加圆角 (首先这个View有一个确定的frame)

 @param view 添加的View
 @param radius 圆角的半径
 @param type 添加圆角类型(0~14)
 0:左下 1:右下 2:左上 3:右上 4:底部左右 5:顶部左右 6:左边上下 7:右边上下 8:除左下 9:除左上 10:除右下
 11:除右上 12:左上右下 13:左下右上 14:全部(默认)
 */
+ (void)cornerViewInView:(UIView *)view cornerRadius:(CGFloat)radius cornerType:(int)type;

@end

NS_ASSUME_NONNULL_END
