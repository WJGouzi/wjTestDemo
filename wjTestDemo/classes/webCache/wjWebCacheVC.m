//
//  wjWebCacheVC.m
//  wjTestDemo
//
//  Created by jerry on 2017/9/1.
//  Copyright © 2017年 wangjun. All rights reserved.
//

#import "wjWebCacheVC.h"
#import "wjWebCacheURLProtocal.h"

@interface wjWebCacheVC ()

@end

@implementation wjWebCacheVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"web缓存";
    // 开启监听
    [wjWebCacheURLProtocal webCacheStartListeningNetWork];
    UIWebView *webview = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webview];
    NSURL *URL = [NSURL URLWithString:@"https://m.jd.com"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:URL];
    [webview loadRequest:request];
    
    NSLog(@"cache directory---%@", NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]);
}


- (void)dealloc {
    [wjWebCacheURLProtocal webCacheEndListeningNetWork];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [wjWebCacheURLProtocal webCacheEndListeningNetWork];
}


@end
