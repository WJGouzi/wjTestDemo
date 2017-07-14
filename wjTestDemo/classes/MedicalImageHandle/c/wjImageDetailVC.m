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

@interface wjImageDetailVC ()

@property (nonatomic, strong) NSMutableArray *buttonsArray;

// 选中的按钮
@property (nonatomic, weak) UIButton *selectedBtn;

/** 展示图片的view */
@property (nonatomic, strong) wjPageView *wjPageView;

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
    pageView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 49 - 64);
    pageView.imageNames = self.model.imageDataArray;
    [self.view addSubview:pageView];
    self.wjPageView = pageView;
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
    self.selectedBtn.selected = !self.selectedBtn.selected;
}


/**
 * 导航栏上的保存按钮的点击事件
 * 目标是:保存到相册中指定的文件夹中
 */
- (void)wjSaveImageAction:(UIBarButtonItem *)item {
    NSLog(@"保存了");
    UIGraphicsBeginImageContextWithOptions(self.wjPageView.imageView.bounds.size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.wjPageView.imageView.layer renderInContext:ctx];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // 判断有没有进行绘画
//    if (self.doodleBoardView.allPathArray.count > 0) {
//        // 有就进行保存
//    } else {
//        // 给出提示，还没进行绘画
//        [self wjShowAlertNoticeWithTitle:@"提示" message:@"您还未在画布上进行绘制\n保存无法执行!" actionTitle:@"知道了"];
//    }
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image: didFinishSavingWithError: contextInfo:), nil);
    
}

// 代理方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    [self wjShowAlertNoticeWithTitle:@"保存成功!" message:@"你可以到相册中查看" actionTitle:@"确定"];
}




#pragma mark - 通用方法
/**
 显示提示框
 
 @param title 提示标题
 @param message 提示信息
 @param actionTitle 按钮文字
 */
- (void)wjShowAlertNoticeWithTitle:(NSString *)title message:(NSString *)message actionTitle:(NSString *)actionTitle {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:nil];
    [alertVC addAction:action];
    [self presentViewController:alertVC animated:YES completion:nil];
}



@end
