//
//  skyExternWin.h
//  SkyworthSCXPJ
//
//  Created by skyworth on 13-8-14.
//  Copyright (c) 2013年 skyworth. All rights reserved.
//

#import "skyExternViewController.h"

// 扩展视图代理
@protocol skyExternWinDelegate <NSObject>

// 模拟信号新建代理函数
- (void)newSignalWithCVBS;
// 高清信号新建代理函数
- (void)newSignalWithHDMI;

@end

// class skyExternWin
@interface skyExternWin : skyExternViewController <UIGestureRecognizerDelegate>

//////////////// Property ///////////////////////
// 扩展视图代理id
@property (nonatomic, assign) id<skyExternWinDelegate> delegate;

//////////////// Methods ////////////////////////
// 隐藏视图控制器
- (void)hideExternWin;
// 还原说明文字
- (void)resetConfigLabel;

//////////////// Ends ///////////////////////////

@end
