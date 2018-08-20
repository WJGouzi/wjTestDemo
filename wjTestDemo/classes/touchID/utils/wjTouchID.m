//
//  wjTouchID.m
//  指纹识别
//
//  Created by gouzi on 16/5/22.
//  Copyright © 2016年 wj. All rights reserved.
//

#import "wjTouchID.h"
#import <LocalAuthentication/LocalAuthentication.h>

@implementation wjTouchID

- (void)wjTouchIDWithDetail:(NSString *)message Block:(void (^)(BOOL, kErrorType, NSError *))block {
    // 初始化上下文对象
    LAContext *context = [[LAContext alloc] init];
    NSError *error = nil;
    NSString *detail;
    if (!message.length) {
        detail = @"通过Home键验证已有手机指纹";
    }else {
        detail = message;
    }
    
    // 判断设备是否支持指纹识别
    BOOL isSupport = [context canEvaluatePolicy: LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
    if (isSupport) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:detail reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                // 验证成功
                block(YES, kErrorTypeSuccess, error);
            } else {
                switch (error.code) {
                    case LAErrorSystemCancel:
                        self.errType = kErrorTypeSystemCancel;
                        break;
                    case LAErrorUserCancel:
                        self.errType = kErrorTypeUserCancel;
                        break;
                    case LAErrorUserFallback:
                        self.errType = kErrorTypeUserFallback;
                        break;
                    case LAErrorTouchIDLockout:
                        self.errType = kErrorTypeTouchIDLockout;
                    case LAErrorAppCancel:
                        self.errType = kErrorTypeAppCancel;
                    case LAErrorInvalidContext:
                        self.errType = kErrorTypeInvalidContext;
                    default:
                        self.errType = kErrorTypeAuthenticationFailed;
                        break;
                }
                block(NO, self.errType, error);
            }
        }];
    } else {
        // 不支持指纹识别
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled:
                self.errType = kErrorTypeTouchIDNotEnrolled;
                break;
            case LAErrorPasscodeNotSet:
                self.errType = kErrorTypePasscodeNotSet;
                break;
            default:
                self.errType = kErrorTypeTouchIDNotAvailable;
                break;
        }
        
        block(NO, self.errType, error);
    }
}

@end
