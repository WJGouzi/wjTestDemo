//
//  WJCornerButtonVC.m
//  wjTestDemo
//
//  Created by 王钧 on 2018/2/26.
//  Copyright © 2018年 wangjun. All rights reserved.
//

#import "WJCornerButtonVC.h"
#import "WJCornerButton.h"

@interface WJCornerButtonVC ()

@end

@implementation WJCornerButtonVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"圆角按钮";
}

- (IBAction)firstBtnAction:(WJCornerButton *)sender {
    NSLog(@"%@", [WJCornerButton class]);
}
@end
