//
//  wjGestureLockView.m
//  wjGestureLock
//
//  Created by gouzi on 2017/5/24.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "wjGestureLockView.h"

#define wjSaveKey @"saveKey"

@interface wjGestureLockView ()

@property (nonatomic, strong) NSMutableArray *selectedNumberArray;

/* current*/
@property (nonatomic, assign) CGPoint currentPoint;

@end

@implementation wjGestureLockView


- (NSMutableArray *)selectedNumberArray {
    if (!_selectedNumberArray) {
        _selectedNumberArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _selectedNumberArray;
}



// 加载
- (void)awakeFromNib {
    [super awakeFromNib];
    // 添加9个按钮
    for (int i = 0; i < 9; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        btn.userInteractionEnabled = NO;
        [btn setImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"gesture_node_selected"] forState:UIControlStateSelected];
        [self addSubview:btn];
    }
}

// 重置frame
- (void)layoutSubviews {
    [super layoutSubviews];
    int column = 3;
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat BtnWH = 74;
    int currentColumn = 0;
    int currentRaw = 0;
    CGFloat magin = (self.frame.size.width - column * BtnWH) / (column + 1);
    for (int i = 0; i < self.subviews.count; i++) {
        UIButton *btn = self.subviews[i];
        currentColumn = i % column;
        currentRaw = i / column;
        x = magin + (magin + BtnWH) * currentColumn;
        y = magin + (magin + BtnWH) * currentRaw;
        btn.frame = CGRectMake(x, y, BtnWH, BtnWH);
    }
}

// 判断这个点是不是在按钮的范围内
- (UIButton *)wjButtonRectContainPoint:(CGPoint)point {
    for (UIButton *btn in self.subviews) {
        BOOL isContain = CGRectContainsPoint(btn.frame, point);
        if (isContain) {
            return btn;
        }
    }
    return nil;
}

// 获取当前点
- (CGPoint)wjGetCurrentPointWithTouches:(NSSet *)touches {
    UITouch *touch = [touches anyObject];
    return [touch locationInView:self];
}


// 开始点击
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 判断点的位置
    CGPoint currentPoint = [self wjGetCurrentPointWithTouches:touches];
    UIButton *btn = [self wjButtonRectContainPoint:currentPoint];
    if (btn && btn.selected == NO) {
        btn.selected = YES;
        // 把点加入到数组中‘
        [self.selectedNumberArray addObject:btn];
    }
}

// 开始移动
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint currentPoint = [self wjGetCurrentPointWithTouches:touches];
    UIButton *btn = [self wjButtonRectContainPoint:currentPoint];
    if (btn && btn.selected == NO) {
        btn.selected = YES;
        [self.selectedNumberArray addObject:btn];
    }
    [self setNeedsDisplay];
    self.currentPoint = currentPoint;
}


// 结束
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 让所有的按钮取消选中
    NSMutableString *codeStr = [NSMutableString string];
    for (UIButton *btn in self.selectedNumberArray) {
        btn.selected = NO;
        [codeStr appendFormat:@"%ld", btn.tag];
    }
    // 情况路径
    self.selectedNumberArray = nil;
    [self setNeedsDisplay];
    // 将选择的点存到userDefaults中
    if (codeStr.length < 4) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请至少绘制4个按钮" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    } else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *key = [defaults objectForKey:wjSaveKey];
        if (!key) {
            [defaults setObject:codeStr forKey:wjSaveKey];
            [defaults synchronize];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"添加手势成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        } else {
            if ([key isEqualToString:codeStr]) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您输入的手势正确" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您输入的手势错误" message:@"请重新输入手势" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            }
        }
    }
    
    
}


- (void)drawRect:(CGRect)rect {
    if (self.selectedNumberArray.count) {
        // 绘制线
        UIBezierPath *path = [UIBezierPath bezierPath];
        for (int i = 0; i < self.selectedNumberArray.count; i++) {
            UIButton *btn = self.selectedNumberArray[i];
            if (i == 0) {
                [path moveToPoint:btn.center];
            } else {
                [path addLineToPoint:btn.center];
            }
        }
        // 点到收当前的位置
        [path addLineToPoint:self.currentPoint];
        [path setLineJoinStyle:kCGLineJoinRound];
        [path setLineWidth:10.f];
        [[UIColor redColor] set];
        [path stroke];
    }
}


@end
