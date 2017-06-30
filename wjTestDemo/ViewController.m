//
//  ViewController.m
//  wjTestDemo
//
//  Created by jerry on 2017/6/27.
//  Copyright © 2017年 wangjun. All rights reserved.
//

#import "ViewController.h"
#import "wjModel.h"

#define wjScreenWidth [UIScreen mainScreen].bounds.size.width
#define wjScreenHeight [UIScreen mainScreen].bounds.size.height


@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray * dataArray;

@end

@implementation ViewController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"model.plist" ofType:nil]];
        NSMutableArray *modelArray = [NSMutableArray array];
        for (NSDictionary *dict in array) {
            wjModel *model = [wjModel modelWithDictionary:dict];
            [modelArray addObject:model];
        }
        _dataArray = [modelArray copy];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self wjBasicSettings];
}

- (void)wjBasicSettings {
    self.title = @"主页";
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *iden = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    wjModel *model = self.dataArray[indexPath.row];
    cell.textLabel.text = model.cellName;
    cell.imageView.image = [UIImage imageNamed:model.imageName];
    return cell;
}

#pragma mark - UITableViewDelegate 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            wjQRCodeVC *qrvc = [[wjQRCodeVC alloc] init];
            [self.navigationController pushViewController:qrvc animated:YES];
        }
            break;
        case 1: {
            wjScanQRCodeVC *scanQRCodeVC = [[wjScanQRCodeVC alloc] init];
            [self.navigationController pushViewController:scanQRCodeVC animated:YES];
        }
            break;
        case 2: {
            wjAlterAppIconVC *alterIconVC = [[wjAlterAppIconVC alloc] init];
            [self.navigationController pushViewController:alterIconVC animated:YES];
        }
            break;
        case 3: {
            wj3DTouchVC *touchVC = [[wj3DTouchVC alloc] init];
            [self.navigationController pushViewController:touchVC animated:YES];
        }
            break;
        case 4: {
            wjTouchIDVerificationVC *touchIDVC = [[wjTouchIDVerificationVC alloc] init];
            [self.navigationController pushViewController:touchIDVC animated:YES];
        }
            break;
        case 5: {
            wjGestureLockVC *gestureVC = [[wjGestureLockVC alloc] init];
            [self.navigationController pushViewController:gestureVC animated:YES];
        }
            break;
        default:
            break;
    }
}


@end
