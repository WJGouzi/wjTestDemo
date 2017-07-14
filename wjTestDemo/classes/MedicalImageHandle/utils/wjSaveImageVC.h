//
//  wjSaveImageVC.h
//  wjTestDemo
//
//  Created by jerry on 2017/7/14.
//  Copyright © 2017年 wangjun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface wjSaveImageVC : UIViewController

/**
 保存图片到自定义相册中

 @param image 需要保存的图片
 */
- (void)saveWithImage:(UIImage *)image;

@end
