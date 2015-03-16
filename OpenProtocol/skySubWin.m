//
//  skySubWin.m
//  SkyworthSCXPJ
//
//  Created by skyworth on 13-8-9.
//  Copyright (c) 2013年 skyworth. All rights reserved.
//

#import "skySubWin.h"

#define kBoarderViewSize        -7.5f

static skyResizableAnchorPoint resizableAnchorPointNone = {0.0, 0.0, 0.0, 0.0, 0};
static skyResizableAnchorPoint resizableAnchorPointUpperLeft = {1.0, 1.0, -1.0, 1.0, 1};
static skyResizableAnchorPoint resizableAnchorPointMiddleLeft = {1.0, 0.0, 0.0, 1.0, 8};
static skyResizableAnchorPoint resizableAnchorPointLowerLeft = {1.0, 0.0, 1.0, 1.0, 7};
static skyResizableAnchorPoint resizableAnchorPointUpperMiddle = {0.0, 1.0, -1.0, 0.0, 2};
static skyResizableAnchorPoint resizableAnchorPointUpperRight = {0.0, 1.0, -1.0, -1.0, 3};
static skyResizableAnchorPoint resizableAnchorPointMiddleRight = {0.0, 0.0, 0.0, -1.0, 4};
static skyResizableAnchorPoint resizableAnchorPointLowerRight = {0.0, 0.0, 1.0, -1.0, 5};
static skyResizableAnchorPoint resizableAnchorPointLowerMiddle = {0.0, 0.0, 1.0, 0.0, 6};

// Private
@interface skySubWin()
{
    skyResizableAnchorPoint anchor;             // 拖动与缩放的定位锚点数据
    
    CGPoint touchStart;                         // 起始点击点
    CGPoint touchEnd;                           // 结束点击点
}

//////////////////////// Property //////////////////////////


//////////////////////// Methods ///////////////////////////
// 初始化组件
- (void)initialComponents;
// 初始化弹出菜单
- (void)initialPopovers;
// 拖动手势识别器函数
- (void)handlePanGestures:(UIPanGestureRecognizer *)paramSender;
// 点击手势识别器函数
- (void)handleTapGestures:(UITapGestureRecognizer *)paramSender;
// 功能扩展按钮
- (void)functionButtonHandle:(id)sender;
// 绘制背景
- (void)drawBackground:(CGContextRef)context;
// 绘制外框
- (void)drawOutline:(CGContextRef)context;
// 绘制窗口编号与信号源
- (void)drawSubWinDatas:(CGContextRef)context;
// 设置信号源与通道
- (void)setSignal:(NSInteger)nType andChannel:(NSInteger)nChannel;
// 窗口移动
- (void)moveSubWinUsingTouchLocation:(CGPoint)touchPoint;
// 窗口缩放
- (void)resizeSubWinUsingTouchLocation:(CGPoint)touchPoint;
// 确定点击时手指在那个Anchor附近
- (skyResizableAnchorPoint)anchorPointForTouchLocation:(CGPoint)touchPoint;
// 判断是移动还是缩放
- (BOOL)isResizing;
// 计算范围百分比
- (void)reCaculateCentiArea;

//////////////////////// Ends //////////////////////////////

@end

@implementation skySubWin

@synthesize winNumber = nWinNumber;
@synthesize winSourceType = nSourceType;
@synthesize winChannelNum = nChannelNum;
@synthesize limitRect = rectParent;
@synthesize delegate = _delegate;
@synthesize dataSource = _dataSource;
@synthesize panGesture = _panGesture;
@synthesize tapGesture = _tapGesture;
@synthesize boarderView = _boarderView;
@synthesize funcBtn = _funcBtn;
@synthesize popView = _popView;
@synthesize subPop = _subPop;

#pragma mark - Basic Methods
// 初始化
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 初始化组件
        [self initialComponents];
        // 初始化弹出菜单
        [self initialPopovers];
    }
    return self;
}

// 背景重绘
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 绘制背景
    [self drawBackground:context];
    // 绘制外框
    [self drawOutline:context];
    // 绘制数据
    [self drawSubWinDatas:context];
}

// 绘制背景
- (void)drawBackground:(CGContextRef)context
{
    UIGraphicsPushContext(context);
    
    // 创建色彩空间对象
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    
    // 创建起点颜色
    CGColorRef beginColor = CGColorCreate(colorSpaceRef, (CGFloat[]){5.0f/255.0f, 68.0f/255.0f, 64.0f/255.0f, 1.0f});
    
    // 创建终点颜色
    CGColorRef endColor = CGColorCreate(colorSpaceRef, (CGFloat[]){174.0f/255.0f, 192.0f/255.0f, 196.0f/255.0f, 1.0f});
    
    // 创建颜色数组
    CFArrayRef colorArray = CFArrayCreate(kCFAllocatorDefault, (const void*[]){beginColor, endColor}, 2, nil);
    
    // 创建渐变对象
    CGGradientRef gradientRef = CGGradientCreateWithColors(colorSpaceRef, colorArray, (CGFloat[]){
        0.0f,       // 对应起点颜色位置
        1.0f        // 对应终点颜色位置
    });
    
    // 释放颜色数组
    CFRelease(colorArray);
    
    // 释放起点和终点颜色
    CGColorRelease(beginColor);
    CGColorRelease(endColor);
    
    // 释放色彩空间
    CGColorSpaceRelease(colorSpaceRef);
    
    CGContextDrawLinearGradient(context, gradientRef, CGPointMake(0.0f, 0.0f), CGPointMake(self.bounds.size.width, self.bounds.size.height), 0);
    
    // 释放渐变对象
    CGGradientRelease(gradientRef);
    
    UIGraphicsPopContext();
}

// 绘制外框
- (void)drawOutline:(CGContextRef)context
{
    UIGraphicsPushContext(context);
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:1.0 green:1.0 blue:0.0 alpha:1.0].CGColor);
    
    CGContextSetLineWidth(context, 2);
    
    CGContextAddRect(context, self.bounds);
    
    CGContextStrokePath(context);
    
    UIGraphicsPopContext();
}
// 绘制窗口编号与信号源
- (void)drawSubWinDatas:(CGContextRef)context
{
    UIGraphicsPushContext(context);
    
    int minWidth = self.bounds.size.width > self.bounds.size.height ? self.bounds.size.height : self.bounds.size.width;
    
    UIFont *helveticaBold_Num = [UIFont fontWithName:@"HelveticaNeue-Bold" size:minWidth/7];
    UIFont *helveticaBold_Signal = [UIFont fontWithName:@"HelveticaNeue-Bold" size:minWidth/6];
    UIColor *textColor = [UIColor whiteColor];
    [textColor set];
    
    // 编号标签
    NSString *winNumString = [NSString stringWithFormat:@"Sub.%ld",nWinNumber];
    // 信号源标签
    NSString *signalString;
    switch (nSourceType)
    {
        case 0:// HDMI
            signalString = [NSString stringWithFormat:@"HDMI-%ld",nChannelNum];
            break;
        case 1:// DVI
            signalString = [NSString stringWithFormat:@"DVI-%ld",nChannelNum];
            break;
        case 2:// VGA
            signalString = [NSString stringWithFormat:@"VGA-%ld",nChannelNum];
            break;
        case 3:// CVBS
            signalString = [NSString stringWithFormat:@"CVBS-%ld",nChannelNum];
            break;
        case 4:// SDI
            signalString = [NSString stringWithFormat:@"SDI-%ld",nChannelNum];
            break;
    }
    
    // 绘制
    //[winNumString drawAtPoint:CGPointMake(5, 5) withFont:helveticaBold_Num];
    [winNumString drawAtPoint:CGPointMake(5, 5) withAttributes:@{NSFontAttributeName: helveticaBold_Num}];
    //[signalString drawInRect:CGRectMake(5, self.bounds.size.height - minWidth/6-5, self.bounds.size.width-10, minWidth/6) withFont:helveticaBold_Signal lineBreakMode:0 alignment:NSTextAlignmentRight];
    
    NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    textStyle.lineBreakMode = 0;
    textStyle.alignment = NSTextAlignmentRight;
    [signalString drawInRect:CGRectMake(5, self.bounds.size.height - minWidth/6-5, self.bounds.size.width-10, minWidth/6) withAttributes:@{NSFontAttributeName: helveticaBold_Signal,NSParagraphStyleAttributeName:textStyle}];
    UIGraphicsPopContext();
}

// 设置Frame
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    _boarderView.frame = CGRectInset(self.bounds, kBoarderViewSize, kBoarderViewSize);
    [_boarderView setNeedsDisplay];
}

#pragma mark - Private Methods
// 初始化组件
- (void)initialComponents
{
    // 窗口内组件
    UIImage *image = [UIImage imageNamed:@"scxWin_Btn_Normal.png"];
    _funcBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _funcBtn.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    _funcBtn.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    [self.funcBtn setBackgroundImage:[UIImage imageNamed:@"scxWin_Btn_Normal"] forState:UIControlStateNormal];
    [self.funcBtn setBackgroundImage:[UIImage imageNamed:@"scxWin_Btn_Select"] forState:UIControlStateHighlighted];
    [self.funcBtn addTarget:self action:@selector(functionButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
    _funcBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    // 安装手势识别器
    // 拖动手势
    _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestures:)];
    _panGesture.minimumNumberOfTouches = 1;
    _panGesture.maximumNumberOfTouches = 1;
    [self addGestureRecognizer:_panGesture];
    // 点击手势
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestures:)];
    _tapGesture.delegate = self;
    [self addGestureRecognizer:_tapGesture];
    
    // 带锚点外框视图
    _boarderView = [[skyWinBoarder alloc] initWithFrame:CGRectInset(self.bounds, kBoarderViewSize, kBoarderViewSize)];
    _boarderView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self addSubview:_boarderView];
    [_boarderView setHidden:YES];
 
    // 添加窗口组件
    [self addSubview:_funcBtn];
    // 允许视图自动排列子视图
    self.autoresizesSubviews = YES;
}

// 初始化弹出菜单
- (void)initialPopovers
{
    // 功能选择主菜单
    _subPop = [[skySubWinPopover alloc] initWithStyle:UITableViewStyleGrouped];
    _subPop.popDelegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_subPop];
    _popView = [[UIPopoverController alloc] initWithContentViewController:nav];
    _popView.popoverContentSize = CGSizeMake(320.0f, 450.0f);
}

// 拖动手势识别器函数
- (void)handlePanGestures:(UIPanGestureRecognizer *)paramSender
{
    CGPoint touchPoint = [paramSender locationInView:self];
    
    // 在可编辑状态
    if (![_boarderView isHidden])
    {
        // 状态判断
        switch (paramSender.state)
        {
            case UIGestureRecognizerStateBegan:             // 拖动刚开始 --- 判断是移动还是缩放
                anchor = [self anchorPointForTouchLocation:touchPoint];     // 获取拖动的方位
                touchStart = touchPoint;                    // 记录开始进入点
                if ([self isResizing])                      // 判断是移动还是缩放
                {
                    touchStart= [paramSender locationInView:self.superview];
                }
                break;
                
            case UIGestureRecognizerStateChanged:           // 拖动改变数值
                if ([self isResizing])                      // 缩放
                {
                    touchPoint = [paramSender locationInView:self.superview];
                    [self resizeSubWinUsingTouchLocation:touchPoint];
                }
                else                                        // 移动
                {
                    [self moveSubWinUsingTouchLocation:touchPoint];
                }
                break;
                
            case UIGestureRecognizerStateEnded:             // 拖动结束或被迫停止
            case UIGestureRecognizerStateFailed:
                // 重新计算范围百分比
                [self reCaculateCentiArea];
                // 结束移动后通过代理调用 进行协议发送
                [_delegate subWinMove:self];
                break;
                
            default:
                NSLog(@"Others");
                break;
        }
    }
}

// 点击手势识别器函数
- (void)handleTapGestures:(UITapGestureRecognizer *)paramSender
{
    // 点击进入编辑状态
    [_delegate subWinBeginEditing:self];
}

// 功能扩展按钮
- (void)functionButtonHandle:(id)sender
{
    [_delegate subWinBeginEditing:self];
    
    [_popView presentPopoverFromRect:_funcBtn.frame inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];    
}

// 设置信号源与通道
- (void)setSignal:(NSInteger)nType andChannel:(NSInteger)nChannel
{
    nSourceType = nType;
    nChannelNum = nChannel;
    
    [self setNeedsDisplay];
}

// 窗口移动
- (void)moveSubWinUsingTouchLocation:(CGPoint)touchPoint
{
    CGPoint newPoint = CGPointMake(self.center.x + touchPoint.x - touchStart.x, self.center.y + touchPoint.y - touchStart.y);
    
    CGFloat midPointX = CGRectGetMidX(self.bounds);
        
    if (newPoint.x > rectParent.size.width+rectParent.origin.x  - midPointX)
        newPoint.x = rectParent.size.width+rectParent.origin.x - midPointX;
    else if (newPoint.x < rectParent.origin.x + midPointX)
        newPoint.x = rectParent.origin.x + midPointX;
        
    CGFloat midPointY = CGRectGetMidY(self.bounds);
        
    if (newPoint.y > rectParent.size.height+rectParent.origin.y - midPointY)
        newPoint.y = rectParent.size.height+rectParent.origin.y - midPointY;
    else if (newPoint.y < rectParent.origin.y + midPointY)
        newPoint.y = rectParent.origin.y + midPointY;
        
    self.center = newPoint;
}

// 窗口缩放
- (void)resizeSubWinUsingTouchLocation:(CGPoint)touchPoint
{
    // 处理视图移动细节
    CGFloat deltaW = anchor.adjustW * (touchStart.x - touchPoint.x);
    CGFloat deltaX = anchor.adjustX * (-1.0 * deltaW);
    CGFloat deltaH = anchor.adjustH * (touchPoint.y - touchStart.y);
    CGFloat deltaY = anchor.adjustY * (-1.0 * deltaH);
    
    // 计算出View的四个新值
    CGFloat newX = self.frame.origin.x + deltaX;
    CGFloat newY = self.frame.origin.y + deltaY;
    CGFloat newWidth = self.frame.size.width + deltaW;
    CGFloat newHeight = self.frame.size.height + deltaH;
    
    // 限制可拉伸最小值
    if (newWidth < rectParent.size.width/8) {
        newWidth = self.frame.size.width;
        newX = self.frame.origin.x;
    }
    if (newHeight < rectParent.size.height/8) {
        newHeight = self.frame.size.height;
        newY = self.frame.origin.y;
    }
    
    // 处理视图的移动
    if (newX < self.limitRect.origin.x)
    {
        deltaW = self.frame.origin.x - self.limitRect.origin.x;
        newWidth = self.frame.size.width + deltaW;
        newX = self.limitRect.origin.x;
    }
    if (newX + newWidth > self.limitRect.origin.x + self.limitRect.size.width)
    {
        newWidth = self.limitRect.size.width + self.limitRect.origin.x - newX;
    }
    if (newY < self.limitRect.origin.y)
    {
        deltaH = self.frame.origin.y - self.limitRect.origin.y;
        newHeight = self.frame.size.height + deltaH;
        newY = self.limitRect.origin.y;
    }
    if (newY + newHeight > self.limitRect.origin.y + self.limitRect.size.height)
    {
        newHeight = self.limitRect.size.height+self.limitRect.origin.y - newY;
    }
    
    // 重新绘制视图
    self.frame = CGRectMake(newX, newY, newWidth, newHeight);
    touchStart = touchPoint;
    
    [self setNeedsDisplay];
}

// 两点之间距离
static CGFloat skyDistanceWithTwoPoints(CGPoint point1, CGPoint point2)
{
    CGFloat dx = point1.x - point2.x;
    CGFloat dy = point1.y - point2.y;
    return sqrt(dx*dx + dy*dy);
}

// 确定点击时手指在那个Anchor附近
- (skyResizableAnchorPoint)anchorPointForTouchLocation:(CGPoint)touchPoint
{
    // 制作位置与锚点对
    skyPointAndResizableAnchorPoint upperLeft = {CGPointMake(0.0, 0.0), resizableAnchorPointUpperLeft};
    skyPointAndResizableAnchorPoint upperMiddle = {CGPointMake(self.bounds.size.width/2, 0.0), resizableAnchorPointUpperMiddle};
    skyPointAndResizableAnchorPoint upperRight = {CGPointMake(self.bounds.size.width, 0.0), resizableAnchorPointUpperRight};
    skyPointAndResizableAnchorPoint middleLeft = {CGPointMake(0, self.bounds.size.height/2), resizableAnchorPointMiddleLeft};
    skyPointAndResizableAnchorPoint middleRight = {CGPointMake(self.bounds.size.width, self.bounds.size.height/2), resizableAnchorPointMiddleRight};
    skyPointAndResizableAnchorPoint lowerLeft = {CGPointMake(0, self.bounds.size.height), resizableAnchorPointLowerLeft};
    skyPointAndResizableAnchorPoint lowerMiddle = {CGPointMake(self.bounds.size.width/2, self.bounds.size.height), resizableAnchorPointLowerMiddle};
    skyPointAndResizableAnchorPoint lowerRight = {CGPointMake(self.bounds.size.width, self.bounds.size.height), resizableAnchorPointLowerRight};
    skyPointAndResizableAnchorPoint center = {CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2), resizableAnchorPointNone};
    
    // 计算点击位置与锚点最短距离点
    skyPointAndResizableAnchorPoint points[9] = {upperLeft, upperMiddle, upperRight, middleLeft, middleRight, lowerLeft, lowerMiddle, lowerRight, center};
    
    CGFloat smallestDistance = MAXFLOAT;
    skyPointAndResizableAnchorPoint closestPoint = center;
    for (int i = 0; i < 9; i++)
    {
        CGFloat distance = skyDistanceWithTwoPoints(touchPoint, points[i].point);
        if (distance < smallestDistance)
        {
            smallestDistance = distance;
            closestPoint = points[i];
        }
    }
    
    return closestPoint.anchor;
}

// 判断是移动还是缩放
- (BOOL)isResizing
{
    return (anchor.adjustX || anchor.adjustY || anchor.adjustW || anchor.adjustH);
}

// 计算范围百分比
- (void)reCaculateCentiArea
{
    rectSub = self.frame;
    
    fCentiStartX = (rectSub.origin.x - rectParent.origin.x) / rectParent.size.width;
    fCentiStartY = (rectSub.origin.y - rectParent.origin.y) / rectParent.size.height;
    fCentiWidth = rectSub.size.width / rectParent.size.width;
    fCentiHeight = rectSub.size.height / rectParent.size.height;
}

#pragma mark - Public Methods
// 窗口数据初始化
- (void)initializeSubWin:(NSInteger)nNum
{
    // 设置初值
    nWinNumber = nNum;
    
    // 获取初始值
    [_dataSource initSubWinDataSource:self];
    
    // 信号源切换界面初始化
    _subPop.signalView = [[skySignalView alloc] initWithStyle:UITableViewStylePlain];
    _subPop.signalView.dataSource = [_delegate subWinSignalDataSource];
    _subPop.signalView.signalDelegate = self;
    [_subPop.signalView initialSignalTable];
    
    // 更新窗口
    [self updateWindowUI];
}

// 更新窗口UI
- (void)updateWindowUI
{
    // 窗口范围
    rectSub = CGRectMake(rectParent.origin.x + rectParent.size.width*fCentiStartX,
                         rectParent.origin.y + rectParent.size.height*fCentiStartY,
                         rectParent.size.width*fCentiWidth,
                         rectParent.size.height*fCentiHeight);
    [self setFrame:rectSub];
    
    // 设置信号通道
    [self setSignal:nSourceType andChannel:nChannelNum];
    
    // 设置显示状态
    if (bVisible) 
        [self setHidden:NO];
    else
        [self setHidden:YES];
}

// 保存窗口值
- (void)saveSubWinToFile
{
    [_dataSource saveSubWinDataSource:self];
}

// 切换矩阵
- (void)switchSignal:(NSInteger)nType toChannel:(NSInteger)nChannel
{
    [self setSignal:nType andChannel:nChannel];
    
    // 代理调用
    [_delegate subWin:self Signal:nType SwitchTo:nChannel];
}

// 计算窗口位置
- (void)calculateSubWinFrame
{
    // 根据比例计算值
    rectSub = CGRectMake(rectParent.origin.x + rectParent.size.width*fCentiStartX,
                         rectParent.origin.y + rectParent.size.height*fCentiStartY,
                         rectParent.size.width*fCentiWidth,
                         rectParent.size.height*fCentiHeight);
    // 设置窗口范围
    [self setFrame:rectSub];
    [self setNeedsDisplay];
    
    // 代理调用
    // TODO:
}

// 添加子窗
- (void)addSubWinWithParentFrame:(CGRect)parentFrame sourceType:(NSInteger)nType andChannel:(NSInteger)nChannel
{
    // 计算范围百分比
    switch (nWinNumber)
    {
        case 1:
            [self setSubWinCentiStartX:0.0f];
            [self setSubWinCentiStartY:0.0f];
            [self setSubWinCentiWidth:0.4f];
            [self setSubWinCentiHeight:0.4f];
            break;
            
        case 2:
            [self setSubWinCentiStartX:0.6f];
            [self setSubWinCentiStartY:0.0f];
            [self setSubWinCentiWidth:0.4f];
            [self setSubWinCentiHeight:0.4f];
            break;
            
        case 3:
            [self setSubWinCentiStartX:0.0f];
            [self setSubWinCentiStartY:0.6f];
            [self setSubWinCentiWidth:0.4f];
            [self setSubWinCentiHeight:0.4f];
            break;
            
        case 4:
            [self setSubWinCentiStartX:0.6f];
            [self setSubWinCentiStartY:0.6f];
            [self setSubWinCentiWidth:0.4f];
            [self setSubWinCentiHeight:0.4f];
            break;
    }
    // 设置父窗口范围
    self.limitRect = parentFrame;
    // 设置窗口可见
    [self setSubWinVisible:YES];
    // 切换矩阵
    //[self switchSignal:nType toChannel:nChannel];
    [self setSignal:nType andChannel:nChannel];
    // 更新窗口范围
    [self calculateSubWinFrame];
    // 设置显示
    [self setHidden:NO];
    
    // 代理调用
    [_delegate subWinAdd:self];
}

// 删除子窗口
- (void)deleteSubWin
{
    // 设置显示状态为NO
    [self setSubWinVisible:NO];
    // 隐藏子窗口
    [self setHidden:YES];
    
    // 代理调用
    //[_delegate subWinDelete:self];
}

// 转换为可控制状态
- (void)changeToControllStatus
{
    [_boarderView setHidden:NO];
}

// 转换为不可控制状态
- (void)changeToUnControllStatus
{
    [_boarderView setHidden:YES];
}

// 保存子窗的情景模式状态
- (void)saveSubWinModelStatusAtIndex:(NSInteger)nIndex
{
    // 叠加窗口情景数据保存
    [_dataSource saveSubWinModelDataSource:self AtIndex:nIndex];
}

// 加载子窗情景模式
- (void)loadSubWinModelStatusAtIndex:(NSInteger)nIndex
{
    // 反序列化
    [_dataSource loadSubWinModelDataSource:self AtIndex:nIndex];
    
    // 信号源切换界面初始化
    _subPop.signalView = [[skySignalView alloc] initWithStyle:UITableViewStylePlain];
    _subPop.signalView.dataSource = [_delegate subWinSignalDataSource];
    _subPop.signalView.signalDelegate = self;
    [_subPop.signalView initialSignalTable];
    
    // 更新窗口
    [self updateWindowUI];
}

#pragma mark - Setter & Getter
// 窗口是否显示 setter & getter
- (void)setSubWinVisible:(BOOL)bShow
{
    bVisible = bShow;
}
- (BOOL)getSubWinVisible
{
    return bVisible;
}

// 窗口占父窗口范围百分比 StartX Setter & getter
- (void)setSubWinCentiStartX:(CGFloat)fValue
{
    fCentiStartX = fValue;
}
- (CGFloat)getSubWinCentiStartX
{
    return fCentiStartX;
}

// 窗口占父窗口范围百分比 StartY Setter & getter
- (void)setSubWinCentiStartY:(CGFloat)fValue
{
    fCentiStartY = fValue;
}
- (CGFloat)getSubWinCentiStartY
{
    return fCentiStartY;
}

// 窗口占父窗口范围百分比 Width Setter & getter
- (void)setSubWinCentiWidth:(CGFloat)fValue
{
    fCentiWidth = fValue;
}
- (CGFloat)getSubWinCentiWidth
{
    return fCentiWidth;
}

// 窗口占父窗口范围百分比 Height Setter & getter
- (void)setSubWinCentiHeight:(CGFloat)fValue
{
    fCentiHeight = fValue;
}
- (CGFloat)getSubWinCentiHeight
{
    return fCentiHeight;
}

#pragma mark - skySubWinPopover Delegate
// 删除子窗口
- (void)deleteSubWindow
{
    [_popView dismissPopoverAnimated:YES];

    // 设置显示状态为NO
    [self setSubWinVisible:NO];
    // 隐藏子窗口
    [self setHidden:YES];
    
    // 代理调用
    [_delegate subWinDelete:self];
}

#pragma mark - skySignalView Delegate
// 进行信号切换
- (void)haveSignal:(NSInteger)nType SwitchTo:(NSInteger)nNum
{
    [_popView dismissPopoverAnimated:YES];
    
    [self switchSignal:nType toChannel:nNum];
}

#pragma mark - UIGestureRecognizer Delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }
    return YES;
}

@end
