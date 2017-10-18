//
//  wjQRCodeVC.m
//  wjTestDemo
//
//  Created by jerry on 2017/6/27.
//  Copyright © 2017年 wangjun. All rights reserved.
//

#import "wjQRCodeVC.h"
#import <CoreImage/CoreImage.h>
#import "UIImage+wjQRCodeCreate.h"

@interface wjQRCodeVC ()
// 二维码图片
@property (weak, nonatomic) IBOutlet UIImageView *wjQRCodeImageView;
@property (weak, nonatomic) IBOutlet UITextView *textInputView;

@end

@implementation wjQRCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}

- (void)setUpUI {
    self.title = @"扫描二维码";
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}



// 系统创建二维码
- (IBAction)wjCreatQRCodeAction:(UIButton *)sender {
    [self creatCIQRCodeImage];
}

// 创建二维码
- (void)creatCIQRCodeImage {
    // 1.创建过滤器，这里的@"CIQRCodeGenerator"是固定的
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 2.恢复默认设置
    [filter setDefaults];
    
    // 3. 给过滤器添加数据
    NSString *dataString = self.textInputView.text;
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    // 注意，这里的value必须是NSData类型
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    // 4. 生成二维码
    CIImage *outputImage = [filter outputImage];
    
    // 5. 显示二维码
//    self.wjQRCodeImageView.image = [UIImage imageWithCIImage:outputImage];
    // 高清的二维码
    self.wjQRCodeImageView.image = [UIImage creatNonInterpolatedUIImageFormCIImage:outputImage withSize:150.f];
}


// 自定义二维码的创建
- (IBAction)wjCustomQRCodeCreatAction:(UIButton *)sender {
    // 选择一张照片设置
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    backView.backgroundColor = [UIColor colorWithRed:253/255.0f green:245/255.0f blue:230/255.0f alpha:1.0f];
    backView.layer.masksToBounds = YES;
    backView.layer.cornerRadius = 5.f;
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(2, 2, 46, 46);
    imageView.image = [UIImage imageNamed:@"icon.jpeg"];
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 5.f;
    [backView addSubview:imageView];
    
    UIGraphicsBeginImageContextWithOptions(backView.bounds.size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [backView.layer renderInContext:ctx];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // 二维码
    UIImage *qrCodeImage = [UIImage qrCodeImageWithContent:self.textInputView.text
                                               codeImageSize:150
                                                        logo:image
                                                   logoFrame:CGRectMake(50, 50, 50, 50)
                                                         red:0.0f
                                                       green:139/255.0f
                                                        blue:139/255.0f];
    self.wjQRCodeImageView.image = qrCodeImage;
    self.wjQRCodeImageView.backgroundColor = [UIColor colorWithRed:253/255.0f green:245/255.0f blue:230/255.0f alpha:1.0f];//:@"#FDF5E6"];// #006400
    // 阴影
    self.wjQRCodeImageView.layer.shadowOffset = CGSizeMake(0, 0);
    self.wjQRCodeImageView.layer.shadowRadius = 5;
    self.wjQRCodeImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.wjQRCodeImageView.layer.shadowOpacity = 0.4;
}


@end
