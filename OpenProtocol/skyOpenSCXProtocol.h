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
- (BOOL)connectTCPService:(NSString *)hostAddress andPort:(NSInteger)nPort;
// 端口TCP服务器
- (void)disconnectWithTCPService;
// 服务器重连
- (void)reConnectToService;
// 服务器进入后台
- (void)serviceEnterBackground;

/*******************************************************/
// 1.控制器设置
- (void)openSCXControllerSetRow:(NSInteger)nRow Column:(NSInteger)nColumn Resolution:(NSInteger)nRes;
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
- (void)openSCXSaveModelAtIndex:(NSInteger)nIndex;
// 9.情景加载
- (void)openSCXLoadModelAtIndex:(NSInteger)nIndex;
// 10.情景删除
- (void)openSCXDeleteModelAtIndex:(NSInteger)nIndex;
// 11.普通窗口信号切换
- (void)openSCXSignalSwitchSCXWin:(NSInteger)nWinID ofType:(NSInteger)nSrcType toChannel:(NSInteger)nSrcPath;
// 12.叠加底图窗口信号切换
- (void)openSCXSignalSwitchOpenUnderWin:(NSInteger)nWinID ofType:(NSInteger)nSrcType toChannel:(NSInteger)nSrcPath;
// 13.叠加子窗口信号切换
- (void)openSCXSignalSwitchSubWin:(NSInteger)nSubID ofType:(NSInteger)nSrcType toChannel:(NSInteger)nSrcPath;
// 14.大画面拼接
- (void)openSCXSpliceSCXWin:(NSInteger)nWinID StartPanel:(NSInteger)nStart VScreen:(NSInteger)nVCount HScreen:(NSInteger)nHCount ofType:(NSInteger)nSrcType toChannel:(NSInteger)nSrcPath;
// 15.大画面分解
- (void)openSCXResolveSCXWin:(NSInteger)nWinID;
// 16.进入叠加开窗
- (void)openSCXEnterOpenStatus:(NSInteger)nWinID ofType:(NSInteger)nSrcType toChannel:(NSInteger)nSrcPath;
// 17.退出叠加开窗
- (void)openSCXLeaveOpenStatus:(NSInteger)nWinID ofType:(NSInteger)nSrcType toChannel:(NSInteger)nSrcPath;
// 18.添加子窗口
- (void)openSCXAddSubWin:(NSInteger)nSubID ofType:(NSInteger)nSrcType toChannel:(NSInteger)nSrcPath;
// 19.关闭子窗口
- (void)openSCXDeleteSubWin:(NSInteger)nSubID ofType:(NSInteger)nSrcType toChannel:(NSInteger)nSrcPath;
// 20.移动子窗口
- (void)openSCXMoveSubWin:(NSInteger)nSubID StartX:(NSInteger)nStartX StartY:(NSInteger)nStartY;
// 21.缩放子窗口
- (void)openSCXResizeSubWin:(NSInteger)nSubID WinWidth:(NSInteger)nWidth WinHeight:(NSInteger)nHeight;
/*******************************************************/

///////////////////// Ends /////////////////////////////

@end
