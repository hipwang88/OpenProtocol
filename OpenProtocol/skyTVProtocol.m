//
//  skyTVProtocol.m
//  OpenProtocol
//
//  Created by skyworth on 14-9-17.
//  Copyright (c) 2014年 skyworth. All rights reserved.
//

#import "skyTVProtocol.h"
#import "AsyncSocket.h"

// Private
@interface skyTVProtocol ()<AsyncSocketDelegate>
{
    Byte m_nSendCmd[32];                    // 发送数组
    Byte m_nReceiveCmd[32];                 // 接收数组
    BOOL m_bConnection;                     // 连接状态
    BOOL m_bConnectedBefore;                // 以前是否连接
}

///////////////////// Property /////////////////////////
@property (nonatomic, strong) AsyncSocket *tcpSocket;       // Socket对象
@property (nonatomic, strong) NSString *serviceAddress;     // 服务器IP地址
@property (nonatomic, assign) NSInteger nPort;                    // 服务器端口号

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

@implementation skyTVProtocol

@synthesize tcpSocket = _tcpSocket;
@synthesize serviceAddress = _serviceAddress;
@synthesize nPort = _nPort;

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
    
    stringResult = [NSString stringWithFormat:@"skyTVProtocol 机芯协议->>>[%@ : %@]",stringLog,sendDatas];
    
    return stringResult;
}

#pragma mark - Public Methods
// 初始化屏幕控制协议
- (id)initTVProtocol
{
    self = [super init];
    
    if (self)
    {
        // TCP Socket对象初始
        _tcpSocket = [[AsyncSocket alloc] initWithDelegate:self];
        // 发送位与接收位初始化
        memset(m_nSendCmd, 0, 32);
        memset(m_nReceiveCmd, 0, 32);
        // 连接状态初始
        m_bConnection = NO;
        m_bConnectedBefore = NO;
    }
    
    return self;
}

// 连接TCP服务端
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

// 断开服务器连接
- (void)disconnectWithTCPService
{
    m_bConnection = NO;
    m_bConnectedBefore = NO;
    [_tcpSocket disconnect];
    LOG_MESSAGE(@"Close Socket Connect!");
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

// 服务器进入后台
- (void)serviceEnterBackground
{
    m_bConnection = NO;
    [_tcpSocket disconnect];
    LOG_MESSAGE(@"Socket Connect Enter Background");
}

#pragma mark - Sending Protocol
// 1.屏幕全选指令
- (void)skyTVSelectAll
{
    // 协议命令
    memset(m_nSendCmd, 0, sizeof(m_nSendCmd));
    m_nSendCmd[0] = 0x80;
    m_nSendCmd[1] = 0x74;
    m_nSendCmd[2] = 0x1B;
    m_nSendCmd[3] = 0xFF;
    m_nSendCmd[4] = 0xFF;
    m_nSendCmd[5] = 0xFF;
    m_nSendCmd[6] = 0xFF;
    m_nSendCmd[7] = 0xFF;
    // 协议发送
    [self sendCmd:8];
    
    // 信息
    LOG_MESSAGE([self sendStringWithLog:@"机芯全选指令发送" andByteCount:8],nil);
}

// 2.屏幕全不选指令
- (void)skyTVUnSelectAll
{
    // 协议命令
    memset(m_nSendCmd, 0, sizeof(m_nSendCmd));
    m_nSendCmd[0] = 0x80;
    m_nSendCmd[1] = 0x74;
    m_nSendCmd[2] = 0x1C;
    m_nSendCmd[3] = 0xFF;
    m_nSendCmd[4] = 0xFF;
    m_nSendCmd[5] = 0xFF;
    m_nSendCmd[6] = 0xFF;
    m_nSendCmd[7] = 0xFF;
    // 协议发送
    [self sendCmd:8];
    
    // 信息
    LOG_MESSAGE([self sendStringWithLog:@"机芯全不选指令发送" andByteCount:8],nil);}

// 3.开启屏幕指令
- (void)skyTVOpenTV
{
    // 协议命令
    memset(m_nSendCmd, 0, sizeof(m_nSendCmd));
    m_nSendCmd[0] = 0x80;
    m_nSendCmd[1] = 0x74;
    m_nSendCmd[2] = 0x3F;
    m_nSendCmd[3] = 0xFF;
    m_nSendCmd[4] = 0xFF;
    m_nSendCmd[5] = 0xFF;
    m_nSendCmd[6] = 0xFF;
    m_nSendCmd[7] = 0xFF;
    // 协议发送
    [self sendCmd:8];
    
    // 信息
    LOG_MESSAGE([self sendStringWithLog:@"机芯开启指令发送" andByteCount:8],nil);
}

// 4.关闭屏幕指令
- (void)skyTVCloseTV
{
    // 协议命令
    memset(m_nSendCmd, 0, sizeof(m_nSendCmd));
    m_nSendCmd[0] = 0x80;
    m_nSendCmd[1] = 0x74;
    m_nSendCmd[2] = 0x40;
    m_nSendCmd[3] = 0xFF;
    m_nSendCmd[4] = 0xFF;
    m_nSendCmd[5] = 0xFF;
    m_nSendCmd[6] = 0xFF;
    m_nSendCmd[7] = 0xFF;
    // 协议发送
    [self sendCmd:8];
    
    // 信息
    LOG_MESSAGE([self sendStringWithLog:@"机芯关闭指令发送" andByteCount:8],nil);
}

@end
