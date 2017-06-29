//
//  wjModel.h
//  wjTestDemo
//
//  Created by jerry on 2017/6/27.
//  Copyright © 2017年 wangjun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface wjModel : NSObject

/** 名字*/
@property (nonatomic,strong) NSString * cellName;
/** 图标*/
@property (nonatomic,strong) NSString * imageName;

+ (instancetype)modelWithDictionary:(NSDictionary *)dict;

@end
