//
//  skySettingSignal.h
//  SkyworthSCXPJ
//
//  Created by skyworth on 13-8-8.
//  Copyright (c) 2013年 skyworth. All rights reserved.
//

#import "skySecondLevelView.h"

// Protocol
@protocol skySettingSignalDataSource <NSObject>

// 获取板卡数目
- (NSInteger)getSignalCardNumbers;
// 设置输入板卡数目
- (void)setSignalCardNumber:(NSInteger)nNum;
// 获取板卡类型
- (NSInteger)getCardTypeAtIndex:(NSInteger)nIndex;
// 设置板卡类型
- (void)setCardTypeAtIndex:(NSInteger)nIndex withValue:(NSInteger)nType;
// 重置信号数据
- (void)resetSignalTypeData;

@end

// class skySettingSignal
@interface skySettingSignal : skySecondLevelView <UITableViewDelegate,UITableViewDataSource>

//////////////////////// Property ///////////////////////////
@property (strong, nonatomic) IBOutlet UITableView *signalTableView;            // 列表视图
@property (assign, nonatomic) id<skySettingSignalDataSource> myDataSource;      // 数据源代理对象

//////////////////////// Methods ///////////////////////////

//////////////////////// Ends //////////////////////////////

@end
