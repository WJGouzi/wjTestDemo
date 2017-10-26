//
//  WJLineChart.h
//  WJChartDemo
//
//  Created by gouzi on 16/4/10.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJChart.h"

/**
 *  Line chart type, has been abandoned
 */
typedef  NS_ENUM(NSInteger,WJLineChartType){

    WJChartLineEveryValueForEveryX=0, /*        Default         */
    WJChartLineValueNotForEveryX
};



/**
 *  Distribution type of line graph
 */
typedef NS_ENUM(NSInteger,WJLineChartQuadrantType){
    
    WJLineChartQuadrantTypeFirstQuardrant,
};



/****************************华丽的分割线***********************************/



@interface WJLineChart :WJChart

/**
 *  X axis scale data of a broken line graph, the proposed use of NSNumber or the number of strings
 */
@property (nonatomic, strong) NSArray * xLineDataArr;


/**
 *  Y axis scale data of a broken line graph, the proposed use of NSNumber or the number of strings
 */
@property (nonatomic, strong) NSArray * yLineDataArr;



/**
 *  数组中应该包含的是平均值中的最大值和最低值两个数据。
 *  其中第一个数值应该是范围值中的最低值， 第二个数值应该是范围值中的最大值。
 */
@property (nonatomic, strong) NSArray *averageValues;


/**
 *  An array of values that are about to be drawn.
 */
@property (nonatomic, strong) NSArray * valueArr;


/**
 *  The type of broken line graph has been abandoned.
 */
@property (assign , nonatomic) WJLineChartType  lineType ;


/**
 *  The quadrant of the specified line chart
 */
@property (assign, nonatomic) WJLineChartQuadrantType  lineChartQuadrantType;


/**
 *  Line width (the value of non drawn path width, only refers to the X, Y axis scale line width)
 */
@property (assign, nonatomic) CGFloat lineWidth;


/**
 *  To draw the line color of the target
 */
@property (nonatomic, strong) NSArray * valueLineColorArr;




/**
 *  Color for each value draw point
 */
@property (nonatomic, strong) NSArray * pointColorArr;


/**
 *  Y, X axis scale numerical color
 */
@property (nonatomic, strong) UIColor * xAndYNumberColor;


/**
 *  Draw dotted line color
 */
@property (nonatomic, strong) NSArray * positionLineColorArr;



/**
 *  Draw the text color of the information.
 */
@property (nonatomic, strong) NSArray * pointNumberColorArr;



/**
 *  Value path is required to draw points
 */
@property (assign,  nonatomic) BOOL hasPoint;



/**
 *  Draw path line width
 */
@property (nonatomic, assign) CGFloat animationPathWidth;


/**
 *  Drawing path is the curve, the default NO
 */
@property (nonatomic, assign) BOOL pathCurve;





/**
 *  Whether to fill the contents of the drawing path, the default NO
 */
@property (nonatomic, assign) BOOL contentFill;




/**
 *  Draw path fill color, default is grey
 */
@property (nonatomic, strong) NSArray * contentFillColorArr;


/*!
 * whether this chart shows the pointDescription or not.Default is YES
 */
@property (nonatomic , assign)BOOL showPointDescription;

/**
 *  whether this chart shows the Y line or not.Default is YES
 */
@property (nonatomic,assign) BOOL showYLine ;


/**
 *  whether this chart shows the Y level lines or not.Default is NO
 */
@property (nonatomic,assign) BOOL showYLevelLine;

/**
 *  whether this chart shows leading lines for value point or not,default is YES
 */
@property (nonatomic,assign) BOOL showValueLeadingLine;


/**
 *  fontsize of value point.Default 8.0;
 */
@property (nonatomic,assign) CGFloat valueFontSize;

/*!
 * whether chart shows XLineDescription vertical or not。Default is NO；
 */
@property (nonatomic , assign)BOOL showXDescVertical;

/*!
 * if showXDescVertical is YES,this property will control xDescription width.Default is 20.0
 */
@property (nonatomic , assign)CGFloat xDescMaxWidth;

/*!
 * if showXDescVertical is YES,this property will control xDescription angle;
 */
@property (nonatomic , assign)CGFloat xDescriptionAngle;

/*!
 * if showDoubleYLevelLine is true ,this chart will show two y levelLine.Default is NO;
 */
@property (nonatomic , assign)BOOL showDoubleYLevelLine;

/*!
 * if showDoubleYLevelLine is true ,this chart will display others vlaues from this Array;
 */
@property (nonatomic , strong)NSArray * valueBaseRightYLineArray;

/*!
 * it will draw path start will point valueArray[drawPathFromXIndex];Default 0;Action:this property only take effect when chart type in WJLineChartQuadrantTypeFirstQuardrant and
  WJLineChartQuadrantTypeFirstAndFouthQuardrant;
 */
@property (nonatomic , assign)NSInteger drawPathFromXIndex;
/**
 *  Custom initialization method
 *
 *  @param frame         frame
 *  @param lineChartType Abandoned
 *
 */
-(instancetype)initWithFrame:(CGRect)frame
            andLineChartType:(WJLineChartType)lineChartType;




@end
