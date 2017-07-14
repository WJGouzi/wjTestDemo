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
#import "wjPageView.h" // 展示图片的scrollview

static NSInteger selectedTag = 0;

@interface wjImageDetailVC ()

@property (nonatomic, strong) NSMutableArray *buttonsArray;

// 选中的按钮
@property (nonatomic, weak) UIButton *selectedBtn;

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
    [self wjNavigationBarSettings];
    [self wjBasicUISettings];
}

#pragma mark - 导航栏的设置
- (void)wjNavigationBarSettings {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(wjSaveImageAction:)];
}

#pragma mark - 基本的界面设置
- (void)wjBasicUISettings {
    [self wjButtomBarUISetttings];
    [self wjScrollViewUISettings];
}


/**
 * 设置底部的按钮
 */
- (void)wjButtomBarUISetttings {
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


/**
 * 图片展示的scrollview
 */
- (void)wjScrollViewUISettings {
    wjPageView *pageView = [wjPageView pageView];
    pageView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49);
    pageView.imageNames = self.model.imageDataArray;
    [self.view addSubview:pageView];
}


#pragma mark - 通用的方法
#pragma mark - 按钮的一些点击事件
/**
 底部按钮的点击事件
 @param btn 被点击的按钮
 */
- (void)btnClickAction:(UIButton *)btn {
    if (btn != self.selectedBtn) {
        self.selectedBtn.selected = NO;
        self.selectedBtn = btn;
    }
    self.selectedBtn.selected = YES;
}


/**
 * 导航栏上的保存按钮的点击事件
 * 目标是:保存到相册中指定的文件夹中
 */
- (void)wjSaveImageAction:(UIBarButtonItem *)item {
    NSLog(@"保存了");
    
}





@end
