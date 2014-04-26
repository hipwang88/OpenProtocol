//
//  skySCXWinPopover.h
//  SkyworthSCXPJ
//
//  Created by skyworth on 13-8-19.
//  Copyright (c) 2013年 skyworth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "skySignalView.h"

// protocol
@protocol skySCXWinPopoverDelegate <NSObject>

// 返回Table有多少个Cell
- (int)getTableViewCellNum;
// 返回Table中Cell的数据内容
- (NSMutableArray *)getTableViewCellData;
// 是否在开窗状态
- (BOOL)isOverlying;
// 全屏状态选择
- (void)fullScreen;
// 大画面分解
- (void)resolveScreen;
// 叠加开窗
- (void)enterSCXStatus;
// 退出叠加开窗状态
- (void)leaveSCXStatus;
// 添加子窗口
- (void)addSubWin;

@end

// class skySCXWinPopover
@interface skySCXWinPopover : UITableViewController

///////////////////// Property ////////////////////////
@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, assign) id<skySCXWinPopoverDelegate> delegatePop;        // 代理对象
@property (nonatomic, strong) skySignalView *signalView;

///////////////////// Methods /////////////////////////

///////////////////// Ends ////////////////////////////

@end
