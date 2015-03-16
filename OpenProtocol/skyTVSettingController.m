//
//  skyTVSettingController.m
//  OpenProtocol
//
//  Created by skyworth on 14-9-17.
//  Copyright (c) 2014年 skyworth. All rights reserved.
//

#import "skyTVSettingController.h"

@interface skyTVSettingController ()

///////////////////////// Property ///////////////////////////

///////////////////////// Methods ////////////////////////////
// 控制器连接值改变
- (void)connectionSwitchValueChanged;
// 屏幕全选
- (void)selectAllScreen;
// 屏幕全不选
- (void)unselectAllScreen;
// 屏幕开启
- (void)screenOn;
// 屏幕关闭
- (void)screenOff;

///////////////////////// Ends ////////////////////////////////

@end

@implementation skyTVSettingController

@synthesize tvTableView = _tvTableView;
@synthesize serverIP = _serverIP;
@synthesize serverPort = _serverPort;
@synthesize connectionSwitcher = _connectionSwitcher;
@synthesize tvDelegate = _tvDelegate;
@synthesize tvDataSource = _tvDataSource;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initializeComponents];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 控屏页面出现，发送全选指令
    [self selectAllScreen];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    // 控屏页面消失，发送全不选指令
    //[self unselectAllScreen];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_serverIP resignFirstResponder];
    [_serverPort resignFirstResponder];
}

#pragma mark - Private Methods
// 控制器连接值改变
- (void)connectionSwitchValueChanged
{
    if (_connectionSwitcher.isOn)
    {
        NSLog(@"Connection On");
        NSString *ipAddress = _serverIP.text;
        int nPort = [_serverPort.text intValue];
        
        // 20140917 by wh 设置控制器IP和端口
        [_tvDelegate setCurrentCmdIPAddress:ipAddress Port:nPort];
        // 代理调用
        [_tvDelegate connectToCmd:ipAddress Port:nPort];
        // 发送全选指令
        [self selectAllScreen];
    }
    else
    {
        NSLog(@"Connection Off");
        
        // 发送全不选指令
        [self unselectAllScreen];
        // 代理调用
        [_tvDelegate disConnectCmd];
    }
}

// 屏幕全选
- (void)selectAllScreen
{
    NSLog(@"屏幕全选");
    [_tvDelegate skyTVSettingSelectAllScreen];
}

// 屏幕全不选
- (void)unselectAllScreen
{
    NSLog(@"屏幕全不选");
    [_tvDelegate skyTVSettingUnSelectAllScreen];
}

// 屏幕开启
- (void)screenOn
{
    NSLog(@"屏幕开启");
    [_tvDelegate skyTVSettingScreenOn];
}

// 屏幕关闭
- (void)screenOff
{
    NSLog(@"屏幕关闭");
    [_tvDelegate skyTVSettingScreenOff];
}

#pragma mark - Public Methods
// 组件初始化
- (void)initializeComponents
{
    // IP Address
    _serverIP = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 160, 30)];
    _serverIP.placeholder = @"172.16.16.114";
    _serverIP.text = [_tvDataSource getCurrnetCmdIPAddress];
    _serverIP.textAlignment = NSTextAlignmentLeft;
    _serverIP.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _serverIP.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _serverIP.delegate = self;
    // Server Port
    _serverPort = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 160, 30)];
    _serverPort.placeholder = @"5000";
    _serverPort.text = [NSString stringWithFormat:@"%ld",(long)[_tvDataSource getCurrentCmdPortNumber]];
    _serverIP.textAlignment = NSTextAlignmentLeft;
    _serverPort.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _serverPort.keyboardType = UIKeyboardTypeNumberPad;
    _serverPort.delegate = self;
    // Connection Switcher
    _connectionSwitcher = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 160, 30)];
    _connectionSwitcher.on = NO;
    [_connectionSwitcher addTarget:self action:@selector(connectionSwitchValueChanged) forControlEvents:UIControlEventValueChanged];
}

// 能否连接
- (void)controllerCanBeConnected:(BOOL)bFlag
{
    if (!bFlag)
    {
        NSLog(@"Can not Connect");
        [_connectionSwitcher setOn:NO];
    }
}

#pragma mark - TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger result = 0;
    
    if (section == 0)
    {
        result = 3;
    }
    else if (section == 1)
    {
        result = 2;
    }
    
    return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SettingConnection";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case 0:
                _serverIP.text = [_tvDataSource getCurrnetCmdIPAddress];
                _serverIP.textColor = [UIColor blueColor];
                cell.textLabel.text = @"控制器IP";
                cell.accessoryView = _serverIP;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
                
            case 1:
                _serverPort.text = [NSString stringWithFormat:@"%ld",[_tvDataSource getCurrentCmdPortNumber]];
                _serverPort.textColor = [UIColor blueColor];
                cell.textLabel.text = @"控制器端口";
                cell.accessoryView = _serverPort;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
                
            case 2:
                cell.textLabel.text = @"连接命令控制器";
                cell.accessoryView = _connectionSwitcher;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
        }
    }
    else if (indexPath.section == 1)
    {
        switch (indexPath.row)
        {
            case 0:
                cell.textLabel.text = @"屏幕开机";
                cell.textLabel.textColor = [UIColor colorWithRed:0.9 green:0.1 blue:0.0 alpha:1.0];
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                //cell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
                
            case 1:
                cell.textLabel.text = @"屏幕关机";
                cell.textLabel.textColor = [UIColor colorWithRed:0.9 green:0.1 blue:0.0 alpha:1.0];
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                //cell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
        }
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *result = @"";
    
    if (section == 0)
    {
        result = @"命令控制器网络设置";
    }
    else if (section == 1)
    {
        result = @"屏幕开关机操作";
    }
    
    return result;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSString *result = @"";
    
    if (section == 0)
    {
        result = @"输入命令控制器IP地址和端口号进行连接";
    }
    else if (section == 1)
    {
        result = @"请点击进行操作";
    }
    
    return result;
}

#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        switch (indexPath.row)
        {
            case 0: // 屏幕开启
                // 开启屏幕
                [self screenOn];
                break;
                
            case 1: // 屏幕关闭
                // 关闭屏幕
                [self screenOff];
                break;
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_serverIP resignFirstResponder];
    [_serverPort resignFirstResponder];
    return true;
}

@end
