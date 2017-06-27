//
//  UIImage+wjQRCodeCreate.h
//  wjTestDemo
//
//  Created by jerry on 2017/6/27.
//  Copyright © 2017年 wangjun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (wjQRCodeCreate)

//Avilable in iOS 7.0 and later
+ (UIImage *)qrCodeImageWithContent:(NSString *)content
                      codeImageSize:(CGFloat)size
                               logo:(UIImage *)logo
                          logoFrame:(CGRect)logoFrame
                                red:(CGFloat)red
                              green:(CGFloat)green
                               blue:(CGFloat)blue;


/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度
 *
 *  @return 生成的高清的UIImage
 */
+ (UIImage *)creatNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size;

@end
