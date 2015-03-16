//
//  skyViewController.m
//  SkyworthSCXPJ
//
//  Created by skyworth on 13-8-6.
//  Copyright (c) 2013年 skyworth. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "skyViewController.h"
#import "skyAppDelegate.h"
#import "skyExternViewController+skyExternViewCategory.h"

// Private
@interface skyViewController ()
{
    CGPoint startCanvas;            // 视图有效区起始位置
    NSInteger     nWinWidth;
    NSInteger     nWinHeight;
    NSInteger     nRows;
    NSInteger     nColumn;
    NSMutableArray *pArrayChess;    // 大画面棋盘数据
}

// {Propertys}
// 导航栏属性
@property (strong, nonatomic) UIBarButtonItem *settingButton;                           // 设置按钮
@property (strong, nonatomic) UIBarButtonItem *modelButton;                             // 情景模式按钮
@property (strong, nonatomic) UIBarButtonItem *externButton;                            // 扩展按钮

// 应用程序委托对象
@property (weak, nonatomic) skyAppDelegate *appDelegate;

// 扩展视图状态
@property (assign, nonatomic) BOOL externVisible;

// {Methods}
// 初始化导航栏内容
- (void)initializeNavigationItem;
// 弹出视图初始化
- (void)initializePopoverViews;
// 初始化拼接主控区域
- (void)initializeSplitViews;
// 初始化扩展视图
- (void)initializeExternWin;
// 初始化数据
- (void)initializeStatus;
// 初始化协议适配器
- (void)initializeProtocolAdapter;
// 导航栏设置按钮事件
- (void)settingButtonHandle:(id)paramSender;
// 导航栏情景模式按钮事件
- (void)modelButtonHandle:(id)paramSender;
// 导航栏扩展按钮事件
- (void)externButtonHandle:(id)paramSender;
// 获取窗口左上角所在的索引
- (NSInteger)getUnitIndexFromPointLU:(CGPoint)ptLU;
// 获取窗口右下角所在的索引
- (NSInteger)getUnitIndexFromPointRB:(CGPoint)ptRB;
// 情景模式配置文件保存
- (void)saveModelToFileAtIndex:(NSInteger)nIndex;
// 重新布置界面
- (void)reloadUI;

// {Ends}

@end

@implementation skyViewController

// Sync
@synthesize settingButton = _settingButton;
@synthesize modelButton = _modelButton;
@synthesize externButton = _externButton;
@synthesize mySettingsPopover = _mySettingsPopover;
@synthesize myModelPopover = _myModelPopover;
@synthesize currentPopover = _currentPopover;
@synthesize settingNav = _settingNav;
@synthesize modelNav = _modelNav;
@synthesize settingMainView = _settingMainView;
@synthesize modelMainView = _modelMainView;
@synthesize underPaint = _underPaint;
@synthesize appDelegate = _appDelegate;
@synthesize scxWinContainer = _scxWinContainer;
@synthesize subWinContainer = _subWinContainer;
@synthesize protocolAdapter = _protocolAdapter;
@synthesize tvProtocol = _tvProtocol;               // 20140917 by wh

#pragma mark - Basic Methods

// ViewDidLoad 初始加载
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    
    // 初始化程序数据状态
    [self initializeStatus];
    // 初始化导航栏
    [self initializeNavigationItem];
    // 初始化弹出菜单
    [self initializePopoverViews];
    // 初始化拼接主控视图
    [self initializeSplitViews];
    // 初始化扩展弹出视图
    [self initializeExternWin];
    // 初始化协议适配器
    [self initializeProtocolAdapter];
}

// ViewDidUnLoad 释放函数
- (void)viewDidUnload
{
    self.settingButton = nil;
    self.modelButton = nil;
    self.externButton = nil;
    self.mySettingsPopover = nil;
    self.myModelPopover = nil;
    self.currentPopover = nil;
    self.settingNav = nil;
    self.modelNav = nil;
    self.settingMainView = nil;
    self.modelMainView = nil;
    self.underPaint = nil;
    self.appDelegate = nil;
    self.scxWinContainer = nil;
    self.subWinContainer = nil;
    [super viewDidUnload];
}

// 方向控制
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
//{
//    return (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) ||
//        (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
//}

#pragma mark - Private Methods
// {Private}
// 初始化导航栏内容
- (void)initializeNavigationItem
{
    // 导航栏左侧两个按钮加入
    self.settingButton = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:/*UITabBarSystemItemContacts*/UIBarButtonItemStyleBordered target:self action:@selector(settingButtonHandle:)];
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:self.settingButton, nil]];
    
    // 导航栏右侧两个按钮加入
    self.modelButton = [[UIBarButtonItem alloc] initWithTitle:@"情景模式" style:/*UITabBarSystemItemContacts*/UIBarButtonItemStyleBordered target:self action:@selector(modelButtonHandle:)];
    self.externButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"toolbarDrawMode.png"] style:UIBarButtonItemStylePlain target:self action:@selector(externButtonHandle:)];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:self.externButton,self.modelButton, nil]];
    
    // 标题设置
    //self.title = @"创维群欣混合高清智能拼接控制系统";
    //self.title = @"创维基于IOS系统大屏幕拼接显示主机控制软件";
    self.title = @"创维群欣数字智能拼接控制系统";                 // 20140915 by wh 修改程序标题名称
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.0f/255.0f green:143.0f/255.0f blue:88.0f/255.0f alpha:1];
}

// 弹出视图初始化
- (void)initializePopoverViews
{
    // 控制器设置弹出式菜单
    self.settingMainView = [[skySettingMainView alloc] initWithStyle:UITableViewStyleGrouped];
    self.settingNav = [[UINavigationController alloc] initWithRootViewController:self.settingMainView];
    self.settingNav.interactivePopGestureRecognizer.enabled = NO;
    self.mySettingsPopover = [[UIPopoverController alloc] initWithContentViewController:self.settingNav];
    self.mySettingsPopover.popoverContentSize = CGSizeMake(320.0f, 700.0f);
    // add skySettingConnection
    skySettingConnection *myConnection = [[skySettingConnection alloc] initWithNibName:@"skySettingConnection" bundle:nil];
    myConnection.title = @"通讯连接设置";
    myConnection.rowImage = [UIImage imageNamed:@"ConnSet.png"];
    myConnection.setDelegate = self;
    myConnection.setDataSource = _appDelegate.theApp;
    [_settingMainView.controllers addObject:myConnection];
    // add skySettingController
    skySettingController *myController = [[skySettingController alloc] initWithNibName:@"skySettingController" bundle:nil];
    myController.title = @"控制器规格";
    myController.rowImage = [UIImage imageNamed:@"SCXSet.png"];
    myController.myDelegate = self;
    myController.myDataSource = _appDelegate.theApp;
    [_settingMainView.controllers addObject:myController];
    // add skySettingSignal
    skySettingSignal *mySignal = [[skySettingSignal alloc] initWithNibName:@"skySettingSignal" bundle:nil];
    mySignal.title = @"信号源管理";
    mySignal.rowImage = [UIImage imageNamed:@"SignalSet.png"];
    mySignal.myDataSource = _appDelegate.theApp;
    [_settingMainView.controllers addObject:mySignal];
    // add skySettingSDKs
    skySettingSDKs *mySDKs = [[skySettingSDKs alloc] initWithNibName:@"skySettingSDKs" bundle:nil];
    mySDKs.title = @"控制器协议";
    mySDKs.rowImage = [UIImage imageNamed:@"ProtocalSet.png"];
    mySDKs.sdkDelegate = self;
    [_settingMainView.controllers addObject:mySDKs];
    // add skyTVSettings 20140917 by wh
    skyTVSettingController *myTVController = [[skyTVSettingController alloc] initWithNibName:@"skyTVSettingController" bundle:nil];
    myTVController.title = @"屏幕开关机控制";
    myTVController.rowImage = [UIImage imageNamed:@"monitor.png"];
    myTVController.tvDelegate = self;
    myTVController.tvDataSource = _appDelegate.theApp;
    [_settingMainView.controllers addObject:myTVController];
    
    // 情景模式弹出式菜单
    self.modelMainView = [[skyModelView alloc] initWithStyle:UITableViewStylePlain];
    self.modelMainView.modelDelegate = self;
    self.modelMainView.modelDataSource = _appDelegate.theApp;
    self.modelNav = [[UINavigationController alloc] initWithRootViewController:self.modelMainView];
    self.myModelPopover = [[UIPopoverController alloc] initWithContentViewController:self.modelNav];
    self.myModelPopover.popoverContentSize = CGSizeMake(320.0f, 700.0f);
    
    // 设置当前使用的弹出菜单
    self.currentPopover = self.myModelPopover;
}

// 初始化拼接主控区域
- (void)initializeSplitViews
{
    /************************** 底图 ****************************/
    // 主控视图 —— 底图
    self.underPaint = [[skyUnderPaint alloc] initWithFrame:self.view.frame];
    self.underPaint.delegate = self;            // 指定代理
    [self.view addSubview:self.underPaint];     
    [self.underPaint getUnderSpecification];
    startCanvas = [_underPaint getStartPoint];  // 获取起始点位置
    
    /************************** 拼接窗口 *************************/
    // 漫游窗口
    _scxWinContainer = [[NSMutableArray alloc] init];
    CGRect scxWinRect;
    CGRect limitRect = CGRectMake(startCanvas.x, startCanvas.y, nColumn*nWinWidth, nRows*nWinHeight);
    NSInteger count = nRows * nColumn;
    for (int i = 0; i < count; i++)
    {
        // 计算大小位置
        int x = i % nColumn;
        int y = i / nColumn;
        scxWinRect = CGRectMake(startCanvas.x+x*nWinWidth, startCanvas.y+y*nWinHeight, nWinWidth, nWinHeight);
        
        // 初始化漫游窗口
        skySCXWin *scxWin = [[skySCXWin alloc] initWithFrame:scxWinRect withRow:nRows andColumn:nColumn];
        scxWin.delegate = self;
        scxWin.dataSource = _appDelegate.theApp;
        scxWin.startCanvas = startCanvas;           // 窗口活动区域起始点
        scxWin.limitRect = limitRect;               // 窗口活动区域矩形
        // 窗口值初始
        [scxWin initializeSCXWin:i+1];
        [scxWin hideBoarderView];
        
        // 将漫游窗口加入容器数组
        [self.scxWinContainer addObject:scxWin];
        [self.view addSubview:scxWin];
    }
    currentSCXWin = [_scxWinContainer objectAtIndex:0];
    
    // 大画面置顶显示
    for (skySCXWin *scxWin in _scxWinContainer)
    {
        if ([scxWin getSCXWinBigPicture])
            [self.view bringSubviewToFront:scxWin];
    }
    
    /************************ 叠加子窗 *****************************/
    // 叠加子窗
    _subWinContainer = [[NSMutableArray alloc] init];
    CGRect subWinRect = CGRectMake(0, 0, 0, 0);
    for (int i = 0; i < 4; i++)
    {
        // 初始化漫游窗口
        skySubWin *subWin = [[skySubWin alloc] initWithFrame:subWinRect];
        subWin.delegate = self;
        subWin.dataSource = _appDelegate.theApp;
        // 窗口值初始
        [subWin initializeSubWin:i+1];
        
        // 将叠加窗口加入容器数组
        [self.subWinContainer addObject:subWin];
        [self.view addSubview:subWin];
        
        // 所有子窗置顶显示
        [self.view bringSubviewToFront:subWin];
    }
    currentSubWin = [_subWinContainer objectAtIndex:0];
}

// 初始化扩展视图
- (void)initializeExternWin
{
    self.externWin = [[skyExternWin alloc] init];
    _externWin.delegate = self;
}

// 初始化程序状态
- (void)initializeStatus
{
    NSInteger total;
    self.externVisible = NO;
    nWinWidth = _appDelegate.theApp.appUnitWidth * 2;
    nWinHeight = _appDelegate.theApp.appUnitHeight * 2;
    nRows = _appDelegate.theApp.appRows;
    nColumn = _appDelegate.theApp.appColumns;
    
    total = nRows *nColumn;
    pArrayChess = [[NSMutableArray alloc] initWithCapacity:total];
    for (int i = 0; i < total; i++)
        [pArrayChess insertObject:[NSNumber numberWithInt:i+1] atIndex:i];
}

// 初始化协议适配器
- (void)initializeProtocolAdapter
{
    // 控制器协议适配器初始
    _protocolAdapter = [[skyProtocolAdapter alloc] init];
    _protocolAdapter.delegate = _appDelegate.theApp;
    [_protocolAdapter initialAdapter];
    // 20140918 by wh 机芯协议适配器初始
    _tvProtocol = [[skyTVProtocol alloc] initTVProtocol];
}

// 导航栏设置按钮事件
- (void)settingButtonHandle:(id)paramSender
{
    BOOL bFlag = [self.mySettingsPopover isPopoverVisible];
    // 判断是否在显示
    if (bFlag)
    {
        [self.mySettingsPopover dismissPopoverAnimated:YES];
    }
    else
    {
        [self.currentPopover dismissPopoverAnimated:YES];
        [self.mySettingsPopover presentPopoverFromBarButtonItem:self.settingButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        self.currentPopover = self.mySettingsPopover;
    }
}

// 导航栏情景模式按钮事件
- (void)modelButtonHandle:(id)paramSender
{
    BOOL bFlag = [self.myModelPopover isPopoverVisible];
    // 判断是否在显示
    if (bFlag)
    {
        [self.myModelPopover dismissPopoverAnimated:YES];
    }
    else
    {
        [self.currentPopover dismissPopoverAnimated:YES];
        [self.myModelPopover presentPopoverFromBarButtonItem:self.modelButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        self.currentPopover = self.myModelPopover;
    }
}

// 导航栏扩展按钮事件
- (void)externButtonHandle:(id)paramSender
{
    [self.currentPopover dismissPopoverAnimated:YES];
    
    if (!self.externVisible)
    {
        self.topExternViewController = _externWin;
        [self.externButton setStyle:UIBarButtonItemStylePlain];                             // 设置按下状态
        [self.externButton setImage:[UIImage imageNamed:@"toolbarDrawModeHide.png"]];       // 设置背景图片
        self.externVisible = YES;
    }
    else
    {
        [self.externWin hideExternWin];
        [self.externButton setStyle:UIBarButtonItemStylePlain];                             // 设置普通状态
        [self.externButton setImage:[UIImage imageNamed:@"toolbarDrawMode.png"]];           // 设置背景图片
        self.externVisible = NO;
    }
}

// 获取窗口左上角所在的索引
- (NSInteger)getUnitIndexFromPointLU:(CGPoint)ptLU
{
    NSInteger x,y,nIndex;
    
    x = (ptLU.x - startCanvas.x) / nWinWidth;
    y = (ptLU.y - startCanvas.y) / nWinHeight;
    
    nIndex = y * nColumn + x;
    
    return nIndex;
}

// 获取窗口右下角所在的索引
- (NSInteger)getUnitIndexFromPointRB:(CGPoint)ptRB
{
    NSInteger x,y,m,nIndex;
    
    m = (ptRB.x - startCanvas.x) / nWinWidth;
    x = (int)(ptRB.x - startCanvas.x) % nWinWidth ? m : m - 1;
    m = (ptRB.y - startCanvas.y) / nWinHeight;
    y = (int)(ptRB.y - startCanvas.y) % nWinHeight ? m : m - 1;
    
    nIndex = y * nColumn + x;
    
    return nIndex;
}

// 情景模式配置文件保存
- (void)saveModelToFileAtIndex:(NSInteger)nIndex
{
    // 保存窗口配置数据
    for (skySCXWin *scxWin in _scxWinContainer)
    {
        [scxWin saveSCXWinModelStatusAtIndex:nIndex];
    }
    // 保存叠加窗口配置数据
    for (skySubWin *subWin in _subWinContainer)
    {
        [subWin saveSubWinModelStatusAtIndex:nIndex];
    }
}

// 重新布置界面
- (void)reloadUI
{
    /****************** 初始状态重置 ********************/
    [_appDelegate.theApp calculateScreenSize];
    
    NSInteger total;
    self.externVisible = NO;
    nWinWidth = _appDelegate.theApp.appUnitWidth * 2;
    nWinHeight = _appDelegate.theApp.appUnitHeight * 2;
    nRows = _appDelegate.theApp.appRows;
    nColumn = _appDelegate.theApp.appColumns;
    
    total = nRows *nColumn;
    [pArrayChess removeAllObjects];
    pArrayChess = [[NSMutableArray alloc] initWithCapacity:total];
    for (int i = 0; i < total; i++)
        [pArrayChess insertObject:[NSNumber numberWithInt:i+1] atIndex:i];
    
    // 删除存在的数据
    [_appDelegate.theApp deleteSCXWindowData];
    [_appDelegate.theApp deleteAllModelData];
    
    /****************** 移除界面上元素 *******************/
    // 移除底图
    [_underPaint removeFromSuperview];
    // 移除普通窗口
    for (skySCXWin *scxWin in _scxWinContainer)
        [scxWin removeFromSuperview];
    [_scxWinContainer removeAllObjects];            // 移除容器内数据
    // 移除漫游窗口
    for (skySubWin *subWin in _subWinContainer)
        [subWin removeFromSuperview];
    [_subWinContainer removeAllObjects];            // 移除容器内数据
    
    /****************** 配置底图 ************************/
    self.underPaint = [[skyUnderPaint alloc] initWithFrame:self.view.frame];
    self.underPaint.delegate = self;                // 指定代理
    [self.view addSubview:self.underPaint];
    [self.underPaint getUnderSpecification];
    startCanvas = [_underPaint getStartPoint];      // 获取起始点位置

    /****************** 配置普通窗口 *********************/
    // 漫游窗口
    CGRect scxWinRect;
    CGRect limitRect = CGRectMake(startCanvas.x, startCanvas.y, nColumn*nWinWidth, nRows*nWinHeight);
    NSInteger count = nRows * nColumn;
    for (int i = 0; i < count; i++)
    {
        // 计算大小位置
        int x = i % nColumn;
        int y = i / nColumn;
        scxWinRect = CGRectMake(startCanvas.x+x*nWinWidth, startCanvas.y+y*nWinHeight, nWinWidth, nWinHeight);
        
        // 初始化漫游窗口
        skySCXWin *scxWin = [[skySCXWin alloc] initWithFrame:scxWinRect withRow:nRows andColumn:nColumn];
        scxWin.delegate = self;
        scxWin.dataSource = _appDelegate.theApp;
        scxWin.startCanvas = startCanvas;
        scxWin.limitRect = limitRect;
        // 窗口值初始
        [scxWin initializeSCXWin:i+1];
        [scxWin hideBoarderView];
        
        // 将漫游窗口加入容器数组
        [self.scxWinContainer addObject:scxWin];
        [self.view addSubview:scxWin];
    }
    currentSCXWin = [_scxWinContainer objectAtIndex:0];
    
    // 大画面置顶显示
    for (skySCXWin *scxWin in _scxWinContainer)
    {
        if ([scxWin getSCXWinBigPicture])
            [self.view bringSubviewToFront:scxWin];
    }

    /****************** 配置叠加子窗 ******************/
    // 叠加子窗
    CGRect subWinRect = CGRectMake(0, 0, 0, 0);
    for (int i = 0; i < 4; i++)
    {
        // 初始化漫游窗口
        skySubWin *subWin = [[skySubWin alloc] initWithFrame:subWinRect];
        subWin.delegate = self;
        subWin.dataSource = _appDelegate.theApp;
        // 窗口值初始
        [subWin initializeSubWin:i+1];
        
        // 将叠加窗口加入容器数组
        [self.subWinContainer addObject:subWin];
        [self.view addSubview:subWin];
        
        // 所有子窗置顶显示
        [self.view bringSubviewToFront:subWin];
    }
    currentSubWin = [_subWinContainer objectAtIndex:0];

}

#pragma mark - Public Methods
// 控制器状态保存
- (void)appStatusSave
{
    // 掉电记忆
    if (_appDelegate.theApp.appPowerSave)
    {
        // 保存窗口值到文件
        for (skySCXWin *scxWin in _scxWinContainer)
        {
            [scxWin saveSCXWinToFile];
        }
        // 保存叠加窗口值到文件
        for (skySubWin *subWin in _subWinContainer)
        {
            [subWin saveSubWinToFile];
        }

    }
    else    // 没有掉电记忆功能删除窗口数据
    {
        [_appDelegate.theApp deleteSCXWindowData];
    }
    
    // 情景模式状态保存
    [_modelMainView saveModelStatusToFile];
}

#pragma mark - skyUnderPaint Delegate
// 获取拼接行数
- (NSInteger)getSplitRows
{
    return [_appDelegate.theApp appRows];
}

// 获取拼接列数
- (NSInteger)getSplitColumns
{
    return [_appDelegate.theApp appColumns];
}

// 获取机芯单元宽度
- (NSInteger)getSplitUnitWidth
{
    return [_appDelegate.theApp appUnitWidth];
}

// 获取机芯单元高度
- (NSInteger)getSplitUnitHeight
{
    return [_appDelegate.theApp appUnitHeight];
}

// 获取主控区域宽度
- (NSInteger)getScreenWidth
{
    return [_appDelegate.theApp appScreenWidth];
}

// 获取主控区域高度
- (NSInteger)getScreenHeight
{
    return [_appDelegate.theApp appScreenHeight];
}

#pragma mark - skyExternWinDelegate
// 模拟信号新建
- (void)newSignalWithCVBS
{
    // 快速枚举容器
    for (skySCXWin *scxWin in _scxWinContainer)
    {
        [scxWin newWithCVBS];
        [scxWin updateWindowUI];
    }
    
    // 子窗口关闭
    for (skySubWin *subWin in _subWinContainer)
    {
        // 如果存在开窗
        if (subWin.getSubWinVisible)
        {
            // 删除子窗口
            [subWin deleteSubWin];
        }
    }
    
    // 协议发送
    // TODO:
    [_protocolAdapter adapterModelNewWithCVBS];
}

// 高清数字信号新建
- (void)newSignalWithHDMI
{
    // 快速枚举容器
    for (skySCXWin *scxWin in _scxWinContainer)
    {
        [scxWin newWithHDMI];
        [scxWin updateWindowUI];
    }
    
    // 子窗口关闭
    for (skySubWin *subWin in _subWinContainer)
    {
        // 如果存在开窗
        if (subWin.getSubWinVisible)
        {
            // 删除子窗口
            [subWin deleteSubWin];
        }
    }
    
    // 协议发送
    // TODO:
    [_protocolAdapter adapterModelNewWithHDMI];
}

#pragma mark - skySCXWinDelegate
// 开始进行缩放或者移动
- (void)scxWinBeginEditing:(id)sender
{
    skySCXWin *scxWin = (skySCXWin *)sender;
    
    [currentSCXWin hideBoarderView];                // 将前一个窗口的外框隐藏
    [currentSCXWin reCaculateSCXWinToFullScreen];   // 前一个窗口满屏处理
    currentSCXWin = scxWin;                         // 更新当前窗口
    [currentSCXWin showBoarderView];                // 将当前窗口外框显示
    [self.view bringSubviewToFront:currentSCXWin];
    
    //  将所有子窗置顶
    for (skySubWin *subWin in _subWinContainer)
    {
        [self.view bringSubviewToFront:subWin];
    }
    
    // 隐藏叠加子窗外框
    [currentSubWin changeToUnControllStatus];
}

// 更新大画面状态数组
- (void)updateBigPicStatusWithStart:(CGPoint)ptStart andSize:(CGSize)szArea withWinNum:(NSInteger)nNum
{
    NSInteger nIndex,nStart;
    
    for (int i = 0; i < szArea.height; i++)
    {
        nStart = (i+ptStart.y)*nColumn + ptStart.x;
        for (int j = 0; j < szArea.width; j++)
        {
            nIndex = nStart + j;
            [pArrayChess replaceObjectAtIndex:nIndex withObject:[NSNumber numberWithLong:nNum]];
        }
    }
}

// 判断窗口是否遇到大画面
- (BOOL)isSCXWinCanReachBigPicture:(CGRect)rectFrame
{
    skySCXWin *scxWin;
    CGPoint ptLU,ptRB;
    
    CGPoint ptTopLeft = rectFrame.origin;
    CGPoint ptBottomRight = CGPointMake(ptTopLeft.x+rectFrame.size.width, ptTopLeft.y+rectFrame.size.height);
    
    NSInteger nIndexLU = [self getUnitIndexFromPointLU:ptTopLeft];
    NSInteger nIndexRB = [self getUnitIndexFromPointRB:ptBottomRight];
    
    ptLU.x = nIndexLU % nColumn;
    ptLU.y = nIndexLU / nColumn;
    ptRB.x = nIndexRB % nColumn;
    ptRB.y = nIndexRB / nColumn;
        
    NSInteger nStart = nIndexLU;
    NSInteger nIndex = 0;
    int nWinIndex = 0;
    
    for (int i = 0; i <= ptRB.y - ptLU.y; i++)
    {
        for (int j = 0; j <= ptRB.x - ptLU.x; j++)
        {
            // 获取棋盘index
            nIndex = nStart + j;
            // 根据棋盘index获取落入此index上的窗口编号
            nWinIndex = [[pArrayChess objectAtIndex:nIndex] intValue];
            // 根据窗口编号在窗口容器中找到窗口对象
            scxWin = (skySCXWin *)[_scxWinContainer objectAtIndex:nWinIndex-1];
                        
            //  判断是否是大画面
            if (scxWin.getSCXWinBigPicture || scxWin.getSCXWinOpen)
            {
                return YES;
            }
        }
        nStart += nColumn;
    }

    return NO;
}

// 窗口拼接
- (void)scxWinSpliceScreen:(id)sender
{
    skySCXWin *scxWin = (skySCXWin *)sender;
    
    // 协议发送
    // TODO:
    int nStartPanel = scxWin.startPoint.y * nColumn + scxWin.startPoint.x + 1;
    [_protocolAdapter adapterSpliceSCXWin:scxWin.winNumber StartPanel:nStartPanel X:(int)scxWin.startPoint.x Y:(int)scxWin.startPoint.y V:(int)scxWin.winSize.height H:(int)scxWin.winSize.width ofType:scxWin.winSourceType toChannel:scxWin.winChannelNum];
}

// 窗口满屏显示
- (void)scxWinFullScreen:(id)sender
{
    skySCXWin *scxWin = (skySCXWin *)sender;
    
    // 先让其他窗口单屏
    for (skySCXWin *win in _scxWinContainer)
    {
        // 排除本窗口
        if (win.winNumber != scxWin.winNumber)
        {
            // 让开启叠加状态的窗口变为普通状态
            if ([win getSCXWinOpen])
                [self scxWinLeaveOpenStatus:win];
            
            // 让其余窗口是大画面的全部先单屏
            if ([win getSCXWinBigPicture])
                [win setSCXWinToSingleStatus];
        }
    }
    
    // 再处理全屏状态
    [scxWin setSCXWinToFullStatus];
    // 窗口置顶
    [self.view bringSubviewToFront:scxWin];
    
    // 协议发送
    // TODO:
    [_protocolAdapter adapterSpliceSCXWin:scxWin.winNumber StartPanel:1 X:(int)scxWin.startPoint.x Y:(int)scxWin.startPoint.y V:(int)scxWin.winSize.height H:(int)scxWin.winSize.width ofType:scxWin.winSourceType toChannel:scxWin.winChannelNum];
}

// 窗口大画面分解
- (void)scxWinResolveScreen:(id)sender
{
    skySCXWin *scxWin = (skySCXWin *)sender;
    
    // 如果在开窗状态
    if ([scxWin getSCXWinOpen])
    {
        [self scxWinLeaveOpenStatus:scxWin];
    }
    
    // 处理被覆盖的棋盘值
    int nIndex;
    for (int j = 0; j < (int)scxWin.winSize.height; j++)
    {
        for (int i = 0; i < (int)scxWin.winSize.width; i++)
        {
            nIndex = (j+scxWin.startPoint.y)*nColumn + scxWin.startPoint.x + i;
            [pArrayChess replaceObjectAtIndex:nIndex withObject:[NSNumber numberWithInt:nIndex+1]];
        }
    }
    
    // 协议发送
    // TODO:
    [_protocolAdapter adapterResolveSCXWin:scxWin.winNumber X:(int)scxWin.startPoint.x Y:(int)scxWin.startPoint.y H:(int)scxWin.winSize.width V:(int)scxWin.winSize.height];
    
    // 单屏分解
    [scxWin setSCXWinToSingleStatus];
}

// 窗口进入开窗状态
- (void)scxWinEnterOpenStatus:(id)sender
{
    skySCXWin *scxWin = (skySCXWin *)sender;
    
    // 其他窗口退出开窗
    for (skySCXWin *win in _scxWinContainer)
    {
        // 如果在开窗状态
        if ([win getSCXWinOpen] && (win.winNumber != scxWin.winNumber))
        {
            // 退出开窗
            [self scxWinLeaveOpenStatus:win];
        }
    }
    
    // 将窗口设置为开窗状态
    [scxWin setSCXWinToOpenStatus];
    
    
    // 协议发送
    // TODO:
    [_protocolAdapter adapterEnterOpenStatus:scxWin.winNumber ofType:scxWin.winSourceType toChannel:scxWin.winChannelNum];
}

// 窗口离开大画面状态
- (void)scxWinLeaveOpenStatus:(id)sender
{
    skySCXWin *scxWin = (skySCXWin *)sender;
    
    // 将已经开启的子窗关闭
    for (skySubWin *subWin in _subWinContainer)
    {
        // 如果已经开启
        if (subWin.getSubWinVisible)
        {
            // 删除子窗口
            [subWin deleteSubWin];
        }
    }
    
    // 设置窗口为普通状态 
    [scxWin setSCXWinToNormalStatus];
    
    // 协议发送
    // TODO:
    [_protocolAdapter adapterLeaveOpenStatus:scxWin.winNumber ofType:scxWin.winSourceType toChannel:scxWin.winChannelNum];
}

// 添加子窗口
- (void)scxWinAddSubWindow:(id)sender
{
    skySCXWin *scxWin = (skySCXWin *)sender;
    CGRect parentFrame = scxWin.frame;
    
    int nCount = 0;
    for (skySubWin *subWin in _subWinContainer)
    {
        // 检索没有添加的窗口
        if (!subWin.getSubWinVisible)
        {
            // 添加子窗口
            [subWin addSubWinWithParentFrame:parentFrame sourceType:scxWin.winSourceType andChannel:scxWin.winChannelNum];
            
            [self.view bringSubviewToFront:subWin];
            // 跳出循环
            return ;
        }
        else    // 若4个窗口都添加后
        {
            nCount++;
        }
    }
    
    // 窗口都已经添加完毕
    if (nCount == 4)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"最多只能添加四个叠加子窗" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }
}

// 信号切换
- (void)scxWin:(id)sender Signal:(NSInteger)nType SwitchTo:(NSInteger)nChannel
{
    skySCXWin *scxWin = (skySCXWin *)sender;
    
    // 代理调用
    if (scxWin.getSCXWinOpen)
        [_protocolAdapter adapterSignalSwitchOpenUnderWin:scxWin.winNumber ofType:nType toChannel:nChannel];        // 底图信号切换
    else    
        [_protocolAdapter adapterSignalSwitchSCXWin:scxWin.winNumber ofType:nType toChannel:nChannel X:(int)scxWin.startPoint.x Y:(int)scxWin.startPoint.y H:(int)scxWin.winSize.width V:(int)scxWin.winSize.height];                                 // 普通窗口信号切换
}

// 获取信号源数据代理
- (id<skySignalViewDataSource>)scxWinSignalDataSource
{
    return _appDelegate.theApp;
}

// 获取窗口输出分辨率
- (NSInteger)scxWinGetResolution
{
    return _appDelegate.theApp.appResolution;
}

#pragma mark - skySubWin Delegate
// 进入移动或者缩放的编辑状态
- (void)subWinBeginEditing:(id)sender
{
    skySubWin *subWin = (skySubWin *)sender;
    
    [currentSubWin changeToUnControllStatus];                // 将前一个窗口的外框隐藏
    currentSubWin = subWin;                                  // 更新当前窗口
    [currentSubWin changeToControllStatus];                  // 将当前窗口外框显示
    [self.view bringSubviewToFront:currentSubWin];
    
    // 拼接窗口编辑状态隐藏
    [currentSCXWin hideBoarderView];
}

// 添加子窗口
- (void)subWinAdd:(id)sender
{
    skySubWin *subWin = (skySubWin *)sender;
    
    // 协议发送
    // TODO:
    // 先发送添加子窗口
    [_protocolAdapter adapterAddSubWin:subWin.winNumber ofType:subWin.winSourceType toChannel:subWin.winChannelNum];
    // 再发送子窗口位置
//    int nStartX = [subWin getSubWinCentiStartX] * 10000;
//    int nStartY = [subWin getSubWinCentiStartY] * 10000;
//    int nWidth = [subWin getSubWinCentiWidth] * 10000;
//    int nHeight = [subWin getSubWinCentiHeight] * 10000;
//    [_protocolAdapter adapterMoveSubWin:subWin.winNumber StartX:nStartX StartY:nStartY Width:nWidth Height:nHeight];
}

// 关闭子窗口
- (void)subWinDelete:(id)sender
{
    skySubWin *subWin = (skySubWin *)sender;
    
    // 协议发送
    // TODO:
    [_protocolAdapter adapterDeleteSubWin:subWin.winNumber ofType:subWin.winSourceType toChannel:subWin.winChannelNum];
}

// 子窗口位置改变
- (void)subWinMove:(id)sender
{
    skySubWin *subWin = (skySubWin *)sender;
    
    // 协议发送
    // TODO:
    int nStartX = [subWin getSubWinCentiStartX] * 10000;
    int nStartY = [subWin getSubWinCentiStartY] * 10000;
    int nWidth = [subWin getSubWinCentiWidth] * 10000;
    int nHeight = [subWin getSubWinCentiHeight] * 10000;
    
    [_protocolAdapter adapterMoveSubWin:subWin.winNumber StartX:nStartX StartY:nStartY Width:nWidth Height:nHeight];
}

// 信号切换
- (void)subWin:(id)sender Signal:(NSInteger)nType SwitchTo:(NSInteger)nChannel
{
    skySubWin *subWin = (skySubWin *)sender;
    
    // 协议发送
    // TODO:
    [_protocolAdapter adapterSignalSwitchSubWin:subWin.winNumber ofType:nType toChannel:nChannel];
}

// 获取数据代理
- (id<skySignalViewDataSource>)subWinSignalDataSource
{
    return _appDelegate.theApp;
}

#pragma mark - skyModelViewDelegate
// 调用情景模式
- (void)loadModelStatus:(int)nIndex
{
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // 界面处理
    // 先移除以前的窗口 移除普通窗口
    for (skySCXWin *scxWin in _scxWinContainer)
        [scxWin removeFromSuperview];
    [_scxWinContainer removeAllObjects];            // 移除容器内数据
    // 移除漫游窗口
    for (skySubWin *subWin in _subWinContainer) 
        [subWin removeFromSuperview];
    [_subWinContainer removeAllObjects];            // 移除容器内数据
    
    // 添加模式内普通窗口
    CGRect scxWinRect;
    CGRect limitRect = CGRectMake(startCanvas.x, startCanvas.y, nColumn*nWinWidth, nRows*nWinHeight);
    NSInteger count = nRows * nColumn;
    for (int i = 0; i < count; i++)
    {
        // 计算大小位置
        int x = i % nColumn;
        int y = i / nColumn;
        scxWinRect = CGRectMake(startCanvas.x+x*nWinWidth, startCanvas.y+y*nWinHeight, nWinWidth, nWinHeight);
        
        // 初始化漫游窗口
        skySCXWin *scxWin = [[skySCXWin alloc] initWithFrame:scxWinRect withRow:nRows andColumn:nColumn];
        scxWin.delegate = self;
        scxWin.dataSource = _appDelegate.theApp;
        scxWin.startCanvas = startCanvas;
        scxWin.limitRect = limitRect;
        scxWin.winNumber = i+1;
        // 窗口值初始
        [scxWin loadSCXWinModelStatusAtIndex:nIndex+1];
        [scxWin hideBoarderView];
        
        // 将漫游窗口加入容器数组
        [self.scxWinContainer addObject:scxWin];
        [self.view addSubview:scxWin];
    }
    currentSCXWin = [_scxWinContainer objectAtIndex:0];
    
    // 大画面置顶显示
    for (skySCXWin *scxWin in _scxWinContainer)
    {
        if ([scxWin getSCXWinBigPicture])
            [self.view bringSubviewToFront:scxWin];
    }
    
    // 叠加子窗
    _subWinContainer = [[NSMutableArray alloc] init];
    CGRect subWinRect = CGRectMake(0, 0, 0, 0);
    for (int i = 0; i < 4; i++)
    {
        // 初始化漫游窗口
        skySubWin *subWin = [[skySubWin alloc] initWithFrame:subWinRect];
        subWin.delegate = self;
        subWin.dataSource = _appDelegate.theApp;
        subWin.winNumber = i+1;
        // 窗口值初始
        [subWin loadSubWinModelStatusAtIndex:nIndex+1];
        
        // 将叠加窗口加入容器数组
        [self.subWinContainer addObject:subWin];
        [self.view addSubview:subWin];
        
        // 所有子窗置顶显示
        [self.view bringSubviewToFront:subWin];
    }
    currentSubWin = [_subWinContainer objectAtIndex:0];

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // 消除弹出窗口
    [_myModelPopover dismissPopoverAnimated:YES];
    
    // 情景模式调用协议
    // TODO:
    [_protocolAdapter adapterLoadModelAtIndex:nIndex+1];
}

// 保存情景模式截图
- (void)shootAppToImage:(int)nIndex
{
    // 情景模式保存协议发送
    // TODO:
    [_protocolAdapter adapterSaveModelAtIndex:nIndex+1];
    
    // 截取控制区域显示图像
    UIGraphicsBeginImageContext(self.view.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    [self.view.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // 保存模式图片到文件
    NSString *appDefaultsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *appStandardDir = [appDefaultsPath stringByAppendingPathComponent:@"ModelSavedImages"];
    [[NSFileManager defaultManager] createDirectoryAtPath:appStandardDir withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *appDefaultFileName = [appStandardDir stringByAppendingPathComponent:[NSString stringWithFormat:@"model_%d.png",nIndex+1]];
    [UIImagePNGRepresentation(image) writeToFile:appDefaultFileName atomically:YES];
    
    // 替换情景模式图片数组
    [_appDelegate.theApp saveModelImage:image toIndex:nIndex];
    
    // 情景模式配置文件保存
    [self saveModelToFileAtIndex:nIndex+1];
}

// 删除情景模式
- (void)removeModelImage:(int)nIndex
{
    // 情景模式删除协议发送
    // TODO:
    [_protocolAdapter adapterDeleteModelAtIndex:nIndex+1];
    
    // 替换情景模式图片数组
    [_appDelegate.theApp deleteModelImageAtIndex:nIndex];
}

#pragma mark - skySettingConnection Delegate
// 连接通讯
- (void)connectToController:(NSString *)ipAddress Port:(NSInteger)nPort
{
    if (![_protocolAdapter adapterConnectToController:ipAddress Port:nPort])
    {
        [(skySettingConnection *)[_settingMainView.controllers objectAtIndex:0] controllerCanBeConnected:NO];
    }
}

// 端口通讯
- (void)disConnectController
{
    [_protocolAdapter adapterDisconnection];
}

// 20140917 by wh 设置当前控制器IP地址和端口号
- (void)setCurrentIPAddress:(NSString *)ipAddress Port:(NSInteger)nPort
{
    [_appDelegate.theApp setAppIPAddress:ipAddress];
    [_appDelegate.theApp setAppPortNumber:nPort];
}

#pragma mark - skySettingController Delegate
// 设置当前控制器数据
- (void)setCurrentRow:(NSInteger)r Column:(NSInteger)c Resolution:(NSInteger)re
{
    // 数据设置
    [_appDelegate.theApp setAppRows:r];
    [_appDelegate.theApp setAppColumns:c];
    [_appDelegate.theApp setAppResolution:re];
    [_appDelegate.theApp calculateScreenSize];

    // 界面配置
    [_mySettingsPopover dismissPopoverAnimated:YES];
    [self reloadUI];
    
    // 协议调用
    // TODO:
    [_protocolAdapter adapterInitialControllerRow:r Column:c Resolution:re];
}

// 设置当前控制器类型
- (void)setCurrentControllerType:(NSInteger)nValue
{
    [_appDelegate.theApp setAppControllerType:nValue];
}

// 设置当前掉电状态
- (void)setCurrentPowerStatus:(BOOL)bFlag
{
    [_appDelegate.theApp setAppPowerSave:bFlag];
    
    // 协议调用
    // TODO:
    [_protocolAdapter adapterPowerMemoryStatus:bFlag];
}

// 设置当前温控状态
- (void)setCurrentTemperatureStatus:(BOOL)bFlag
{
    [_appDelegate.theApp setAppTemperature:bFlag];
    
    // 协议调用
    // TODO:
    [_protocolAdapter adapterTemperatureStatus:bFlag];
}

// 设置当前边缘融合状态
- (void)setCurrentStraightStatus:(BOOL)bFlag
{
    [_appDelegate.theApp setAppStraight:bFlag];
    
    // 协议调用
    // TODO:
    [_protocolAdapter adapterStraightStatus:bFlag];
}

// 设置蜂鸣器状态
- (void)setCurrentBuzzerStatus:(BOOL)bFlag
{
    [_appDelegate.theApp setAppBuzzer:bFlag];
    
    // 协议调用
    // TODO:
    [_protocolAdapter adapterBuzzerStatus:bFlag];
}

#pragma mark - skySettingSDKs Delegate
// 获取协议类型
- (NSInteger)getProtocolType
{
    return _appDelegate.theApp.appProtocolType;
}

// 设置协议类型
- (void)setProtocolType:(NSInteger)nType
{
    [_protocolAdapter setAdapterType:nType];
}

#pragma mark - skyTVSettingController Delegate
// 连接通讯
- (void)connectToCmd:(NSString *)ipAddress Port:(NSInteger)nPort
{
    if (![_tvProtocol connectTCPService:ipAddress andPort:nPort])
    {
        [(skyTVSettingController *)[_settingMainView.controllers objectAtIndex:4] controllerCanBeConnected:NO];
    }
}

// 端口通讯
- (void)disConnectCmd
{
    [_tvProtocol disconnectWithTCPService];
}

// 20140917 by wh 设置当前控制器IP地址和端口号
- (void)setCurrentCmdIPAddress:(NSString *)ipAddress Port:(NSInteger)nPort
{
    [_appDelegate.theApp setAppCmdIPAddress:ipAddress];
    [_appDelegate.theApp setAppCmdPortNumber:nPort];
}

// 屏幕全选
- (void)skyTVSettingSelectAllScreen
{
    [_tvProtocol skyTVSelectAll];
}

// 屏幕全不选
- (void)skyTVSettingUnSelectAllScreen
{
    [_tvProtocol skyTVUnSelectAll];
}

// 屏幕开启
- (void)skyTVSettingScreenOn
{
    // 界面配置
    [_mySettingsPopover dismissPopoverAnimated:YES];
    // 协议发送
    [_tvProtocol skyTVOpenTV];
}

// 屏幕关闭
- (void)skyTVSettingScreenOff
{
    // 界面配置
    [_mySettingsPopover dismissPopoverAnimated:YES];
    // 协议发送
    [_tvProtocol skyTVCloseTV];
}

@end
