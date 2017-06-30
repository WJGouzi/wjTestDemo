//
//  wjTouchIDVerificationVC.m
//  wjTestDemo
//
//  Created by jerry on 2017/6/30.
//  Copyright © 2017年 wangjun. All rights reserved.
//

#import "wjTouchIDVerificationVC.h"
#import "wjTouchID.h"

@interface wjTouchIDVerificationVC ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *reTouchID;
@property (weak, nonatomic) IBOutlet UIView *backView;

@end

@implementation wjTouchIDVerificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"指纹识别";
    [self wjTouchIDVerifyAction];
}

- (void)wjTouchIDVerifyAction {
    wjTouchID *touchID = [[wjTouchID alloc] init];
    [touchID wjTouchIDWithDetail:nil Block:^(BOOL success, kErrorType type, NSError *error) {
        if (success) {
            NSLog(@"verification");
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showImage];
            });
            
        } else {
            NSLog(@"%@ - %ld", error, type);
            dispatch_async(dispatch_get_main_queue(), ^{
                // code here
                [self showReTouchView];
            });
        }
    }];
}

- (void)showImage {
    self.backView.hidden = YES;
    self.imageView.image = [UIImage imageNamed:@"icon.jpeg"];
}

- (void)showReTouchView {
    self.backView.hidden = NO;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wjTouchIDVerifyAction)];
    [self.reTouchID addGestureRecognizer:tap];
}


@end
