//
//  wjGestureLockVC.m
//  wjTestDemo
//
//  Created by jerry on 2017/6/30.
//  Copyright © 2017年 wangjun. All rights reserved.
//

#import "wjGestureLockVC.h"

#define wjSaveKey @"saveKey"
typedef void(^actionBlock)(UIAlertAction *action);


@interface wjGestureLockVC ()
@property (weak, nonatomic) IBOutlet UIImageView *wjGestureLockImageView;

@end

@implementation wjGestureLockVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"手势解锁";
    [self wjAddNameMarkInPicture];
}

- (void)wjAddNameMarkInPicture {
    UIImage *image = [UIImage imageNamed:@"icon.jpeg"];
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    [image drawAtPoint:CGPointZero];
    NSString *markStr = @"@请输入账号名";
    NSDictionary *dict = @{
                           NSForegroundColorAttributeName : [UIColor redColor],
                           NSFontAttributeName : [UIFont systemFontOfSize:25.f]
                           };
    [markStr drawAtPoint:CGPointMake(image.size.width - markStr.length * 25.0f - 10, image.size.height - 35) withAttributes:dict];
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.wjGestureLockImageView.image = newImg;
}



- (IBAction)wjResetGestureCodeAction:(UIButton *)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:wjSaveKey];
    [self wjShowAlertWithTitle:@"提示" message:@"重置成功" actionTitle:@"确定" actionStyle:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }];
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
