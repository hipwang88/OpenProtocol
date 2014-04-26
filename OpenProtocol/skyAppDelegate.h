//
//  skyAppDelegate.h
//  SkyworthSCXPJ
//
//  Created by skyworth on 13-8-6.
//  Copyright (c) 2013年 skyworth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "skyViewController.h"
#import "skyAppStatus.h"

@interface skyAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navigation;
@property (strong, nonatomic) skyViewController *viewController;

// 应用程序状态对象
@property (strong, nonatomic) skyAppStatus *theApp;

@end
