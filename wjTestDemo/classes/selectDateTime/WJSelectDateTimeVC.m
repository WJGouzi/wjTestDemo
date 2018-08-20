//
//  WJSelectDateTimeVC.m
//  wjTestDemo
//
//  Created by 王钧 on 2018/8/20.
//  Copyright © 2018年 wangjun. All rights reserved.
//

#import "WJSelectDateTimeVC.h"
#import "WJDateTimeSelectView.h"

@interface WJSelectDateTimeVC ()

@end

@implementation WJSelectDateTimeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"选择日期及时间";
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    if ([touch.view isEqual:self.view]) {
        WJDateTimeSelectView *selectView = [[WJDateTimeSelectView alloc] initWithFrame:self.view.frame];
        selectView.selectTimeBlock = ^(NSString *selectTime) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 300, 200, 40)];
            label.text = selectTime;
            label.textColor = [UIColor blackColor];
            label.textAlignment = NSTextAlignmentCenter;
            [self.view addSubview:label];
        };
        [self.view addSubview:selectView];
    }
}
@end
