//
//  wjScanQRCodeVC.m
//  wjTestDemo
//
//  Created by jerry on 2017/6/28.
//  Copyright © 2017年 wangjun. All rights reserved.
//  扫描二维码的页面

#import "wjScanQRCodeVC.h"
#import <AVFoundation/AVFoundation.h>

typedef void(^actionBlock)(UIAlertAction *action);
/**
 *  屏幕 高 宽 边界
 */


#define TOP (SCREEN_HEIGHT-220)/2
#define LEFT (SCREEN_WIDTH-220)/2

#define kScanRect CGRectMake(LEFT, TOP, 220, 220)

@interface wjScanQRCodeVC () <AVCaptureMetadataOutputObjectsDelegate> {
    int num;
    BOOL upOrdown;
    NSTimer * timer;
    CAShapeLayer *cropLayer;
}

@property (strong,nonatomic) AVCaptureDevice *device;
@property (strong,nonatomic) AVCaptureDeviceInput *input;
@property (strong,nonatomic) AVCaptureMetadataOutput *output;
@property (strong,nonatomic) AVCaptureSession *session;
@property (strong,nonatomic) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) UIImageView * scanLine;

@property (nonatomic,strong) actionBlock actionblock;

@end


@implementation wjScanQRCodeVC

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扫描二维码";
    [self wjScanViewSettings];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setCoverRect:kScanRect];
    [self performSelector:@selector(wjCameraSettings) withObject:nil afterDelay:0.3];
}

- (void)dealloc {
    [timer invalidate];
    [self.session stopRunning];
}

/**
 扫描界面的显示
 */
- (void)wjScanViewSettings {
    UIImageView *scanImageView = [[UIImageView alloc] initWithFrame:kScanRect];
    scanImageView.image = [UIImage imageNamed:@"pick_bg"];
    [self.view addSubview:scanImageView];
    
    upOrdown = NO;
    num = 0;
    self.scanLine = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT, TOP + 10, 220, 2)];
    self.scanLine.image = [UIImage imageNamed:@"line"];
    [self.view addSubview:self.scanLine];
    
    // 开始扫描
    timer = [NSTimer scheduledTimerWithTimeInterval:0.02f target:self selector:@selector(wjScanLineAnimationSettings) userInfo:nil repeats:YES];
}


/**
 开始扫描
 */
- (void)wjScanLineAnimationSettings {
    if (upOrdown == NO) {
        // 向下移动
        num++;
        self.scanLine.frame = CGRectMake(LEFT, TOP + 10 + 2 * num, 220, 2);
        if (2 * num == 200) {
            upOrdown = !upOrdown;
        }
    } else {
        // 向上移动
        num--;
        self.scanLine.frame = CGRectMake(LEFT, TOP + 10 + 2 * num, 220, 2);
        if (num == 0) {
            upOrdown = !upOrdown;
        }
    }
}


#pragma mark - 设置蒙层
- (void)setCoverRect:(CGRect)coverRect {
    cropLayer = [[CAShapeLayer alloc] init];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, nil, coverRect);
    CGPathAddRect(path, nil, self.view.bounds);
    
    [cropLayer setFillRule:kCAFillRuleEvenOdd];
    [cropLayer setPath:path];
    [cropLayer setFillColor:[UIColor blackColor].CGColor];
    [cropLayer setOpacity:0.6];
    [cropLayer setNeedsDisplay];
    [self.view.layer addSublayer:cropLayer];
}




#pragma mark - 设置相机
- (void)wjCameraSettings {
    // 判断有没有设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (!device) {
        [self wjShowAlertWithTitle:@"提示" message:@"设备没有摄像头" actionTitle:@"确认" actionStyle:UIAlertActionStyleDefault];
        return;
    }
    
    // 设置
    self.device = device;
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    self.output = [[AVCaptureMetadataOutput alloc] init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // 扫描区域
    CGFloat top = TOP / SCREEN_HEIGHT;
    CGFloat left = LEFT / SCREEN_WIDTH;
    CGFloat width = 220 / SCREEN_WIDTH;
    CGFloat height = 200 / SCREEN_HEIGHT;
    [self.output setRectOfInterest:CGRectMake(top, left, height, width)];
    
    // 创建会话
    self.session = [[AVCaptureSession alloc] init];
    self.session.sessionPreset = AVCaptureSessionPresetHigh;
    if ([self.session canAddInput:self.input]) {
        
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.output]) {
        [self.session addOutput:self.output];
    }
    
    // 初步设置了二维码和条形码
    [self.output setMetadataObjectTypes:[NSArray arrayWithObjects:AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, nil]];
    
    // 插入图像到view中
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.previewLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
    
    [self.session startRunning];
}


#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    NSLog(@"%@", metadataObjects);
    if (metadataObjects.count > 0) {
        // 有扫描的结果
        [self.session stopRunning];
        [timer setFireDate:[NSDate distantFuture]];
        
        AVMetadataMachineReadableCodeObject *metadataObject = metadataObjects[0];
        NSString *scanResult = metadataObject.stringValue;
        NSLog(@"scan result is %@", scanResult);
        
        NSArray *arry = metadataObject.corners;
        for (id temp in arry) {
            NSLog(@"temp:%@",temp);
        }
        
        [self wjShowAlertWithTitle:@"扫描结果" message:scanResult actionTitle:@"确认" actionStyle:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            if (self.session != nil && timer != nil) {
                [self.session startRunning];
                [timer setFireDate:[NSDate date]];
            }
        }];
    } else {
        [self wjShowAlertWithTitle:@"提示" message:@"无扫描信息" actionTitle:@"确定" actionStyle:UIAlertActionStyleDefault];
    }
    
}


#pragma mark - 共用方法

/**
 提示框

 @param title 提示
 @param message 提示的文字
 @param actionTitle 按钮的文字
 @param style action的样式
 */
- (void)wjShowAlertWithTitle:(NSString *)title message:(NSString *)message actionTitle:(NSString *)actionTitle actionStyle:(UIAlertActionStyle)style  {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"设备没有摄像头" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}


/**
 提示框

 @param title 提示
 @param message 提示的文字
 @param actionTitle 按钮的文字
 @param style 按钮的样式
 @param block 点击后需要做的操作
 */
- (void)wjShowAlertWithTitle:(NSString *)title message:(NSString *)message actionTitle:(NSString *)actionTitle actionStyle:(UIAlertActionStyle)style handler:(actionBlock)block {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:block];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
