//
//  wjPageView.h
//  1-轮播器功能封装
//
//  Created by gouzi on 2017/3/23.
//  Copyright © 2017年 wangjun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface wjPageView : UIView

/** 图片名*/
@property (nonatomic, strong) NSArray *imageNames;


/** 展示在scrollview上的图片*/
@property (nonatomic, strong) UIImageView *imageView;

/**
 类方法
 */
+ (instancetype)pageView;

@end
