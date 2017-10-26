//
//  WJLineChart.m
//  WJChartDemo
//
//  Created by gouzi on 16/4/10.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "WJLineChart.h"
#define kXandYSpaceForSuperView 20.0

@interface WJLineChart ()

@property (assign, nonatomic)   CGFloat  xLength;
@property (assign , nonatomic)  CGFloat  yLength;
@property (assign , nonatomic)  CGFloat  perXLen ;
@property (assign , nonatomic)  CGFloat  perYlen ;
@property (assign , nonatomic)  CGFloat  perValue ;
@property (nonatomic,strong)    NSMutableArray * drawDataArr;
@property (nonatomic,strong) CAShapeLayer *shapeLayer;
@property (assign , nonatomic) BOOL  isEndAnimation ;
@property (nonatomic,strong) NSMutableArray * layerArr;
@end

@implementation WJLineChart



/**
 *  重写初始化方法
 *
 *  @param frame         frame
 *  @param lineChartType 折线图类型
 *
 *  @return 自定义折线图
 */
-(instancetype)initWithFrame:(CGRect)frame andLineChartType:(WJLineChartType)lineChartType{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _lineType = lineChartType;
        _lineWidth = 0.5;
       
        _yLineDataArr  = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7"];
        _xLineDataArr  = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7"];
        _showXDescVertical = NO;
        _xDescriptionAngle = M_PI_2/15;
        _xDescMaxWidth = 20.0;
        _pointNumberColorArr = @[[UIColor redColor]];
        _positionLineColorArr = @[[UIColor darkGrayColor]];
        _pointColorArr = @[[UIColor orangeColor]];
        _xAndYNumberColor = [UIColor darkGrayColor];
        _valueLineColorArr = @[[UIColor redColor]];
        _layerArr = [NSMutableArray array];
        _showYLine = YES;
        _showYLevelLine = NO;
        _showValueLeadingLine = YES;
        _valueFontSize = 8.0;
        _showPointDescription = YES;
        _drawPathFromXIndex = 0;
        _showDoubleYLevelLine = NO;
        self.animationDuration = 2.0;
//        _contentFillColorArr = @[[UIColor lightGrayColor]];
        [self configChartXAndYLength];
        [self configChartOrigin];
        [self configPerXAndPerY];
    }
    return self;
    
}

/**
 *  清除图标内容
 */
-(void)clear{
    
    _valueArr = nil;
    _drawDataArr = nil;
    
    for (CALayer *layer in _layerArr) {
        
        [layer removeFromSuperlayer];
    }
    [self showAnimation];
    
}

/**
 *  获取每个X或y轴刻度间距
 */
- (void)configPerXAndPerY{
    
    switch (_lineChartQuadrantType) {
        case WJLineChartQuadrantTypeFirstQuardrant:
        {
            _perXLen = (_xLength-kXandYSpaceForSuperView)/(_xLineDataArr.count-1);
            _perYlen = (_yLength-kXandYSpaceForSuperView)/_yLineDataArr.count;
            if (_showDoubleYLevelLine) {
                _perYlen = (_yLength-kXandYSpaceForSuperView)/[_yLineDataArr[0] count];
            }
        }
            break;
        default:
            break;
    }
    
}


/**
 *  重写LineChartQuardrantType的setter方法 动态改变折线图原点
 *
 */
-(void)setLineChartQuadrantType:(WJLineChartQuadrantType)lineChartQuadrantType{
    
    _lineChartQuadrantType = lineChartQuadrantType;
    [self configChartOrigin];
    
}


/**
 *  获取X与Y轴的长度
 */
- (void)configChartXAndYLength{
    _xLength = CGRectGetWidth(self.frame)-self.contentInsets.left-self.contentInsets.right;
    _yLength = CGRectGetHeight(self.frame)-self.contentInsets.top-self.contentInsets.bottom;
}


/**
 *  重写ValueArr的setter方法 赋值时改变Y轴刻度大小
 *
 */
-(void)setValueArr:(NSArray *)valueArr{
    
    _valueArr = valueArr;
    
    [self updateYScale];
    
}


/**
 *  更新Y轴的刻度大小
 */
- (void)updateYScale{
        switch (_lineChartQuadrantType) {
        
        case WJLineChartQuadrantTypeFirstQuardrant:{
            if (_valueArr.count) {
                
                NSInteger max=0;
                
                for (NSArray *arr in _valueArr) {
                    for (NSString * numer  in arr) {
                        NSInteger i = [numer integerValue];
                        if (i>=max) {
                            max = i;
                        }
                        
                    }
                }

                if (max%5==0) {
                    max = max;
                }else
                    max = (max/5+1)*5;
                _yLineDataArr = nil;
                NSMutableArray *arr = [NSMutableArray array];
                if (max<=5) {
                    for (NSInteger i = 0; i<5; i++) {
                        
                        [arr addObject:[NSString stringWithFormat:@"%ld",(i+1)*1]];
                        
                    }
                }
                
                if (max<=10&&max>5) {
                    
                    for (NSInteger i = 0; i<5; i++) {
                        
                        [arr addObject:[NSString stringWithFormat:@"%ld",(i+1)*2]];
                    }
                    
                }else if(max>10&&max<=50){
                    
                    for (NSInteger i = 0; i<max/5+1; i++) {
                        [arr addObject:[NSString stringWithFormat:@"%ld",(i+1)*5]];
                    }
                    
                }else if(max<=100){
                    for (NSInteger i = 0; i<max/10; i++) {
                        [arr addObject:[NSString stringWithFormat:@"%ld",(i+1)*10]];
                    }
                    
                }else if(max > 100){
                    
                    NSInteger count = max / 10;
                    
                    for (NSInteger i = 0; i<10+1; i++) {
                        [arr addObject:[NSString stringWithFormat:@"%ld",(i+1)*count]];
                    }
                }
                _yLineDataArr = [arr copy];
                
                [self setNeedsDisplay];
            }
        }
            break;
        default:
            break;
    }
    
}

// 给平均值进行设置
- (void)setAverageValues:(NSArray *)averageValues {
    _averageValues = averageValues;
}

- (void)updateAverageValueUIWithContext:(CGContextRef)context {
    if (_averageValues.count>0) {
        CGFloat yPace = (_yLength - kXandYSpaceForSuperView)/[_yLineDataArr.lastObject integerValue];
        for (NSInteger i = 0; i<_averageValues.count; i++) {
            CGPoint p = P_M(self.chartOrigin.x, self.chartOrigin.y - [_averageValues[i] integerValue]*yPace);
            
            CGFloat len = [self sizeOfStringWithMaxSize:CGSizeMake(CGFLOAT_MAX, 30) textFont:self.yDescTextFontSize aimString:_yLineDataArr[i]].width;
            CGFloat hei = [self sizeOfStringWithMaxSize:CGSizeMake(CGFLOAT_MAX, 30) textFont:self.yDescTextFontSize aimString:_yLineDataArr[i]].height;
            // 在坐标轴中添加横线
            [self drawLineWithContext:context andStarPoint:p andEndPoint:P_M(self.contentInsets.left+_xLength, p.y) andIsDottedLine:NO andColor:[UIColor greenColor]];
           
            // 在Y轴上添加数据
            [self drawText:[NSString stringWithFormat:@"%@",_averageValues[i]] andContext:context atPoint:P_M(p.x-len-3, p.y-hei / 2) WithColor:[UIColor greenColor] andFontSize:self.yDescTextFontSize];
            
        }
        // 在坐标轴中添加背景颜色
        
        //创建路径并获取句柄
        CGMutablePathRef
        path = CGPathCreateMutable();
        //将矩形添加到路径中
        CGFloat rectOY = self.chartOrigin.y - [_averageValues.lastObject integerValue] *yPace;
        CGFloat width = self.contentInsets.left + _xLength - self.chartOrigin.x;
        CGFloat height = yPace * ([_averageValues.lastObject integerValue] - [_averageValues.firstObject integerValue]);
        CGRect rect = CGRectMake(self.chartOrigin.x, rectOY, width, height);
        CGPathAddRect(path,NULL,rect);
        //将路径添加到上下文
        CGContextAddPath(context,path);
        //设置矩形填充色
        [[UIColor colorWithRed:0 green:1 blue:0 alpha:0.2] setFill];
        //矩形边框颜色
        [[UIColor greenColor] setStroke];
        //边框宽度
        CGContextSetLineWidth(context,0);
        //绘制
        CGContextDrawPath(context, kCGPathFillStroke);
    }
    
}


-(void)setContentInsets:(UIEdgeInsets)contentInsets{
    [super setContentInsets:contentInsets];
    [self configChartOrigin];
}

/**
 *  构建折线图原点
 */
- (void)configChartOrigin{
    
    switch (_lineChartQuadrantType) {
        case WJLineChartQuadrantTypeFirstQuardrant:
        {
            self.chartOrigin = CGPointMake(self.contentInsets.left, self.frame.size.height-self.contentInsets.bottom);
        }
            break;
        
            
        default:
            break;
    }
    
}




/* 绘制x与y轴 */
- (void)drawXAndYLineWithContext:(CGContextRef)context{

    switch (_lineChartQuadrantType) {
        case WJLineChartQuadrantTypeFirstQuardrant:{
            
            [self drawLineWithContext:context andStarPoint:self.chartOrigin andEndPoint:P_M(self.contentInsets.left+_xLength, self.chartOrigin.y) andIsDottedLine:NO andColor:self.xAndYLineColor];
            if (_showYLine) {
                  [self drawLineWithContext:context andStarPoint:self.chartOrigin andEndPoint:P_M(self.chartOrigin.x,self.chartOrigin.y-_yLength) andIsDottedLine:NO andColor:self.xAndYLineColor];
            }
            
          
            if (_xLineDataArr.count>0) {
                CGFloat xPace = (_xLength-kXandYSpaceForSuperView)/(_xLineDataArr.count-1);
                
                for (NSInteger i = 0; i<_xLineDataArr.count;i++ ) {
                    CGPoint p = P_M(i*xPace+self.chartOrigin.x, self.chartOrigin.y);
                    if (_showXDescVertical) {
                        CGSize contentSize = [self sizeOfStringWithMaxSize:CGSizeMake(_xDescMaxWidth, CGFLOAT_MAX) textFont:self.xDescTextFontSize aimString:[NSString stringWithFormat:@"%@",_xLineDataArr[i]]];
                        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(p.x - contentSize.width / 2.0, p.y+2, contentSize.width, contentSize.height)];
                        label.text = [NSString stringWithFormat:@"%@",_xLineDataArr[i]];
                        label.font = [UIFont systemFontOfSize:self.xDescTextFontSize];
                        label.numberOfLines = 0;
                        label.transform = CGAffineTransformRotate(label.transform, _xDescriptionAngle);
                        [self addSubview:label];
            
                    } else{
                        CGFloat len = [self sizeOfStringWithMaxSize:CGSizeMake(CGFLOAT_MAX, 30) textFont:self.xDescTextFontSize aimString:_xLineDataArr[i]].width;
                        [self drawLineWithContext:context andStarPoint:p andEndPoint:P_M(p.x, p.y-3) andIsDottedLine:NO andColor:self.xAndYLineColor];
                    
                        [self drawText:[NSString stringWithFormat:@"%@",_xLineDataArr[i]] andContext:context atPoint:P_M(p.x-len/2, p.y+2) WithColor:_xAndYNumberColor andFontSize:self.xDescTextFontSize];
                    }
                }
            }
            
            if (_yLineDataArr.count>0) {
                CGFloat yPace = (_yLength - kXandYSpaceForSuperView)/(_yLineDataArr.count);
                for (NSInteger i = 0; i<_yLineDataArr.count; i++) {
                    CGPoint p = P_M(self.chartOrigin.x, self.chartOrigin.y - (i+1)*yPace);
                    
                    CGFloat len = [self sizeOfStringWithMaxSize:CGSizeMake(CGFLOAT_MAX, 30) textFont:self.yDescTextFontSize aimString:_yLineDataArr[i]].width;
                    CGFloat hei = [self sizeOfStringWithMaxSize:CGSizeMake(CGFLOAT_MAX, 30) textFont:self.yDescTextFontSize aimString:_yLineDataArr[i]].height;
                    if (_showYLevelLine) {
                        [self drawLineWithContext:context andStarPoint:p andEndPoint:P_M(self.contentInsets.left+_xLength, p.y) andIsDottedLine:YES andColor:self.xAndYLineColor];
                        
                    }else{
                        [self drawLineWithContext:context andStarPoint:p andEndPoint:P_M(p.x+3, p.y) andIsDottedLine:NO andColor:self.xAndYLineColor];
                    }
                    [self drawText:[NSString stringWithFormat:@"%@",_yLineDataArr[i]] andContext:context atPoint:P_M(p.x-len-3, p.y-hei / 2) WithColor:_xAndYNumberColor andFontSize:self.yDescTextFontSize];
                }
            }
        }
            break;
        
        default:
            break;
    }
}

/**
 *  动画展示路径
 */
-(void)showAnimation{
    [self configChartXAndYLength];
    [self configChartOrigin];
    [self configPerXAndPerY];
    [self configValueDataArray];
    [self drawAnimation];
}


- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawXAndYLineWithContext:context];
    
    if (!_isEndAnimation) {
        return;
    }
    
    if (_drawDataArr.count) {
        [self drawPositionLineWithContext:context];
    }
    
    if (_averageValues.count) {
        [self updateAverageValueUIWithContext:context];
    }
}



/**
 *  装换值数组为点数组
 */
- (void)configValueDataArray{
    _drawDataArr = [NSMutableArray array];
    
    if (_valueArr.count==0) {
        return;
    }
    
    switch (_lineChartQuadrantType) {
        case WJLineChartQuadrantTypeFirstQuardrant:{
            if (_showDoubleYLevelLine) {
                _perValue = _perYlen/[[_yLineDataArr[0] firstObject] floatValue];
            }else{
                _perValue = _perYlen/[[_yLineDataArr firstObject] floatValue];
            }
            
            for (NSArray *valueArr in _valueArr) {
                NSMutableArray *dataMArr = [NSMutableArray array];
                for (NSInteger i = _drawPathFromXIndex; i<valueArr.count; i++) {
                    
                    CGPoint p = P_M(i*_perXLen+self.chartOrigin.x,self.contentInsets.top + _yLength - [valueArr[i] floatValue]*_perValue);
                    NSValue *value = [NSValue valueWithCGPoint:p];
                    [dataMArr addObject:value];
                }
                [_drawDataArr addObject:[dataMArr copy]];
            }
            
            if (_showDoubleYLevelLine) {
                CGFloat scale = [_yLineDataArr[0][0] floatValue] / [_yLineDataArr[1][0] floatValue];
                for (NSArray *valueArr in _valueBaseRightYLineArray) {
                    NSMutableArray *dataMArr = [NSMutableArray array];
                    for (NSInteger i = _drawPathFromXIndex; i<valueArr.count; i++) {
                        CGPoint p = P_M(i*_perXLen+self.chartOrigin.x,self.contentInsets.top + _yLength - [valueArr[i] floatValue]*_perValue*scale);
                        NSValue *value = [NSValue valueWithCGPoint:p];
                        [dataMArr addObject:value];
                    }
                    [_drawDataArr addObject:[dataMArr copy]];
                }
            }
        }
            break;
        
        default:
            break;
    }
}


//执行动画
- (void)drawAnimation{
    [_shapeLayer removeFromSuperlayer];
    _shapeLayer = [CAShapeLayer layer];
    if (_drawDataArr.count==0) {
        return;
    }
    //第一、UIBezierPath绘制线段
    [self configPerXAndPerY];
 
    for (NSInteger i = 0;i<_drawDataArr.count;i++) {
        NSArray *dataArr = _drawDataArr[i];
        [self drawPathWithDataArr:dataArr andIndex:i];
    }
}


- (CGPoint)centerOfFirstPoint:(CGPoint)p1 andSecondPoint:(CGPoint)p2{
    return P_M((p1.x + p2.x) / 2.0, (p1.y + p2.y) / 2.0);
}



- (void)drawPathWithDataArr:(NSArray *)dataArr andIndex:(NSInteger )colorIndex{
    
    UIBezierPath *firstPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 0, 0)];
    UIBezierPath *secondPath = [UIBezierPath bezierPath];
    for (NSInteger i = 0; i<dataArr.count; i++) {
        NSValue *value = dataArr[i];
        CGPoint p = value.CGPointValue;
        if (_pathCurve) {
            if (i==0) {
                if (_contentFill) {
                    [secondPath moveToPoint:P_M(p.x, self.chartOrigin.y)];
                    [secondPath addLineToPoint:p];
                }
                [firstPath moveToPoint:p];
            } else{
                CGPoint nextP = [dataArr[i-1] CGPointValue];
                CGPoint control1 = P_M(p.x + (nextP.x - p.x) / 2.0, nextP.y );
                CGPoint control2 = P_M(p.x + (nextP.x - p.x) / 2.0, p.y);
                 [secondPath addCurveToPoint:p controlPoint1:control1 controlPoint2:control2];
                [firstPath addCurveToPoint:p controlPoint1:control1 controlPoint2:control2];
            }
        } else{
              if (i==0) {
                  if (_contentFill) {
                      [secondPath moveToPoint:P_M(p.x, self.chartOrigin.y)];
                      [secondPath addLineToPoint:p];
                  }
                  [firstPath moveToPoint:p];
              } else{
                   [firstPath addLineToPoint:p];
                   [secondPath moveToPoint:p];
                   [secondPath addLineToPoint:p];
            }
        }

        if (i==dataArr.count-1) {
            [secondPath addLineToPoint:P_M(p.x, self.chartOrigin.y)];
        }
    }
    
    if (_contentFill) {
        [secondPath closePath];
    }
    
    //第二、UIBezierPath和CAShapeLayer关联
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = self.bounds;
    shapeLayer.path = firstPath.CGPath;
    UIColor *color = (_valueLineColorArr.count==_drawDataArr.count?(_valueLineColorArr[colorIndex]):([UIColor orangeColor]));
    shapeLayer.strokeColor = color.CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = (_animationPathWidth<=0?2:_animationPathWidth);
    
    //第三，动画
    CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
    ani.fromValue = @0;
    ani.toValue = @1;
    ani.duration = self.animationDuration;
    ani.delegate = self;
    
    if (ani.duration > 0) {
        [shapeLayer addAnimation:ani forKey:NSStringFromSelector(@selector(strokeEnd))];
    }else{
        ani = nil;
    }
    [self.layer addSublayer:shapeLayer];
    [_layerArr addObject:shapeLayer];
    
    weakSelf(weakSelf)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(ani.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        CAShapeLayer *shaperLay = [CAShapeLayer layer];
        shaperLay.frame = weakself.bounds;
        shaperLay.path = secondPath.CGPath;
        if (weakself.contentFillColorArr.count == weakself.drawDataArr.count) {
            
            shaperLay.fillColor = [weakself.contentFillColorArr[colorIndex] CGColor];
        }else{
            shaperLay.fillColor = [UIColor clearColor].CGColor;
        }
        
        [weakself.layer addSublayer:shaperLay];
        [_layerArr addObject:shaperLay];
    });
}



/**
 *  设置点的引导虚线
 *
 *  @param context 图形面板上下文
 */
- (void)drawPositionLineWithContext:(CGContextRef)context{
    
    if (_drawDataArr.count == 0) {
        return;
    }
    
    for (NSInteger m = 0;m<_valueArr.count;m++) {
        NSArray *arr = _drawDataArr[m];
        for (NSInteger i = 0 ;i<arr.count;i++ ) {
            
            CGPoint p = [arr[i] CGPointValue];
            UIColor *positionLineColor;
            if (_positionLineColorArr.count == _valueArr.count) {
                positionLineColor = _positionLineColorArr[m];
            }else
                positionLineColor = [UIColor orangeColor];

            if (_showValueLeadingLine) {
                [self drawLineWithContext:context andStarPoint:P_M(self.chartOrigin.x, p.y) andEndPoint:p andIsDottedLine:YES andColor:positionLineColor];
                [self drawLineWithContext:context andStarPoint:P_M(p.x, self.chartOrigin.y) andEndPoint:p andIsDottedLine:YES andColor:positionLineColor];
            }
          
            if (!_showPointDescription) {
                continue;
            }
            
            if (p.y!=0) {
                UIColor *pointNumberColor = (_pointNumberColorArr.count == _valueArr.count?(_pointNumberColorArr[m]):([UIColor orangeColor]));
                switch (_lineChartQuadrantType) {
                       
                    case WJLineChartQuadrantTypeFirstQuardrant: {
                        NSString *aimStr = [NSString stringWithFormat:@"(%@,%@)",_xLineDataArr[i],_valueArr[m][i]];
                        CGSize size = [self sizeOfStringWithMaxSize:CGSizeMake(100, 25) textFont:self.valueFontSize aimString:aimStr];
                        CGFloat length = size.width;
                        
                        [self drawText:aimStr andContext:context atPoint:P_M(p.x - length / 2, p.y - size.height / 2 -10) WithColor:pointNumberColor andFontSize:self.valueFontSize];
                    }
                        break;
                        
                    default:
                        break;
                }
            }
        }
    }
     _isEndAnimation = NO;
}


-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (flag) {
        [self drawPoint];
    }
}

/**
 *  绘制值的点
 */
- (void)drawPoint{
    
    for (NSInteger m = 0;m<_drawDataArr.count;m++) {
        NSArray *arr = _drawDataArr[m];
        for (NSInteger i = 0; i<arr.count; i++) {
            NSValue *value = arr[i];
            CGPoint p = value.CGPointValue;
            UIBezierPath *pBezier = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 5, 5)];
            [pBezier moveToPoint:p];
            CAShapeLayer *pLayer = [CAShapeLayer layer];
            pLayer.frame = CGRectMake(0, 0, 5, 5);
            pLayer.position = p;
            pLayer.path = pBezier.CGPath;
            UIColor *color = _pointColorArr.count == _drawDataArr.count ? (_pointColorArr[m]) : ([UIColor orangeColor]);
            pLayer.fillColor = color.CGColor;
            CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
            ani.fromValue = @0;
            ani.toValue = @1;
            ani.duration = 1;
            [pLayer addAnimation:ani forKey:NSStringFromSelector(@selector(strokeEnd))];
            [self.layer addSublayer:pLayer];
            // 添加文本
            UILabel *label = [[UILabel alloc] init];
            label.backgroundColor = [UIColor whiteColor];
            label.layer.position = P_M(p.x + 5, p.y - 15);
            label.font = [UIFont systemFontOfSize:10.0];
            label.textColor = [UIColor blueColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = [NSString stringWithFormat:@"%.2f", [_valueArr.firstObject[i] floatValue]];
            label.layer.borderWidth = 1.f;
            label.layer.borderColor = [UIColor blueColor].CGColor;
            [label sizeToFit];
            [self.layer addSublayer:label.layer];
            [self addSubview:label];
            
            [_layerArr addObject:pLayer];
        }
        _isEndAnimation = YES;
        [self setNeedsDisplay];
    }
}


@end
