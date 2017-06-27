//
//  wjModel.m
//  wjTestDemo
//
//  Created by jerry on 2017/6/27.
//  Copyright © 2017年 wangjun. All rights reserved.
//

#import "wjModel.h"

@implementation wjModel

+ (instancetype)modelWithDictionary:(NSDictionary *)dict {
    wjModel *model = [[self alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}

@end
