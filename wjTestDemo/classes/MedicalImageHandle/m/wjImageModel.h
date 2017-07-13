//
//  wjImageModel.h
//  wjTestDemo
//
//  Created by jerry on 2017/7/13.
//  Copyright © 2017年 wangjun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface wjImageModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *imageDataArray;

+ (instancetype)modelWithDictionary:(NSDictionary *)dict;

@end
