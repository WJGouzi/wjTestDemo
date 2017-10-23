//
//  AppDelegate.m
//  wjTestDemo
//
//  Created by jerry on 2017/6/27.
//  Copyright © 2017年 wangjun. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <Contacts/Contacts.h>

//#define wjScreenWidth [UIScreen mainScreen].bounds.size.width
//#define wjScreenHeight [UIScreen mainScreen].bounds.size.height



@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    ViewController *vc = [[ViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    // 获取手机通讯录
    [self requestAuthorizationForAddressBook];
    
    // 3DTOUCH
    [self wjCreat3DShortCutItemInAppicon];
    [self wjAccordingToFlagIntoDifferentControllerWithOptions:launchOptions navigation:nav];
    return YES;
}

#pragma mark - --------------------------------------获取手机通讯录 相关-------------------------------------------------
- (void)requestAuthorizationForAddressBook {
    CNAuthorizationStatus authorizationStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (authorizationStatus == CNAuthorizationStatusNotDetermined) {
        CNContactStore *contactStore = [[CNContactStore alloc] init];
        [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                
            } else {
                NSLog(@"授权失败, error=%@", error);
            }
        }];
    }
}


#pragma mark - -------------------------------------------------------------------------------------------------------



#pragma mark - -------------------------------------------3DTouch 相关-------------------------------------------------

/**
 在图标上创建一个3DTouch的列表
 */
- (void)wjCreat3DShortCutItemInAppicon {
    // 创建系统风格的快捷键
    UIApplicationShortcutIcon *systemIcon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeShare];
    // 创建快捷选项
    UIApplicationShortcutItem *systemItem = [[UIApplicationShortcutItem alloc] initWithType:@"com.wangjun.wjTestDemo.3Dtouch.share" localizedTitle:@"分享" localizedSubtitle:@"一起分享" icon:systemIcon userInfo:nil];
    
    // 自定义的风格的快捷键
    UIApplicationShortcutIcon *changeAppIcon = [UIApplicationShortcutIcon iconWithTemplateImageName:@"扫描二维码"];
    UIApplicationShortcutItem *changIconItem = [[UIApplicationShortcutItem alloc] initWithType:@"com.wangjun.wjTestDemo.3Dtouch.scanQRCode" localizedTitle:@"扫一扫" localizedSubtitle:@"试试吧" icon:changeAppIcon userInfo:nil];
    
    [UIApplication sharedApplication].shortcutItems = @[systemItem, changIconItem];
}


/**
 根据不同的标志进入到不同的页面
 */
- (BOOL)wjAccordingToFlagIntoDifferentControllerWithOptions:(NSDictionary *)launchOptions navigation:(UINavigationController *)nav {
    UIApplicationShortcutItem *item = [launchOptions valueForKey:UIApplicationLaunchOptionsShortcutItemKey];
    if (item) {
        [self wjIntoDifferentControllerWithItem:item withNavgation:nav];
        return NO;
    }
    return YES;
}

//如果app在后台，通过快捷选项标签进入app，则调用该方法，如果app不在后台已杀死，则处理通过快捷选项标签进入app的逻辑在- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions中
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    ViewController *vc = [[ViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    [self wjIntoDifferentControllerWithItem:shortcutItem withNavgation:nav];
    if (completionHandler) {
        completionHandler(YES);
    }
}


// 封装->进入不同的控制器
- (void)wjIntoDifferentControllerWithItem:(UIApplicationShortcutItem *)item withNavgation:(UINavigationController *)nav{
    if ([item.type isEqualToString:@"com.wangjun.wjTestDemo.3Dtouch.share"]) {
        NSArray *shares = @[@"3d Touch"];
        UIActivityViewController *shareVC = [[UIActivityViewController alloc]initWithActivityItems:shares applicationActivities:nil];
        [self.window.rootViewController presentViewController:shareVC animated:YES completion:^{
            NSLog(@"this is share demo display!");
        }];
    } else if ([item.type isEqualToString:@"com.wangjun.wjTestDemo.3Dtouch.changeAppIcon"]) {
        wjAlterAppIconVC *alterIconVC = [[wjAlterAppIconVC alloc] init];
        [nav pushViewController:alterIconVC animated:YES];
    } else if ([item.type isEqualToString:@"com.wangjun.wjTestDemo.3Dtouch.scanQRCode"]) {
        wjScanQRCodeVC *scanQRCodeVC = [[wjScanQRCodeVC alloc] init];
        [nav pushViewController:scanQRCodeVC animated:YES];
    } else if ([item.type isEqualToString:@"com.wangjun.wjTestDemo.3Dtouch.creatQRCode"]) {
        wjQRCodeVC *creatQRCodeVC = [[wjQRCodeVC alloc] init];
        [nav pushViewController:creatQRCodeVC animated:YES];
    }
}

#pragma mark - --------------------------------------------------------------------------------------------------------

@end
