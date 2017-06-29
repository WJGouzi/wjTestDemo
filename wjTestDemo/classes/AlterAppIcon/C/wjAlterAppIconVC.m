//
//  wjAlterAppIconVC.m
//  wjTestDemo
//
//  Created by jerry on 2017/6/29.
//  Copyright © 2017年 wangjun. All rights reserved.
//

#import "wjAlterAppIconVC.h"

@interface wjAlterAppIconVC ()

@end

@implementation wjAlterAppIconVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"更换应用图标";
}

- (IBAction)wjAlterAppIconAction:(UIButton *)sender {
    [self wjChangeAppIcon:@"iconChange"];
}

/**
 切换应用的图标
 
 @param imageName 切换的图片的名字
 */
- (void)wjChangeAppIcon:(NSString *)imageName {
    if ([UIApplication sharedApplication].supportsAlternateIcons) {
        NSLog(@"系统支持切换应用图标");
    } else {
        NSLog(@"系统不支持切换应用图标");
        return;
    }
    
    if ([UIApplication sharedApplication].alternateIconName) {
        [[UIApplication sharedApplication] setAlternateIconName:nil completionHandler:^(NSError * _Nullable error) {
            NSLog(@"the alternate icon's error is:%@", error.description);
        }];
    } else {
        [[UIApplication sharedApplication] setAlternateIconName:imageName completionHandler:^(NSError * _Nullable error) {
            NSLog(@"the alternate icon's error is:%@", error);
        }];
    }
}

@end
