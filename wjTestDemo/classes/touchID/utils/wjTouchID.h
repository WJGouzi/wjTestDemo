//
//  wjTouchID.h
//  指纹识别
//
//  Created by gouzi on 16/5/22.
//  Copyright © 2016年 wj. All rights reserved.
//

/**
 *  使用时请导入LocalAuthentication.framework
 */

/**
 *  iOS系统的指纹识别功能最低支持的机型为iPhone5s，最低支持系统为iOS8(注意：iOS7系统的5s机型可以使用系统提供的指纹解锁功能，但由于API并未开放，所以理论上第三方软件不可使用)
 */

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, kErrorType) {
    /* 验证成功 */
    kErrorTypeSuccess,
    /* 识别失败，未知原因，验证失败 */
    kErrorTypeAuthenticationFailed,
    /* 识别失败，用户取消了验证 */
    kErrorTypeUserCancel,
    /* 识别失败，用户选择输入密码 */
    kErrorTypeUserFallback,
    /* 识别失败，程序切换到其他APP */
    kErrorTypeSystemCancel,
    /* 识别失败，，因为未在此设备设置密码 */
    kErrorTypePasscodeNotSet,
    /* 识别失败，指纹识别在此设备无法使用 */
    kErrorTypeTouchIDNotAvailable,
    /* 识别失败，，因为未在此设备注册指纹 */
    kErrorTypeTouchIDNotEnrolled,
    /* 识别失败，这种情况是由于尝试了太多次数的指纹解锁，除非使用系统密码进行解锁 */
    kErrorTypeTouchIDLockout,
    /* 识别失败，例如程序验证过程中被其他程序挂起 */
    kErrorTypeAppCancel,
    /* 识别失败，识别上下文被销毁 */
    kErrorTypeInvalidContext,
};

@interface wjTouchID : NSObject
/**
 *  错误类型
 */
@property (nonatomic, assign) kErrorType errType;

/**
 *  创建方法
 *
 *  @param message 如果要显示自定义信息，请设置这个属性，如果使用默认请设置为nil
 *  @param block   结果回调
 */
- (void)wjTouchIDWithDetail:(NSString *)message Block:(void(^)(BOOL success, kErrorType type, NSError *error))block;

@end
