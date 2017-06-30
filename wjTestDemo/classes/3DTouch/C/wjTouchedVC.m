//
//  wjTouchedVC.m
//  wjTestDemo
//
//  Created by jerry on 2017/6/29.
//  Copyright © 2017年 wangjun. All rights reserved.
//

#import "wjTouchedVC.h"

@interface wjTouchedVC ()

@end

@implementation wjTouchedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.touchCellIndex;
}

// peek后上滑的几个选择按钮
- (NSArray<id<UIPreviewActionItem>> *)previewActionItems {
    // setup a list of preview actions
    UIPreviewAction *action1 = [UIPreviewAction actionWithTitle:@"短信" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSDictionary *info = @{@"msm" : @"你好"};
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@", @"10086"]] options:info completionHandler:^(BOOL success) {
            
        }];
    }];
    
    UIPreviewAction *action2 = [UIPreviewAction actionWithTitle:@"电话" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        // 打电话(系统会自动弹出提示框)
        NSDictionary *info = @{@"tel" : @"10086"};
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", info[@"tel"]]] options:info completionHandler:^(BOOL success) {
            
        }];
    }];
    
    UIPreviewAction *action3 = [UIPreviewAction actionWithTitle:@"关闭" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    NSArray *actions = @[action1,action2,action3];
    return actions;
}

@end
