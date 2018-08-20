//
//  WJDateTimeSelectView.h
//  WJDateTimeSelect
//
//  Created by 王钧 on 2018/7/24.
//  Copyright © 2018年 王钧. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WJDateTimeSelectBlock)(NSString *selectTime);

@interface WJDateTimeSelectView : UIView

@property (nonatomic, strong) WJDateTimeSelectBlock selectTimeBlock;

@end
