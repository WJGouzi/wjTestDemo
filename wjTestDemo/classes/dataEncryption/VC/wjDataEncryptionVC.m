//
//  wjDataEncryptionVC.m
//  wjTestDemo
//
//  Created by jerry on 2017/7/24.
//  Copyright © 2017年 wangjun. All rights reserved.
//

#import "wjDataEncryptionVC.h"
#import "wjEncryptionVC.h"

@interface wjDataEncryptionVC ()

@property (nonatomic, strong) NSMutableArray *dataArray;


@end

@implementation wjDataEncryptionVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"加密方式";
}


#pragma mark - 懒加载
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        [_dataArray addObjectsFromArray: @[
                                           @"md5",
//                                           @"base64",
                                           @"des"
                                          ]];
    }
    return _dataArray;
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *iden = @"dataEncryptionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    wjEncryptionVC *encryptionVC = [[wjEncryptionVC alloc] init];
    encryptionVC.type = self.dataArray[indexPath.row];
    NSLog(@"%@", encryptionVC.type);
    [self.navigationController pushViewController:encryptionVC animated:YES];
}




@end
