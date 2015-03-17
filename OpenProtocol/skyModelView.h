//
//  skyModelView.h
//  SkyworthSCXPJ
//
//  Created by skyworth on 13-8-6.
//  Copyright (c) 2013年 skyworth. All rights reserved.
//

#import <UIKit/UIKit.h>

// protocol DataSource
@protocol skyModelViewDataSource <NSObject>

// 获取运行截图
- (UIImage *)getModelImageAtIndex:(NSInteger)nIndex;
// 获取保存日期
- (NSString *)getModelSaveDateAtIndex:(NSInteger)nIndex;
// 保存情景模式状态
- (void)saveModelDataSource;
// 确认情景模式是否可用
- (BOOL)isModelCanBeUsedAtIndex:(NSInteger)nIndex;

@end

// protocol
@protocol skyModelViewDelegate <NSObject>

// 加载情景模式
- (void)loadModelStatus:(int)nIndex;
// 保存情景模式
- (void)shootAppToImage:(int)nIndex;
// 删除情景模式
- (void)removeModelImage:(int)nIndex;

@end

// class skyModelView
@interface skyModelView : UITableViewController

///////////////////// Property ////////////////////////
@property (nonatomic, strong) NSMutableArray *tableData;                // 列表数据
@property (nonatomic, strong) NSMutableArray *modelSaveDate;            // 模式保存日期
@property (nonatomic, assign) id<skyModelViewDelegate> modelDelegate;   // 模式代理对象
@property (nonatomic, assign) id<skyModelViewDataSource> modelDataSource;// 数据代理对象

///////////////////// Methods /////////////////////////
// 情景模式状态保存
- (void)saveModelStatusToFile;

///////////////////// Ends ////////////////////////////

@end
