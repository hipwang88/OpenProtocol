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
- (BOOL)connectTCPService:(NSString *)hostAddress andPort:(NSInteger)nPort;
// 端口TCP服务器
- (void)disconnectWithTCPService;
// 服务器重连
- (void)reConnectToService;
// 服务器进入后台
- (void)serviceEnterBackground;

/*******************************************************/
// 1.控制器设置
- (void)scxControllerSetRow:(NSInteger)nRow Column:(NSInteger)nColumn Resolution:(NSInteger)nRes;
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
- (void)scxSaveModelAtIndex:(NSInteger)nIndex;
// 9.情景加载
- (void)scxLoadModelAtIndex:(NSInteger)nIndex;
// 10.情景删除
- (void)scxDeleteModelAtIndex:(NSInteger)nIndex;
// 11.普通窗口信号切换
- (void)scxSignalSwitchSCXWin:(NSInteger)nWinID ofType:(NSInteger)nSrcType toChannel:(NSInteger)nSrcPath X:(NSInteger)nStartX Y:(NSInteger)nStartY H:(NSInteger)nHCount V:(NSInteger)nVCount;
// 12.叠加底图窗口信号切换
- (void)scxSignalSwitchOpenUnderWin:(NSInteger)nWinID ofType:(NSInteger)nSrcType toChannel:(NSInteger)nSrcPath;
// 13.叠加子窗口信号切换
- (void)scxSignalSwitchSubWin:(NSInteger)nSubID ofType:(NSInteger)nSrcType toChannel:(NSInteger)nSrcPath;
// 14.大画面拼接
- (void)scxSpliceSCXWin:(NSInteger)nWinID X:(NSInteger)nStartX Y:(NSInteger)nStartY VScreen:(NSInteger)nVCount HScreen:(NSInteger)nHCount ofType:(NSInteger)nSrcType toChannel:(NSInteger)nSrcPath;
// 15.大画面分解
- (void)scxResolveSCXWin:(NSInteger)nWinID X:(NSInteger)nStartX Y:(NSInteger)nStartY H:(NSInteger)nHCount V:(NSInteger)nVCount;
// 16.进入叠加开窗
- (void)scxEnterOpenStatus:(NSInteger)nWinID ofType:(NSInteger)nSrcType toChannel:(NSInteger)nSrcPath;
// 17.退出叠加开窗
- (void)scxLeaveOpenStatus:(NSInteger)nWinID ofType:(NSInteger)nSrcType toChannel:(NSInteger)nSrcPath;
// 18.添加子窗口
- (void)scxAddSubWin:(NSInteger)nSubID ofType:(NSInteger)nSrcType toChannel:(NSInteger)nSrcPath;
// 19.关闭子窗口
- (void)scxDeleteSubWin:(NSInteger)nSubID ofType:(NSInteger)nSrcType toChannel:(NSInteger)nSrcPath;
// 20.移动子窗口
- (void)scxMoveSubWin:(NSInteger)nSubID StartX:(NSInteger)nStartX StartY:(NSInteger)nStartY;
// 21.缩放子窗口
- (void)scxResizeSubWin:(NSInteger)nSubID WinWidth:(NSInteger)nWidth WinHeight:(NSInteger)nHeight;

///////////////////// Ends /////////////////////////////

@end
