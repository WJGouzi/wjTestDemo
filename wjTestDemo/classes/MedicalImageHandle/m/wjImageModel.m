//
//  wjImageModel.m
//  wjTestDemo
//
//  Created by jerry on 2017/7/13.
//  Copyright © 2017年 wangjun. All rights reserved.
//

#import "wjImageModel.h"


@implementation wjImageModel

+ (instancetype)modelWithDictionary:(NSDictionary *)dict {
    wjImageModel *model = [[self alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}

@end
