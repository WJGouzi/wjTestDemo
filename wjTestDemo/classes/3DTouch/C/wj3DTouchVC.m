//
//  wj3DTouchVC.m
//  wjTestDemo
//
//  Created by jerry on 2017/6/29.
//  Copyright © 2017年 wangjun. All rights reserved.
//

#import "wj3DTouchVC.h"
#import "wjTouchedVC.h"

typedef void(^actionBlock)(UIAlertAction *action);

@interface wj3DTouchVC () <UIViewControllerPreviewingDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation wj3DTouchVC

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        for (int i = 0; i < 20; i++) {
            [_dataArray addObject:[NSString stringWithFormat:@"3d touch - %d", i]];
        }
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"3Dtouch";
}



#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *iden = @"3DTouchCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    
    // 判断是否支持3DTouch
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        [self registerForPreviewingWithDelegate:self sourceView:cell];
    } else {
        [self wjShowAlertWithTitle:@"提示" message:@"您的设置不支持3DTouch功能!" actionTitle:@"确定" actionStyle:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }];
        
    }
    return cell;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    wjTouchedVC *touchedVC = [[wjTouchedVC alloc] init];
    touchedVC.touchCellIndex = [NSString stringWithFormat:@"%@--点击进来的",self.dataArray[indexPath.row]];
    [self.navigationController pushViewController:touchedVC animated:YES];
}


#pragma mark - UIViewControllerPreviewingDelegate

// If you return nil, a preview presentation will not be performed
/**
 peek预览
 */
- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    // 获取到点按的cell的行数
    NSIndexPath *index = [self.tableView indexPathForCell:(UITableViewCell *)[previewingContext sourceView]];
    wjTouchedVC *touchedVC = [[wjTouchedVC alloc] init];
    touchedVC.preferredContentSize = CGSizeMake(0, 500.0f);
    touchedVC.touchCellIndex = [NSString stringWithFormat:@"%@--用力按进来的", self.dataArray[index.row]];
    previewingContext.sourceRect = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    return touchedVC;
}


/**
 pop用力点击
 */
- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self showViewController:viewControllerToCommit sender:self];
}



#pragma mark - common method
/**
 提示框
 
 @param title 提示
 @param message 提示的文字
 @param actionTitle 按钮的文字
 @param style 按钮的样式
 @param block 点击后需要做的操作
 */
- (void)wjShowAlertWithTitle:(NSString *)title message:(NSString *)message actionTitle:(NSString *)actionTitle actionStyle:(UIAlertActionStyle)style handler:(actionBlock)block {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:block];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}


@end
