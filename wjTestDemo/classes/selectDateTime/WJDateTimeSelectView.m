//
//  WJDateTimeSelectView.m
//  WJDateTimeSelect
//
//  Created by 王钧 on 2018/7/24.
//  Copyright © 2018年 王钧. All rights reserved.
//

#import "WJDateTimeSelectView.h"

@interface WJDateTimeSelectView() <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIView *selectView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) NSMutableArray *dateElementArray;
@property (nonatomic, strong) UIPickerView *yearPickView;
@property (nonatomic, strong) UIPickerView *monthPickView;
@property (nonatomic, strong) UIPickerView *dayPickView;
@property (nonatomic, strong) UIPickerView *hourPickView;
@property (nonatomic, strong) UIPickerView *minutePickView;

@property (nonatomic, strong) NSString *dateYearStr;
@property (nonatomic, strong) NSString *dateMonthStr;
@property (nonatomic, strong) NSString *dateDayStr;
@property (nonatomic, strong) NSString *dateHourStr;
@property (nonatomic, strong) NSString *dateMinuteStr;
@end

@implementation WJDateTimeSelectView

#pragma mark - 懒加载
- (NSMutableArray *)dateElementArray {
    if (!_dateElementArray) {
        _dateElementArray = [NSMutableArray array];
    }
    return _dateElementArray;
}


#pragma mark - 构造方法
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpUI];
    }
    return self;
}

//+ (instancetype)selectDateTime {
//
//}

#pragma mark - 创建UI
- (void)setUpUI {
    UIView *backView = [[UIView alloc] initWithFrame:self.frame];
    backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    backView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissTapAction:)];
    [backView addGestureRecognizer:tap];
    [self addSubview:backView];
    self.backView = backView;
    
    CGFloat selectViewW = 300;
    CGFloat selectViewH = 333;
    CGFloat selectViewX = (self.frame.size.width - selectViewW) * 0.5;
    CGFloat selectViewY = (self.frame.size.height - selectViewH) * 0.5;
    UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(selectViewX, selectViewY, selectViewW, selectViewH)];
    selectView.backgroundColor = [UIColor whiteColor];
    selectView.layer.masksToBounds = YES;
    selectView.layer.cornerRadius = 5;
    UITapGestureRecognizer *selectTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTimeTapAction:)];
    [selectView addGestureRecognizer:selectTap];
    [backView addSubview:selectView];
    self.selectView = selectView;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, selectViewW, 43)];
    titleLabel.backgroundColor = [UIColor colorWithRed:46/255.0f green:168/255.0f blue:254/255.0f alpha:1.0f];
    titleLabel.text = @"安排时间";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textColor = [UIColor whiteColor];
    [selectView addSubview:titleLabel];
    
    CGFloat selectTimeLabelY = CGRectGetMaxY(titleLabel.frame);
    UILabel *selectTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, selectTimeLabelY, 110, 40)];
    selectTimeLabel.text = @"请选择时间:";
    selectTimeLabel.textColor = [UIColor colorWithRed:20.0/255 green:20.0/255 blue:20.0/255 alpha:1.0];
    selectTimeLabel.textAlignment = NSTextAlignmentRight;
    [selectView addSubview:selectTimeLabel];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd hh:mm";
    NSString *dateTimeStr = [dateFormatter stringFromDate:[NSDate date]];
    CGFloat timeLabelX = CGRectGetMaxX(selectTimeLabel.frame) + 10;
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(timeLabelX, selectTimeLabelY, 170, 40)];
    timeLabel.text = dateTimeStr;
    timeLabel.textColor = [UIColor colorWithRed:46/255.0f green:168/255.0f blue:254/255.0f alpha:1.0f];
    timeLabel.textAlignment = NSTextAlignmentLeft;
    [selectView addSubview:timeLabel];
    self.timeLabel = timeLabel;

    CGFloat lineViewX = 17;
    CGFloat lineViewY = CGRectGetMaxY(timeLabel.frame);
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(lineViewX, lineViewY, selectViewW - 2 * lineViewX, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:46/255.0f green:168/255.0f blue:254/255.0f alpha:1.0f];
    [selectView addSubview:lineView];
    
    CGFloat timeElementLabelW = CGRectGetWidth(lineView.frame) / 5;
    CGFloat timeElementLabelY = CGRectGetMaxY(lineView.frame);
    NSArray *timeElementArray = @[@"年", @"月", @"日", @"时", @"分"];
    for (int i = 0; i < timeElementArray.count; i++) {
        UILabel *timeElementLabel = [[UILabel alloc] initWithFrame:CGRectMake(i * timeElementLabelW + lineViewX, timeElementLabelY, timeElementLabelW, 40)];
        timeElementLabel.text = timeElementArray[i];
        timeElementLabel.textColor = [UIColor colorWithRed:20.0/255 green:20.0/255 blue:20.0/255 alpha:1.0];
        timeElementLabel.textAlignment = NSTextAlignmentCenter;
        [selectView addSubview:timeElementLabel];
    }

    CGFloat timeControlViewY = timeElementLabelY + 40;
    UIView *timeControlView = [[UIView alloc] initWithFrame:CGRectMake(lineViewX, timeControlViewY, selectViewW - 2 * lineViewX, 144)];
    timeControlView.backgroundColor = [UIColor whiteColor];
    [selectView addSubview:timeControlView];
    
    [timeControlView.layer addSublayer:[self drawDotLineWithTopDistance:0 inView:timeControlView]];
    [timeControlView.layer addSublayer:[self drawDotLineWithTopDistance:CGRectGetHeight(timeControlView.frame) inView:timeControlView]];
    
    
    self.dateElementArray = [self countDateTimeEachElementWithDateNow:dateTimeStr];
    for (int i = 0; i < self.dateElementArray.count; i++) {
        UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(i * timeElementLabelW, 0, timeElementLabelW, 144)];
        pickerView.tag = 50000 + i;
        pickerView.dataSource = self;
        pickerView.delegate = self;
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(5, 85, timeElementLabelW - 10, 1)];
        lineView.backgroundColor = [UIColor colorWithRed:46/255.0f green:168/255.0f blue:254/255.0f alpha:1.0f];
        [pickerView.layer addSublayer:lineView.layer];
        UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(5, 59, timeElementLabelW - 10, 1)];
        topLineView.backgroundColor = [UIColor colorWithRed:46/255.0f green:168/255.0f blue:254/255.0f alpha:1.0f];
        [pickerView.layer addSublayer:topLineView.layer];
        [timeControlView addSubview:pickerView];
    }
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setBackgroundImage:[WJDateTimeSelectView imageWithColor:[UIColor orangeColor]] forState:UIControlStateNormal];
    CGFloat cancelBtnX = lineViewX;
    CGFloat cancelBtnY = CGRectGetMaxY(timeControlView.frame) + 15;
    cancelBtn.frame = CGRectMake(cancelBtnX, cancelBtnY, 125, 35);
    cancelBtn.layer.masksToBounds = YES;
    cancelBtn.layer.cornerRadius = 5;
    [cancelBtn addTarget:self action:@selector(cancelButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [selectView addSubview:cancelBtn];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setBackgroundImage:[WJDateTimeSelectView imageWithColor:[UIColor colorWithRed:46/255.0f green:168/255.0f blue:254/255.0f alpha:1.0f]] forState:UIControlStateNormal];
    CGFloat sureBtnX = CGRectGetMaxX(cancelBtn.frame) + 20;
    sureBtn.frame = CGRectMake(sureBtnX, cancelBtnY, 125, 35);
    sureBtn.layer.masksToBounds = YES;
    sureBtn.layer.cornerRadius = 5;
    [sureBtn addTarget:self action:@selector(sureButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [selectView addSubview:sureBtn];
}


#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger tagValue = pickerView.tag - 50000;
    NSMutableArray *datas = self.dateElementArray[tagValue];
    return datas.count;
}

#pragma mark - UIPickerViewDelegate
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    NSInteger tagValue = pickerView.tag - 50000;
    UILabel *label = [[UILabel alloc] init];
    NSMutableArray *datas = self.dateElementArray[tagValue];
    label.text = [datas objectAtIndex:row];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSInteger tagValue = pickerView.tag - 50000;
    switch (tagValue) {
        case 0: {
            [self.monthPickView selectRow:0 inComponent:0 animated:NO];
            NSArray *years = [self.dateElementArray.firstObject copy];
            self.dateYearStr = years[row];
            [self scrollYearPickViewWithPickView:pickerView withRow:(NSInteger)row];
        }
            break;
        case 1:{
            NSMutableArray *months = self.dateElementArray[1];
            self.dateMonthStr = months[row];
            [self scrollMonthPickView:pickerView withRow:row];
        }
            break;
        case 2: {
            NSMutableArray *days = self.dateElementArray[2];
            self.dateDayStr = days[row];
            [self scrollDayPickView:pickerView withRow:row];
        }
            break;
        case 3: {
            NSMutableArray *hours = self.dateElementArray[3];
            self.dateHourStr = hours[row];
            [self scrollHourPickView:pickerView withRow:row];
        }
            break;
        case 4: {
//            [self scrollMinutePickView:pickerView withRow:row];
            NSMutableArray *minutes = self.dateElementArray[4];
            self.dateMinuteStr = minutes[row];
        }
            break;
        default:
            break;
    }
    // 修改时间显示的label
    [self modifyShowTimeLableText];
}

- (void)modifyShowTimeLableText {
    NSString *showTimeText = [NSString stringWithFormat:@"%@-%@-%@ %@:%@", self.dateYearStr, self.dateMonthStr, self.dateDayStr, self.dateHourStr, self.dateMinuteStr];
    self.timeLabel.text = showTimeText;
}

#pragma mark - pickerView的滚动的事件
// 年
- (void)scrollYearPickViewWithPickView:(UIPickerView *)pickView withRow:(NSInteger)row {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateTimeStr = [dateFormatter stringFromDate:[NSDate date]];
    NSArray *dataElements = [dateTimeStr componentsSeparatedByString:@"-"];
    NSString *year = dataElements.firstObject;
    NSString *month = dataElements[1];
    UILabel *label = (UILabel *)[pickView viewForRow:row forComponent:0];
    NSMutableArray *monthArray = [NSMutableArray array];
    if ([label.text isEqualToString:year]) {
        for (int i = month.intValue; i <= 12; i++) {
            [monthArray addObject:[NSString stringWithFormat:@"%d", i]];
        }
    } else {
        for (int i = 1; i < month.intValue + 1; i++) {
            [monthArray addObject:[NSString stringWithFormat:@"%d", i]];
        }
    }
    self.dateMonthStr = monthArray.firstObject;
    [self.dateElementArray replaceObjectAtIndex:1 withObject:monthArray];
    self.monthPickView = (UIPickerView *)[self viewWithTag:50001];
    [self.monthPickView reloadAllComponents];
    [self.monthPickView selectRow:0 inComponent:0 animated:YES];
    [self scrollMonthPickView:self.monthPickView withRow:0];
}


// 月
- (void)scrollMonthPickView:(UIPickerView *)pickView withRow:(NSInteger)row {
    [self.dayPickView selectRow:0 inComponent:0 animated:NO];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateTimeStr = [dateFormatter stringFromDate:[NSDate date]];
    NSArray *dataElements = [dateTimeStr componentsSeparatedByString:@"-"];
    NSString *year = dataElements.firstObject;
    NSString *month = [NSString stringWithFormat:@"%d", [dataElements[1] intValue]];
    NSString *day = dataElements.lastObject;
    UILabel *label = (UILabel *)[pickView viewForRow:row forComponent:0];
    NSArray *notLeapDaysArray = @[@"31", @"28", @"31", @"30", @"31", @"30", @"31", @"31", @"30", @"31", @"30", @"31"];
    NSArray *leapDaysArray = @[@"31", @"29", @"31", @"30", @"31", @"30", @"31", @"31", @"30", @"31", @"30", @"31"];
    NSMutableArray *chooseDaysArray = [self judgeYearIsLeapyear:year] ? [leapDaysArray mutableCopy] : [notLeapDaysArray mutableCopy];
    NSMutableArray *daysArray = [NSMutableArray array];
    if ([label.text isEqualToString:month] && [year isEqualToString:self.dateYearStr]) {
        for (int i = day.intValue; i <= [chooseDaysArray[month.integerValue-1] integerValue]; i++) {
            [daysArray addObject:[NSString stringWithFormat:@"%d", i]];
        }
    } else if ([label.text isEqualToString:month] && ![year isEqualToString:self.dateYearStr]) {
        for (int i = 1; i < day.intValue; i++) {
            [daysArray addObject:[NSString stringWithFormat:@"%d", i]];
        }
    } else {
        for (int i = 1; i <= [chooseDaysArray[label.text.intValue-1] intValue]; i++) {
            [daysArray addObject:[NSString stringWithFormat:@"%d", i]];
        }
    }
    self.dateDayStr = daysArray.firstObject;
    [self.dateElementArray replaceObjectAtIndex:2 withObject:daysArray];
    self.dayPickView = (UIPickerView *)[self viewWithTag:50002];
    [self.dayPickView reloadAllComponents];
    [self.dayPickView selectRow:0 inComponent:0 animated:YES];
    [self scrollDayPickView:self.dayPickView withRow:0];
}

// 日
- (void)scrollDayPickView:(UIPickerView *)pickView withRow:(NSInteger)row {
    [self.hourPickView selectRow:0 inComponent:0 animated:NO];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-M-d h:m";
    NSString *dateTimeStr = [dateFormatter stringFromDate:[NSDate date]];
    NSString *dateStr = [dateTimeStr componentsSeparatedByString:@" "].firstObject;
    NSString *timeStr = [dateTimeStr componentsSeparatedByString:@" "].lastObject;
    NSString *hour = [timeStr componentsSeparatedByString:@":"].firstObject;
    NSString *pickDateStr = [NSString stringWithFormat:@"%@-%d-%d", self.dateYearStr, [self.dateMonthStr intValue], [self.dateDayStr intValue]];
    NSMutableArray *hoursArray = [NSMutableArray array];
    if ([pickDateStr isEqualToString:dateStr]) {
        // 现在的时间和pickview上的时间相同的时候
        for (int i = hour.intValue; i < 24; i++) {
            [hoursArray addObject:[NSString stringWithFormat:@"%d", i]];
        }
    } else {
        for (int i = 0; i < 24; i++) {
            [hoursArray addObject:[NSString stringWithFormat:@"%d", i]];
        }
    }
    self.dateHourStr = hoursArray.firstObject;
    [self.dateElementArray replaceObjectAtIndex:3 withObject:hoursArray];
    self.hourPickView = (UIPickerView *)[self viewWithTag:50003];
    [self.hourPickView reloadAllComponents];
    [self.hourPickView selectRow:0 inComponent:0 animated:YES];
    [self scrollHourPickView:self.hourPickView withRow:0];
}

// 时
- (void)scrollHourPickView:(UIPickerView *)pickView withRow:(NSInteger)row {
    [self.minutePickView selectRow:0 inComponent:0 animated:NO];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-M-d h:m";
    NSString *dateTimeStr = [dateFormatter stringFromDate:[NSDate date]];
    NSString *dateStr = [dateTimeStr componentsSeparatedByString:@" "].firstObject;
    NSString *timeStr = [dateTimeStr componentsSeparatedByString:@" "].lastObject;
    NSArray *dataElements = [dateStr componentsSeparatedByString:@"-"];
    NSString *year = dataElements.firstObject;
    NSString *month = [NSString stringWithFormat:@"%d", [dataElements[1] intValue]];
    NSString *day = [NSString stringWithFormat:@"%d", [dataElements.lastObject intValue]];
    NSString *hour = [timeStr componentsSeparatedByString:@":"].firstObject;
    NSString *minute = [timeStr componentsSeparatedByString:@":"].lastObject;
    NSString *pickViewTime = [NSString stringWithFormat:@"%@-%d-%d %d", self.dateYearStr, [self.dateMonthStr intValue], [self.dateDayStr intValue], [self.dateHourStr intValue]];
    NSString *nowTime = [NSString stringWithFormat:@"%@-%@-%@ %@", year, month, day, hour];
    NSMutableArray *minuteArray = [NSMutableArray array];
    if ([nowTime isEqualToString:pickViewTime]) {
        for (int i = minute.intValue; i < 60; i++) {
            [minuteArray addObject:[NSString stringWithFormat:@"%d", i]];
        }
    } else {
        for (int i = 0; i < 60; i++) {
            [minuteArray addObject:[NSString stringWithFormat:@"%d", i]];
        }
    }
    self.dateMinuteStr = minuteArray.firstObject;
    [self.dateElementArray replaceObjectAtIndex:4 withObject:minuteArray];
    self.minutePickView = (UIPickerView *)[self viewWithTag:50004];
    [self.minutePickView reloadAllComponents];
    [self.minutePickView selectRow:0 inComponent:0 animated:YES];
}


#pragma mark - 点击事件
- (void)sureButtonClickAction:(UIButton *)sureBtn {
    NSString *selectTimeText = [NSString stringWithFormat:@"%@/%@/%@ %@:%@", self.dateYearStr, self.dateMonthStr, self.dateDayStr, self.dateHourStr, self.dateMinuteStr];
    self.selectTimeBlock(selectTimeText);
    [self removeFromSuperview];
}

- (void)cancelButtonClickAction:(UIButton *)cancelBtn {
    [self removeFromSuperview];
}

- (void)dismissTapAction:(UITapGestureRecognizer *)tap {
    [self removeFromSuperview];
}

- (void)selectTimeTapAction:(UITapGestureRecognizer *)tap {
    NSLog(@"选择好时间");
    self.monthPickView = [self viewWithTag:50001];
    
}

#pragma mark - 私有方法
+ (UIImage *)imageWithColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0, 0, 1.0f, 1.0f);
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 开启上下文
    CGContextRef ref = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(ref, color.CGColor);
    // 渲染上下文
    CGContextFillRect(ref, rect);
    // 从上下文中获取图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    return image;
}

/** 画虚线 */
- (CAShapeLayer *)drawDotLineWithTopDistance:(CGFloat)distance inView:(UIView *)view {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:CGRectMake(0, distance, view.frame.size.width, 1)];
    [shapeLayer setPosition:CGPointMake(view.frame.size.width / 2.0,  2 * distance)];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //设置虚线颜色
    [shapeLayer setStrokeColor:[UIColor lightGrayColor].CGColor];
    //设置虚线宽度
    [shapeLayer setLineWidth:1];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //设置虚线的线宽及间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:3], [NSNumber numberWithInt:1], nil]];
    //创建虚线绘制路径
    CGMutablePathRef path = CGPathCreateMutable();
    //设置虚线绘制路径起点
    CGPathMoveToPoint(path, NULL, 0 , 0);
    //设置虚线绘制路径终点
    CGPathAddLineToPoint(path, NULL, view.frame.size.width, 0);
    //设置虚线绘制路径
    [shapeLayer setPath:path];
    CGPathRelease(path);
    return shapeLayer;
}

/** 判断闰年 */
- (BOOL)judgeYearIsLeapyear:(NSString *)yearStr {
    NSInteger year = yearStr.integerValue;
    
    if((year % 4 == 0 && year % 100 != 0) || (year % 400 == 0))
        return YES;
    else
        return NO;
}



/**
 返回每个时间元素的数组

 @param dateNow 现在的时间
 @return 根据现在时间返回的时间元素
 */
- (NSMutableArray *)countDateTimeEachElementWithDateNow:(NSString *)dateNow {
    
    NSString *dateStr = [dateNow componentsSeparatedByString:@" "].firstObject;
    NSString *timeStr = [dateNow componentsSeparatedByString:@" "].lastObject;
    
    NSArray *dateArray = [dateStr componentsSeparatedByString:@"-"];
    NSArray *timeArray = [timeStr componentsSeparatedByString:@":"];
    
    NSMutableArray *yearAarray = [NSMutableArray array];
    NSString *year = [dateArray firstObject];
    self.dateYearStr = year;
    for (int i = 0; i < 2; i++) {
        [yearAarray addObject:[NSString stringWithFormat:@"%ld", year.integerValue + i]];
    }
    
    NSString *month = dateArray[1];
    self.dateMonthStr = month;
    NSMutableArray *monthArray = [NSMutableArray array];
    for (int i = month.intValue; i < 13; i++) {
        [monthArray addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    NSString *day = dateArray.lastObject;
    self.dateDayStr = day;
    NSArray *notLeapDaysArray = @[@"31", @"28", @"31", @"30", @"31", @"30", @"31", @"31", @"30", @"31", @"30", @"31"];
    NSArray *leapDaysArray = @[@"31", @"29", @"31", @"30", @"31", @"30", @"31", @"31", @"30", @"31", @"30", @"31"];
    NSMutableArray *chooseDaysArray = [self judgeYearIsLeapyear:year] ? [leapDaysArray mutableCopy] : [notLeapDaysArray mutableCopy];
    NSMutableArray *daysArray = [NSMutableArray array];
    for (int i = day.intValue; i < [chooseDaysArray[month.integerValue-1] integerValue] + 1; i++) {
        [daysArray addObject:[NSString stringWithFormat:@"%d", i]];

    }
    
    NSString *hour = timeArray.firstObject;
    self.dateHourStr = hour;
    NSMutableArray *hoursArray = [NSMutableArray array];
    for (int i = hour.intValue; i < 24; i++) {
        [hoursArray addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    NSString *minute = timeArray.lastObject;
    self.dateMinuteStr = minute;
    NSMutableArray *minuteArray = [NSMutableArray array];
    for (int i = minute.intValue; i < 60; i++) {
        [minuteArray addObject:[NSString stringWithFormat:@"%d", i]];
    }
    NSMutableArray *dateElementArray = [NSMutableArray array];
    [dateElementArray addObject:yearAarray];
    [dateElementArray addObject:monthArray];
    [dateElementArray addObject:daysArray];
    [dateElementArray addObject:hoursArray];
    [dateElementArray addObject:minuteArray];

    return dateElementArray;
}

@end

