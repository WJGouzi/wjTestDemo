//
//  WJChartSpeciesVC.m
//  wjTestDemo
//
//  Created by gouzi on 2017/10/26.
//  Copyright © 2017年 wangjun. All rights reserved.
//

#import "WJChartSpeciesVC.h"
#import "WJChartDisplayVC.h"

@interface WJChartSpeciesVC ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation WJChartSpeciesVC

#pragma mark - 懒加载
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithObjects:@"曲线图", nil];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"图标展示";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [[UIView alloc] init];
}



#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *iden = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 这个是row == 0 的时候
    WJChartDisplayVC *displayVC = [[WJChartDisplayVC alloc] init];
    [self.navigationController pushViewController:displayVC animated:YES];
}


@end
