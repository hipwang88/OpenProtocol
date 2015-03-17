//
//  skyViewController.h
//  SkyworthSCXPJ
//
//  Created by skyworth on 13-8-6.
//  Copyright (c) 2013年 skyworth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "skyUnderPaint.h"
#import "skySettingMainView.h"
#import "skyModelView.h"
#import "skySignalView.h"
#import "skyExternWin.h"
#import "skySCXWin.h"
#import "skySubWin.h"
#import "skyProtocolAdapter.h"
#import "skySettingConnection.h"
#import "skySettingController.h"
#import "skySettingSignal.h"
#import "skySettingSDKs.h"
#import "skyTVSettingController.h"  // 20140917 by wh for TV Setting Controller
#import "skyTVProtocol.h"           // 20140917 by wh for TV Protocol

// class skyViewController
// delegate: skyUnderPaintDelegate --- 主控视图底图代理
//           skyExternWinDelegate --- 扩展视图代理
//           skySCXWinDelegate --- 漫游窗口代理
//           skySubWinDelegate --- 叠加窗口代理
//           skyModelViewDelegate --- 情景模式代理
//           skySettingConnectionDelegate --- 通讯设置代理
//           skySettingControllerDelegate --- 控制器设置代理
//           skySettingSDKsDelegate --- 协议设置代理
//           skyTVSettingControllerDelegate --- 机芯操作代理
@interface skyViewController : UIViewController<skyUnderPaintDelegate,skyExternWinDelegate,
    skySCXWinDelegate,skySubWinDelegate,skyModelViewDelegate,skySettingConnectionDelegate,
    skySettingControllerDelegate,skySettingSDKsDelegate,skyTVSettingControllerDelegate>
{
    skySCXWin *currentSCXWin;           // 当前控制的窗口
    skySubWin *currentSubWin;           // 当前叠加子窗
}

///////////////////////  Property  //////////////////////////
// 导航栏弹出视图
@property (strong, nonatomic) UIPopoverController *mySettingsPopover;                   // 设置按钮弹出视图
@property (strong, nonatomic) UIPopoverController *myModelPopover;                      // 情景模式按钮弹出视图
@property (strong, nonatomic) UIPopoverController *currentPopover;     
@property (strong, nonatomic) UINavigationController *settingNav;                       // 设置弹出视图导航控制器
@property (strong, nonatomic) UINavigationController *modelNav;                         // 情景模式弹出视图导航控制器
@property (strong, nonatomic) skySettingMainView *settingMainView;                      // 设置视图主页面
@property (strong, nonatomic) skyModelView *modelMainView;                              // 情景模式主页面

// 扩展视图
@property (strong, nonatomic) skyExternWin *externWin;                                  // 功能扩展视图界面

// 拼接主画面
@property (strong, nonatomic) skyUnderPaint *underPaint;                                // 拼接底视图
// 漫游窗口容器数组
@property (strong, nonatomic) NSMutableArray *scxWinContainer;                          // 漫游窗口容器
// 叠加子窗容器数组
@property (strong, nonatomic) NSMutableArray *subWinContainer;                          // 叠加子窗口容器
// 协议适配器
@property (strong, nonatomic) skyProtocolAdapter *protocolAdapter;                      // 协议适配器
// 控制机芯 20140917 by wh
@property (strong, nonatomic) skyTVProtocol *tvProtocol;                                // 机芯控制协议封装

///////////////////////  Methods  ///////////////////////////
// 状态保存
- (void)appStatusSave;

///////////////////////   Ends    ///////////////////////////

@end
