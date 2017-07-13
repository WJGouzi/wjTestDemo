//
//  wjButtonModel.m
//  wjTestDemo
//
//  Created by gouzi on 2017/7/13.
//  Copyright © 2017年 wangjun. All rights reserved.
//

#import "wjButtonModel.h"

@implementation wjButtonModel

+ (instancetype)buttionWithButtonDict:(NSDictionary *)dict {
    wjButtonModel *model = [[wjButtonModel alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}


@end
