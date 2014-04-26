//
//  skySettingController.h
//  SkyworthSCXPJ
//
//  Created by skyworth on 13-8-8.
//  Copyright (c) 2013年 skyworth. All rights reserved.
//

#import "skySecondLevelView.h"

// Protocol - DataSource
@protocol skySettingControllerDataSource <NSObject>

// 获取当前屏幕行数
- (int)getCurrentScreenRows;
// 获取当前屏幕列数
- (int)getCurrentScreenColumns;
// 获取当前屏幕分辨率
- (int)getCurrentScreenResolution;
// 获取当前控制器类型
- (int)getCurrentControllerType;
// 获取当前掉电记忆状态
- (BOOL)getCurrentPowerStatus;
// 获取当前温控状态
- (BOOL)getCurrentTemperatureStatus;
// 获取当前边缘融合状态
- (BOOL)getCurrentStraightStatus;
// 获取当前蜂鸣器状态
- (BOOL)getCurrentBuzzerStatus;

@end

// Protocol - Delegate
@protocol skySettingControllerDelegate <NSObject>

// 设置当前控制器基本数据
- (void)setCurrentRow:(int)nRows Column:(int)nColumns Resolution:(int)nRes;
// 设置当前控制器类型
- (void)setCurrentControllerType:(int)nType;
// 设置当前掉电状态
- (void)setCurrentPowerStatus:(BOOL)bFlag;
// 设置当前温控状态
- (void)setCurrentTemperatureStatus:(BOOL)bFlag;
// 设置当前边缘融合状态
- (void)setCurrentStraightStatus:(BOOL)bFlag;
// 设置蜂鸣器状态
- (void)setCurrentBuzzerStatus:(BOOL)bFlag;

@end

// class skySettingController 
@interface skySettingController : skySecondLevelView <UITableViewDelegate,UITableViewDataSource>

/////////////////////// Property ///////////////////////////
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) UISwitch *switchPowerSave;                         // 掉电记忆
@property (nonatomic,strong) UISwitch *switchTemperature;                       // 温控功能
@property (nonatomic,strong) UISwitch *switchStraight;                          // 边缘融合
@property (nonatomic,strong) UISwitch *switchBuzzer;                            // 蜂鸣器开关

@property (nonatomic,assign) id<skySettingControllerDataSource> myDataSource;   // 数据代理对象
@property (nonatomic,assign) id<skySettingControllerDelegate> myDelegate;       // 代理对象

/////////////////////// Methods ////////////////////////////

/////////////////////// Ends ///////////////////////////////

@end
