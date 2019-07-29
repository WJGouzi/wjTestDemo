//
//  UIView+WJCornerView.m
//  wjTestDemo
//
//  Created by gouzi on 2019/7/29.
//  Copyright © 2019 wangjun. All rights reserved.
//

#import "UIView+WJCornerView.h"



@implementation UIView (WJCornerView)
+ (void)cornerViewInView:(UIView *)view cornerRadius:(CGFloat)radius cornerType:(int)type {
    UIRectCorner corners;
    switch ( type ) {
        case 0:
            corners = UIRectCornerBottomLeft;
            break;
        case 1:
            corners = UIRectCornerBottomRight;
            break;
        case 2:
            corners = UIRectCornerTopLeft;
            break;
        case 3:
            corners = UIRectCornerTopRight;
            break;
        case 4:
            corners = UIRectCornerBottomLeft | UIRectCornerBottomRight;
            break;
        case 5:
            corners = UIRectCornerTopLeft | UIRectCornerTopRight;
            break;
        case 6:
            corners = UIRectCornerBottomLeft | UIRectCornerTopLeft;
            break;
        case 7:
            corners = UIRectCornerBottomRight | UIRectCornerTopRight;
            break;
        case 8:
            corners = UIRectCornerBottomRight | UIRectCornerTopRight | UIRectCornerTopLeft;
            break;
        case 9:
            corners = UIRectCornerBottomRight | UIRectCornerTopRight | UIRectCornerBottomLeft;
            break;
        case 10:
            corners = UIRectCornerBottomLeft | UIRectCornerTopLeft | UIRectCornerTopRight;
            break;
        case 11:
            corners = UIRectCornerBottomLeft | UIRectCornerTopLeft | UIRectCornerBottomRight;
            break;
        case 12:
            corners = UIRectCornerBottomRight | UIRectCornerTopLeft;
            break;
        case 13:
            corners = UIRectCornerBottomLeft | UIRectCornerTopRight;
            break;
        case 14:
            corners = UIRectCornerAllCorners;
        default:
            corners = UIRectCornerAllCorners;
            break;
    }
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds
                                                   byRoundingCorners:corners
                                                         cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame         = view.bounds;
    maskLayer.path          = maskPath.CGPath;
    view.layer.mask         = maskLayer;
}
@end
