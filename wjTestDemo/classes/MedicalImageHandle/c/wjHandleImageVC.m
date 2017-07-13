//
//  wjHandleImageVC.m
//  wjTestDemo
//
//  Created by jerry on 2017/7/13.
//  Copyright © 2017年 wangjun. All rights reserved.
//

#import "wjHandleImageVC.h"
#import "wjImageModel.h"
#import "wjImageDetailVC.h"

@interface wjHandleImageVC ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation wjHandleImageVC

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"wjImageData" ofType:@"plist"];
        NSArray *data = [NSArray arrayWithContentsOfFile:dataPath];
        NSMutableArray *imageDataArray = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *dict in data) {
            wjImageModel *model = [wjImageModel modelWithDictionary:dict];
            [imageDataArray addObject:model];
        }
        _dataArray = [imageDataArray copy];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"医学影像";
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *iden = @"medicalImageDataCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:iden];
        cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
    }
    
    wjImageModel *model = self.dataArray[indexPath.row];
    cell.textLabel.text = model.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"共有%ld张图片", model.imageDataArray.count];
    
    return cell;
}


#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 点击不同的cell传入不同的数据到之后的展示页面去
    wjImageDetailVC *imageDetailVC = [[wjImageDetailVC alloc] init];
    imageDetailVC.model = self.dataArray[indexPath.row];
//    imageDetailVC.hidesBottomBarWhenPushed = YES; // 项目中没有tableBar
    [self.navigationController pushViewController:imageDetailVC animated:YES];
}






@end
