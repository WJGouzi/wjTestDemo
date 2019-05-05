//
//  WJHomepageCell.h
//  wjTestDemo
//
//  Created by pinnettech on 2019/5/5.
//  Copyright © 2019 wangjun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class wjModel;

@interface WJHomepageCell : UICollectionViewCell

@property (nonatomic, strong) wjModel *model;

/**
 homepageCell的构造方法
 */
+ (instancetype)homepageCellWithCollectionView:(UICollectionView *)collectionView inIndexPath:(NSIndexPath *)indexPath cellFrame:(CGRect)cellFrame;

@end
