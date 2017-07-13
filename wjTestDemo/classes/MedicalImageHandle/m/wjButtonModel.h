//
//  wjButtonModel.h
//  wjTestDemo
//
//  Created by gouzi on 2017/7/13.
//  Copyright © 2017年 wangjun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface wjButtonModel : NSObject

/** 按钮的名字*/
@property (nonatomic, strong) NSString *name;

/** 按钮的图片*/
@property (nonatomic, strong) NSString *imageName;

/** 选择的按钮的图片*/
@property (nonatomic, strong) NSString *selectedImageName;

+ (instancetype)buttionWithButtonDict:(NSDictionary *)dict;

@end
