//
//  cardScrollViewController.m
//  wjTestDemo
//
//  Created by jerry on 2017/9/7.
//  Copyright © 2017年 wangjun. All rights reserved.
//

#import "WJCardScrollViewController.h"
#import "NewPagedFlowView.h"
#import "WJCarBannerView.h"

#define Width [UIScreen mainScreen].bounds.size.width

@interface WJCardScrollViewController () <NewPagedFlowViewDelegate, NewPagedFlowViewDataSource>

@property (nonatomic, strong) NSMutableArray *images;

@property (nonatomic, strong) NewPagedFlowView *pageFlowView;

@end

@implementation WJCardScrollViewController


#pragma mark - 懒加载
- (NSMutableArray *)images {
    if (!_images) {
        _images = [NSMutableArray arrayWithCapacity:0];
    }
    return _images;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"卡片式轮播图";
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray *imgArr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"imgsModel" ofType:@"plist"]];
    NSLog(@"%@", imgArr);
    
    [self.images addObjectsFromArray:imgArr];
    // UI设置
    [self setUpScrollView];
}

- (void)dealloc {
    [self.pageFlowView.timer invalidate];
}


/**
 UI搭建
 */
- (void)setUpScrollView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NewPagedFlowView *pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0, 72, Width, Width * 9 / 16)];
    pageFlowView.backgroundColor = [UIColor whiteColor];
    pageFlowView.minimumPageAlpha = 0.4;
    pageFlowView.delegate = self;
    pageFlowView.dataSource = self;
    pageFlowView.leftRightMargin = 30;
    pageFlowView.topBottomMargin = 30;
    pageFlowView.isOpenAutoScroll = YES;
    pageFlowView.pageCount = self.images.count;
    pageFlowView.autoTime = 3.0f;
    
    // UIPageControl
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, pageFlowView.frame.size.height - 24, Width, 8)];
//    [pageControl setValue:[UIImage imageNamed:@"current"] forKeyPath:@"_currentPageImage"];
//    [pageControl setValue:[UIImage imageNamed:@"other"] forKeyPath:@"_pageImage"];
    pageFlowView.pageControl = pageControl;
    [pageFlowView addSubview:pageControl];
    [pageFlowView reloadData];
    self.pageFlowView = pageFlowView;
    [self.view addSubview:pageFlowView];
}


#pragma mark - NewPagedFlowViewDataSource
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    return self.images.count;
}

- (PGIndexBannerSubiew *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index {
    WJCarBannerView *bannerView = (WJCarBannerView *)[flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[WJCarBannerView alloc] init];
        bannerView.layer.cornerRadius = 4;
        bannerView.layer.masksToBounds = YES;
    }
    bannerView.mainImageView.image = [UIImage imageNamed:self.images[index]];
    return bannerView;
}


#pragma mark - NewPagedFlowViewDelegate

- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
    return  CGSizeMake(Width - 50, (Width - 50) * 9 / 16);
}


- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
    NSLog(@"%ld", pageNumber);
}

/**
 *  点击了第几个cell
 *
 *  @param subView 点击的控件
 *  @param subIndex    点击控件的index
 *
 */
- (void)didSelectCell:(PGIndexBannerSubiew *)subView withSubViewIndex:(NSInteger)subIndex {
    NSLog(@"%ld", subIndex+1);
}



@end

