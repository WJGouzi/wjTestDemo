//
//  WJChartDisplayVC.m
//  wjTestDemo
//
//  Created by gouzi on 2017/10/26.
//  Copyright © 2017年 wangjun. All rights reserved.
//

#import "WJChartDisplayVC.h"
#import "WJLineChart.h"

@interface WJChartDisplayVC ()

@end

@implementation WJChartDisplayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"曲线图";
    self.view.backgroundColor = [UIColor whiteColor];
    [self showFirstQuardrant];
}

//第一象限折线图
- (void)showFirstQuardrant{
    /*     Create object        */
    WJLineChart *lineChart = [[WJLineChart alloc] initWithFrame:CGRectMake(10, 70, SCREEN_WIDTH - 20, 300) andLineChartType:WJChartLineValueNotForEveryX];
    lineChart.xLineDataArr = @[@"一月份",@"二月份",@"三月份",@"四月份",@"五月份",@"六月份",@"七月份",@"八月份"];
    lineChart.contentInsets = UIEdgeInsetsMake(0, 25, 20, 25);
    lineChart.lineChartQuadrantType = WJLineChartQuadrantTypeFirstQuardrant;
    lineChart.valueArr = @[@[@"0",@"12",@"1",@6,@4,@9,@6,@7]];
    lineChart.showYLevelLine = YES;
    lineChart.showYLine = YES;
    lineChart.yLineDataArr = @[@5,@10,@15,@20,@25,@30];// [NSMutableArray arrayWithObjects:, nil];
    lineChart.averageValues = @[@3, @11];
    lineChart.drawPathFromXIndex = 0;
    lineChart.animationDuration = 2.0;
    lineChart.showDoubleYLevelLine = NO;
    lineChart.showValueLeadingLine = NO;
    lineChart.valueFontSize = 9.0;
    lineChart.backgroundColor = [UIColor whiteColor];
    lineChart.showPointDescription = NO;
    lineChart.showXDescVertical = YES;
    lineChart.xDescMaxWidth = 15;
    /* Line Chart colors */
    lineChart.valueLineColorArr =@[ [UIColor greenColor], [UIColor orangeColor]];
    /* Colors for every line chart*/
    lineChart.pointColorArr = @[[UIColor orangeColor],[UIColor yellowColor]];
    /* color for XY axis */
    lineChart.xAndYLineColor = [UIColor blackColor];
    /* XY axis scale color */
    lineChart.xAndYNumberColor = [UIColor darkGrayColor];
    /* Dotted line color of the coordinate point */
    lineChart.positionLineColorArr = @[[UIColor blueColor],[UIColor greenColor]];
    /*        Set whether to fill the content, the default is False         */
    lineChart.contentFill = NO;
    /*        Set whether the curve path         */
    lineChart.pathCurve = YES;
    /*        Set fill color array         */
    lineChart.contentFillColorArr = @[[UIColor colorWithRed:0 green:1 blue:0 alpha:0.468],[UIColor colorWithRed:1 green:0 blue:0 alpha:0.468]];
    [self.view addSubview:lineChart];
    /*       Start animation        */
    [lineChart showAnimation];
}


@end
