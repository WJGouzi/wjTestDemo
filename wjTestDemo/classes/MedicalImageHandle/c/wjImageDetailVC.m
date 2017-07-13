//
//  wjImageDetailVC.m
//  wjTestDemo
//
//  Created by jerry on 2017/7/13.
//  Copyright © 2017年 wangjun. All rights reserved.
//

#import "wjImageDetailVC.h"
#import "wjImageModel.h"
#import "wjButton.h"

@interface wjImageDetailVC ()

@end

@implementation wjImageDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"图像处理";
    NSLog(@"model is : %@", (wjImageModel *)self.model.name);

    [self wjBasicUISettings];
    
}


#pragma mark - 基本的界面设置
- (void)wjBasicUISettings {
    // 设置底部的按钮
    NSArray *buttonArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"wjButton" ofType:@"plist"]];
    NSMutableArray *buttons = [NSMutableArray array];
    for (NSDictionary *dict in buttonArray) {
        [buttons addObject:dict];
    }
    CGFloat y = SCREEN_HEIGHT - 49;
    CGFloat width = (CGFloat)SCREEN_WIDTH / buttons.count;
    CGFloat height = 49;
    for (int i = 0; i < buttons.count; i++) {
        CGFloat x = i * width;
        wjButton *btn = [[wjButton alloc] init];
        btn.backgroundColor = [UIColor blueColor];
        btn.frame = CGRectMake(x, y, width, height);
        btn.model = buttons[i];
        [self.view addSubview:btn];
    }
    
}








@end
