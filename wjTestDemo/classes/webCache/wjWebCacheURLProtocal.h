//
//  wjWebCacheURLProtocal.h
//  wjTestDemo
//
//  Created by jerry on 2017/9/1.
//  Copyright © 2017年 wangjun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface wjWebCacheURLProtocal : NSURLProtocol <NSURLSessionDataDelegate>

// 相同的url，在大于了这个时间的时候，才会发送新的网络请求，如果小于这个时间的，就不进行请求。
@property (nonatomic, assign, readwrite) NSInteger updateInterval;

// 全局的config，每次的网络请求都是加载的这个
@property (nonatomic, strong, readwrite) NSURLSessionConfiguration *config;

// 开始监听
+ (void)webCacheStartListeningNetWork;

// 结束监听
+ (void)webCacheEndListeningNetWork;

// 清除上次的时间
+ (void)webCacheClearUrlDateDict;

+ (void)setUpdateInterval:(NSInteger)updateInterval;

+ (void)setConfig:(NSURLSessionConfiguration *)config;

@end
