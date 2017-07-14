//
//  wjPageView.m
//  1-轮播器功能封装
//
//  Created by gouzi on 2017/3/23.
//  Copyright © 2017年 wangjun. All rights reserved.
//

#import "wjPageView.h"

@interface wjPageView () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *wjScrollView;

@property (weak, nonatomic) IBOutlet UIPageControl *wjPageControl;

/** 定时器 */
@property (nonatomic, weak) NSTimer *timer;

@end


@implementation wjPageView

+ (instancetype)pageView {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}


/**
 加载xib的时候就要进行设置的代码（只设置一次可以放在这里）
 */
- (void)awakeFromNib {
    [super awakeFromNib];
    self.wjPageControl.hidesForSinglePage = YES;
    [self.wjPageControl setValue:[UIImage imageNamed:@"current"] forKeyPath:@"_currentPageImage"];
    [self.wjPageControl setValue:[UIImage imageNamed:@"other"] forKeyPath:@"_pageImage"];
    self.wjScrollView.delegate = self;
    self.wjScrollView.bounces = NO;
//    [self startTimer];
    [self pageViewAutoResizing];
}

#pragma mark - 利用代码进来自动布局
/**
 需要关掉xib中已经设置好的autoResizing的连线
 */
-(void)pageViewAutoResizing {
    self.wjScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.wjPageControl.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
}



#pragma mark - setter方法
- (void)setImageNames:(NSArray *)imageNames {
    _imageNames = imageNames;
    
    // 根据图片名数据创建imageView添加到scrollView上
    CGFloat scrollViewW = self.wjScrollView.frame.size.width;
    CGFloat scrollViewH = self.wjScrollView.frame.size.height;
    NSInteger imageCount = imageNames.count;
    // 移除之前已经添加的imageView
    // 让subviews数组的每一个对象都执行removeFromSuperview这个方法
    [self.wjScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    for (int i = 0; i < imageCount; i++) {
        // 1.添加图片
        self.imageView = [[UIImageView alloc] init];
        self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight; // 适配尺寸
        self.imageView.image = [UIImage imageNamed:imageNames[i]];
        self.imageView.frame = CGRectMake(scrollViewW * i, 0, scrollViewW, scrollViewH);
        [self.wjScrollView addSubview:self.imageView];
    }
    self.wjScrollView.contentSize = CGSizeMake(imageCount * scrollViewW, 0);
    self.wjScrollView.pagingEnabled = YES;
    self.wjScrollView.showsHorizontalScrollIndicator = NO;
    self.wjPageControl.numberOfPages = imageCount;
    
    
}

// 重新布局子控件的尺寸
- (void)layoutSubviews {
    [super layoutSubviews];
    // 根据最新的scrollView的尺寸来计算imageView的尺寸
    CGFloat scrollViewW = self.wjScrollView.frame.size.width;
    NSInteger count = self.wjPageControl.numberOfPages;
    for (int i = 0; i < count; i++) {
        // 1.添加图片
        self.imageView = self.wjScrollView.subviews[i];
        CGRect rect = self.imageView.frame;
        rect.origin.x = i * scrollViewW;
        self.imageView.frame = rect;
    }
    // 更新contentSize
    self.wjScrollView.contentSize = CGSizeMake(count * scrollViewW, 0);
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int page = (int)(self.wjScrollView.contentOffset.x / scrollView.frame.size.width + 0.5);
    self.wjPageControl.currentPage = page;
    
}

// 暂时关掉自动轮播
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    [self startTimer];
}


#pragma mark - 定时器相关
- (void)startTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(autoNextPage:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)autoNextPage:(NSTimer *)tiemr {
    NSInteger nextPage = self.wjPageControl.currentPage + 1;
    [self.wjScrollView setContentOffset:nextPage == self.wjPageControl.numberOfPages ? CGPointMake(0, 0) : CGPointMake(nextPage * self.wjScrollView.frame.size.width, 0) animated:YES];
    self.wjPageControl.currentPage = nextPage == self.wjPageControl.numberOfPages ? 0 : nextPage;
}




@end
