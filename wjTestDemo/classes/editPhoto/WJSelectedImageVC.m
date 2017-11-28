//
//  WJSelectedImageVC.m
//  photoEditDemo
//
//  Created by 王钧 on 2017/11/28.
//  Copyright © 2017年 王钧. All rights reserved.
//  修改截取从相册中选取的图片或者是摄像头拍摄的图片

#import "WJSelectedImageVC.h"
#import "WJEditPhotoVC.h"

@interface WJSelectedImageVC () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation WJSelectedImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.imageView.image = nil;
}


- (void)setUpUI {
    self.title = @"截取图片";
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 100, 100, 100)];
    imageView.backgroundColor = [UIColor cyanColor];
    [imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    imageView.contentMode =  UIViewContentModeScaleAspectFill;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    imageView.clipsToBounds = YES;
    [self.view addSubview:imageView];
    self.imageView = imageView;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"选择图片" forState:UIControlStateNormal];
    button.frame = CGRectMake(80, 300, 80, 30);
    [button setBackgroundColor:[UIColor orangeColor]];
    [button addTarget:self action:@selector(selectedImageAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)selectedImageAction:(UIButton *)btn {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    WJEditPhotoVC *editPhotoVC = [[WJEditPhotoVC alloc] init];
    editPhotoVC.selectedImage = image;
    __weak typeof(self) weakSelf = self;
    editPhotoVC.block = ^(UIImage *image) {
        weakSelf.imageView.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        weakSelf.imageView.contentMode = UIViewContentModeScaleAspectFill;
    };
    [self presentViewController:editPhotoVC animated:YES completion:nil];
}


@end
