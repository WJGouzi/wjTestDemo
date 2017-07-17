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

@interface wjImageDetailVC () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray *buttonsArray;

// 选中的按钮
@property (nonatomic, weak) UIButton *selectedBtn;

/** 展示图片的view */
@property (nonatomic, strong) wjPageView *wjPageView;

/** 展示标注的view*/
@property (nonatomic,strong) UIView *wjSignView;


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

#pragma mark - 生命周期
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
    
    switch (btn.tag) {
        case 100: { // 调窗点击
            if (btn.selected) {
                // 展示toolBar
                
            } else {
                // 隐藏toolBar
            }
        }
            break;
        case 101: { // 缩放
            if (btn.selected) {
                // 允许平移、缩放等操作
//                self.wjPageView.imageView.userInteractionEnabled = YES;
//                [self handleViewWithGesture];
            } else {
//                self.wjPageView.imageView.userInteractionEnabled = NO;
            }
        }
            break;
        case 102: { // 标注
            if (btn.selected) {
                // 展示toolBar
                [self wjShowSignBar];
            } else {
                // 隐藏toolBar
//                [self wjHideSignBar];
            }
        }
            break;
        case 103: { // 重置
            if (btn.selected) {
            } else {
            }
        }
            break;
        default:
            break;
    }
    
    // 如果是非标注的按钮被点击 则标注的bar也要隐藏掉
    UIButton *signBtn = (UIButton *)[btn viewWithTag:102];
    if (!signBtn.selected) {
        [self wjHideSignBar];
    }
}



/**
 展示标注的view
 */
- (void)wjShowSignBar {
    self.wjSignView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 49 - 44, SCREEN_WIDTH, 44)];
    self.wjSignView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.wjSignView];
    // scrollview就不能进行滑动了
    self.wjPageView.wjScrollView.scrollEnabled = NO;
}


/**
 隐藏标注的view
 */
- (void)wjHideSignBar {
    [self.wjSignView removeFromSuperview];
    // scrollview可以进滚动
    self.wjPageView.wjScrollView.scrollEnabled = YES;
}




/**
 * 导航栏上的保存按钮的点击事件
 * 目标是:保存到相册中指定的文件夹中
 */
- (void)wjSaveImageAction:(UIBarButtonItem *)item {
    NSLog(@"保存了");
    UIGraphicsBeginImageContextWithOptions(self.wjPageView.bounds.size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.wjPageView.layer renderInContext:ctx];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // C语言的方法
//    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image: didFinishSavingWithError: contextInfo:), nil);
    // 利用的是<Photos/Photos.h>来进行保存的图片
    wjSaveImageVC *saveImageVC = [[wjSaveImageVC alloc] init];
    [saveImageVC saveWithImage:image];
}

// 代理方法
//- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
//    [self wjShowAlertNoticeWithTitle:@"保存成功!" message:@"你可以到相册中查看" actionTitle:@"确定"];
//}




#pragma mark

#pragma mark - 手势添加
- (void)handleViewWithGesture {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [self.wjPageView.imageView addGestureRecognizer:pan];
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchAction:)];
    pinch.delegate = self;
    [self.wjPageView.imageView addGestureRecognizer:pinch];
    
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)panAction:(UIPanGestureRecognizer *)pan {
    CGPoint currentPoint = [pan translationInView:pan.view];
    pan.view.transform = CGAffineTransformTranslate(pan.view.transform, currentPoint.x, currentPoint.y);
    // 复位操作
    [pan setTranslation:CGPointZero inView:pan.view];
}

- (void)pinchAction:(UIPinchGestureRecognizer *)pinch {
    pinch.view.transform = CGAffineTransformScale(pinch.view.transform, pinch.scale, pinch.scale);
    pinch.scale = 1.0f;
}
























#pragma mark - 通用的方法
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
