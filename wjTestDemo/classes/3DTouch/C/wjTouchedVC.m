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
    UIPreviewAction *action1 = [UIPreviewAction actionWithTitle:@"点赞" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"Aciton1");
    }];
    
    UIPreviewAction *action2 = [UIPreviewAction actionWithTitle:@"分享" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"Aciton2");
    }];
    
    UIPreviewAction *action3 = [UIPreviewAction actionWithTitle:@"关闭" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    NSArray *actions = @[action1,action2,action3];
    
    // and return them (return the array of actions instead to see all items ungrouped)
    return actions;
}

@end
