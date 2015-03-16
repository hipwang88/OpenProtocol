//
//  skySCXProtocol.m
//  SkyworthSCXPJ
//
//  Created by skyworth on 13-9-16.
//  Copyright (c) 2013年 skyworth. All rights reserved.
//

#import "skySCXProtocol.h"
#import "AsyncSocket.h"
#import "skyAppDelegate.h"

// Private
@interface skySCXProtocol()
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
@property (nonatomic, strong) skyAppDelegate *appDelegate;

///////////////////// Methods //////////////////////////
// 连接判断
- (BOOL)isConnected;
// 协议发送
- (void)sendCmd:(NSInteger)nLength;
// 协议接收
- (void)recevieCmd:(NSInteger)nLength;
// 获取发送码字符串
- (NSString *)sendStringWithLog:(NSString *)stringLog andByteCount:(NSInteger)nCount;

/*******************************************************/
// 32626 关闭窗口指令
- (void)TV_CloseWinsByX:(NSInteger)nStartX Y:(NSInteger)nStartY H:(NSInteger)nHCount V:(NSInteger)nVCount;
// 32636 窗口信号切换指令
- (void)TV_SwitchWin:(NSInteger)nWinNum SrcType:(NSInteger)nSrcType;
// 32626 窗口拼接
- (void)TV_SpliceWin:(NSInteger)nWinNum SrcType:(NSInteger)nSrcType X:(NSInteger)nStartX Y:(NSInteger)nStartY H:(NSInteger)nHCount V:(NSInteger)nVCount;
// HDMI 矩阵切换
- (void)MATRIX_HDMI_SwitchInput:(NSInteger)nSrcPath X:(NSInteger)nStartX Y:(NSInteger)nStartY H:(NSInteger)nHCount V:(NSInteger)nVCount;
// CVBS 矩阵切换
- (void)MATRIX_CVBS_SwitchInput:(NSInteger)nSrcPath X:(NSInteger)nStartX Y:(NSInteger)nStartY H:(NSInteger)nHCount V:(NSInteger)nVCount;

///////////////////// Ends /////////////////////////////

@end

@implementation skySCXProtocol

@synthesize tcpSocket = _tcpSocket;
@synthesize serviceAddress = _serviceAddress;
@synthesize nPort = _nPort;
@synthesize appDelegate = _appDelegate;

#pragma mark - Public Methods
// 初始化开放协议SDK
- (id)initSCXProtocol
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
        
        // 获取单例对象
        _appDelegate = [[UIApplication sharedApplication] delegate];
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
    
    stringResult = [NSString stringWithFormat:@"LCD-Controller12-V5 内部协议->>>[%@ : %@]",stringLog,sendDatas];
    
    return stringResult;
}

#pragma mark - Protocol Private
// 32626 关闭窗口指令
- (void)TV_CloseWinsByX:(NSInteger)nStartX Y:(NSInteger)nStartY H:(NSInteger)nHCount V:(NSInteger)nVCount
{
    NSInteger nColumn,nStartPanel;
    nColumn = _appDelegate.theApp.appColumns;
    nStartPanel = nStartY*nColumn + nStartX;
    
    memset(m_nSendCmd, 0, sizeof(m_nSendCmd));
    // 协议打包
    m_nSendCmd[0] = 0xEB;
    m_nSendCmd[1] = 0xA1;
    m_nSendCmd[2] = 0x10;
    m_nSendCmd[19]= 0x97;
    // 控制板协议
    m_nSendCmd[3] = 0x51;
    m_nSendCmd[4] = 0x00;
    m_nSendCmd[5] = 0x1A;
    m_nSendCmd[6] = 0x00;
    // 操作码
    m_nSendCmd[7] = nStartPanel;
    m_nSendCmd[8] = nHCount;
    m_nSendCmd[9] = nVCount;
    m_nSendCmd[15]= 0x00;
    m_nSendCmd[16]= 0x00;
    // 板卡码
    m_nSendCmd[17]= 0xFE;
    // 校验码
    m_nSendCmd[18]= 0xFF;
    
    [self sendCmd:20];
    
    // 信息
    LOG_MESSAGE([self sendStringWithLog:[NSString stringWithFormat:@"32626 先关闭窗口 Start:%ld Row:%ld Column:%ld",nStartPanel,nVCount,nHCount] andByteCount:20],nil);
}

// 32626 窗口信号切换
- (void)TV_SwitchWin:(NSInteger)nWinNum SrcType:(NSInteger)nSrcType
{
    NSInteger nType;
    switch (nSrcType) {
        case 0:
        case 1:
        case 2:
            nType = 0x01;
            break;
            
        case 3:
            nType = 0x03;
            break;
    }
    
    memset(m_nSendCmd, 0, sizeof(m_nSendCmd));
    // 协议打包
    m_nSendCmd[0] = 0xEB;
    m_nSendCmd[1] = 0xA1;
    m_nSendCmd[2] = 0x10;
    m_nSendCmd[19]= 0x97;
    // 控制板协议
    m_nSendCmd[3] = 0x51;
    m_nSendCmd[4] = 0x00;
    m_nSendCmd[5] = 0x05;
    m_nSendCmd[6] = 0x00;
    // 操作码
    m_nSendCmd[15]= nType;
    m_nSendCmd[16]= nWinNum;
    // 板卡码
    m_nSendCmd[17]= 0xFF;
    // 校验码
    m_nSendCmd[18]= 0xFF;
    
    [self sendCmd:20];
    
    // 信息
    LOG_MESSAGE([self sendStringWithLog:[NSString stringWithFormat:@"32626 切换窗口%ld 信号源-%ld",nWinNum,nType] andByteCount:20],nil);
}

// 32626 窗口拼接
- (void)TV_SpliceWin:(NSInteger)nWinNum SrcType:(NSInteger)nSrcType X:(NSInteger)nStartX Y:(NSInteger)nStartY H:(NSInteger)nHCount V:(NSInteger)nVCount
{
    NSInteger nColumn,nStartPanel;
    nColumn = _appDelegate.theApp.appColumns;
    nStartPanel = nStartY*nColumn + nStartX;
    
    int nType;
    switch (nSrcType) {
        case 0:
        case 1:
        case 2:
            nType = 0x01;
            break;
            
        case 3:
            nType = 0x03;
            break;
    }
    
    memset(m_nSendCmd, 0x00, sizeof(m_nSendCmd));
    // 协议打包
    m_nSendCmd[0] = 0xEB;
    m_nSendCmd[1] = 0xA1;
    m_nSendCmd[2] = 0x10;
    m_nSendCmd[19]= 0x97;
    // 控制板协议
    m_nSendCmd[3] = 0x51;
    m_nSendCmd[4] = 0x00;
    m_nSendCmd[5] = 0x14;
    m_nSendCmd[6] = 0x00;
    // 操作码
    m_nSendCmd[7] = nStartPanel;
    m_nSendCmd[8] = nHCount;
    m_nSendCmd[9] = nVCount;
    m_nSendCmd[15]= nType;
    m_nSendCmd[16]= nWinNum;
    // 板卡码
    m_nSendCmd[17]= 0xFF;
    m_nSendCmd[18]= 0xFF;
    
    // 协议发送
    [self sendCmd:20];
    
    // 信息
    LOG_MESSAGE([self sendStringWithLog:[NSString stringWithFormat:@"窗口%ld 拼接 起始:%ld 横向跨屏:%ld 纵向跨屏:%ld",nWinNum,nStartPanel,nHCount,nVCount] andByteCount:20],nil);
}

// HDMI 矩阵切换
- (void)MATRIX_HDMI_SwitchInput:(NSInteger)nSrcPath X:(NSInteger)nStartX Y:(NSInteger)nStartY H:(NSInteger)nHCount V:(NSInteger)nVCount
{
    NSInteger nRow,nColumn,nCount,nIndex;
    nRow = _appDelegate.theApp.appRows;
    nColumn = _appDelegate.theApp.appColumns;
    nCount = nHCount * nVCount;
    
    // 输出数组 创建
    NSMutableArray *outputArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < nVCount; i++)
    {
        nIndex = (nStartY+i)*nColumn + nStartX + 6;
        for (int j = 0; j < nHCount; j++)
        {
            [outputArray addObject:[NSNumber numberWithLong:nIndex]];
            nIndex ++;
        }
    }
    
    // 发送协议
    if (nCount <= 9)
    {
        memset(m_nSendCmd, 0xFF, sizeof(m_nSendCmd));
        // 协议打包
        m_nSendCmd[0] = 0xEB;
        m_nSendCmd[1] = 0xA1;
        m_nSendCmd[2] = 0x0D;
        m_nSendCmd[3] = 0xD9;
        m_nSendCmd[15]= 0xA1;
        m_nSendCmd[16]= 0x9D;
        // 操作位
        for (int i = 0; i < nCount; i++)
            m_nSendCmd[4+i] = [[outputArray objectAtIndex:i] intValue];
        // 数据位
        m_nSendCmd[13] = nSrcPath;
        m_nSendCmd[14] = nCount;
        // 协议发送
        [self sendCmd:17];
        
        // 信息
        LOG_MESSAGE([self sendStringWithLog:[NSString stringWithFormat:@"HDMI矩阵切换"] andByteCount:17],nil);
    }
    else
    {
        int m = 0;
        // 第一部分指令
        memset(m_nSendCmd, 0xFF, sizeof(m_nSendCmd));
        for (int i = 0; i < (nCount-1)/9; i++)
        {
            // 协议打包
            m_nSendCmd[0] = 0xEB;
            m_nSendCmd[1] = 0xA1;
            m_nSendCmd[2] = 0x0D;
            m_nSendCmd[3] = 0xD9;
            m_nSendCmd[15]= 0xA1;
            m_nSendCmd[16]= 0x9D;
            // 操作位
            for (int j = 0; j < 9; j++)
                m_nSendCmd[4+j] = [[outputArray objectAtIndex:j+9*i] intValue];
            // 数据位
            m_nSendCmd[13] = nSrcPath;
            m_nSendCmd[14] = 0x09;
            
            // 协议发送
            [self sendCmd:17];
            m++;
            
            // 信息
            LOG_MESSAGE([self sendStringWithLog:[NSString stringWithFormat:@"HDMI矩阵切换"] andByteCount:17],nil);
        }
        // 剩下9个除不尽部分
        memset(m_nSendCmd, 0xFF, sizeof(m_nSendCmd));
        // 协议打包
        m_nSendCmd[0] = 0xEB;
        m_nSendCmd[1] = 0xA1;
        m_nSendCmd[2] = 0x0D;
        m_nSendCmd[3] = 0xD9;
        m_nSendCmd[15]= 0xA1;
        m_nSendCmd[16]= 0x9D;
        // 操作位
        for (int j = 0; j < nCount-9*m; j++)
            m_nSendCmd[4+j] = [[outputArray objectAtIndex:j+9*m] intValue];
        // 数据位
        m_nSendCmd[13] = nSrcPath;
        m_nSendCmd[14] = nCount % 9;
        if (m_nSendCmd[14] == 0) m_nSendCmd[14] = 0x09;
        
        // 协议发送
        [self sendCmd:17];
        
        // 信息
        LOG_MESSAGE([self sendStringWithLog:[NSString stringWithFormat:@"HDMI矩阵切换"] andByteCount:17],nil);
    }
}

// CVBS 矩阵切换
- (void)MATRIX_CVBS_SwitchInput:(NSInteger)nSrcPath X:(NSInteger)nStartX Y:(NSInteger)nStartY H:(NSInteger)nHCount V:(NSInteger)nVCount
{
    NSInteger nRow,nColumn,nCount,nIndex;
    nRow = _appDelegate.theApp.appRows;
    nColumn = _appDelegate.theApp.appColumns;
    nCount = nHCount * nVCount;
    
    // 输出数组 创建
    NSMutableArray *outputArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < nVCount; i++)
    {
        nIndex = (nStartY+i)*nColumn + nStartX + 5;
        for (int j = 0; j < nHCount; j++)
        {
            [outputArray addObject:[NSNumber numberWithLong:nIndex]];
            nIndex ++;
        }
    }
    
    // 发送协议
    if (nCount <= 9)
    {
        memset(m_nSendCmd, 0xFF, sizeof(m_nSendCmd));
        // 协议打包
        m_nSendCmd[0] = 0xEB;
        m_nSendCmd[1] = 0xA1;
        m_nSendCmd[2] = 0x0D;
        m_nSendCmd[3] = 0xE9;
        m_nSendCmd[15]= 0xA1;
        m_nSendCmd[16]= 0x9E;
        // 操作位
        for (int i = 0; i < nCount; i++)
            m_nSendCmd[4+i] = [[outputArray objectAtIndex:i] intValue];
        // 数据位
        m_nSendCmd[13] = nSrcPath;
        m_nSendCmd[14] = nCount;
        // 协议发送
        [self sendCmd:17];
        
        // 信息
        LOG_MESSAGE([self sendStringWithLog:[NSString stringWithFormat:@"CVBS矩阵切换"] andByteCount:17],nil);
    }
    else
    {
        int m = 0;
        // 第一部分指令
        memset(m_nSendCmd, 0xFF, sizeof(m_nSendCmd));
        for (int i = 0; i < (nCount-1)/9; i++)
        {
            // 协议打包
            m_nSendCmd[0] = 0xEB;
            m_nSendCmd[1] = 0xA1;
            m_nSendCmd[2] = 0x0D;
            m_nSendCmd[3] = 0xE9;
            m_nSendCmd[15]= 0xA1;
            m_nSendCmd[16]= 0x9E;
            // 操作位
            for (int j = 0; j < 9; j++)
                m_nSendCmd[4+j] = [[outputArray objectAtIndex:j+9*i] intValue];
            // 数据位
            m_nSendCmd[13] = nSrcPath;
            m_nSendCmd[14] = 0x09;
            
            // 协议发送
            [self sendCmd:17];
            m++;
            
            // 信息
            LOG_MESSAGE([self sendStringWithLog:[NSString stringWithFormat:@"CVBS矩阵切换"] andByteCount:17],nil);
        }
        // 剩下9个除不尽部分
        memset(m_nSendCmd, 0xFF, sizeof(m_nSendCmd));
        // 协议打包
        m_nSendCmd[0] = 0xEB;
        m_nSendCmd[1] = 0xA1;
        m_nSendCmd[2] = 0x0D;
        m_nSendCmd[3] = 0xE9;
        m_nSendCmd[15]= 0xA1;
        m_nSendCmd[16]= 0x9E;
        // 操作位
        for (int j = 0; j < nCount-9*m; j++)
            m_nSendCmd[4+j] = [[outputArray objectAtIndex:j+9*m] intValue];
        // 数据位
        m_nSendCmd[13] = nSrcPath;
        m_nSendCmd[14] = nCount % 9;
        if (m_nSendCmd[14] == 0) m_nSendCmd[14] = 0x09;
        
        // 协议发送
        [self sendCmd:17];
        
        // 信息
        LOG_MESSAGE([self sendStringWithLog:[NSString stringWithFormat:@"CVBS矩阵切换"] andByteCount:17],nil);
    }
}

#pragma mark - Protocol Public
/*******************************************************/
// 1.控制器设置
- (void)scxControllerSetRow:(NSInteger)nRow Column:(NSInteger)nColumn Resolution:(NSInteger)nRes
{
    // 先向单片机发送初始指令
    memset(m_nSendCmd, 0, sizeof(m_nSendCmd));
    m_nSendCmd[0] = 0x80;
    m_nSendCmd[1] = 0xD7;
    m_nSendCmd[2] = 0x24;
    m_nSendCmd[3] = nRow;
    m_nSendCmd[4] = nColumn;
    m_nSendCmd[5] = nRes;
    m_nSendCmd[6] = 0xFF;
    m_nSendCmd[7] = 0xFF;
    [self sendCmd:8];
    // 信息
    LOG_MESSAGE([self sendStringWithLog:[NSString stringWithFormat:@"SCM InitController Row:%ld Column:%ld Resolution:%ld",nRow,nColumn,nRes] andByteCount:8],nil);
    
    // 再向机芯发送初始指令
    memset(m_nSendCmd, 0, sizeof(m_nSendCmd));
    // 协议打包
    m_nSendCmd[0] = 0xEB;
    m_nSendCmd[1] = 0xA1;
    m_nSendCmd[2] = 0x10;
    m_nSendCmd[19]= 0x97;
    // 控制板协议
    m_nSendCmd[3] = 0x51;
    m_nSendCmd[4] = 0x00;
    m_nSendCmd[5] = 0x00;
    m_nSendCmd[6] = 0x00;
    // 操作码
    m_nSendCmd[7] = nColumn;
    m_nSendCmd[8] = nRow;
    m_nSendCmd[9] = nRes;
    // 板卡码
    m_nSendCmd[17]= 0xFF;
    // 校验码
    m_nSendCmd[18] = 0xFF;
    [self sendCmd:20];
    // 信息
    LOG_MESSAGE([self sendStringWithLog:[NSString stringWithFormat:@"32626 InitController Row:%ld Column:%ld Resolution:%ld",nRow,nColumn,nRes] andByteCount:20],nil);
}

// 2.蜂鸣器开关
- (void)scxBuzzerStatus:(BOOL)bFlag
{
    // 协议命令
    memset(m_nSendCmd, 0, sizeof(m_nSendCmd));
    m_nSendCmd[0] = 0xEB;
    m_nSendCmd[1] = 0xA2;
    m_nSendCmd[2] = 0x02;
    m_nSendCmd[3] = 0x84;
    m_nSendCmd[4] = bFlag ? 0x01 : 0x02;
    m_nSendCmd[5] = 0x96;
    [self sendCmd:6];
    
    // 信息
    LOG_MESSAGE([self sendStringWithLog:[NSString stringWithFormat:@"蜂鸣器开关"] andByteCount:6],nil);
}

// 3.掉电记忆开关
- (void)scxPowerMemoryStatus:(BOOL)bFlag
{
    // 协议命令
    memset(m_nSendCmd, 0, sizeof(m_nSendCmd));
    m_nSendCmd[0] = 0xEB;
    m_nSendCmd[1] = 0xA2;
    m_nSendCmd[2] = 0x02;
    m_nSendCmd[3] = 0x87;
    m_nSendCmd[4] = bFlag ? 0x01 : 0x02;
    m_nSendCmd[5] = 0x96;
    [self sendCmd:6];
    
    // 信息
    LOG_MESSAGE([self sendStringWithLog:[NSString stringWithFormat:@"掉电记忆开关"] andByteCount:6],nil);
}

// 4.温控开关
- (void)scxTemperatureStatus:(BOOL)bFlag
{
    // 协议命令
    memset(m_nSendCmd, 0, sizeof(m_nSendCmd));
    m_nSendCmd[0] = 0xEB;
    m_nSendCmd[1] = 0xA2;
    m_nSendCmd[2] = 0x02;
    m_nSendCmd[3] = 0x88;
    m_nSendCmd[4] = bFlag ? 0x01 : 0x02;
    m_nSendCmd[5] = 0x96;
    [self sendCmd:6];
    
    // 信息
    LOG_MESSAGE([self sendStringWithLog:[NSString stringWithFormat:@"温控开关"] andByteCount:6],nil);
}

// 5.边缘屏蔽开关
- (void)scxStraightStatus:(BOOL)bFlag
{
    // 协议命令
    memset(m_nSendCmd, 0, sizeof(m_nSendCmd));
    m_nSendCmd[0] = 0xEB;
    m_nSendCmd[1] = 0xA2;
    m_nSendCmd[2] = 0x02;
    m_nSendCmd[3] = 0x88;
    m_nSendCmd[4] = bFlag ? 0x03 : 0x04;
    m_nSendCmd[5] = 0x96;
    [self sendCmd:6];
    
    // 信息
    LOG_MESSAGE([self sendStringWithLog:[NSString stringWithFormat:@"边缘屏蔽开关"] andByteCount:6],nil);
}

// 6.情景新建 - CVBS
- (void)scxModelNewWithCVBS
{
    // 协议命令
    memset(m_nSendCmd, 0, sizeof(m_nSendCmd));
    m_nSendCmd[0] = 0x85;
    m_nSendCmd[1] = 0x03;
    m_nSendCmd[2] = 0x32;
    m_nSendCmd[3] = 0xFF;
    m_nSendCmd[4] = 0xFF;
    m_nSendCmd[5] = 0xFF;
    m_nSendCmd[6] = 0xFF;
    m_nSendCmd[7] = 0xFF;
    [self sendCmd:8];
    
    // 信息
    LOG_MESSAGE([self sendStringWithLog:[NSString stringWithFormat:@"CVBS新建"] andByteCount:8],nil);
}

// 7.情景新建 - HDMI
- (void)scxModelNewWithHDMI
{
    // 协议命令
    memset(m_nSendCmd, 0, sizeof(m_nSendCmd));
    m_nSendCmd[0] = 0x85;
    m_nSendCmd[1] = 0x03;
    m_nSendCmd[2] = 0x33;
    m_nSendCmd[3] = 0xFF;
    m_nSendCmd[4] = 0xFF;
    m_nSendCmd[5] = 0xFF;
    m_nSendCmd[6] = 0xFF;
    m_nSendCmd[7] = 0xFF;
    [self sendCmd:8];
    
    // 信息
    LOG_MESSAGE([self sendStringWithLog:[NSString stringWithFormat:@"HDMI新建"] andByteCount:8],nil);
}

// 8.情景保存
- (void)scxSaveModelAtIndex:(NSInteger)nIndex
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
    [self sendCmd:8];
    
    // 信息
    LOG_MESSAGE([self sendStringWithLog:[NSString stringWithFormat:@"情景模式%ld保存",nIndex] andByteCount:8],nil);

}

// 9.情景加载
- (void)scxLoadModelAtIndex:(NSInteger)nIndex
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
    [self sendCmd:8];
    
    // 信息
    LOG_MESSAGE([self sendStringWithLog:[NSString stringWithFormat:@"情景模式%ld加载",nIndex] andByteCount:8],nil);
}

// 10.情景删除
- (void)scxDeleteModelAtIndex:(NSInteger)nIndex
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
    [self sendCmd:8];
    
    // 信息
    LOG_MESSAGE([self sendStringWithLog:[NSString stringWithFormat:@"情景模式%ld删除",nIndex] andByteCount:8],nil);
}

// 11.普通窗口信号切换
- (void)scxSignalSwitchSCXWin:(NSInteger)nWinID ofType:(NSInteger)nSrcType toChannel:(NSInteger)nSrcPath X:(NSInteger)nStartX Y:(NSInteger)nStartY H:(NSInteger)nHCount V:(NSInteger)nVCount
{
    // 先切换机芯状态
    [self TV_SwitchWin:nWinID SrcType:nSrcType];
    // 然后切换矩阵
    switch (nSrcType) {
        case 0:
        case 1:
        case 2: // HDMI矩阵
            [self MATRIX_HDMI_SwitchInput:nSrcPath X:nStartX Y:nStartY H:nHCount V:nVCount];
            break;
            
        case 3: // CVBS矩阵
            [self MATRIX_CVBS_SwitchInput:nSrcPath X:nStartX Y:nStartY H:nHCount V:nVCount];
            break;
    }
}

// 12.叠加底图窗口信号切换
- (void)scxSignalSwitchOpenUnderWin:(NSInteger)nWinID ofType:(NSInteger)nSrcType toChannel:(NSInteger)nSrcPath
{
    
}

// 13.叠加子窗口信号切换
- (void)scxSignalSwitchSubWin:(NSInteger)nSubID ofType:(NSInteger)nSrcType toChannel:(NSInteger)nSrcPath
{
    
}

// 14.大画面拼接
- (void)scxSpliceSCXWin:(NSInteger)nWinID X:(NSInteger)nStartX Y:(NSInteger)nStartY VScreen:(NSInteger)nVCount HScreen:(NSInteger)nHCount ofType:(NSInteger)nSrcType toChannel:(NSInteger)nSrcPath
{
    // 先切换矩阵
    switch (nSrcType) {
        case 0:
        case 1:
        case 2: // HDMI矩阵
            [self MATRIX_HDMI_SwitchInput:nSrcPath X:nStartX Y:nStartY H:nHCount V:nVCount];
            break;
            
        case 3: // CVBS矩阵
            [self MATRIX_CVBS_SwitchInput:nSrcPath X:nStartX Y:nStartY H:nHCount V:nVCount];
            break;
    }
    // 最后进行32626拼接
    [self TV_SpliceWin:nWinID SrcType:nSrcType X:nStartX Y:nStartY H:nHCount V:nVCount];
}

// 15.大画面分解
- (void)scxResolveSCXWin:(NSInteger)nWinID X:(NSInteger)nStartX Y:(NSInteger)nStartY H:(NSInteger)nHCount V:(NSInteger)nVCount
{
    NSInteger nColumn,nStartPanel;
    nColumn = _appDelegate.theApp.appColumns;
    nStartPanel = nStartY*nColumn + nStartX;
    
    memset(m_nSendCmd, 0x00, sizeof(m_nSendCmd));
    // 协议打包
    m_nSendCmd[0] = 0xEB;
    m_nSendCmd[1] = 0xA1;
    m_nSendCmd[2] = 0X10;
    m_nSendCmd[19]= 0X97;
    // 控制板协议
    m_nSendCmd[3] = 0x51;
    m_nSendCmd[4] = 0x00;
    m_nSendCmd[5] = 0x19;
    m_nSendCmd[6] = 0x00;
    // 操作码
    m_nSendCmd[7] = nStartPanel;
    m_nSendCmd[8] = nHCount;
    m_nSendCmd[9] = nVCount;
    m_nSendCmd[15]= 0x00;
    m_nSendCmd[16]= 0x00;
    // 板卡码
    m_nSendCmd[17]= 0xFF;
    m_nSendCmd[18]= 0xFF;
    
    // 协议发送
    [self sendCmd:20];
    
    // 信息
    LOG_MESSAGE([self sendStringWithLog:[NSString stringWithFormat:@"窗口%ld 分解 起始:%ld 横向跨屏:%ld 纵向跨屏:%ld",nWinID,nStartPanel,nHCount,nVCount] andByteCount:20],nil);
}

// 16.进入叠加开窗
- (void)scxEnterOpenStatus:(NSInteger)nWinID ofType:(NSInteger)nSrcType toChannel:(NSInteger)nSrcPath
{
    
}

// 17.退出叠加开窗
- (void)scxLeaveOpenStatus:(NSInteger)nWinID ofType:(NSInteger)nSrcType toChannel:(NSInteger)nSrcPath
{
    
}

// 18.添加子窗口
- (void)scxAddSubWin:(NSInteger)nSubID ofType:(NSInteger)nSrcType toChannel:(NSInteger)nSrcPath
{
    
}

// 19.关闭子窗口
- (void)scxDeleteSubWin:(NSInteger)nSubID ofType:(NSInteger)nSrcType toChannel:(NSInteger)nSrcPath
{
    
}

// 20.移动子窗口
- (void)scxMoveSubWin:(NSInteger)nSubID StartX:(NSInteger)nStartX StartY:(NSInteger)nStartY
{
    
}

// 21.缩放子窗口
- (void)scxResizeSubWin:(NSInteger)nSubID WinWidth:(NSInteger)nWidth WinHeight:(NSInteger)nHeight
{
    
}
/*******************************************************/

@end
