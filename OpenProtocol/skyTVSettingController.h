//
//  skyTVSettingController.h
//  OpenProtocol
//
//  Created by skyworth on 14-9-17.
//  Copyright (c) 2014年 skyworth. All rights reserved.
//

#import "skySecondLevelView.h"

// Protocol - Delegate
@protocol skyTVSettingControllerDelegate <NSObject>

// 连接通讯
- (void)connectToCmd:(NSString *)ipAddress Port:(NSInteger)nPort;
// 端口通讯
- (void)disConnectCmd;
// 20140917 by wh 设置当前控制器IP地址和端口号
- (void)setCurrentCmdIPAddress:(NSString *)ipAddress Port:(NSInteger)nPort;
// 屏幕全选
- (void)skyTVSettingSelectAllScreen;
// 屏幕全不选
- (void)skyTVSettingUnSelectAllScreen;
// 屏幕开启
- (void)skyTVSettingScreenOn;
// 屏幕关闭
- (void)skyTVSettingScreenOff;

@end

// Protocol - DataSource
@protocol skyTVSettingCOntrollerDataSource <NSObject>

// 获取命令控制器服务端IP地址
- (NSString *)getCurrnetCmdIPAddress;
// 获取命令控制器服务端端口号
- (NSInteger)getCurrentCmdPortNumber;

@end

// class skyTVSettingController
@interface skyTVSettingController : skySecondLevelView<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

/////////////////////// Property ///////////////////////////
@property (strong, nonatomic) IBOutlet UITableView *tvTableView;
@property (strong, nonatomic) UITextField *serverIP;
@property (strong, nonatomic) UITextField *serverPort;
@property (strong, nonatomic) UISwitch *connectionSwitcher;
@property (assign, nonatomic) id<skyTVSettingControllerDelegate> tvDelegate;        // 代理
@property (assign, nonatomic) id<skyTVSettingCOntrollerDataSource> tvDataSource;    // 数据代理

/////////////////////// Methods ////////////////////////////
// 组件初始化
- (void)initializeComponents;
// 能否连接
- (void)controllerCanBeConnected:(BOOL)bFlag;

/////////////////////// Ends ///////////////////////////////

@end
