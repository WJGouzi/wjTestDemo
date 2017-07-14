//
//  wjImageDetailVC.m
//  wjTestDemo
//
//  Created by jerry on 2017/7/13.
//  Copyright © 2017年 wangjun. All rights reserved.
//

#import "wjImageDetailVC.h"
#import "wjImageModel.h"
#import "wjButtonModel.h"
#import "wjButton.h"


@interface wjImageDetailVC ()

@property (nonatomic, strong) NSMutableArray *buttonsArray;


@end

@implementation wjImageDetailVC


#pragma mark - 懒加载
- (NSMutableArray *)buttonsArray {
    if (!_buttonsArray) {
        NSArray *buttons = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"wjButton" ofType:@"plist"]];
        NSMutableArray *btnArr = [NSMutableArray array];
        for (NSDictionary *dict in buttons) {
            wjButtonModel *model = [wjButtonModel buttionWithButtonDict:dict];
            [btnArr addObject:model];
        }
        _buttonsArray = [btnArr copy];
    }
    return _buttonsArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"图像处理";
    NSLog(@"model is : %@", (wjImageModel *)self.model.name);
    [self wjBasicUISettings];
    
}


#pragma mark - 基本的界面设置
- (void)wjBasicUISettings {
    // 设置底部的按钮
    CGFloat y = SCREEN_HEIGHT - 49;
    CGFloat width = (CGFloat)SCREEN_WIDTH / self.buttonsArray.count;
    CGFloat height = 49;
    for (int i = 0; i < self.buttonsArray.count; i++) {
        CGFloat x = i * width;
        wjButton *btn = [[wjButton alloc] init];
        btn.tag = i + 100; // 设tag值
        btn.frame = CGRectMake(x, y, width, height);
        btn.model = self.buttonsArray[i];
        [btn addTarget:self action:@selector(btnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    
}


static bool isClicked = NO;
- (void)btnClickAction:(UIButton *)btn {
    NSLog(@"%ld", btn.tag);
//    if (!isClicked) {
//        btn.backgroundColor = [UIColor blueColor];
//        
//        isClicked = !isClicked;
//    }
    btn.backgroundColor = isClicked ? [UIColor whiteColor] : [UIColor blueColor];
    isClicked = !isClicked;
    
}







@end
