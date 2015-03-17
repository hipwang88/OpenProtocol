//
//  skyExternWin.m
//  SkyworthSCXPJ
//
//  Created by skyworth on 13-8-14.
//  Copyright (c) 2013年 skyworth. All rights reserved.
//

#import "skyExternWin.h"

@interface skyExternWin ()

///////////////// Property //////////////////////
// 功能说明Label
@property (strong, nonatomic) UILabel *configLabel;
// CVBS新建按钮
@property (strong, nonatomic) UIButton *cvbsNew;
// 高清信号新建按钮
@property (strong, nonatomic) UIButton *hdmiNew;

///////////////// Methods ///////////////////////
// 初始化功能部件
- (void)initializeComponets;
// CVBS新建按钮按下消息
- (void)cvbsBtnClickHandle:(id)sender;
// HDMI新建按钮按下消息
- (void)hdmiBtnClickHandle:(id)sender;

///////////////// Ends //////////////////////////

@end

@implementation skyExternWin

@synthesize configLabel = _configLabel;
@synthesize cvbsNew = _cvbsNew;
@synthesize hdmiNew = _hdmiNew;
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.sideAnimationDuration = 0.3f;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view
    self.contentView.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.6];
    
    // 初始化
    [self initializeComponets];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)hideExternWin
{
    [self dismissController:self.view];
}

// 初始化功能布局
- (void)initializeComponets
{
    NSInteger frameWidth = 1024;
    // 功能说明
    CGRect labelFrame = CGRectMake(20, 0, 700, 44);
    _configLabel = [[UILabel alloc] initWithFrame:labelFrame];
    //_configLabel.textAlignment = UITextAlignmentLeft;
    _configLabel.textAlignment = NSTextAlignmentLeft;
    _configLabel.backgroundColor = [UIColor clearColor];
    _configLabel.textColor = [UIColor whiteColor];
    _configLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    //_configLabel.text = @"功能扩展视图，请根据需要点击右侧按钮！";
    _configLabel.text = NSLocalizedString(@"ExFunctionView", nil);
    
    // 模拟信号新建
    CGRect cvbsBtnFrame = CGRectMake(frameWidth-110, 2, 40, 40);
    _cvbsNew = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cvbsNew setFrame:cvbsBtnFrame];
    [self.cvbsNew setBackgroundImage:[UIImage imageNamed:@"CVBSNor"] forState:UIControlStateNormal];
    [self.cvbsNew setBackgroundImage:[UIImage imageNamed:@"CVBSDown"] forState:UIControlStateHighlighted];
    [self.cvbsNew addTarget:self action:@selector(cvbsBtnClickHandle:) forControlEvents:UIControlEventTouchUpInside];
    
    // 高清信号新建
    CGRect hdmiBtnFrame = CGRectMake(frameWidth-60, 2, 40, 40);
    _hdmiNew = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.hdmiNew setFrame:hdmiBtnFrame];
    [self.hdmiNew setBackgroundImage:[UIImage imageNamed:@"HDMINor"] forState:UIControlStateNormal];
    [self.hdmiNew setBackgroundImage:[UIImage imageNamed:@"HDMIDown"] forState:UIControlStateHighlighted];
    [self.hdmiNew addTarget:self action:@selector(hdmiBtnClickHandle:) forControlEvents:UIControlEventTouchUpInside];
    
    // 加入手势还原说明文字
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resetConfigLabel)];
    tap.delegate = self;
    
    // 将组件加入视图
    [self.view addSubview:_configLabel];
    [self.view addSubview:_cvbsNew];
    [self.view addSubview:_hdmiNew];
    [self.view addGestureRecognizer:tap];
}

// 还原说明文字
- (void)resetConfigLabel
{
    //_configLabel.text = @"功能扩展视图，请根据需要点击右侧按钮！";
    _configLabel.text = NSLocalizedString(@"ExFunctionView", nil);
}

#pragma mark - UIGestureRecognizerDelegate
// UITapGestureRecgnizer
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }
    return YES;
}

#pragma mark - Message Dump
// CVBS新建按钮按下消息
- (void)cvbsBtnClickHandle:(id)sender
{
    //_configLabel.text = @"模拟信号新建：所有窗口以模拟信号一对一输出。";
    _configLabel.text = NSLocalizedString(@"ExFunctionInfo_CVBS", nil);
    // 通过代理对象发送模拟新建功能
    [_delegate newSignalWithCVBS];
}

// HDMI新建按钮按下消息
- (void)hdmiBtnClickHandle:(id)sender
{
    //_configLabel.text = @"高清信号新建：所有窗口以高清数字信号一对一输出。";
    _configLabel.text = NSLocalizedString(@"ExFunctionInfo_HDMI", nil);
    // 通过代理对象发送高清新建功能
    [_delegate newSignalWithHDMI];
}

@end
