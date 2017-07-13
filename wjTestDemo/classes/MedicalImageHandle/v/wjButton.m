//
//  wjButton.m
//  wjTestDemo
//
//  Created by gouzi on 2017/7/13.
//  Copyright © 2017年 wangjun. All rights reserved.
//

#import "wjButton.h"
#import "wjButtonModel.h"

@implementation wjButton


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 文本居中
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        // 文字颜色
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 获取自身的尺寸
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    // 调整子控件的位置
    self.imageView.frame = CGRectMake(0, 0, width, width);
    self.titleLabel.frame = CGRectMake(0, width, width, height - width);
}

- (void)setModel:(wjButtonModel *)model {
    _model = model;
    
    [self setImage:[UIImage imageNamed:model.imageName] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:model.selectedImageName] forState:UIControlStateSelected];
    [self setTitle:model.name forState:UIControlStateNormal];
}

@end
