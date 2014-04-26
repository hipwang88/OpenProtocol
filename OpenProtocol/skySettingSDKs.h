//
//  skySettingSDKs.h
//  SkyworthSCXPJ
//
//  Created by skyworth on 13-8-8.
//  Copyright (c) 2013年 skyworth. All rights reserved.
//

#import "skySecondLevelView.h"

// protocol
@protocol skySettingSDKsDelegate <NSObject>

// 获取协议类型
- (int)getProtocolType;
// 设置协议类型
- (void)setProtocolType:(int)nType;

@end

// class skySettingSDKs
@interface skySettingSDKs : skySecondLevelView<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *sdkTableView;
@property (strong, nonatomic) id<skySettingSDKsDelegate> sdkDelegate;

@end
