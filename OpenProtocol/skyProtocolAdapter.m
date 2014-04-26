//
//  skyProtocolAdapter.m
//  SkyworthSCXPJ
//
//  Created by skyworth on 13-9-6.
//  Copyright (c) 2013年 skyworth. All rights reserved.
//

#import "skyProtocolAdapter.h"

// Private
@interface skyProtocolAdapter()

///////////////////// Property ///////////////////////
// SDK 对象
@property (nonatomic, strong) skySCXProtocol *scxSDK;               // 混合开窗开发协议SDK对象
@property (nonatomic, strong) skyOpenSCXProtocol *scxOpenSDK;       // 混合开窗开放协议SDK对象

///////////////////// Methods ////////////////////////

///////////////////// Ends ///////////////////////////

@end

// implementation
@implementation skyProtocolAdapter

@synthesize adapterType = _adapterType;
@synthesize scxSDK = _scxSDK;
@synthesize scxOpenSDK = _scxOpenSDK;
@synthesize delegate = _delegate;

#pragma mark - Publice Methods
// 初始
- (id)init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}

// 适配器初始
- (id)initAdapterWithProtocolType:(int)nProtocolType
{
    self = [super init];
    if (self)
    {
        _adapterType = nProtocolType;
        _scxSDK = [[skySCXProtocol alloc] initSCXProtocol];
        _scxOpenSDK = [[skyOpenSCXProtocol alloc] initOpenSCXProtocol];
    }
    return self;
}

// 状态初始
- (void)initialAdapter
{
    _adapterType = [_delegate adapterDelegateGetType];
    _scxSDK = [[skySCXProtocol alloc] initSCXProtocol];
    _scxOpenSDK = [[skyOpenSCXProtocol alloc] initOpenSCXProtocol];
}

// 控制器连接
- (BOOL)adapterConnectToController:(NSString *)ipAddress Port:(int)nPort
{
    BOOL bResult = NO;
    // 协议判断
    switch (_adapterType) {
        case kSCXPROTOCOL:          // 混合开窗开发协议
            bResult = [_scxSDK connectTCPService:ipAddress andPort:nPort];
            break;
            
        case kSCXOPENPROTOCOL:      // 混合开窗开放协议
            bResult = [_scxOpenSDK connectTCPService:ipAddress andPort:nPort];
            break;
    }

    return bResult;
}

// 断开控制器连接
- (void)adapterDisconnection
{
    [_scxSDK disconnectWithTCPService];
    [_scxOpenSDK disconnectWithTCPService];
}

// 控制器重连
- (void)adapterReconnectToController
{
    // 协议判断
    switch (_adapterType)
    {
        case kSCXPROTOCOL:
            [_scxSDK reConnectToService];
            break;
            
        case kSCXOPENPROTOCOL:
            [_scxOpenSDK reConnectToService];
            break;
    }
}

// 控制器进入后台
- (void)adapterConnectEnterBackground
{
    // 协议判断
    switch (_adapterType)
    {
        case kSCXPROTOCOL:
            [_scxSDK serviceEnterBackground];
            break;
            
        case kSCXOPENPROTOCOL:
            [_scxOpenSDK serviceEnterBackground];
            break;
    }
}

// 设置控制器类型
- (void)setAdapterType:(NSInteger)nType
{
    _adapterType = nType;
    
    [_delegate adapterDelegateSetType:nType];
}

#pragma mark - Protocol Adapter Interface
// 1.控制器设置
- (void)adapterInitialControllerRow:(int)nRow Column:(int)nColumn Resolution:(int)nRes
{
    // 协议判断
    switch (_adapterType) {
        case kSCXPROTOCOL:          // 混合开窗开发协议
            [_scxSDK scxControllerSetRow:nRow Column:nColumn Resolution:nRes];
            break;
            
        case kSCXOPENPROTOCOL:      // 混合开窗开放协议
            [_scxOpenSDK openSCXControllerSetRow:nRow Column:nColumn Resolution:nRes];
            break;
    }
}

// 2.蜂鸣器开关
- (void)adapterBuzzerStatus:(BOOL)bFlag
{
    // 协议判断
    switch (_adapterType) {
        case kSCXPROTOCOL:          // 混合开窗开发协议
            [_scxSDK scxBuzzerStatus:bFlag];
            break;
            
        case kSCXOPENPROTOCOL:      // 混合开窗开放协议
            [_scxOpenSDK openSCXBuzzerStatus:bFlag];
            break;
    }
}

// 3.掉电记忆开关
- (void)adapterPowerMemoryStatus:(BOOL)bFlag
{
    // 协议判断
    switch (_adapterType) {
        case kSCXPROTOCOL:          // 混合开窗开发协议
            [_scxSDK scxPowerMemoryStatus:bFlag];
            break;
            
        case kSCXOPENPROTOCOL:      // 混合开窗开放协议
            [_scxOpenSDK openSCXPowerMemoryStatus:bFlag];
            break;
    }
}

// 4.温控开关
- (void)adapterTemperatureStatus:(BOOL)bFlag
{
    // 协议判断
    switch (_adapterType) {
        case kSCXPROTOCOL:          // 混合开窗开发协议
            [_scxSDK scxTemperatureStatus:bFlag];
            break;
            
        case kSCXOPENPROTOCOL:      // 混合开窗开放协议
            [_scxOpenSDK openSCXTemperatureStatus:bFlag];
            break;
    }
}

// 5.边缘屏蔽功能
- (void)adapterStraightStatus:(BOOL)bFlag
{
    // 协议判断
    switch (_adapterType) {
        case kSCXPROTOCOL:          // 混合开窗开发协议
            [_scxSDK scxStraightStatus:bFlag];
            break;
            
        case kSCXOPENPROTOCOL:      // 混合开窗开放协议
            [_scxOpenSDK openSCXStraightStatus:bFlag];
            break;
    }
}

// 6.情景新建 - CVBS
- (void)adapterModelNewWithCVBS
{
    // 协议判断
    switch (_adapterType) {
        case kSCXPROTOCOL:          // 混合开窗开发协议
            [_scxSDK scxModelNewWithCVBS];
            break;
            
        case kSCXOPENPROTOCOL:      // 混合开窗开放协议
            [_scxOpenSDK openSCXModelNewWithCVBS];
            break;
    }
}

// 7.情景新建 - HDMI
- (void)adapterModelNewWithHDMI
{
    // 协议判断
    switch (_adapterType) {
        case kSCXPROTOCOL:          // 混合开窗开发协议
            [_scxSDK scxModelNewWithHDMI];
            break;
            
        case kSCXOPENPROTOCOL:      // 混合开窗开放协议
            [_scxOpenSDK openSCXModelNewWithHDMI];
            break;
    }
}

// 8.情景保存
- (void)adapterSaveModelAtIndex:(int)nIndex
{
    // 协议判断
    switch (_adapterType) {
        case kSCXPROTOCOL:          // 混合开窗开发协议
            [_scxSDK scxSaveModelAtIndex:nIndex];
            break;
            
        case kSCXOPENPROTOCOL:      // 混合开窗开放协议
            [_scxOpenSDK openSCXSaveModelAtIndex:nIndex];
            break;
    }
}

// 9.情景加载
- (void)adapterLoadModelAtIndex:(int)nIndex
{
    // 协议判断
    switch (_adapterType) {
        case kSCXPROTOCOL:          // 混合开窗开发协议
            [_scxSDK scxLoadModelAtIndex:nIndex];
            break;
            
        case kSCXOPENPROTOCOL:      // 混合开窗开放协议
            [_scxOpenSDK openSCXLoadModelAtIndex:nIndex];
            break;
    }
}

// 10.情景删除
- (void)adapterDeleteModelAtIndex:(int)nIndex
{
    // 协议判断
    switch (_adapterType) {
        case kSCXPROTOCOL:          // 混合开窗开发协议
            [_scxSDK scxDeleteModelAtIndex:nIndex];
            break;
            
        case kSCXOPENPROTOCOL:      // 混合开窗开放协议
            [_scxOpenSDK openSCXDeleteModelAtIndex:nIndex];
            break;
    }
}

// 11.普通窗口信号切换
- (void)adapterSignalSwitchSCXWin:(int)nWinID ofType:(int)nSrcType toChannel:(int)nSrcPath X:(int)nStartX Y:(int)nStartY H:(int)nHCount V:(int)nVCount;
{
    // 协议判断
    switch (_adapterType) {
        case kSCXPROTOCOL:          // 混合开窗开发协议
            [_scxSDK scxSignalSwitchSCXWin:nWinID ofType:nSrcType toChannel:nSrcPath X:nStartX Y:nStartY H:nHCount V:nVCount];
            break;
            
        case kSCXOPENPROTOCOL:      // 混合开窗开放协议
            [_scxOpenSDK openSCXSignalSwitchSCXWin:nWinID ofType:nSrcType toChannel:nSrcPath];
            break;
    }
}

// 12.叠加底图窗口信号切换
- (void)adapterSignalSwitchOpenUnderWin:(int)nWinID ofType:(int)nSrcType toChannel:(int)nSrcPath
{
    // 协议判断
    switch (_adapterType) {
        case kSCXPROTOCOL:          // 混合开窗开发协议
            [_scxSDK scxSignalSwitchOpenUnderWin:nWinID ofType:nSrcType toChannel:nSrcPath];
            break;
            
        case kSCXOPENPROTOCOL:      // 混合开窗开放协议
            [_scxOpenSDK openSCXSignalSwitchOpenUnderWin:nWinID ofType:nSrcType toChannel:nSrcPath];
            break;
    }
}

// 13.叠加子窗口信号切换
- (void)adapterSignalSwitchSubWin:(int)nWinID ofType:(int)nSrcType toChannel:(int)nSrcPath
{
    // 协议判断
    switch (_adapterType) {
        case kSCXPROTOCOL:          // 混合开窗开发协议
            [_scxSDK scxSignalSwitchSubWin:nWinID ofType:nSrcType toChannel:nSrcPath];
            break;
            
        case kSCXOPENPROTOCOL:      // 混合开窗开放协议
            [_scxOpenSDK openSCXSignalSwitchSubWin:nWinID ofType:nSrcType toChannel:nSrcPath];
            break;
    }
}

// 14.大画面拼接
- (void)adapterSpliceSCXWin:(int)nWinID StartPanel:(int)nStart X:(int)nStartX Y:(int)nStartY V:(int)nVCount H:(int)nHCount ofType:(int)nSrcType toChannel:(int)nSrcPath
{
    // 协议判断
    switch (_adapterType) {
        case kSCXPROTOCOL:          // 混合开窗开发协议
            [_scxSDK scxSpliceSCXWin:nWinID X:nStartX Y:nStartY VScreen:nVCount HScreen:nHCount ofType:nSrcType toChannel:nSrcPath];
            break;
            
        case kSCXOPENPROTOCOL:      // 混合开窗开放协议
            [_scxOpenSDK openSCXSpliceSCXWin:nWinID StartPanel:nStart VScreen:nVCount HScreen:nHCount ofType:nSrcType toChannel:nSrcPath];
            break;
    }

}

// 15.大画面分解
- (void)adapterResolveSCXWin:(int)nWinID X:(int)nStartX Y:(int)nStartY H:(int)nHCount V:(int)nVCount
{
    // 协议判断
    switch (_adapterType) {
        case kSCXPROTOCOL:          // 混合开窗开发协议
            [_scxSDK scxResolveSCXWin:nWinID X:nStartX Y:nStartY H:nHCount V:nVCount];
            break;
            
        case kSCXOPENPROTOCOL:      // 混合开窗开放协议
            [_scxOpenSDK openSCXResolveSCXWin:nWinID];
            break;
    }
}

// 16.进入叠加开窗
- (void)adapterEnterOpenStatus:(int)nWinID ofType:(int)nSrcType toChannel:(int)nSrcPath
{
    // 协议判断
    switch (_adapterType) {
        case kSCXPROTOCOL:          // 混合开窗开发协议
            [_scxSDK scxEnterOpenStatus:nWinID ofType:nSrcType toChannel:nSrcPath];
            break;
            
        case kSCXOPENPROTOCOL:      // 混合开窗开放协议
            [_scxOpenSDK openSCXEnterOpenStatus:nWinID ofType:nSrcType toChannel:nSrcPath];
            break;
    }
}

// 17.退出叠加开窗
- (void)adapterLeaveOpenStatus:(int)nWinID ofType:(int)nSrcType toChannel:(int)nSrcPath
{
    // 协议判断
    switch (_adapterType) {
        case kSCXPROTOCOL:          // 混合开窗开发协议
            [_scxSDK scxLeaveOpenStatus:nWinID ofType:nSrcType toChannel:nSrcPath];
            break;
            
        case kSCXOPENPROTOCOL:      // 混合开窗开放协议
            [_scxOpenSDK openSCXLeaveOpenStatus:nWinID ofType:nSrcType toChannel:nSrcPath];
            break;
    }
}

// 18.添加子窗口
- (void)adapterAddSubWin:(int)nSubID ofType:(int)nSrcType toChannel:(int)nSrcPath
{
    // 协议判断
    switch (_adapterType) {
        case kSCXPROTOCOL:          // 混合开窗开发协议
            [_scxSDK scxAddSubWin:nSubID ofType:nSrcType toChannel:nSrcPath];
            break;
            
        case kSCXOPENPROTOCOL:      // 混合开窗开放协议
            [_scxOpenSDK openSCXAddSubWin:nSubID ofType:nSrcType toChannel:nSrcPath];
            break;
    }
}

// 19.关闭子窗口
- (void)adapterDeleteSubWin:(int)nSubID ofType:(int)nSrcType toChannel:(int)nSrcPath
{
    // 协议判断
    switch (_adapterType) {
        case kSCXPROTOCOL:          // 混合开窗开发协议
            [_scxSDK scxDeleteSubWin:nSubID ofType:nSrcType toChannel:nSrcPath];
            break;
            
        case kSCXOPENPROTOCOL:      // 混合开窗开放协议
            [_scxOpenSDK openSCXDeleteSubWin:nSubID ofType:nSrcType toChannel:nSrcPath];
            break;
    }
}

// 20.移动子窗口 同时包括位置与大小
- (void)adapterMoveSubWin:(int)nSubID StartX:(int)nStartX StartY:(int)nStartY Width:(int)nWidth Height:(int)nHeight
{
    // 协议判断
    switch (_adapterType) {
        case kSCXPROTOCOL:          // 混合开窗开发协议
            // 子窗位子移动
            [_scxSDK scxMoveSubWin:nSubID StartX:nStartX StartY:nStartY];
            // 子窗缩放
            [_scxSDK scxResizeSubWin:nSubID WinWidth:nWidth WinHeight:nHeight];
            break;
            
        case kSCXOPENPROTOCOL:      // 混合开窗开放协议
            // 子窗位置移动
            [_scxOpenSDK openSCXMoveSubWin:nSubID StartX:nStartX StartY:nStartY];
            // 子窗缩放
            [_scxOpenSDK openSCXResizeSubWin:nSubID WinWidth:nWidth WinHeight:nHeight];
            break;
    }
}

@end
