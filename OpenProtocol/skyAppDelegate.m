//
//  skyAppDelegate.m
//  SkyworthSCXPJ
//
//  Created by skyworth on 13-8-6.
//  Copyright (c) 2013年 skyworth. All rights reserved.
//

#import "skyAppDelegate.h"

@implementation skyAppDelegate

@synthesize window = _window;
@synthesize navigation = _navigation;
@synthesize viewController = _viewController;
@synthesize theApp = _theApp;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[skyViewController alloc] initWithNibName:@"skyViewController_iPhone" bundle:nil];
    } else {
        self.viewController = [[skyViewController alloc] initWithNibName:@"skyViewController_iPad" bundle:nil];
    }
    
    // 应用程序状态对象
    self.theApp = [[skyAppStatus alloc] init];
    
    self.navigation = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    //[self.window addSubview:self.navigation.view];
    self.window.rootViewController = self.navigation;
    
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

// 程序进入后台 将运行数据保存下来
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // 数据存储处理
    [self.theApp appDefaultDatasSave];
    [self.viewController appStatusSave];
    // 网络连接调入后台
    [self.viewController.protocolAdapter adapterConnectEnterBackground];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    // 网络进入后台后 根据是否连接进行重连
    [self.viewController.protocolAdapter adapterReconnectToController];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
