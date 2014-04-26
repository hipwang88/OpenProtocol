//
//  skySCXProtocol.h
//  SkyworthSCXPJ
//
//  Created by skyworth on 13-9-16.
//  Copyright (c) 2013年 skyworth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "definition.h"

// skySCXProtocol
@interface skySCXProtocol : NSObject

///////////////////// Property /////////////////////////

///////////////////// Methods //////////////////////////
// 初始化开放协议SDK
- (id)initSCXProtocol;
// 连接TCP服务器
- (BOOL)connectTCPService:(NSString *)hostAddress andPort:(int)nPort;
// 端口TCP服务器
- (void)disconnectWithTCPService;
// 服务器重连
- (void)reConnectToService;
// 服务器进入后台
- (void)serviceEnterBackground;

/*******************************************************/
// 1.控制器设置
- (void)scxControllerSetRow:(int)nRow Column:(int)nColumn Resolution:(int)nRes;
// 2.蜂鸣器开关
- (void)scxBuzzerStatus:(BOOL)bFlag;
// 3.掉电记忆开关
- (void)scxPowerMemoryStatus:(BOOL)bFlag;
// 4.温控开关
- (void)scxTemperatureStatus:(BOOL)bFlag;
// 5.边缘屏蔽开关
- (void)scxStraightStatus:(BOOL)bFlag;
// 6.情景新建 - CVBS
- (void)scxModelNewWithCVBS;
// 7.情景新建 - HDMI
- (void)scxModelNewWithHDMI;
// 8.情景保存
- (void)scxSaveModelAtIndex:(int)nIndex;
// 9.情景加载
- (void)scxLoadModelAtIndex:(int)nIndex;
// 10.情景删除
- (void)scxDeleteModelAtIndex:(int)nIndex;
// 11.普通窗口信号切换
- (void)scxSignalSwitchSCXWin:(int)nWinID ofType:(int)nSrcType toChannel:(int)nSrcPath X:(int)nStartX Y:(int)nStartY H:(int)nHCount V:(int)nVCount;
// 12.叠加底图窗口信号切换
- (void)scxSignalSwitchOpenUnderWin:(int)nWinID ofType:(int)nSrcType toChannel:(int)nSrcPath;
// 13.叠加子窗口信号切换
- (void)scxSignalSwitchSubWin:(int)nSubID ofType:(int)nSrcType toChannel:(int)nSrcPath;
// 14.大画面拼接
- (void)scxSpliceSCXWin:(int)nWinID X:(int)nStartX Y:(int)nStartY VScreen:(int)nVCount HScreen:(int)nHCount ofType:(int)nSrcType toChannel:(int)nSrcPath;
// 15.大画面分解
- (void)scxResolveSCXWin:(int)nWinID X:(int)nStartX Y:(int)nStartY H:(int)nHCount V:(int)nVCount;
// 16.进入叠加开窗
- (void)scxEnterOpenStatus:(int)nWinID ofType:(int)nSrcType toChannel:(int)nSrcPath;
// 17.退出叠加开窗
- (void)scxLeaveOpenStatus:(int)nWinID ofType:(int)nSrcType toChannel:(int)nSrcPath;
// 18.添加子窗口
- (void)scxAddSubWin:(int)nSubID ofType:(int)nSrcType toChannel:(int)nSrcPath;
// 19.关闭子窗口
- (void)scxDeleteSubWin:(int)nSubID ofType:(int)nSrcType toChannel:(int)nSrcPath;
// 20.移动子窗口
- (void)scxMoveSubWin:(int)nSubID StartX:(int)nStartX StartY:(int)nStartY;
// 21.缩放子窗口
- (void)scxResizeSubWin:(int)nSubID WinWidth:(int)nWidth WinHeight:(int)nHeight;

///////////////////// Ends /////////////////////////////

@end
