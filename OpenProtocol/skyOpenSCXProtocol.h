//
//  skyOpenSCXProtocol.h
//  SkyworthSCXPJ
//
//  Created by skyworth on 13-9-6.
//  Copyright (c) 2013年 skyworth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "definition.h"

// skyOpenSCXProtocol
@interface skyOpenSCXProtocol : NSObject

///////////////////// Property /////////////////////////

///////////////////// Methods //////////////////////////
// 初始化开放协议SDK
- (id)initOpenSCXProtocol;
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
- (void)openSCXControllerSetRow:(int)nRow Column:(int)nColumn Resolution:(int)nRes;
// 2.蜂鸣器开关
- (void)openSCXBuzzerStatus:(BOOL)bFlag;
// 3.掉电记忆开关
- (void)openSCXPowerMemoryStatus:(BOOL)bFlag;
// 4.温控开关
- (void)openSCXTemperatureStatus:(BOOL)bFlag;
// 5.边缘屏蔽开关
- (void)openSCXStraightStatus:(BOOL)bFlag;
// 6.情景新建 - CVBS
- (void)openSCXModelNewWithCVBS;
// 7.情景新建 - HDMI
- (void)openSCXModelNewWithHDMI;
// 8.情景保存
- (void)openSCXSaveModelAtIndex:(int)nIndex;
// 9.情景加载
- (void)openSCXLoadModelAtIndex:(int)nIndex;
// 10.情景删除
- (void)openSCXDeleteModelAtIndex:(int)nIndex;
// 11.普通窗口信号切换
- (void)openSCXSignalSwitchSCXWin:(int)nWinID ofType:(int)nSrcType toChannel:(int)nSrcPath;
// 12.叠加底图窗口信号切换
- (void)openSCXSignalSwitchOpenUnderWin:(int)nWinID ofType:(int)nSrcType toChannel:(int)nSrcPath;
// 13.叠加子窗口信号切换
- (void)openSCXSignalSwitchSubWin:(int)nSubID ofType:(int)nSrcType toChannel:(int)nSrcPath;
// 14.大画面拼接
- (void)openSCXSpliceSCXWin:(int)nWinID StartPanel:(int)nStart VScreen:(int)nVCount HScreen:(int)nHCount ofType:(int)nSrcType toChannel:(int)nSrcPath;
// 15.大画面分解
- (void)openSCXResolveSCXWin:(int)nWinID;
// 16.进入叠加开窗
- (void)openSCXEnterOpenStatus:(int)nWinID ofType:(int)nSrcType toChannel:(int)nSrcPath;
// 17.退出叠加开窗
- (void)openSCXLeaveOpenStatus:(int)nWinID ofType:(int)nSrcType toChannel:(int)nSrcPath;
// 18.添加子窗口
- (void)openSCXAddSubWin:(int)nSubID ofType:(int)nSrcType toChannel:(int)nSrcPath;
// 19.关闭子窗口
- (void)openSCXDeleteSubWin:(int)nSubID ofType:(int)nSrcType toChannel:(int)nSrcPath;
// 20.移动子窗口
- (void)openSCXMoveSubWin:(int)nSubID StartX:(int)nStartX StartY:(int)nStartY;
// 21.缩放子窗口
- (void)openSCXResizeSubWin:(int)nSubID WinWidth:(int)nWidth WinHeight:(int)nHeight;
/*******************************************************/

///////////////////// Ends /////////////////////////////

@end
