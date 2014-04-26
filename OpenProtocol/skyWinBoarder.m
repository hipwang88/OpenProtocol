//
//  skyWinBoarder.m
//  SkyworthSCXPJ
//
//  Created by skyworth on 13-8-15.
//  Copyright (c) 2013年 skyworth. All rights reserved.
//

#import "skyWinBoarder.h"

#define kBoarderAnchorPointSize     15.0f

@implementation skyWinBoarder

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

// 重绘
- (void)drawRect:(CGRect)rect
{
    // 绘制上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    // 绘制外框
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0 green:1.0 blue:0.2 alpha:1.0].CGColor);
    CGContextAddRect(context, CGRectInset(self.bounds, kBoarderAnchorPointSize/2, kBoarderAnchorPointSize/2));
    CGContextStrokePath(context);
    
    // 确定锚点外围矩形
    CGRect upperLeft = CGRectMake(0, 0, kBoarderAnchorPointSize, kBoarderAnchorPointSize);
    CGRect upperRight = CGRectMake(self.bounds.size.width-kBoarderAnchorPointSize, 0, kBoarderAnchorPointSize, kBoarderAnchorPointSize);
    CGRect lowerLeft = CGRectMake(0, self.bounds.size.height-kBoarderAnchorPointSize, kBoarderAnchorPointSize, kBoarderAnchorPointSize);
    CGRect lowerRight = CGRectMake(self.bounds.size.width-kBoarderAnchorPointSize, self.bounds.size.height-kBoarderAnchorPointSize, kBoarderAnchorPointSize, kBoarderAnchorPointSize);
    CGRect upperMiddle = CGRectMake((self.bounds.size.width-kBoarderAnchorPointSize)/2, 0, kBoarderAnchorPointSize, kBoarderAnchorPointSize);
    CGRect lowerMiddle = CGRectMake((self.bounds.size.width-kBoarderAnchorPointSize)/2, self.bounds.size.height-kBoarderAnchorPointSize, kBoarderAnchorPointSize, kBoarderAnchorPointSize);
    CGRect middleLeft = CGRectMake(0, (self.bounds.size.height-kBoarderAnchorPointSize)/2, kBoarderAnchorPointSize, kBoarderAnchorPointSize);
    CGRect middleRight = CGRectMake(self.bounds.size.width-kBoarderAnchorPointSize, (self.bounds.size.height-kBoarderAnchorPointSize)/2, kBoarderAnchorPointSize, kBoarderAnchorPointSize);
    
    // 定义渐变颜色
    CGFloat colors [] = {
        0.4, 0.8, 1.0, 1.0,
        0.0, 0.0, 1.0, 1.0
    };
    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, colors, NULL, 2);
    CGColorSpaceRelease(baseSpace), baseSpace = NULL;
    
    CGContextSetLineWidth(context, 1);
    CGContextSetShadow(context, CGSizeMake(0.5, 0.5), 1);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    
    // 绘制锚点图像
    CGRect allPoints[8] = { upperLeft, upperRight, lowerRight, lowerLeft, upperMiddle, lowerMiddle, middleLeft, middleRight };
    for (NSInteger i = 0; i < 8; i++) {
        CGRect currPoint = allPoints[i];
        CGContextSaveGState(context);
        CGContextAddEllipseInRect(context, currPoint);
        CGContextClip(context);
        CGPoint startPoint = CGPointMake(CGRectGetMidX(currPoint), CGRectGetMinY(currPoint));
        CGPoint endPoint = CGPointMake(CGRectGetMidX(currPoint), CGRectGetMaxY(currPoint));
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
        CGContextRestoreGState(context);
        CGContextStrokeEllipseInRect(context, CGRectInset(currPoint, 1, 1));
    }
    CGGradientRelease(gradient), gradient = NULL;
    CGContextRestoreGState(context);
}


@end
