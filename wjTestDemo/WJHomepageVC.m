//
//  WJHomepageVC.m
//  wjTestDemo
//
//  Created by pinnettech on 2019/5/5.
//  Copyright © 2019 wangjun. All rights reserved.
//  homePape页面

#import "WJHomepageVC.h"
#import "WJHomepageCell.h"
#import "wjModel.h"

@interface WJHomepageVC () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
@property (nonatomic,strong) NSMutableArray * dataArray;

@end

@implementation WJHomepageVC


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
    
    [self setUpUI];
}


/** UI界面的搭建 */
- (void)setUpUI {
    self.view.backgroundColor = WHITE_COLOR;
    self.title = @"我的私有项目";
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(75, 75);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    collectionView.backgroundColor = NORMAL_THEME_COLOR;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [self.view addSubview:collectionView];
    
    [collectionView registerClass:[WJHomepageCell class] forCellWithReuseIdentifier:@"homepageCell"];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    WJHomepageCell *cell = [WJHomepageCell homepageCellWithCollectionView:collectionView inIndexPath:indexPath cellFrame:CGRectMake(0, 0, 75, 75)];
    cell.model = self.dataArray[indexPath.row];
    return cell;
    
}


#pragma mark - UICollectionViewDelegateFlowLayout
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return 15;
    }
    
    return 10;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(75, 75);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(15, 15, 5, 15);//分别为上、左、下、右
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    wjModel *model = self.dataArray[indexPath.row];
    NSString *vcStr = model.viewController;
    id vc = [[NSClassFromString(vcStr) alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}




@end
