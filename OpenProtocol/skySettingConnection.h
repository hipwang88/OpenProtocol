//
//  skySettingConnection.h
//  SkyworthSCXPJ
//
//  Created by skyworth on 13-8-9.
//  Copyright (c) 2013年 skyworth. All rights reserved.
//

#import "skySecondLevelView.h"

// protocol
@protocol skySettingConnectionDelegate <NSObject>

// 连接通讯
- (void)connectToController:(NSString *)ipAddress Port:(int)nPort;
// 端口通讯
- (void)disConnectController;

@end

// class skySettingConnection
@interface skySettingConnection : skySecondLevelView<UITableViewDelegate,UITableViewDataSource>

///////////////////// Property /////////////////////////
@property (strong,nonatomic) UITextField *serverIP;                             // 服务器IP地址
@property (strong,nonatomic) UITextField *serverPort;                           // 服务器端口
@property (strong,nonatomic) UISwitch   *connectionSwitcher;                    // 连接开关
@property (assign,nonatomic) id<skySettingConnectionDelegate> setDelegate;      // 代理对象

///////////////////// Methods //////////////////////////
// 组件初始化
- (void)initializeComponents;
// 能否连接
- (void)controllerCanBeConnected:(BOOL)bFlag;

///////////////////// Ends /////////////////////////////

@end
