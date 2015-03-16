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
- (void)connectToController:(NSString *)ipAddress Port:(NSInteger)nPort;
// 端口通讯
- (void)disConnectController;

// 20140917 by wh 设置当前控制器IP地址和端口号
- (void)setCurrentIPAddress:(NSString *)ipAddress Port:(NSInteger)nPort;

@end

// protocol - DataSource   20140917 by wh 增加IP保存功能
@protocol skySettingConnectionDataSource <NSObject>

// 获取当前IP地址
- (NSString *)getCurrentIPAddress;
// 获取当前端口号
- (NSInteger)getCurrentPortNumber;

@end

// class skySettingConnection
@interface skySettingConnection : skySecondLevelView<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

///////////////////// Property /////////////////////////
@property (strong,nonatomic) UITextField *serverIP;                             // 服务器IP地址
@property (strong,nonatomic) UITextField *serverPort;                           // 服务器端口
@property (strong,nonatomic) UISwitch   *connectionSwitcher;                    // 连接开关
@property (assign,nonatomic) id<skySettingConnectionDelegate> setDelegate;      // 代理对象
@property (assign,nonatomic) id<skySettingConnectionDataSource> setDataSource;  // 数据代理对象

///////////////////// Methods //////////////////////////
// 组件初始化
- (void)initializeComponents;
// 能否连接
- (void)controllerCanBeConnected:(BOOL)bFlag;

///////////////////// Ends /////////////////////////////

@end
