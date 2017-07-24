//
//  NSString+wjEncryptionData.h
//  wjTestDemo
//
//  Created by jerry on 2017/7/24.
//  Copyright © 2017年 wangjun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"

@interface NSString (wjEncryptionData)

/**
 DES加密处理
 
 @param plainText 需要加密的文字
 @return 返回加密的字符串
 */
+ (NSString *)encryptUseDES:(NSString *)plainText;


/**
 DES解密处理

 @param cipherText 加密的文字
 @return 返回解密的字符串
 */
+ (NSString *)decryptUseDES:(NSString*)cipherText;


/**
 MD5码加密处理

 @param str 需要加密的字符串
 @return 加密后的字符串
 */
+ (NSString *)Md5StringWithString:(NSString *)str;

@end
