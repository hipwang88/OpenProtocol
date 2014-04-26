//
//  skyUnderPaint.m
//  SkyworthSCXPJ
//
//  Created by skyworth on 13-8-9.
//  Copyright (c) 2013年 skyworth. All rights reserved.
//

#import "skyUnderPaint.h"

@interface skyUnderPaint()
{
    int nTotalUnits;                // 单元总数
    CGPoint start;                  // 起始点
}

// 绘制背景Logo
- (void)drawLogoImage:(CGContextRef)context;
// 绘制实线外框
- (void)drawFrameWithSolidLine:(CGContextRef)context;
// 绘制虚线四分线
- (void)drawQuartWithDotLine:(CGContextRef)context;
// 绘制机芯编号
- (void)drawUnitID:(CGContextRef)context;

@end

@implementation skyUnderPaint

@synthesize delegate = _delegate;
@synthesize nRows = _nRows;
@synthesize nColumns = _nColumns;
@synthesize nUnitWidth = _nUnitWidth;
@synthesize nUnitHeight = _nUnitHeight;
@synthesize nSplitWidth = _nSplitWidth;
@synthesize nSplitHeight = _nSplitHeight;


#pragma mark - Basic Methods

// 视图初始化
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 设置水印logo
        UIColor *bkColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.bmp"]];
        [self setBackgroundColor:bkColor];
    }
    return self;
}

// 视图初始化
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        // 设置水印logo 
        UIColor *bkColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.bmp"]];
        [self setBackgroundColor:bkColor];
        // 获取拼接规格后进行重绘
        [self getUnderSpecification];
    }
    return self;
}

// 绘制背景图片
- (void)drawLogoImage:(CGContextRef)context
{
    UIGraphicsPushContext(context);
    
    UIImage *image = [UIImage imageNamed:@"SMC_Logo.jpg"];
    [image drawInRect:CGRectMake(start.x, start.y, _nSplitWidth, _nSplitHeight)];
    
    UIGraphicsPopContext();
}

// 绘制实线外框
- (void)drawFrameWithSolidLine:(CGContextRef)context
{
    UIGraphicsPushContext(context);
    
    // 设置线宽
    CGContextSetLineWidth(context, 2);    
    CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
    
    // 竖线
    for (int i = 0; i <= _nColumns; i++)
    {
        CGContextMoveToPoint(context, start.x+i*2*_nUnitWidth, start.y);
        CGContextAddLineToPoint(context, start.x+i*2*_nUnitWidth, start.y+_nSplitHeight);
    }
    // 横线
    for (int i = 0; i <= _nRows; i++)
    {
        CGContextMoveToPoint(context, start.x, start.y+i*2*_nUnitHeight);
        CGContextAddLineToPoint(context, start.x+_nSplitWidth, start.y+i*2*_nUnitHeight);
    }
    
    CGContextStrokePath(context);
    
    UIGraphicsPopContext();
}

// 绘制虚线四分线
- (void)drawQuartWithDotLine:(CGContextRef)context
{
    UIGraphicsPushContext(context);
    
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor darkGrayColor].CGColor);
    CGFloat length[2] = {10.0f,10.0f};
    CGContextSetLineDash(context, 0, length, 2);
    
    // 竖线
    for (int i = 0; i < _nColumns; i++)
    {
        CGContextMoveToPoint(context, start.x+i*2*_nUnitWidth+_nUnitWidth, start.y+1);
        CGContextAddLineToPoint(context, start.x+i*2*_nUnitWidth+_nUnitWidth, start.y+_nSplitHeight);
    }
    // 横线
    for (int i = 0; i < _nRows; i++)
    {
        CGContextMoveToPoint(context, start.x+1, start.y+i*2*_nUnitHeight+_nUnitHeight);
        CGContextAddLineToPoint(context, start.x+_nSplitWidth, start.y+i*2*_nUnitHeight+_nUnitHeight);
    }
    
    CGContextStrokePath(context);
    
    UIGraphicsPopContext();
}

// 绘制机芯编号
- (void)drawUnitID:(CGContextRef)context
{
    UIGraphicsPushContext(context);
    
    int posX,posY,offsetX,offsetY;
    
    offsetX = start.x+8;
    offsetY = start.y+8;
    
    UIFont *helveticaBold = [UIFont fontWithName:@"HelveticaNeue-Bold" size:24.0f];
    UIColor *textColor = [UIColor whiteColor];
    [textColor set];
    
    for (int i = 1; i <= nTotalUnits; i++)
    {
        posX = ((i-1) % _nColumns) * _nUnitWidth * 2 + offsetX;
        posY = ((i-1) / _nColumns) * _nUnitHeight * 2 + offsetY;
        
        NSString *numberID = [NSString stringWithFormat:@"%d",i];
        
        // 绘制
        //[numberID drawAtPoint:CGPointMake(posX, posY) withFont:helveticaBold];
        [numberID drawAtPoint:CGPointMake(posX, posY) withAttributes:@{NSFontAttributeName: helveticaBold}];
    }
    
    UIGraphicsPopContext();
}

// 视图刷新绘制
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 绘制背景logo
    [self drawLogoImage:context];
    // 绘制实线外框
    [self drawFrameWithSolidLine:context];
    // 绘制虚线四分线
    [self drawQuartWithDotLine:context];
    // 绘制机芯编号
    [self drawUnitID:context];
}

// 获取规格设定
- (void)getUnderSpecification
{
    // 通过代理方式获取规格
    _nRows = [_delegate getSplitRows];
    _nColumns = [_delegate getSplitColumns];
    _nUnitWidth = [_delegate getSplitUnitWidth];
    _nUnitHeight = [_delegate getSplitUnitHeight];
    _nSplitWidth = [_delegate getScreenWidth];
    _nSplitHeight = [_delegate getScreenHeight];
    
    // 机芯单元总数
    nTotalUnits = _nRows * _nColumns;
    
    start.x = (CGFloat)((1024 - _nSplitWidth)/2);
    start.y = (CGFloat)((804 - _nSplitHeight)/2);
    
    // 获取重绘
    [self setNeedsDisplay];
}

// 获取起始点
- (CGPoint)getStartPoint
{
    return start;
}

@end
