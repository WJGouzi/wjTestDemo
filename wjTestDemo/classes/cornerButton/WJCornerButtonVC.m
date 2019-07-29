//
//  WJCornerButtonVC.m
//  wjTestDemo
//
//  Created by gouzi on 2019/7/29.
//  Copyright © 2019 wangjun. All rights reserved.
//

#import "WJCornerButtonVC.h"
#import "WJCornerButton.h"

@interface WJCornerButtonVC ()

@property (weak, nonatomic) IBOutlet UIView *cornerView;

@end

@implementation WJCornerButtonVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"圆角View";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:18.f];
    [self.cornerView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.cornerView.mas_centerY);
        make.centerX.mas_equalTo(self.cornerView.mas_centerX);
    }];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.cornerView.bounds
                                                   byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                                                         cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame         = self.cornerView.bounds;
    maskLayer.path          = maskPath.CGPath;
    self.cornerView.layer.mask         = maskLayer;
    
    
    
}

- (IBAction)cornerButtonClickAction:(WJCornerButton *)sender {
    NSLog(@"BUTTON TYPE IS: %d", sender.style);
}

@end
