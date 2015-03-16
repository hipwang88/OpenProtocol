//
//  skySettingConnection.m
//  SkyworthSCXPJ
//
//  Created by skyworth on 13-8-9.
//  Copyright (c) 2013年 skyworth. All rights reserved.
//

#import "skySettingConnection.h"
#import "skyTableButtonCell.h"

@interface skySettingConnection ()

// 控制器连接值改变
- (void)connectionSwitchValueChanged;

@end

@implementation skySettingConnection

@synthesize serverIP = _serverIP;
@synthesize serverPort = _serverPort;
@synthesize connectionSwitcher = _connectionSwitcher;
@synthesize setDelegate = _setDelegate;
@synthesize setDataSource = _setDataSource;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // 组件初始化
    [self initializeComponents];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        result = 2;
    }
    else if (section == 1)
    {
        result = 1;
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
                cell.textLabel.text = @"服务器IP";
                _serverIP.text = [_setDataSource getCurrentIPAddress];
                cell.accessoryView = self.serverIP;
                _serverIP.textColor = [UIColor blueColor];
                break;
            
            case 1:
                cell.textLabel.text = @"服务器端口";
                _serverPort.text = [[NSString alloc] initWithFormat:@"%ld",[_setDataSource getCurrentPortNumber]];
                cell.accessoryView = self.serverPort;
                _serverPort.textColor = [UIColor blueColor];
                break;
        }
    }
    else if (indexPath.section == 1)
    {
        cell.textLabel.text = @"连接控制器";
        cell.accessoryView = self.connectionSwitcher;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *result = @"";
    
    if (section == 0)
    {
        result = @"通讯连接";
    }

    return result;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSString *result = @"";
    
    if (section == 0)
    {
        // 20140917 by wh
        result = @"输入控制器IP地址、端口号";
    }
    
    return result;
}

// 20140918 by wh
#pragma mark - UITextFiled Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_serverIP resignFirstResponder];
    [_serverPort resignFirstResponder];
    return YES;
}

#pragma mark - Class Methods

// 组件初始化
- (void)initializeComponents
{
    // IP Address
    _serverIP = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 160, 30)];
    _serverIP.placeholder = @"172.16.16.119";
    _serverIP.text = [_setDataSource getCurrentIPAddress];
    //_serverIP.textAlignment = UITextAlignmentCenter;
    _serverIP.textAlignment = NSTextAlignmentLeft;
    _serverIP.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _serverIP.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _serverIP.delegate = self;
    // Server Port
    _serverPort = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 160, 30)];
    _serverPort.placeholder = @"5000";
    _serverPort.text = [NSString stringWithFormat:@"%ld",[_setDataSource getCurrentPortNumber]];
    //_serverPort.textAlignment = UITextAlignmentCenter;
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

// 控制器连接值改变
- (void)connectionSwitchValueChanged
{
    if (_connectionSwitcher.isOn)
    {
        NSLog(@"Connection On");
        NSString *ipAddress = _serverIP.text;
        int nPort = [_serverPort.text intValue];
        
        // 20140917 by wh 设置控制器IP和端口
        [_setDelegate setCurrentIPAddress:ipAddress Port:nPort];
        // 代理调用
        [_setDelegate connectToController:ipAddress Port:nPort];
    }
    else
    {
        NSLog(@"Connection Off");
        
        // 代理调用
        [_setDelegate disConnectController];
    }
}

@end
