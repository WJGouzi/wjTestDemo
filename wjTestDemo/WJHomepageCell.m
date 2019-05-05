//
//  WJHomepageCell.m
//  wjTestDemo
//
//  Created by pinnettech on 2019/5/5.
//  Copyright © 2019 wangjun. All rights reserved.
//  主页上的cell

#import "WJHomepageCell.h"
#import "wjModel.h"

@interface WJHomepageCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation WJHomepageCell

#pragma mark - 构造方法
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpUI];
    }
    return self;
}

+ (instancetype)homepageCellWithCollectionView:(UICollectionView *)collectionView inIndexPath:(NSIndexPath *)indexPath cellFrame:(CGRect)cellFrame {
    static NSString *iden = @"homepageCell";
    WJHomepageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:iden forIndexPath:indexPath];
    if (!cell) {
        cell = [[WJHomepageCell alloc] initWithFrame:cellFrame];
    }
    return cell;
}


#pragma mark - UI界面的搭建
- (void)setUpUI {
    
    self.layer.borderColor = [UIColor colorWithRed:114/255.0 green:114/255.0 blue:114/255.0 alpha:1.0].CGColor;
    self.layer.borderWidth = 0.5;
    
    self.iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backgroundImageGakki.jpeg"]];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.iconImageView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:12 * SCREEN_RATE];
    self.titleLabel.textColor = [UIColor colorWithRed:20/255.0 green:20/255.0 blue:20/255.0 alpha:1.0];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
    [self.titleLabel sizeToFit];
    self.titleLabel.text = @"名称";
    
    [self addSubview:self.titleLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.iconImageView.frame = CGRectMake(20 * SCREEN_RATE, 5 * SCREEN_RATE, 35 * SCREEN_RATE, 30 * SCREEN_RATE);
    CGFloat imageViewMaxY = CGRectGetMaxY(self.iconImageView.frame);
    self.titleLabel.frame = CGRectMake(0, imageViewMaxY + 5 * SCREEN_RATE, self.bounds.size.width, 35 * SCREEN_RATE);
    
}


- (void)setModel:(wjModel *)model {
    _model = model;
    
    self.iconImageView.image = [UIImage imageNamed:model.imageName];
    self.titleLabel.text = model.cellName;
}


@end
