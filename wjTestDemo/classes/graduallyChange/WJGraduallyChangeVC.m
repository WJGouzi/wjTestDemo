//
//  WJGraduallyChangeVC.m
//  wjTestDemo
//
//  Created by jerry on 2017/9/7.
//  Copyright © 2017年 wangjun. All rights reserved.
//

#import "WJGraduallyChangeVC.h"

@interface WJGraduallyChangeVC ()

@end

@implementation WJGraduallyChangeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"背景渐变";
    self.view.backgroundColor = [UIColor whiteColor];
    [self graduallChangeBackgroundViewAlpha];
    [self graduallChangeBackgroundViewColor];
}


/**
 view的背景透明度的渐变
 */
- (void)graduallChangeBackgroundViewAlpha {
    UIView *alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 375, 78)];
    UIColor *topColor = [UIColor colorWithWhite:0 alpha:0];
    UIColor *bottomColor = [UIColor colorWithWhite:0.0 alpha:0.2];
    NSArray *colors = [NSArray arrayWithObjects:(id)topColor.CGColor, (id)bottomColor.CGColor, nil];
    CAGradientLayer *alphaLayer = [CAGradientLayer layer];
    alphaLayer.startPoint = CGPointMake(0, 0);
    alphaLayer.endPoint = CGPointMake(0, 1);
    alphaLayer.colors = colors;
    alphaLayer.frame = alphaView.frame;
    [alphaView.layer insertSublayer:alphaLayer atIndex:0];
    [self.view addSubview:alphaView];
}


/**
 view的背景颜色的渐变
 */
- (void)graduallChangeBackgroundViewColor {
    UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, 375, 78)];
    NSArray *colors = [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor, (id)[UIColor redColor].CGColor, nil];
    CAGradientLayer *colorLayer = [CAGradientLayer layer];
    colorLayer.startPoint = CGPointMake(0, 0);
    colorLayer.endPoint = CGPointMake(0, 1);
    colorLayer.colors = colors;
    colorLayer.frame = colorView.frame;
    [colorView.layer insertSublayer:colorLayer atIndex:0];
    [self.view addSubview:colorView];
}


@end
