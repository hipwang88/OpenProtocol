//
//  skySubWinPopover.h
//  SkyworthSCXPJ
//
//  Created by skyworth on 13-9-3.
//  Copyright (c) 2013年 skyworth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "skySignalView.h"

// Protocol
@protocol skySubWinPopoverDelegate <NSObject>

// 关闭子窗口
- (void)deleteSubWindow;

@end

// class skySubWinPopover
@interface skySubWinPopover : UITableViewController

//////////////////////// Property /////////////////////////
@property (nonatomic, strong) NSMutableArray *tableData;                // 列表数据
@property (nonatomic, assign) id<skySubWinPopoverDelegate> popDelegate; // 控制器代理对象
@property (nonatomic, strong) skySignalView *signalView;                // 信号源切换视图

//////////////////////// Methods //////////////////////////

//////////////////////// Ends /////////////////////////////

@end
