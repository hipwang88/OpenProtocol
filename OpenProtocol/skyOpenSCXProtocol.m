//
//  skyOpenSCXProtocol.m
//  SkyworthSCXPJ
//
//  Created by skyworth on 13-9-6.
//  Copyright (c) 2013年 skyworth. All rights reserved.
//

#import "skyOpenSCXProtocol.h"
#import "AsyncSocket.h"

// Private
@interface skyOpenSCXProtocol()
{
    Byte m_nSendCmd[32];                    // 发送数组
    Byte m_nReceiveCmd[32];                 // 接收数组
    BOOL m_bConnection;                     // 连接状态
    BOOL m_bConnectedBefore;                // 以前是否连接
}

///////////////////// Property /////////////////////////
@property (nonatomic, strong) AsyncSocket *tcpSocket;               // Socket 对象
@property (nonatomic, strong) NSString *serviceAddress;             // 服务器地址
@property (nonatomic, assign) NSInteger nPort;                      // 服务器端口

///////////////////// Methods //////////////////////////
// 连接判断
- (BOOL)isConnected;
// 协议发送
- (void)sendCmd:(NSInteger)nLength;
// 协议接收
- (void)recevieCmd:(NSInteger)nLength;
// 获取发送码字符串
- (NSString *)sendStringWithLog:(NSString *)stringLog andByteCount:(NSInteger)nCount;

///////////////////// Ends /////////////////////////////

@end

@implementation skyOpenSCXProtocol

@synthesize tcpSocket = _tcpSocket;
@synthesize serviceAddress = _serviceAddress;
@synthesize nPort = _nPort;

#pragma mark - Public Methods
// 初始化开放协议SDK
- (id)initOpenSCXProtocol
{
    self = [super init];
    
    if (self)
    {
        // TCP Socket 对象初始
        _tcpSocket = [[AsyncSocket alloc] initWithDelegate:self];
        // 发送与接收数据初始化
        memset(m_nSendCmd, 0, 32);
        memset(m_nReceiveCmd, 0, 32);
        // 连接状态
        m_bConnection = NO;
        m_bConnectedBefore = NO;
    }
    
    return self;
}

// 连接TCP服务器
- (BOOL)connectTCPService:(NSString *)hostAddress andPort:(NSInteger)nPortNum
{
    NSError *error;
    BOOL isConnected = NO;
    m_bConnectedBefore = NO;
    
    // 在没有进入连接时尝试连接
    if (!m_bConnection)
    {
        isConnected = [_tcpSocket connectToHost:hostAddress onPort:nPortNum error:&error];
        
        // 连接情况判断
        if (!isConnected)
        {
            NSLog(@"TCP Connected error = %@",error);
            m_bConnection = NO;
        }
        else
        {
            // 变量赋值
            m_bConnection = YES;
            m_bConnectedBefore = YES;
            _serviceAddress = hostAddress;
            _nPort = nPortNum;
            // 设置运行循环模式
            [_tcpSocket setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
            
            LOG_MESSAGE([NSString stringWithFormat:@"Connect to %@ onPort %ld Successful!",hostAddress,nPortNum],nil);
        }
    }
    return m_bConnection;
}

// 端口TCP服务器
- (void)disconnectWithTCPService
{
    m_bConnection = NO;
    m_bConnectedBefore = NO;
    [_tcpSocket disconnect];
    LOG_MESSAGE(@"Close Socket Connect!");
}

// 服务器进入后台
- (void)serviceEnterBackground
{
    m_bConnection = NO;
    [_tcpSocket disconnect];
    LOG_MESSAGE(@"Socket Connect Enter Background");
}

// 服务器重连
- (void)reConnectToService
{
    NSError *error;
    BOOL isConnected = NO;
    
    // 在没有进入连接时尝试连接
    if (m_bConnectedBefore)
    {
        isConnected = [_tcpSocket connectToHost:_serviceAddress onPort:_nPort error:&error];
        
        // 连接情况判断
        if (!isConnected)
        {
            NSLog(@"TCP Connected error = %@",error);
            m_bConnection = NO;
        }
        else
        {
            // 变量赋值
            m_bConnection = YES;
            // 设置运行循环模式
            [_tcpSocket setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
            
            LOG_MESSAGE([NSString stringWithFormat:@"Reconnect to %@ onPort %ld Successful!",_serviceAddress,_nPort],nil);
        }
    }
}

#pragma mark - Private Methods
// 连接判断
- (BOOL)isConnected
{
    return m_bConnection;
}

// 协议发送
- (void)sendCmd:(NSInteger)nLength
{
    NSData *sendData;
    // 在连接可用情况下发送指令
    if ([self isConnected])
    {
        sendData = [[NSData alloc] initWithBytes:m_nSendCmd length:nLength];
        // 数据发送
        [_tcpSocket writeData:sendData withTimeout:-1 tag:0];
        // 命令延迟
        usleep(SKY_SEND_DELAY);
    }
    else
        LOG_MESSAGE(@"TCP Service can't reach");
}

// 协议接收
- (void)recevieCmd:(NSInteger)nLength
{
    NSData *recevieData;
    // 在连接情况下才能读取
    if ([self isConnected])
    {
        [_tcpSocket readDataToData:recevieData withTimeout:-1 tag:0];
        [recevieData getBytes:m_nReceiveCmd length:nLength];
    }
}

// 获取发送码字符串
- (NSString *)sendStringWithLog:(NSString *)stringLog andByteCount:(NSInteger)nCount
{
    NSString *stringResult;
    NSData *sendDatas = [[NSData alloc] initWithBytes:m_nSendCmd length:nCount];
    
    stringResult = [NSString stringWithFormat:@"LCD-Controller12-V5 开放协议->>>[%@ : %@]",stringLog,sendDatas];
    
    return stringResult;
}

#pragma mark - Protocols
/*******************************************************/
// 1.控制器设置
- (void)openSCXControllerSetRow:(NSInteger)nRow Column:(NSInteger)nColumn Resolution:(NSInteger)nRes
{
    // 协议命令
    memset(m_nSendCmd, 0, sizeof(m_nSendCmd));
    m_nSendCmd[0] = 0x80;
    m_nSendCmd[1] = 0xD7;
    m_nSendCmd[2] = 0x24;
    m_nSendCmd[3] = nRow;
    m_nSendCmd[4] = nColumn;
    m_nSendCmd[5] = nRes;
    m_nSendCmd[6] = 0xFF;
    m_nSendCmd[7] = 0xFF;
    // 协议发送
    [self sendCmd:8];
    
    // 信息
    LOG_MESSAGE([self sendStringWithLog:[NSString stringWithFormat:@"InitController Row:%ld Column:%ld Resolution:%ld",nRow,nColumn,nRes] andByteCount:8],nil);
}

// 2.蜂鸣器开关
- (void)openSCXBuzzerStatus:(BOOL)bFlag
{
    // 协议命令
    memset(m_nSendCmd, 0, sizeof(m_nSendCmd));
    m_nSendCmd[0] = 0x80;
    m_nSendCmd[1] = 0x84;
    m_nSendCmd[2] = bFlag == YES ? 0x01 : 0x02;
    m_nSendCmd[3] = 0xFF;
    m_nSendCmd[4] = 0xFF;
    m_nSendCmd[5] = 0xFF;
    m_nSendCmd[6] = 0xFF;
    m_nSendCmd[7] = 0xFF;
    // 协议发送
    [self sendCmd:8];
    
    // 信息
    LOG_MESSAGE([self sendStringWithLog:@"蜂鸣器开关" andByteCount:8],nil);
}

// 3.掉电记忆开关
- (void)openSCXPowerMemoryStatus:(BOOL)bFlag
{
    // 协议命令
    memset(m_nSendCmd, 0, sizeof(m_nSendCmd));
    m_nSendCmd[0] = 0x80;
    m_nSendCmd[1] = 0x87;
    m_nSendCmd[2] = bFlag == YES ? 0x01 : 0x02;
    m_nSendCmd[3] = 0xFF;
    m_nSendCmd[4] = 0xFF;
    m_nSendCmd[5] = 0xFF;
    m_nSendCmd[6] = 0xFF;
    m_nSendCmd[7] = 0xFF;
    // 协议发送
    [self sendCmd:8];
    
    // 信息
    LOG_MESSAGE([self sendStringWithLog:@"掉电记忆" andByteCount:8],nil);
}

// 4.温控开关
- (void)openSCXTemperatureStatus:(BOOL)bFlag
{
    // 协议命令
    memset(m_nSendCmd, 0, sizeof(m_nSendCmd));
    m_nSendCmd[0] = 0x80;
    m_nSendCmd[1] = 0x88;
    m_nSendCmd[2] = bFlag == YES ? 0x01 : 0x02;
    m_nSendCmd[3] = 0xFF;
    m_nSendCmd[4] = 0xFF;
    m_nSendCmd[5] = 0xFF;
    m_nSendCmd[6] = 0xFF;
    m_nSendCmd[7] = 0xFF;
    // 协议发送
    [self sendCmd:8];
    
    // 信息
    LOG_MESSAGE([self sendStringWithLog:@"温控开关" andByteCount:8],nil);
}

// 5.边缘屏蔽开关
- (void)openSCXStraightStatus:(BOOL)bFlag
{
    // 协议命令
    memset(m_nSendCmd, 0, sizeof(m_nSendCmd));
    m_nSendCmd[0] = 0x80;
    m_nSendCmd[1] = 0x88;
    m_nSendCmd[2] = bFlag == YES ? 0x03 : 0x04;
    m_nSendCmd[3] = 0xFF;
    m_nSendCmd[4] = 0xFF;
    m_nSendCmd[5] = 0xFF;
    m_nSendCmd[6] = 0xFF;
    m_nSendCmd[7] = 0xFF;
    // 协议发送
    [self sendCmd:8];
    
    // 信息
    LOG_MESSAGE([self sendStringWithLog:@"边缘屏蔽开关" andByteCount:8],nil);
}

// 6.情景新建 - CVBS
- (void)openSCXModelNewWithCVBS
{
    // 协议命令
    memset(m_nSendCmd, 0, sizeof(m_nSendCmd));
    m_nSendCmd[0] = 0x85;
    m_nSendCmd[1] = 0x03;
    //m_nSendCmd[1] = 0x05;
    m_nSendCmd[2] = 0x32;
    m_nSendCmd[3] = 0xFF;
    m_nSendCmd[4] = 0xFF;
    m_nSendCmd[5] = 0xFF;
    m_nSendCmd[6] = 0xFF;
    m_nSendCmd[7] = 0xFF;
    // 协议发送
    [self sendCmd:8];
    
    // 信息
    LOG_MESSAGE([self sendStringWithLog:@"CVBS新建" andByteCount:8],nil);
}

// 7.情景新建 - HDMI
- (void)openSCXModelNewWithHDMI
{
    // 协议命令
    memset(m_nSendCmd, 0, sizeof(m_nSendCmd));
    m_nSendCmd[0] = 0x85;
    m_nSendCmd[1] = 0x03;
    //m_nSendCmd[1] = 0x05;
    m_nSendCmd[2] = 0x33;
    m_nSendCmd[3] = 0xFF;
    m_nSendCmd[4] = 0xFF; 
    m_nSendCmd[5] = 0xFF;
    m_nSendCmd[6] = 0xFF;
    m_nSendCmd[7] = 0xFF;
    // 协议发送
    [self sendCmd:8];
    
    // 信息
    LOG_MESSAGE([self sendStringWithLog:@"HDMI新建" andByteCount:8],nil);
}

// 8.情景保存
- (void)openSCXSaveModelAtIndex:(NSInteger)nIndex
{
    // 协议命令
    memset(m_nSendCmd, 0, sizeof(m_nSendCmd));
    m_nSendCmd[0] = 0x85;
    m_nSendCmd[1] = 0x02;
    m_nSendCmd[2] = nIndex;
    m_nSendCmd[3] = 0xFF;
    m_nSendCmd[4] = 0xFF;
    m_nSendCmd[5] = 0xFF;
    m_nSendCmd[6] = 0xFF;
    m_nSendCmd[7] = 0xFF;
    // 协议发送
    [self sendCmd:8];
    
    // 信息
    LOG_MESSAGE([self sendStringWithLog:[NSString stringWithFormat:@"情景%ld保存",nIndex] andByteCount:8],nil);
}

// 9.情景加载
- (void)openSCXLoadModelAtIndex:(NSInteger)nIndex
{
    // 协议命令
    memset(m_nSendCmd, 0, sizeof(m_nSendCmd));
    m_nSendCmd[0] = 0x85;
    m_nSendCmd[1] = 0x01;
    m_nSendCmd[2] = nIndex;
    m_nSendCmd[3] = 0xFF;
    m_nSendCmd[4] = 0xFF;
    m_nSendCmd[5] = 0xFF;
    m_nSendCmd[6] = 0xFF;
    m_nSendCmd[7] = 0xFF;
    // 协议发送
    [self sendCmd:8];
    
    // 信息
    LOG_MESSAGE([self sendStringWithLog:[NSString stringWithFormat:@"情景%ld加载",nIndex] andByteCount:8],nil);
}

// 10.情景删除
- (void)openSCXDeleteModelAtIndex:(NSInteger)nIndex
{
    // 协议命令
    memset(m_nSendCmd, 0, sizeof(m_nSendCmd));
    m_nSendCmd[0] = 0x85;
    m_nSendCmd[1] = 0x04;
    m_nSendCmd[2] = nIndex;
    m_nSendCmd[3] = 0xFF;
    m_nSendCmd[4] = 0xFF;
    m_nSendCmd[5] = 0xFF;
    m_nSendCmd[6] = 0xFF;
    m_nSendCmd[7] = 0xFF;
    // 协议发送
    [self sendCmd:8];
    
    // 信息
    LOG_MESSAGE([self sendStringWithLog:[NSString stringWithFormat:@"情景%ld删除",nIndex] andByteCount:8],nil);
}

// 11.普通窗口信号切换
- (void)openSCXSignalSwitchSCXWin:(NSInteger)nWinID ofType:(NSInteger)nSrcType toChannel:(NSInteger)nSrcPath
{
    int nType;
    NSString *stringType;
    // 类型判断
    switch (nSrcType) {
        case 0: // HDMI
        case 1: // DVI
        case 2: // VGA
            nType = 0x33;
            stringType = @"HDMI";
            break;
            
        case 3: // CVBS
            nType = 0x32;
            stringType = @"CVBS";
            break;
    }
    // 协议命令
    memset(m_nSendCmd, 0, sizeof(m_nSendCmd));
    m_nSendCmd[0] = 0x81;
    m_nSendCmd[1] = 0xD0;
    m_nSendCmd[2] = nType;
    m_nSendCmd[3] = nSrcPath;
    m_nSendCmd[4] = nWinID;
    m_nSendCmd[5] = 0xFF;
    m_nSendCmd[6] = 0xFF;
    m_nSendCmd[7] = 0xFF;
    // 协议发送
    [self sendCmd:8];
    
    // 信息
    LOG_MESSAGE([self sendStringWithLog:[NSString stringWithFormat:@"窗口%ld 切换信号 Src:%@ Path:%ld",nWinID,stringType,nSrcPath] andByteCount:8],nil);
}

// 12.叠加底图窗口信号切换
- (void)openSCXSignalSwitchOpenUnderWin:(NSInteger)nWinID ofType:(NSInteger)nSrcType toChannel:(NSInteger)nSrcPath
{
    int nType;
    NSString *stringType;
    // 类型判断
    switch (nSrcType) {
        case 0: // HDMI
        case 1: // DVI
        case 2: // VGA
            nType = 0x33;
            stringType = @"HDMI";
            break;
            
        case 3: // CVBS
            nType = 0x32;
            stringType = @"CVBS";
            break;
    }
    // 协议命令
    memset(m_nSendCmd, 0, sizeof(m_nSendCmd));
    m_nSendCmd[0] = 0x90;
    m_nSendCmd[1] = 0x82;
    m_nSendCmd[2] = 0x94;
    m_nSendCmd[3] = 0x83;
    m_nSendCmd[4] = nWinID;
    m_nSendCmd[5] = nType;
    m_nSendCmd[6] = nSrcPath;
    m_nSendCmd[7] = 0xFF;
    m_nSendCmd[8] = 0xFF;
    // 协议发送
    [self sendCmd:9];
    
    // 信息
    LOG_MESSAGE([self sendStringWithLog:[NSString stringWithFormat:@"底图%ld 切换信号 Src:%@ Path:%ld",nWinID,stringType,nSrcPath] andByteCount:9],nil);
}

// 13.叠加子窗口信号切换
- (void)openSCXSignalSwitchSubWin:(NSInteger)nSubID ofType:(NSInteger)nSrcType toChannel:(NSInteger)nSrcPath
{
    int nType;
    NSString *stringType;
    // 类型判断
    switch (nSrcType) {
        case 0: // HDMI
        case 1: // DVI
        case 2: // VGA
            nType = 0x33;
            stringType = @"HDMI";
            break;
            
        case 3: // CVBS
            nType = 0x32;
            stringType = @"CVBS";
            break;
    }

    // 协议命令
    memset(m_nSendCmd, 0, sizeof(m_nSendCmd));
    m_nSendCmd[0] = 0x90;
    m_nSendCmd[1] = 0x82;
    m_nSendCmd[2] = 0x94;
    m_nSendCmd[3] = 0x05;
    m_nSendCmd[4] = nSubID;
    m_nSendCmd[5] = nType;
    m_nSendCmd[6] = nSrcPath;
    m_nSendCmd[7] = 0xFF;
    m_nSendCmd[8] = 0xFF;
    // 协议发送
    [self sendCmd:9];
    
    // 信息
    LOG_MESSAGE([self sendStringWithLog:[NSString stringWithFormat:@"叠加子窗%ld 切换信号 Src:%@ Path:%ld",nSubID,stringType,nSrcPath] andByteCount:9],nil);
}

// 14.大画面拼接
- (void)openSCXSpliceSCXWin:(NSInteger)nWinID StartPanel:(NSInteger)nStart VScreen:(NSInteger)nVCount HScreen:(NSInteger)nHCount ofType:(NSInteger)nSrcType toChannel:(NSInteger)nSrcPath
{
    int nType;
    // 判断类型
    switch (nSrcType)
    {
        case 0:
        case 1:
        case 2:
            nType = 0x33;
            break;
            
        case 3:
            nType = 0x32;
            break;
    }
    // 协议命令
    memset(m_nSendCmd, 0, sizeof(m_nSendCmd));
    m_nSendCmd[0] = 0x81;
    m_nSendCmd[1] = 0xD6;
    m_nSendCmd[2] = nStart;
    m_nSendCmd[3] = nHCount;
    m_nSendCmd[4] = nVCount;
    m_nSendCmd[5] = nWinID;
    m_nSendCmd[6] = nType;
    m_nSendCmd[7] = nSrcPath;
    // 协议发送
    [self sendCmd:8];
    
    // 信息
    LOG_MESSAGE([self sendStringWithLog:[NSString stringWithFormat:@"窗口%ld 拼接 开始:%ld 横向跨屏:%ld 纵向跨屏:%ld",nWinID,nStart,nHCount,nVCount] andByteCount:8],nil);
}

// 15.大画面分解
- (void)openSCXResolveSCXWin:(NSInteger)nWinID
{
    // 协议命令
    memset(m_nSendCmd, 0, sizeof(m_nSendCmd));
    m_nSendCmd[0] = 0x81;
    m_nSendCmd[1] = 0xD7;
    m_nSendCmd[2] = nWinID;
    m_nSendCmd[3] = 0x01;
    m_nSendCmd[4] = 0xFF;
    m_nSendCmd[5] = 0xFF;
    m_nSendCmd[6] = 0xFF;
    m_nSendCmd[7] = 0xFF;
    // 协议发送
    [self sendCmd:8];
    
    // 信息
    LOG_MESSAGE([self sendStringWithLog:[NSString stringWithFormat:@"窗口%ld画面分解",nWinID] andByteCount:8],nil);

}

// 16.进入叠加开窗
- (void)openSCXEnterOpenStatus:(NSInteger)nWinID ofType:(NSInteger)nSrcType toChannel:(NSInteger)nSrcPath
{
    int nType;
    // 判断类型
    switch (nSrcType)
    {
        case 0:
        case 1:
        case 2:
            nType = 0x33;
            break;
            
        case 3:
            nType = 0x32;
            break;
    }
    // 协议命令
    memset(m_nSendCmd, 0, sizeof(m_nSendCmd));
    m_nSendCmd[0] = 0x90;
    m_nSendCmd[1] = 0x81;
    m_nSendCmd[2] = nWinID;
    m_nSendCmd[3] = nType;
    m_nSendCmd[4] = nSrcPath;
    m_nSendCmd[5] = 0xFF;
    m_nSendCmd[6] = 0xFF;
    m_nSendCmd[7] = 0xFF;
    m_nSendCmd[8] = 0xFF;
    // 协议发送
    [self sendCmd:9];
    
    // 信息
    LOG_MESSAGE([self sendStringWithLog:[NSString stringWithFormat:@"窗口%ld进入叠加状态",nWinID] andByteCount:9],nil);
}

// 17.退出叠加开窗
- (void)openSCXLeaveOpenStatus:(NSInteger)nWinID ofType:(NSInteger)nSrcType toChannel:(NSInteger)nSrcPath
{
    int nType;
    // 判断类型
    switch (nSrcType)
    {
        case 0:
        case 1:
        case 2:
            nType = 0x33;
            break;
            
        case 3:
            nType = 0x32;
            break;
    }
    // 协议命令
    memset(m_nSendCmd, 0, sizeof(m_nSendCmd));
    m_nSendCmd[0] = 0x90;
    m_nSendCmd[1] = 0x83;
    m_nSendCmd[2] = nWinID;
    m_nSendCmd[3] = nType;
    m_nSendCmd[4] = nSrcPath;
    m_nSendCmd[5] = 0xFF;
    m_nSendCmd[6] = 0xFF;
    m_nSendCmd[7] = 0xFF;
    m_nSendCmd[8] = 0xFF;
    // 协议发送
    [self sendCmd:9];
    
    // 信息
    LOG_MESSAGE([self sendStringWithLog:[NSString stringWithFormat:@"窗口%ld退出叠加状态",nWinID] andByteCount:9],nil);
}

// 18.添加子窗口
- (void)openSCXAddSubWin:(NSInteger)nSubID ofType:(NSInteger)nSrcType toChannel:(NSInteger)nSrcPath
{
    int nType;
    // 判断类型
    switch (nSrcType)
    {
        case 0:
        case 1:
        case 2:
            nType = 0x33;
            break;
            
        case 3:
            nType = 0x32;
            break;
    }
    // 协议命令
    memset(m_nSendCmd, 0, sizeof(m_nSendCmd));
    m_nSendCmd[0] = 0x90;
    m_nSendCmd[1] = 0x82;
    m_nSendCmd[2] = 0x94;
    m_nSendCmd[3] = 0x04;
    m_nSendCmd[4] = nSubID;
    m_nSendCmd[5] = nType;
    m_nSendCmd[6] = nSrcPath;
    m_nSendCmd[7] = 0xFF;
    m_nSendCmd[8] = 0xFF;
    // 协议发送
    [self sendCmd:9];
    
    // 信息
    LOG_MESSAGE([self sendStringWithLog:[NSString stringWithFormat:@"添加子窗口%ld",nSubID] andByteCount:9],nil);
}

// 19.关闭子窗口
- (void)openSCXDeleteSubWin:(NSInteger)nSubID ofType:(NSInteger)nSrcType toChannel:(NSInteger)nSrcPath
{
    // 协议命令
    memset(m_nSendCmd, 0, sizeof(m_nSendCmd));
    m_nSendCmd[0] = 0x90;
    m_nSendCmd[1] = 0x82;
    m_nSendCmd[2] = 0x94;
    m_nSendCmd[3] = 0x02;
    m_nSendCmd[4] = nSubID;
    m_nSendCmd[5] = 0xFF;
    m_nSendCmd[6] = 0xFF;
    m_nSendCmd[7] = 0xFF;
    m_nSendCmd[8] = 0xFF;
    // 协议发送
    [self sendCmd:9];
    
    // 信息
    LOG_MESSAGE([self sendStringWithLog:[NSString stringWithFormat:@"关闭子窗口%ld",nSubID] andByteCount:9],nil);
}

// 20.移动子窗口
- (void)openSCXMoveSubWin:(NSInteger)nSubID StartX:(NSInteger)nStartX StartY:(NSInteger)nStartY
{
    // 协议命令
    memset(m_nSendCmd, 0, sizeof(m_nSendCmd));
    m_nSendCmd[0] = 0x90;
    m_nSendCmd[1] = 0x82;
    m_nSendCmd[2] = 0xD5;
    m_nSendCmd[3] = 0x10;
    m_nSendCmd[4] = nSubID;
    m_nSendCmd[5] = nStartX / 256;
    m_nSendCmd[6] = nStartX % 256;
    m_nSendCmd[7] = nStartY / 256;
    m_nSendCmd[8] = nStartY % 256;
    // 协议发送
    [self sendCmd:9];
    
    // 信息
    LOG_MESSAGE([self sendStringWithLog:[NSString stringWithFormat:@"子窗%ld 移动 X:%ld Y:%ld",nSubID,nStartX,nStartY] andByteCount:9],nil);
}

// 21.缩放子窗口
- (void)openSCXResizeSubWin:(NSInteger)nSubID WinWidth:(NSInteger)nWidth WinHeight:(NSInteger)nHeight
{
    // 协议命令
    memset(m_nSendCmd, 0, sizeof(m_nSendCmd));
    m_nSendCmd[0] = 0x90;
    m_nSendCmd[1] = 0x82;
    m_nSendCmd[2] = 0xD5;
    m_nSendCmd[3] = 0x11;
    m_nSendCmd[4] = nSubID;
    m_nSendCmd[5] = nWidth / 256;
    m_nSendCmd[6] = nWidth % 256;
    m_nSendCmd[7] = nHeight / 256;
    m_nSendCmd[8] = nHeight % 256;
    // 协议发送
    [self sendCmd:9];
    
    // 信息
    LOG_MESSAGE([self sendStringWithLog:[NSString stringWithFormat:@"子窗%ld 缩放 Width:%ld Height:%ld",nSubID,nWidth,nHeight] andByteCount:9],nil);
}

/*******************************************************/

@end
