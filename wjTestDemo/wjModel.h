//
//  wjModel.h
//  wjTestDemo
//
//  Created by jerry on 2017/6/27.
//  Copyright © 2017年 wangjun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface wjModel : NSObject

@property (nonatomic,strong) NSString * cellName;

+ (instancetype)modelWithDictionary:(NSDictionary *)dict;

@end
