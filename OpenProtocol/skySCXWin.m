//
//  skySCXWin.m
//  SkyworthSCXPJ
//
//  Created by skyworth on 13-8-9.
//  Copyright (c) 2013年 skyworth. All rights reserved.
//

#import "skySCXWin.h"

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
@interface skySCXWin()
{
    NSInteger nRows;                    // 拼接规格
    NSInteger nColumns;
    skyResizableAnchorPoint anchor;     // 锚点定位
    
    CGPoint touchStart;                 // 点击起始点
    CGPoint touchEnd;                   // 点击结束点
    BOOL isNotChange;
}

///////////////// Property ////////////////////

///////////////// Methods /////////////////////
// 变量默认初始
- (void)initDefaults;
// 窗口组件初始化
- (void)initComponents;
// 初始化弹出菜单
- (void)initPopovers;
// 功能扩展按钮
- (void)functionButtonHandle:(id)sender;
// 手势事件函数
- (void)handlePanGestures:(UIPanGestureRecognizer *)paramSender;
// 点击手势事件
- (void)handleTapGestures:(UITapGestureRecognizer *)paramSender;
// 渐进背景绘制
- (void)drawViewBackground:(CGContextRef)context;
// 绘制窗口外框
- (void)drawOutline:(CGContextRef)context;
// 信号类型与通道标签设置
- (void)setSignal:(NSInteger)nType andChannel:(NSInteger)nChannel;
// 移动视图
- (void)moveSCXWinUsingTouchLocation:(CGPoint)touchPoint;
// 缩放视图
- (void)resizeSCXWinUsingTouchLocation:(CGPoint)touchPoint;
// 确定点击时手指在那个Anchor附近
- (skyResizableAnchorPoint)anchorPointForTouchLocation:(CGPoint)touchPoint;
// 判断是移动还是缩放
- (BOOL)isResizing;
// 获取位置数据
- (NSString *)getWindowPositionStr;
// 获取大小数据
- (NSString *)getWindowSizeStr;

///////////////// Ends ////////////////////////

@end

@implementation skySCXWin

@synthesize winNumber = nWinNumber;
@synthesize winSourceType = nSignalType;
@synthesize winChannelNum = nChannelNum;
@synthesize winNumLabel = _winNumLabel;
@synthesize signalLabel = _signalLabel;
@synthesize posLabel = _posLabel;
@synthesize sizeLabel = _sizeLabel;
@synthesize funcBtn = _funcBtn;
@synthesize boarderView = _boarderView;
@synthesize popView = _popView;
@synthesize delegate = _delegate;
@synthesize dataSource = _dataSource;
@synthesize panGesture = _panGesture;
@synthesize tapGesture = _tapGesture;
@synthesize startPoint = _startPoint;
@synthesize winSize = _winSize;
@synthesize startCanvas = _startCanvas;
@synthesize scxPop = _scxPop;
@synthesize limitRect = _limitRect;


#pragma mark - Basic Methods
// 窗口初始化
- (id)initWithFrame:(CGRect)frame withRow:(NSInteger)nRow andColumn:(NSInteger)nColumn
{
    self = [super initWithFrame:frame];
    if (self)
    {
        nRows = nRow;
        nColumns = nColumn;
        
        // 变量默认初始
        [self initDefaults];
        // 组件初始化
        [self initComponents];
        // 初始化弹出菜单
        [self initPopovers];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    _boarderView.frame = CGRectInset(self.bounds, kBoarderViewSize, kBoarderViewSize);
    [_boarderView setNeedsDisplay];
}

// 自绘
- (void)drawRect:(CGRect)rect
{
    // 创建Quartz上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 绘制背景
    [self drawViewBackground:context];
    // 绘制窗口外框
    [self drawOutline:context];
}

// 绘制渐进背景
- (void)drawViewBackground:(CGContextRef)context
{
    UIGraphicsPushContext(context);
    
    // 创建色彩空间对象
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    
    // 创建起点颜色
    CGColorRef beginColor = CGColorCreate(colorSpaceRef, (CGFloat[]){17.0f/255.0f, 32.0f/255.0f, 103.0f/255.0f, 192.0f/255.0f});
    
    // 创建终点颜色
    CGColorRef endColor = CGColorCreate(colorSpaceRef, (CGFloat[]){89.0f/255.0f, 113.0f/255.0f, 227.0f/255.0f, 192.0f/255.0f});
    
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

// 绘制窗口外框
- (void)drawOutline:(CGContextRef)context
{
    UIGraphicsPushContext(context);
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0].CGColor);
    
    CGContextSetLineWidth(context, 1);
    
    CGContextAddRect(context, self.bounds);
    
    CGContextStrokePath(context);
    
    UIGraphicsPopContext();
}

#pragma mark - Seter/Geter Methods
// 移动属性 setter
- (void)setSCXWinMove:(BOOL)bMove
{
    bRemovable = bMove;
}

// 移动属性 getter
- (BOOL)getSCXWinMove
{
    return bRemovable;
}

// 缩放属性 setter
- (void)setSCXWinResize:(BOOL)bResize
{
    bScalable = bResize;
}

// 缩放属性 getter
- (BOOL)getSCXWinResize
{
    return bScalable;
}

// 大画面属性 setter
- (void)setSCXWinBigPicture:(BOOL)bBigPic
{
    bBigPicture = bBigPic;
}

// 大画面属性 getter
- (BOOL)getSCXWinBigPicture
{
    return bBigPicture;
}

// 开窗属性 setter
- (void)setSCXWinOpen:(BOOL)bOpen
{
    bOverlying = bOpen;
}

// 开窗属性 getter
- (BOOL)getSCXWinOpen
{
    return bOverlying;
}

// 设置基本单元宽度
- (void)setSCXWinBasicWinWidth:(NSInteger)nBasicWidth
{
    nBasicWinWidth = nBasicWidth;
}

// 获取基本单元宽度
- (NSInteger)getSCXWinBasicWinWidth
{
    return nBasicWinWidth;
}

// 设置基本单元高度
- (void)setSCXWinBasicWinHeight:(NSInteger)nBasicHeight
{
    nBasicWinHeight = nBasicHeight;
}

// 获取基本单元高度
- (NSInteger)getSCXWinBasicWinHeight
{
    return nBasicWinHeight;
}

// 设置当前窗口宽度
- (void)setSCXWinCurrentWinWidth:(NSInteger)nCurrentWidth
{
    nCurrentWinWidth = nCurrentWidth;
}

// 获取当前窗口宽度
- (NSInteger)getSCXWinCurrentWinWidth
{
    return nCurrentWinWidth;
}

// 设置当前窗口高度
- (void)setSCXWinCurrentWinHeight:(NSInteger)nCurrentHeight
{
    nCurrentWinHeight = nCurrentHeight;
}

// 获取当前窗口高度
- (NSInteger)getSCXWinCurrentWinHeight
{
    return nCurrentWinHeight;
}

#pragma mark - Private Methods
// 变量默认初始
- (void)initDefaults
{
    // 状态开关设置
    bRemovable = NO;
    bScalable = NO;
    bOverlying = NO;
    bBigPicture = NO;
    // 窗口属性
    nWinNumber = 0;
    nSignalType = 0;
    nChannelNum = 0;
    nBasicWinWidth = nBasicWinHeight = nCurrentWinWidth = nCurrentWinHeight = 0;
    // 窗口范围
    windowRect = CGRectZero;
    // 窗口棋盘数据
    _startPoint = CGPointZero;
    _winSize = CGSizeZero;
}

// 初始化窗口组件
- (void)initComponents
{
    CGRect bounds = self.bounds;
    
    // Labels
    // 加入窗口编码Label
    CGRect winNumRect = CGRectMake(8, 8, bounds.size.width-16, bounds.size.height/7);
    _winNumLabel = [[UILabel alloc] initWithFrame:winNumRect];
    _winNumLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:bounds.size.height/7];
    //_winNumLabel.textAlignment = UITextAlignmentLeft;
    _winNumLabel.textAlignment = NSTextAlignmentLeft;
    _winNumLabel.backgroundColor = [UIColor clearColor];
    _winNumLabel.textColor = [UIColor whiteColor];
    _winNumLabel.text = [NSString stringWithFormat:@"No.%ld",nWinNumber];
    _winNumLabel.alpha = 1.0;
    _winNumLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    // 加入信号源Label
    CGRect signalRect = CGRectMake(8, 5*bounds.size.height/6-8, bounds.size.width-16, bounds.size.height/6);
    _signalLabel = [[UILabel alloc] initWithFrame:signalRect];
    _signalLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:bounds.size.height/6];
    //_signalLabel.textAlignment = UITextAlignmentRight;
    _signalLabel.textAlignment = NSTextAlignmentRight;
    _signalLabel.backgroundColor = [UIColor clearColor];
    _signalLabel.textColor = [UIColor whiteColor];
    _signalLabel.text = [NSString stringWithFormat:@"CVBS-%ld",nWinNumber];
    _signalLabel.alpha = 1.0;
    _signalLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth ;
    // 加入窗体位置Label
    CGRect posRect = CGRectMake(5, 9*bounds.size.height/10, bounds.size.width-10, bounds.size.height/10);
    _posLabel = [[UILabel alloc] initWithFrame:posRect];
    _posLabel.font = [UIFont fontWithName:@"Helvetica" size:bounds.size.height/12];
    //_posLabel.textAlignment = UITextAlignmentLeft;
    _posLabel.textAlignment = NSTextAlignmentLeft;
    _posLabel.backgroundColor = [UIColor clearColor];
    _posLabel.textColor = [UIColor whiteColor];
    _posLabel.text = @"Pos:0,0";
    _posLabel.alpha = 1.0;
    _posLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    // 加入窗体大小Label
    CGRect sizeRect = CGRectMake(5, 8*bounds.size.height/10, bounds.size.width-10, bounds.size.height/10);
    _sizeLabel = [[UILabel alloc] initWithFrame:sizeRect];
    _sizeLabel.font = [UIFont fontWithName:@"Helvetica" size:bounds.size.height/12];
    //_sizeLabel.textAlignment = UITextAlignmentLeft;
    _sizeLabel.textAlignment = NSTextAlignmentLeft;
    _sizeLabel.backgroundColor = [UIColor clearColor];
    _sizeLabel.textColor = [UIColor whiteColor];
    _sizeLabel.text = @"Size:0,0";
    _sizeLabel.alpha = 1.0;
    _sizeLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    // Function Button
    UIImage *image = [UIImage imageNamed:@"scxWin_Btn_Normal.png"];
    _funcBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _funcBtn.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    _funcBtn.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    [self.funcBtn setBackgroundImage:[UIImage imageNamed:@"scxWin_Btn_Normal"] forState:UIControlStateNormal];
    [self.funcBtn setBackgroundImage:[UIImage imageNamed:@"scxWin_Btn_Select"] forState:UIControlStateHighlighted];
    [self.funcBtn addTarget:self action:@selector(functionButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
    _funcBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    // 带锚点外框视图
    _boarderView = [[skyWinBoarder alloc] initWithFrame:CGRectInset(self.bounds, kBoarderViewSize, kBoarderViewSize)];
    _boarderView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self addSubview:_boarderView];
    [_boarderView setHidden:YES];
    
    // 手势识别器 - 拖动
    _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestures:)];
    _panGesture.minimumNumberOfTouches = 1;
    _panGesture.maximumNumberOfTouches = 1;
    [self addGestureRecognizer:_panGesture];
    // 手势识别器 - 点击
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestures:)];
    _tapGesture.delegate = self;
    [self addGestureRecognizer:_tapGesture];
    
    // 加入视图
    [self addSubview:_winNumLabel];
    [self addSubview:_signalLabel];
    [self addSubview:_posLabel];
    [self addSubview:_sizeLabel];
    [self addSubview:_funcBtn];
    
    self.autoresizesSubviews = YES;
}

// 初始化弹出菜单组件
- (void)initPopovers
{
    // 功能选择主菜单
    _scxPop = [[skySCXWinPopover alloc] initWithStyle:UITableViewStyleGrouped];
    _scxPop.delegatePop = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_scxPop];
    _popView = [[UIPopoverController alloc] initWithContentViewController:nav];
    _popView.popoverContentSize = CGSizeMake(320.0f, 450.0f);
}

// 功能扩展按钮事件
- (void)functionButtonHandle:(id)sender
{
    [_delegate scxWinBeginEditing:self];

    [_popView presentPopoverFromRect:_funcBtn.frame inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

// 手势识别器事件函数
- (void)handlePanGestures:(UIPanGestureRecognizer *)paramSender
{
    CGPoint touchPoint = [paramSender locationInView:self];
    
    // 在可编辑状态
    if (![_boarderView isHidden])
    {
        // 判断状态
        switch (paramSender.state)
        {
            case UIGestureRecognizerStateBegan:         // 刚开始进入 -- 开始判断是移动窗口还是缩放窗口
                anchor = [self anchorPointForTouchLocation:touchPoint]; // 判断方位
                touchStart = touchPoint;                                // 记录开始点
                if ([self isResizing])
                {
                    touchStart = [paramSender locationInView:self.superview];
                }
                break;
                
            case UIGestureRecognizerStateChanged:       // 拖动中
                if ([self isResizing])  // 缩放状态
                {
                    // 大画面情况下屏蔽缩放功能
                    if (!bBigPicture)
                    {
                        touchPoint = [paramSender locationInView:self.superview];
                        [self resizeSCXWinUsingTouchLocation:touchPoint];
                    }
                }
                else                    // 移动状态
                {
                    [self moveSCXWinUsingTouchLocation:touchPoint];
                }
                break;
                
            case UIGestureRecognizerStateEnded:         // 结束拖动
            case UIGestureRecognizerStateFailed:
                // 直通满屏处理
                [self reCaculateSCXWinToFullScreen];
                // 拼接协议发送
                if (!isNotChange) 
                    [_delegate scxWinSpliceScreen:self];
                break;
                
            default:
                NSLog(@"Others");
                break;
        }
    }
}

// 手势识别器事件函数
- (void)handleTapGestures:(UITapGestureRecognizer *)paramSender
{
    [_delegate scxWinBeginEditing:self];
}

// 信号源与通道设置
- (void)setSignal:(NSInteger)nType andChannel:(NSInteger)nChannel
{
    nSignalType = nType;
    nChannelNum = nChannel;
    
    // 信号源与类型
    switch (nSignalType)
    {
        case 0:// HDMI
            _signalLabel.text = [NSString stringWithFormat:@"HDMI-%ld",nChannelNum];
            break;
        case 1:// DVI
            _signalLabel.text = [NSString stringWithFormat:@"DVI-%ld",nChannelNum];
            break;
        case 2:// VGA
            _signalLabel.text = [NSString stringWithFormat:@"VGA-%ld",nChannelNum];
            break;
        case 3:// CVBS
            _signalLabel.text = [NSString stringWithFormat:@"CVBS-%ld",nChannelNum];
            break;
        case 4:// SDI
            _signalLabel.text = [NSString stringWithFormat:@"SDI-%ld",nChannelNum];
            break;
    }
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

// 判断是否是移动
- (BOOL)isResizing
{
    return (anchor.adjustX || anchor.adjustY || anchor.adjustW || anchor.adjustH);
}

// 移动视图
- (void)moveSCXWinUsingTouchLocation:(CGPoint)touchPoint
{
    CGPoint newPoint = CGPointMake(self.center.x + touchPoint.x - touchStart.x, self.center.y + touchPoint.y - touchStart.y);
    
    // 移动限制
    if (bRemovable)
    {
        CGFloat midPointX = CGRectGetMidX(self.bounds);
        
        if (newPoint.x > _limitRect.size.width+_limitRect.origin.x  - midPointX)
            newPoint.x = _limitRect.size.width+_limitRect.origin.x - midPointX;
        else if (newPoint.x < _limitRect.origin.x + midPointX)
            newPoint.x = _limitRect.origin.x + midPointX;
        
        CGFloat midPointY = CGRectGetMidY(self.bounds);
        
        if (newPoint.y > _limitRect.size.height+_limitRect.origin.y - midPointY)
            newPoint.y = _limitRect.size.height+_limitRect.origin.y - midPointY;
        else if (newPoint.y < _limitRect.origin.y + midPointY)
            newPoint.y = _limitRect.origin.y + midPointY;
        
        self.center = newPoint;
    }
}

// 缩放视图
- (void)resizeSCXWinUsingTouchLocation:(CGPoint)touchPoint
{
    // 限制缩放
    if (bScalable)
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
        if (newWidth < 3*nBasicWinWidth/4) {
            newWidth = self.frame.size.width;
            newX = self.frame.origin.x;
        }
        if (newHeight < 3*nBasicWinHeight/4) {
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
        
        // 大画面移入状态判断
        CGRect rectFrame = CGRectMake(newX, newY, newWidth, newHeight);
        if (![_delegate isSCXWinCanReachBigPicture:rectFrame])
        {
            // 重新绘制视图
            self.frame = CGRectMake(newX, newY, newWidth, newHeight);
            touchStart = touchPoint;
        }
    }
}

// 获取位置数据
- (NSString *)getWindowPositionStr;
{
    NSInteger nRes = [_delegate scxWinGetResolution];
    NSString *strValue;
    
    switch (nRes)
    {
        case 0:
            strValue = [NSString stringWithFormat:@"Pos:%d,%d",(int)(1024*_startPoint.x),(int)(768*_startPoint.y)];
            break;
        case 1:
            strValue = [NSString stringWithFormat:@"Pos:%d,%d",(int)(1280*_startPoint.x),(int)(720*_startPoint.y)];
            break;
        case 2:
            strValue = [NSString stringWithFormat:@"Pos:%d,%d",(int)(1366*_startPoint.x),(int)(768*_startPoint.y)];
            break;
        case 3:
            strValue = [NSString stringWithFormat:@"Pos:%d,%d",(int)(1440*_startPoint.x),(int)(900*_startPoint.y)];
            break;
        case 4:
            strValue = [NSString stringWithFormat:@"Pos:%d,%d",(int)(1280*_startPoint.x),(int)(1024*_startPoint.y)];
            break;
        case 5:
            strValue = [NSString stringWithFormat:@"Pos:%d,%d",(int)(1600*_startPoint.x),(int)(1200*_startPoint.y)];
            break;
        case 6:
            strValue = [NSString stringWithFormat:@"Pos:%d,%d",(int)(1920*_startPoint.x),(int)(1080*_startPoint.y)];
            break;
        case 7:
            strValue = [NSString stringWithFormat:@"Pos:%d,%d",(int)(1920*_startPoint.x),(int)(1200*_startPoint.y)];
            break;
    }
    
    return strValue;
}

// 获取大小数据
- (NSString *)getWindowSizeStr
{
    NSInteger nRes = [_delegate scxWinGetResolution];
    NSString *strValue;
    
    switch (nRes)
    {
        case 0:
            strValue = [NSString stringWithFormat:@"Size:%d,%d",(int)(1024*_winSize.width),(int)(768*_winSize.height)];
            break;
        case 1:
            strValue = [NSString stringWithFormat:@"Size:%d,%d",(int)(1280*_winSize.width),(int)(720*_winSize.height)];
            break;
        case 2:
            strValue = [NSString stringWithFormat:@"Size:%d,%d",(int)(1366*_winSize.width),(int)(768*_winSize.height)];
            break;
        case 3:
            strValue = [NSString stringWithFormat:@"Size:%d,%d",(int)(1440*_winSize.width),(int)(900*_winSize.height)];
            break;
        case 4:
            strValue = [NSString stringWithFormat:@"Size:%d,%d",(int)(1280*_winSize.width),(int)(1024*_winSize.height)];
            break;
        case 5:
            strValue = [NSString stringWithFormat:@"Size:%d,%d",(int)(1600*_winSize.width),(int)(1200*_winSize.height)];
            break;
        case 6:
            strValue = [NSString stringWithFormat:@"Size:%d,%d",(int)(1920*_winSize.width),(int)(1080*_winSize.height)];
            break;
        case 7:
            strValue = [NSString stringWithFormat:@"Size:%d,%d",(int)(1920*_winSize.width),(int)(1200*_winSize.height)];
            break;
    }
    
    return strValue;
}

#pragma mark - Public Methods
// 窗口数据初始化
- (void)initializeSCXWin:(NSInteger)nwinNum
{
    // 设置初值
    nWinNumber = nwinNum;
    
    // 窗口初始化
    [_dataSource initSCXWinDataSource:self];
    
    // 信号源切换界面初始化
    _scxPop.signalView = [[skySignalView alloc] initWithStyle:UITableViewStylePlain];
    _scxPop.signalView.dataSource = [_delegate scxWinSignalDataSource];
    _scxPop.signalView.signalDelegate = self;
    
    // 更新窗口UI
    [self updateWindowUI];
}

- (void)updateWindowUI
{
    /********************* 标签值设置 *********************/
    // 窗口编号标签
    _winNumLabel.text = [NSString stringWithFormat:@"No.%ld",nWinNumber];
    
    // 叠加状态设定
    if (bOverlying)
    {
        [_winNumLabel setHidden:YES];
        [_posLabel setHidden:YES];
        [_sizeLabel setHidden:YES];
        [_signalLabel setTextColor:[UIColor redColor]];
    }
    else
    {
        [_winNumLabel setHidden:NO];
        [_posLabel setHidden:NO];
        [_sizeLabel setHidden:NO];
        [_signalLabel setTextColor:[UIColor whiteColor]];
    }

    // 信号源与类型
    [self setSignal:nSignalType andChannel:nChannelNum];
    
    // 设置窗口位置
    [self splitWinStartX:_startPoint.x StartY:_startPoint.y HCount:_winSize.width VCount:_winSize.height];
    
    // 更新位置与大小标题
    _posLabel.text = [self getWindowPositionStr];
    _sizeLabel.text = [self getWindowSizeStr];
}

// 矩阵切换
- (void)switchSignal:(NSInteger)nType toChannel:(NSInteger)nChannel
{
    [self setSignal:nType andChannel:nChannel];
    
    // 代理调用
    // TODO:
    [_delegate scxWin:self Signal:nType SwitchTo:nChannel];
}

// 窗口拼接大小改变
- (void)splitWinStartX:(NSInteger)startx StartY:(NSInteger)starty HCount:(NSInteger)nHcount VCount:(NSInteger)nVCount
{
    _startPoint.x = startx;
    _startPoint.y = starty;
    _winSize.width = nHcount;
    _winSize.height = nVCount;
    
    CGRect frameRect;
    frameRect.origin.x = _startCanvas.x + _startPoint.x * nBasicWinWidth;
    frameRect.origin.y = _startCanvas.y + _startPoint.y * nBasicWinHeight;
    frameRect.size.width = _winSize.width * nBasicWinWidth;
    frameRect.size.height = _winSize.height * nBasicWinHeight;
    [self setFrame:frameRect];
    
    // 判断大画面
    if ((_winSize.width == 1) && (_winSize.height == 1))
    {
        bBigPicture = NO;
    }
    else
    {
        bBigPicture = YES;
    }
    
    // 更新大画面状态数组
    [_delegate updateBigPicStatusWithStart:_startPoint andSize:_winSize withWinNum:nWinNumber];
}

// CVBS新建
- (void)newWithCVBS
{
    // 信号标签设置
    [self setSignal:3 andChannel:nWinNumber];
    
    // 设置窗口到正常状态
    [self setSCXWinToNormalStatus];

    [self splitWinStartX:(nWinNumber-1)%nColumns StartY:(nWinNumber-1)/nColumns HCount:1 VCount:1];
}

// HDMI新建
- (void)newWithHDMI
{
    // 信号标签设置
    [self setSignal:0 andChannel:nWinNumber];
    
    // 设置窗口到正常状态
    [self setSCXWinToNormalStatus];
    
    [self splitWinStartX:(nWinNumber-1)%nColumns StartY:(nWinNumber-1)/nColumns HCount:1 VCount:1];
}

// 保存窗口状态值到文件
- (void)saveSCXWinToFile
{
    [_dataSource saveSCXWinDataSource:self];
}

// 显示外框
- (void)showBoarderView
{
    [_boarderView setHidden:NO];
    
    // 状态置换
    bRemovable = NO;
    bScalable = YES;
}

// 隐藏外框
- (void)hideBoarderView
{
    [_boarderView setHidden:YES];
    
    // 状态置换
    bRemovable = NO;
    bScalable = NO;
}

// 缩放结束后让窗口满屏 --- 直通功能
- (void)reCaculateSCXWinToFullScreen
{
    int startX = 0, startY = 0, HCount = 0, VCount = 0;
    
    // 根据八个方位计算棋盘值
    switch (anchor.direction) {
        case 0: // 正中
            startX = _startPoint.x;
            startY = _startPoint.y;
            HCount = _winSize.width;
            VCount = _winSize.height;
            break;
            
        case 1: // 左上
        case 2: // 上
        case 8: // 左
            // 棋盘值计算
            startX = (int)((self.frame.origin.x-_startCanvas.x) / nBasicWinWidth);
            startY = (int)((self.frame.origin.y-_startCanvas.y) / nBasicWinHeight);
            HCount = (int)((self.frame.origin.x + self.frame.size.width - _startCanvas.x) / nBasicWinWidth + 0.9f) - startX;
            VCount = (int)((self.frame.origin.y + self.frame.size.height - _startCanvas.y) / nBasicWinHeight +0.9f) - startY;
            if (HCount == 0) HCount = 1;
            if (VCount == 0) VCount = 1;
            break;
            
        case 3: // 右上
        case 4: // 右
            startX = _startPoint.x;
            startY = (int)((self.frame.origin.y-_startCanvas.y) / nBasicWinHeight);
            HCount = (int)((self.frame.origin.x + self.frame.size.width - _startCanvas.x) / nBasicWinWidth + 0.9f) - startX;
            VCount = (self.frame.origin.y + self.frame.size.height - _startCanvas.y) / nBasicWinHeight - startY;
            break;
            
        case 5: // 右下
        case 6: // 下
            startX = _startPoint.x;
            startY = _startPoint.y;
            HCount = (int)(self.frame.size.width / nBasicWinWidth + 0.9f);
            VCount = (int)(self.frame.size.height / nBasicWinHeight + 0.9f);
            if (VCount == 0) VCount = 1;
            if (HCount == 0) HCount = 1;
            break;
            
        case 7: // 左下
            startX = (int)((self.frame.origin.x-_startCanvas.x) / nBasicWinWidth);
            startY = _startPoint.y;
            HCount = (self.frame.origin.x + self.frame.size.width - _startCanvas.x) / nBasicWinWidth - startX;
            VCount = (int)((self.frame.origin.y + self.frame.size.height - _startCanvas.y) / nBasicWinHeight + 0.9f) - startY;
            if (VCount == 0) VCount = 1;
            if (HCount == 0) HCount = 1;
            break;
    }
    
    // 判断是否改变位置或大小
    if ((startX == (int)_startPoint.x) && (startY == (int)_startPoint.y)
        && (HCount == (int)_winSize.width) && (VCount == (int)_winSize.height))
        isNotChange = YES;
    else
        isNotChange = NO;
    
    // 大画面情况下屏蔽窗口更新
    if (!bBigPicture)
    {
        // 更新窗口位置
        [self splitWinStartX:startX StartY:startY HCount:HCount VCount:VCount];
    }
    
    [self updateWindowUI];
}

// 窗口单屏状态
- (void)setSCXWinToSingleStatus
{
    CGPoint point = CGPointMake((nWinNumber-1) % nColumns, (nWinNumber-1) / nColumns);
    CGSize size = CGSizeMake(1, 1);
    
    // 设置窗口为普通模式
    [self setSCXWinToNormalStatus];
        
    // 设置单屏显示
    [self splitWinStartX:point.x StartY:point.y HCount:size.width VCount:size.height];
}

// 窗口全屏状态
- (void)setSCXWinToFullStatus
{
    CGPoint point = CGPointMake(0, 0);
    CGSize size = CGSizeMake(nColumns, nRows);
    
    // 设置窗口满屏状态
    [self splitWinStartX:point.x StartY:point.y HCount:size.width VCount:size.height];
}

// 窗口叠加状态
- (void)setSCXWinToOpenStatus
{
    bOverlying = YES;
    [_winNumLabel setHidden:YES];
    [_posLabel setHidden:YES];
    [_sizeLabel setHidden:YES];
    [_signalLabel setTextColor:[UIColor redColor]];
    
    [_scxPop.tableView reloadData];
}

// 窗口普通状态
- (void)setSCXWinToNormalStatus
{
    bOverlying = NO;
    [_winNumLabel setHidden:NO];
    [_posLabel setHidden:NO];
    [_sizeLabel setHidden:NO];
    [_signalLabel setTextColor:[UIColor whiteColor]];
    
    [_scxPop.tableView reloadData];
}

// 保存当前窗口的情景模式
- (void)saveSCXWinModelStatusAtIndex:(NSInteger)nIndex
{
    // 序列化
    [_dataSource saveSCXWinModelDataSource:self AtIndex:nIndex];
}

// 加载窗口情景模式
- (void)loadSCXWinModelStatusAtIndex:(NSInteger)nIndex
{
    // 反序列化
    [_dataSource loadSCXWinModelDataSource:self AtIndex:nIndex];
    
    // 信号源切换界面初始化
    _scxPop.signalView = [[skySignalView alloc] initWithStyle:UITableViewStylePlain];
    _scxPop.signalView.dataSource = [_delegate scxWinSignalDataSource];
    _scxPop.signalView.signalDelegate = self;
    [_scxPop.signalView initialSignalTable];
    
    // 更新窗口UI
    [self updateWindowUI];
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

#pragma mark - skySCXWinPopoverDelegate
// 返回TableView有多少个Cells
- (int)getTableViewCellNum
{
    int nResult = 0;
    
    // 开窗状态
    if (bOverlying)
        nResult = 5;
    else
        nResult = 4;
    
    return nResult;
}

// 返回Table中Cell的数据内容
- (NSMutableArray *)getTableViewCellData
{
    NSMutableArray *array;
    
    // 如果开窗状态
    if (bOverlying)
        array = [[NSMutableArray alloc] initWithObjects:NSLocalizedString(@"UnitMenu_Full", nil),
                 NSLocalizedString(@"UnitMenu_Resolve", nil),
                 NSLocalizedString(@"UnitMenu_SignalSwitch", nil),
                 NSLocalizedString(@"UnitMenu_ExitOpenwin", nil),
                 NSLocalizedString(@"UnitMenu_Add", nil),
                 nil];
    else
        array = [[NSMutableArray alloc] initWithObjects:NSLocalizedString(@"UnitMenu_Full", nil),
                 NSLocalizedString(@"UnitMenu_Resolve", nil),
                 NSLocalizedString(@"UnitMenu_SignalSwitch", nil),
                 NSLocalizedString(@"UnitMenu_OpenWin", nil),
                 nil];
    
    return array;
}

// 是否在开窗状态
- (BOOL)isOverlying
{
    return bOverlying;
}

// 全屏状态选择
- (void)fullScreen
{
    if (!bBigPicture && !bOverlying)
    {
        // 代理控制器处理全屏消息
        [_delegate scxWinFullScreen:self];
    
        [_popView dismissPopoverAnimated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SystemInfo", nil) message:NSLocalizedString(@"SystemInfo_FULL", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"SystemInfo_sure", nil) otherButtonTitles:nil, nil];
        [alert show];
    }
}

// 大画面分解
- (void)resolveScreen
{
    if (bBigPicture)
    {
        [_popView dismissPopoverAnimated:YES];

        // 代理控制器处理大画面分解消息
        [_delegate scxWinResolveScreen:self];    
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SystemInfo", nil) message:NSLocalizedString(@"SystemInfo_Resolve", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"SystemInfo_sure", nil) otherButtonTitles:nil, nil];
        [alert show];
    }
}

// 叠加开窗
- (void)enterSCXStatus
{
    [_popView dismissPopoverAnimated:YES];
    
    // 窗口进入大画面
    [self setSCXWinToOpenStatus];
    [_delegate scxWinEnterOpenStatus:self];
}

// 退出叠加开窗状态
- (void)leaveSCXStatus
{
    [_popView dismissPopoverAnimated:YES];
    
    // 窗口离开大画面
    [self setSCXWinToNormalStatus];
    [_delegate scxWinLeaveOpenStatus:self];
}

// 添加子窗口
- (void)addSubWin
{
    [_popView dismissPopoverAnimated:YES];

    // 添加子窗口
    [_delegate scxWinAddSubWindow:self];
}

#pragma mark - skySignalViewDelegate
// 进行一次矩阵切换
- (void)haveSignal:(NSInteger)nSourceType SwitchTo:(NSInteger)nNum
{
    [_popView dismissPopoverAnimated:YES];
    
    [self switchSignal:nSourceType toChannel:nNum];
}

@end
