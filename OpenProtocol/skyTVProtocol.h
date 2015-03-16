//
//  skyTVProtocol.h
//  OpenProtocol
//
//  Created by skyworth on 14-9-17.
//  Copyright (c) 2014年 skyworth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "definition.h"

// skyTVProtocol
@interface skyTVProtocol : NSObject

///////////////////// Property /////////////////////////

///////////////////// Methods //////////////////////////
// 初始化屏幕控制协议
- (id)initTVProtocol;
// 连接TCP服务端
- (BOOL)connectTCPService:(NSString *)hostAddress andPort:(NSInteger)nPort;
// 断开服务器连接
- (void)disconnectWithTCPService;
// 服务器重连
- (void)reConnectToService;
// 服务器进入后台
- (void)serviceEnterBackground;

/******************************************************/
// 1.屏幕全选指令
- (void)skyTVSelectAll;
// 2.屏幕全不选指令
- (void)skyTVUnSelectAll;
// 3.开启屏幕指令
- (void)skyTVOpenTV;
// 4.关闭屏幕指令
- (void)skyTVCloseTV;

///////////////////// Ends /////////////////////////////

@end
