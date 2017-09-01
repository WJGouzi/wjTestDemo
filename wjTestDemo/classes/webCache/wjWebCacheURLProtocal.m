//
//  wjWebCacheURLProtocal.m
//  wjTestDemo
//
//  Created by jerry on 2017/9/1.
//  Copyright © 2017年 wangjun. All rights reserved.
//

#import "wjWebCacheURLProtocal.h"

#pragma mark - cache config

@interface wjCacheConfig : NSObject

// 记录上次url请求的时间
@property (nonatomic, strong, readwrite) NSMutableDictionary *urlDateDict;

// 相同的url，在大于了这个时间的时候，才会发送新的网络请求，如果小于这个时间的，就不进行请求。
@property (nonatomic, assign, readwrite) NSInteger updateInterval;

// 全局的config，每次的网络请求都是加载的这个
@property (nonatomic, strong, readwrite) NSURLSessionConfiguration *config;

@property (nonatomic, readwrite, strong) NSOperationQueue *forgeroundNetQueue;
@property (nonatomic, readwrite, strong) NSOperationQueue *backgroundNetQueue;

@end

#define defaultUpdateTime 3600

@implementation wjCacheConfig


#pragma mark - 懒加载

- (NSInteger)updateInterval {
    if (_updateInterval == 0) {
        _updateInterval = defaultUpdateTime;
    }
    return _updateInterval;
}


- (NSMutableDictionary *)urlDateDict {
    if (!_updateInterval) {
        _urlDateDict = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _urlDateDict;
}

- (NSURLSessionConfiguration *)config {
    if (!_config) {
        _config = [NSURLSessionConfiguration defaultSessionConfiguration];
    }
    return _config;
}


- (NSOperationQueue *)forgeroundNetQueue {
    if (!_forgeroundNetQueue) {
        _forgeroundNetQueue = [[NSOperationQueue alloc] init];
        _forgeroundNetQueue.maxConcurrentOperationCount = 10;
    }
    return _forgeroundNetQueue;
}

- (NSOperationQueue *)backgroundNetQueue {
    if (!_backgroundNetQueue) {
        _backgroundNetQueue = [[NSOperationQueue alloc] init];
        _backgroundNetQueue.maxConcurrentOperationCount = 6;
    }
    return _backgroundNetQueue;
}

#pragma mark - 创建单例模式
+ (instancetype)shareConfig {
    static wjCacheConfig *configCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        configCache = [[wjCacheConfig alloc] init];
    });
    return configCache;
}

- (void)clearDateDict {
    [wjCacheConfig shareConfig].urlDateDict = nil;
}


@end



#pragma mark - wjWebCacheURLProtocal
static NSString *const URLProtocolAlreadyHandleKey = @"alreadyHandle";
static NSString *const checkUpdateInBgKey = @"checkUpdateInBg";

@interface wjWebCacheURLProtocal ()

@property (nonatomic, strong, readwrite) NSURLSession *session;
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, strong) NSURLResponse *response;

@end



@implementation wjWebCacheURLProtocal

+ (void)webCacheStartListeningNetWork {
    [NSURLProtocol registerClass:[wjWebCacheURLProtocal class]];
}


+ (void)webCacheEndListeningNetWork {
    [NSURLProtocol unregisterClass:[wjWebCacheURLProtocal class]];
}

+ (void)webCacheClearUrlDateDict {
    [[wjCacheConfig shareConfig] clearDateDict];
}

+ (void)setConfig:(NSURLSessionConfiguration *)config {
    [[wjCacheConfig shareConfig] setConfig:config];
}

+ (void)setUpdateInterval:(NSInteger)updateInterval {
    [[wjCacheConfig shareConfig] setUpdateInterval:updateInterval];
}


+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    NSString *schemer = [request URL].scheme;
    if ([schemer caseInsensitiveCompare:@"http"] == NSOrderedSame || [schemer caseInsensitiveCompare:@"https"] == NSOrderedSame) {
        if ([NSURLProtocol propertyForKey:URLProtocolAlreadyHandleKey inRequest:request] || [NSURLProtocol propertyForKey:checkUpdateInBgKey inRequest:request]) {
            return NO;
        }
    }
    return YES;
}


+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

- (void)startLoading {
    // 去加载
    NSCachedURLResponse *urlResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:self.request];
    if (urlResponse) {
        // 缓存存在就加载
        [self.client URLProtocol:self didReceiveResponse:urlResponse.response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        [self.client URLProtocol:self didLoadData:urlResponse.data];
        [self.client URLProtocolDidFinishLoading:self];
        [self wjBackgroundCheckUpdateLoadData];
        return ;
    }
    // 不存在
    NSMutableURLRequest *mutableRequest = [self.request mutableCopy];
    [NSURLProtocol setProperty:@YES forKey:URLProtocolAlreadyHandleKey inRequest:mutableRequest];
    [self wjNetworkRequest:mutableRequest];
}

// 核对加载数据
- (void)wjBackgroundCheckUpdateLoadData {
    __weak typeof(self) weakSelf = self;
    [[[wjCacheConfig shareConfig] backgroundNetQueue] addOperationWithBlock:^{
        NSDate *update = [[[wjCacheConfig shareConfig] urlDateDict] objectForKey:weakSelf.request.URL.absoluteString];
        if (update) {
            NSDate *now = [NSDate date];
            NSInteger interval = [now timeIntervalSinceDate:update];
            if (interval < [wjCacheConfig shareConfig].updateInterval) {
                return ;
            }
        }
        NSMutableURLRequest *mutableRequest = [weakSelf.request mutableCopy];
        // 设置加载过了数据
        [NSURLProtocol setProperty:@YES forKey:checkUpdateInBgKey inRequest:mutableRequest];
        [weakSelf wjNetworkRequest:mutableRequest];
    }];
}

// 加载数据
- (void)wjNetworkRequest:(NSURLRequest *)request {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[wjCacheConfig shareConfig].forgeroundNetQueue];
    self.session = session;
    NSURLSessionTask *task = [self.session dataTaskWithRequest:request];
    [[wjCacheConfig shareConfig].urlDateDict setValue:[NSDate date] forKey:self.request.URL.absoluteString];
    [task resume];
}

// 停止加载
- (void)stopLoading {
    [self.session invalidateAndCancel];
    self.session = nil;
}

- (BOOL)isUseCache{
    //如果有缓存则使用缓存，没有缓存则发出请求
    NSCachedURLResponse *urlResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:[self request]];
    if (urlResponse) {
        return YES;
    }
    return NO;
}


#pragma mark - NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    [self.client URLProtocol:self didLoadData:data];
    
    
}


// 拼接数据
- (void)wjAppendData:(NSData *)data {
    if (self.data == nil) {
        [self setData:[data mutableCopy]];
    } else {
        [self.data appendData:[data mutableCopy]];
    }
}


- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    self.response = response;
    completionHandler(NSURLSessionResponseAllow);
}


- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    if (error) {
        [self.client URLProtocol:self didFailWithError:error];
    } else {
        [self.client URLProtocolDidFinishLoading:self];
        if (!self.data) {
            return;
        }
        NSCachedURLResponse *cacheUrlResponse = [[NSCachedURLResponse alloc] initWithResponse:task.response data:self.data];
        [[NSURLCache sharedURLCache] storeCachedResponse:cacheUrlResponse forRequest:self.request];
        self.data = nil;
    }
}





















@end
