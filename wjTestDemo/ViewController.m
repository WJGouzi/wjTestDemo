//
//  ViewController.m
//  wjTestDemo
//
//  Created by jerry on 2017/6/27.
//  Copyright © 2017年 wangjun. All rights reserved.
//

#import "ViewController.h"
#import "wjQRCodeVC.h"
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
//    self.tableView.frame = CGRectMake(0, 20, wjScreenWidth, wjScreenHeight - 20);
    self.tableView.backgroundColor = [UIColor lightGrayColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%ld", self.dataArray.count);
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *iden = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    wjModel *model = self.dataArray[indexPath.row];
    cell.textLabel.text = model.cellName;
    return cell;
}

#pragma mark - UITableViewDelegate 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            wjQRCodeVC *qrvc = [[wjQRCodeVC alloc] init];
            [self presentViewController:qrvc animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}



@end
