//
//  WJEditPhotoVC.m
//  photoEditDemo
//
//  Created by 王钧 on 2017/11/28.
//  Copyright © 2017年 王钧. All rights reserved.
//  编辑图片

#import "WJEditPhotoVC.h"

@interface WJEditPhotoVC ()

// 开始手指的点
/* startPoint*/
@property (nonatomic, assign) CGPoint startPoint;

@property (nonatomic, strong) UIImageView *editImageView;

/** coverView*/
@property (nonatomic, strong) UIView *coverView;

@property (nonatomic, strong) UIImage *neweditImage;

@property (nonatomic, strong) UIImageView *lookOutImageView;

@property (nonatomic, assign) CGRect coverRect;

@end

@implementation WJEditPhotoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}

- (void)setUpUI {
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    backgroundImageView.image = self.selectedImage;
    backgroundImageView.userInteractionEnabled = YES;
    [backgroundImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    backgroundImageView.contentMode =  UIViewContentModeScaleAspectFit;
    backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    backgroundImageView.clipsToBounds = YES;
    [self.view addSubview:backgroundImageView];
    UIView *coveredView = [[UIView alloc] initWithFrame:self.view.frame];
    coveredView.userInteractionEnabled = YES;
    coveredView.backgroundColor = [UIColor blackColor];
    coveredView.alpha = 0.6;
    [backgroundImageView addSubview:coveredView];

    // 剪切的imageView
    UIImageView *editImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    editImageView.image = self.selectedImage;
    [coveredView addSubview:editImageView];
    editImageView.userInteractionEnabled = YES;
    [editImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    editImageView.contentMode =  UIViewContentModeScaleAspectFit;
    editImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    editImageView.clipsToBounds = YES;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panInPicture:)];
    [editImageView addGestureRecognizer:pan];
    self.editImageView = editImageView;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"重置" forState:UIControlStateNormal];
    button.frame = CGRectMake(50, 50, 50, 30);
    [button addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [self.view bringSubviewToFront:button];
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    sureButton.frame = CGRectMake(300, 50, 50, 30);
    [sureButton addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureButton];
    [self.view bringSubviewToFront:sureButton];
    
    UIButton *reSelectImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [reSelectImageButton setTitle:@"重选" forState:UIControlStateNormal];
    reSelectImageButton.frame = CGRectMake(175, 50, 50, 30);
    [reSelectImageButton addTarget:self action:@selector(reSelectedImageAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reSelectImageButton];
    [self.view bringSubviewToFront:reSelectImageButton];
    
    
    UIImageView *lookOutImageView = [[UIImageView alloc] initWithFrame:CGRectMake(300, 600, 50, 50)];
//    lookOutImageView.contentMode = UIViewContentModeScaleAspectFit;
    lookOutImageView.backgroundColor = [UIColor cyanColor];
    [lookOutImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    lookOutImageView.contentMode =  UIViewContentModeScaleAspectFill;
    lookOutImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    lookOutImageView.clipsToBounds = YES;
    [self.view addSubview:lookOutImageView];
    [self.view bringSubviewToFront:lookOutImageView];
    self.lookOutImageView = lookOutImageView;
}


- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = [UIColor darkGrayColor];
        _coverView.alpha = 0.6;
    }
    return _coverView;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.editImageView.frame = self.view.frame;
    self.editImageView.image = self.selectedImage;
}


// 在storyBoard中拖入的一个手势
- (void)panInPicture:(UIPanGestureRecognizer *)pan {
    
    CGPoint currentPoint = [pan locationInView:self.view];
    // 1判断手势状态
    if (pan.state == UIGestureRecognizerStateBegan) {
        // 获取当前点
        self.startPoint = currentPoint;
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        // 移除遮盖
        [self.coverView removeFromSuperview];
        CGFloat x = self.startPoint.x;
        CGFloat y = self.startPoint.y;
        CGFloat width = currentPoint.x - self.startPoint.x;
        CGFloat height = currentPoint.y - self.startPoint.y;
        if (width < 0) {
            width = -width;
            x = x - width;
        }
        if (height < 0) {
            height = -height;
            y = y - height;
        }
        CGRect rect = CGRectMake(x, y, width, height);
        // 添加一个view
        self.coverView.frame = rect;
        [self.editImageView addSubview:_coverView]; // 解决下次进行裁剪的时候没有coverview的覆盖
        self.coverRect = rect;
    } else if (pan.state == UIGestureRecognizerStateEnded) {
        NSLog(@"coverView:%@ - coverRect:%@",NSStringFromCGRect(self.coverView.frame), NSStringFromCGRect(self.coverRect));
        [self.coverView removeFromSuperview];
        UIImageView *resultImageView = self.editImageView;
        UIImage *resultImage = [self editImageFromView:resultImageView];
        // 超过遮盖以外的内容裁剪掉
        UIGraphicsBeginImageContextWithOptions(self.editImageView.bounds.size, NO, [UIScreen mainScreen].scale);
        // 设置一个裁剪区域
        UIBezierPath *clipPath = [UIBezierPath bezierPathWithRect:self.coverView.frame];
        [clipPath addClip];
        // 移除遮盖
        // 进行渲染
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        [self.editImageView.layer renderInContext:ctx];
        // 生成一张图片
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.editImageView.image = newImage;
        NSLog(@"coverView:%@ - coverRect:%@",NSStringFromCGRect(self.coverView.frame), NSStringFromCGRect(self.coverRect));
        
        self.neweditImage = resultImage;
        self.lookOutImageView.image = resultImage;
        
    }
}


- (UIImage *)editImageFromView:(UIView *)theView {
    
    //截取全屏
    UIGraphicsBeginImageContext(theView.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //截取所需区域
    CGRect captureRect = self.coverRect;
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, captureRect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    return newImage;
}

- (void)reSelectedImageAction:(UIButton *)btn {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelAction:(UIButton *)btn {
    self.editImageView.frame = self.view.frame;
    self.editImageView.image = self.selectedImage;
}

- (void)sureAction:(UIButton *)btn {
    self.block(self.neweditImage);
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
