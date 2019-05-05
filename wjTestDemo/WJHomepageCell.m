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
    self.backgroundColor = WHITE_COLOR;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    
    self.iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backgroundImageGakki.jpeg"]];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.iconImageView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:SCREEN_FIT(12)];
    self.titleLabel.textColor = NORMAL_TITLE_COLOR;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
    [self.titleLabel sizeToFit];
    self.titleLabel.text = @"名称";
    
    [self addSubview:self.titleLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.iconImageView.frame = CGRectMake(SCREEN_FIT(20), SCREEN_FIT(5), SCREEN_FIT(35), SCREEN_FIT(30));
    CGFloat imageViewMaxY = CGRectGetMaxY(self.iconImageView.frame);
    self.titleLabel.frame = CGRectMake(0, imageViewMaxY + SCREEN_FIT(5), self.bounds.size.width, SCREEN_FIT(35));
}


- (void)setModel:(wjModel *)model {
    _model = model;
    
    self.iconImageView.image = [UIImage imageNamed:model.imageName];
    self.titleLabel.text = model.cellName;
}


@end
