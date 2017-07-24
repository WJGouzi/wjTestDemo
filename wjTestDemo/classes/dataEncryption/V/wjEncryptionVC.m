//
//  wjEncryptionVC.m
//  wjTestDemo
//
//  Created by jerry on 2017/7/24.
//  Copyright © 2017年 wangjun. All rights reserved.
//

#import "wjEncryptionVC.h"
#import "NSString+wjEncryptionData.h"

@interface wjEncryptionVC ()
@property (weak, nonatomic) IBOutlet UILabel *wjEncryptionTypeLabel;

@property (weak, nonatomic) IBOutlet UITextField *wjOriginDataTF;
@property (weak, nonatomic) IBOutlet UILabel *wjEncryptionDataLabel;
@end

@implementation wjEncryptionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"数据处理";
    [self wjUISettings];
}

- (void)wjUISettings {
    self.wjEncryptionTypeLabel.text = self.type;
    self.wjEncryptionDataLabel.layer.borderColor = [UIColor colorWithWhite:230/255.0 alpha:1.0f].CGColor;
    self.wjEncryptionDataLabel.layer.borderWidth = 1.0f;
    self.wjEncryptionDataLabel.layer.cornerRadius = 4.f;
    self.wjEncryptionDataLabel.layer.masksToBounds = YES;
}


- (IBAction)wjEncryptionAction:(UIButton *)sender {
    [self.view endEditing:YES];
    if ([self.type isEqualToString:@"des"]) {
        [self wjDesEncryption];
    }
    
    if ([self.type isEqualToString:@"md5"]) {
        [self wjEnMd5Code];
    }
    
    
}

- (IBAction)wjDeEncryptionAction:(UIButton *)sender {
    if ([self.type isEqualToString:@"des"]) {
        [self wjDeDesEncryption];
    }
}


/**
 DES加密处理
 */
- (void)wjDesEncryption {
    if (self.wjOriginDataTF.text.length) {
        self.wjEncryptionDataLabel.text = [NSString encryptUseDES:self.wjOriginDataTF.text];
    } else {
        NSLog(@"还没输入内容");
    }
}



/**
 DES解密处理
 */
- (void)wjDeDesEncryption {
    if (self.wjOriginDataTF.text.length) {
        self.wjEncryptionDataLabel.text = [NSString decryptUseDES:self.wjOriginDataTF.text];
    } else {
        NSLog(@"还没输入内容");
    }
}



/**
 md5加密处理
 */
- (void)wjEnMd5Code {
    if (self.wjOriginDataTF.text.length) {
        self.wjEncryptionDataLabel.text = [NSString Md5StringWithString:self.wjOriginDataTF.text];
    } else {
        NSLog(@"还没输入内容");
    }
}






@end
