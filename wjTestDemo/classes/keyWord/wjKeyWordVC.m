//
//  wjKeyWordVC.m
//  wjTestDemo
//
//  Created by jerry on 2017/8/30.
//  Copyright © 2017年 wangjun. All rights reserved.
//

#import "wjKeyWordVC.h"
#import <RegexKitLite.h>


@interface wjKeyWordVC ()

@property (nonatomic, weak) UITextField *textFiled;

@property (nonatomic,weak) UILabel * label;

@end

@implementation wjKeyWordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"搜索关键字";
    self.view.backgroundColor = [UIColor whiteColor];
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(50, 90, 200, 30)];
    tf.placeholder = @"请输入关键字";
    tf.layer.borderWidth = 1;
    tf.layer.borderColor = [UIColor grayColor].CGColor;
    tf.layer.masksToBounds = YES;
    tf.layer.cornerRadius = 5;
    [self.view addSubview:tf];
    self.textFiled = tf;
    
    //
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 150, 200, 50)];
    label.text = @"撒大声地看上那是三德科技阿萨德空间拉伸的空间拉萨上课了点击后的开发商打开浮点数手机宽带。";
    label.numberOfLines = 0;
    [label sizeToFit];
    [self.view addSubview:label];
    self.label = label;
}

// 查找关键字
-(NSAttributedString *)titleLabText:(NSString *)title {
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:title];
    //匹配搜索关键字，并且改变颜色
    if(self.textFiled.text.length > 0) {
        [title enumerateStringsMatchedByRegex:self.textFiled.text usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
            [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:*capturedRanges];
        }];
    }
    return attributeString;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    if (self.textFiled.text.length > 0) {
        self.label.attributedText = [self titleLabText:self.label.text];
    }
}



@end
