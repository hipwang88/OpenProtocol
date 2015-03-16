//
//  skyAppStatus.m
//  SkyworthSCXPJ
//
//  Created by skyworth on 13-8-12.
//  Copyright (c) 2013年 skyworth. All rights reserved.
//

#import "skyAppStatus.h"


@interface skyAppStatus()

// 应用程序基本数据初始
- (void)appDefaultDatasInit;
// 信号源数据初始化
- (void)appSignalInit;
// 情景模式数据初始化
- (void)appModelInit;

@end

@implementation skyAppStatus

@synthesize appDefaultsDic = _appDefaultsDic;
@synthesize appSignalDic = _appSignalDic;
@synthesize appIPAddress = _appIPAddress;
@synthesize appCmdIPAddress = _appCmdIPAddress;
@synthesize appPortNumber = _appPortNumber;
@synthesize appCmdPortNumber = _appCmdPortNumber;
@synthesize appRows = _appRows;
@synthesize appColumns = _appColumns;
@synthesize appUnitWidth = _appUnitWidth;
@synthesize appUnitHeight = _appUnitHeight;
@synthesize appScreenWidth = _appScreenWidth;
@synthesize appScreenHeight = _appScreenHeight;
@synthesize appControllerType = _appControllerType;
@synthesize appCardNum = _appCardNum;
@synthesize modelSavedImages = _modelSavedImages;
@synthesize modelSavedDic = _modelSavedDic;
@synthesize appResolution = _appResolution;
@synthesize appPowerSave = _appPowerSave;
@synthesize appTemperature = _appTemperature;
@synthesize appStraight = _appStraight;
@synthesize appBuzzer = _appBuzzer;
@synthesize appProtocolType = _appProtocolType;

// 应用程序状态类初始化
- (id)init
{
    self = [super init];
    if (self)
    {
        // 默认初始
        [self appDefaultInit];
    }
    return self;
}

#pragma mark - Public Methods
// 程序默认值初始化
- (void)appDefaultInit
{
    // 应用程序基本数据初始
    [self appDefaultDatasInit];
    // 信号源数据初始
    [self appSignalInit];
    // 情景模式数据初始化
    [self appModelInit];
}

// 情景保存图片存储
- (void)saveModelImage:(UIImage *)image toIndex:(NSInteger)nIndex
{
    NSString *modelKey = [NSString stringWithFormat:@"Model-%ld",nIndex+1];
    // 将情景标志置换
    [_modelSavedDic setObject:@"1" forKey:modelKey];
    
    // 替换图片数组
    [_modelSavedImages replaceObjectAtIndex:nIndex withObject:image];
}

// 情景保存图片删除
- (void)deleteModelImageAtIndex:(NSInteger)nIndex
{
    NSString *modelKey = [NSString stringWithFormat:@"Model-%ld",nIndex+1];
    // 将情景标志置换
    [_modelSavedDic setObject:@"0" forKey:modelKey];
    
    UIImage *image = [UIImage imageNamed:@"notsaved.png"];
    // 替换图片数组
    [_modelSavedImages replaceObjectAtIndex:nIndex withObject:image];
}

// 保存程序基本数据
- (void)appDefaultDatasSave
{
    NSString *appDefaultsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *appDefaultDir = [appDefaultsPath stringByAppendingPathComponent:@"AppStatus"];
    [[NSFileManager defaultManager] createDirectoryAtPath:appDefaultDir withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *appDefaultFileName = [appDefaultDir stringByAppendingPathComponent:APPDEFAULTFILE];
    
    // 保存数据
    [_appDefaultsDic setObject:[NSString stringWithFormat:@"%@",_appIPAddress] forKey:kAPPIPADDRESS];           // 20140917 by wh
    [_appDefaultsDic setObject:[NSString stringWithFormat:@"%ld",_appPortNumber] forKey:kAPPPORTNUMBER];         // 20140917 by wh
    [_appDefaultsDic setObject:[NSString stringWithFormat:@"%@",_appCmdIPAddress] forKey:kAPPCMDIPADDRESS];     // 20140917 by wh
    [_appDefaultsDic setObject:[NSString stringWithFormat:@"%ld",_appCmdPortNumber] forKey:kAPPCMDPORTNUMBER];   // 20140917 by wh
    [_appDefaultsDic setObject:[NSString stringWithFormat:@"%ld",_appRows] forKey:kAPPROWS];
    [_appDefaultsDic setObject:[NSString stringWithFormat:@"%ld",_appColumns] forKey:kAPPCOLUMNS];
    [_appDefaultsDic setObject:[NSString stringWithFormat:@"%ld",_appUnitWidth] forKey:kAPPUNITWIDTH];
    [_appDefaultsDic setObject:[NSString stringWithFormat:@"%ld",_appUnitHeight] forKey:kAPPUNITHEIGHT];
    [_appDefaultsDic setObject:[NSString stringWithFormat:@"%ld",_appScreenWidth] forKey:kAPPSCREENWIDTH];
    [_appDefaultsDic setObject:[NSString stringWithFormat:@"%ld",_appScreenHeight] forKey:kAPPSCREENHEIGHT];
    [_appDefaultsDic setObject:[NSString stringWithFormat:@"%ld",_appControllerType] forKey:kAPPCONTROLLERTYPE];
    [_appDefaultsDic setObject:[NSString stringWithFormat:@"%ld",_appCardNum] forKey:kAPPCARDCOUNT];
    [_appDefaultsDic setObject:[NSString stringWithFormat:@"%ld",_appResolution] forKey:kAPPRESOLUTION];
    [_appDefaultsDic setObject:[NSString stringWithFormat:@"%d",_appPowerSave ? 1 : 0] forKey:kAPPPOWERSAVE];
    [_appDefaultsDic setObject:[NSString stringWithFormat:@"%d",_appTemperature ? 1 : 0] forKey:kAPPTEMPERATURE];
    [_appDefaultsDic setObject:[NSString stringWithFormat:@"%d",_appStraight ? 1 : 0] forKey:kAPPSTRAIGHT];
    [_appDefaultsDic setObject:[NSString stringWithFormat:@"%d",_appBuzzer ? 1 : 0] forKey:kAPPBUZZER];
    [_appDefaultsDic setObject:[NSString stringWithFormat:@"%ld",_appProtocolType] forKey:kAPPPROTOCOLTYPE];
    
    // 写入文件
    [_appDefaultsDic writeToFile:appDefaultFileName atomically:YES];
}

// 计算主控区域 —— 以4：3比例计算
- (void)calculateScreenSize
{
    int nTempWidth,nTempHeight,nTotalWidth,nTotalHeight,nRatioX,nRatioY,nInt;
    
    nTotalWidth = 1150;
    nTotalHeight = 600;
    nRatioX = 4;
    nRatioY = 3;
    nTempWidth = nTempHeight = 0;
    
    if (_appRows < _appColumns)
    {
        nTempWidth = (nTotalWidth / (2*_appColumns)) * 0.8;
        
        nInt = nTempWidth / nRatioX;
        nTempHeight = nInt * nRatioY;
    }
    else if (_appRows >= _appColumns)
    {
        nTempHeight = nTotalHeight / (2*_appRows);
        
        nInt = nTempHeight / nRatioY;
        nTempWidth = nInt * nRatioX;
    }
    
    _appUnitWidth = nTempWidth;
    _appUnitHeight = nTempHeight;
    
    _appScreenWidth = nTempWidth * _appColumns * 2;
    _appScreenHeight = nTempHeight * _appRows * 2;
}

// 删除普通窗口数据文件
- (void)deleteSCXWindowData
{
    // 一个叠加窗口一个保存文件 文件名：skySubWin_X X-编号
    NSString *appDefaultsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *appStandardDir = [appDefaultsPath stringByAppendingPathComponent:@"AppStandard"];
    
    [[NSFileManager defaultManager] removeItemAtPath:appStandardDir error:nil];
}

// 删除情景模式记录
- (void)deleteAllModelData
{
    for (int i = 0; i < 18; i++)
    {
        [self deleteModelImageAtIndex:i];
    }
}

#pragma mark - Private Methods
// 应用程序基本数据初始
- (void)appDefaultDatasInit
{
    NSString *appDefaultsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *appDefaultDir = [appDefaultsPath stringByAppendingPathComponent:@"AppStatus"];
    [[NSFileManager defaultManager] createDirectoryAtPath:appDefaultDir withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *appDefaultFileName = [appDefaultDir stringByAppendingPathComponent:APPDEFAULTFILE];

    // 从文件中初始化字典
    self.appDefaultsDic = [[NSMutableDictionary alloc] initWithContentsOfFile:appDefaultFileName];
    // 如果文件中没有保存
    if (!self.appDefaultsDic)
    {
        // 创建字典
        self.appDefaultsDic = [[NSMutableDictionary alloc] init];
        
        _appRows = 2;
        _appColumns = 3;
        
        // 主控区域计算
        [self calculateScreenSize];
        
        // 设置控制器类型  1 - 16*16(6 cards 2 cvbs)       2 - 32*32(12 cards 4 cvbs)       3 - 64*64(24 cards 8 cvbs)
        _appControllerType = 1;
        _appCardNum = 5;
        _appResolution = 6;
        _appPowerSave = YES;
        _appTemperature = NO;
        _appStraight = NO;
        _appBuzzer = YES;
        _appProtocolType = 1;
        // 20140917 by wh 服务端 IP Port
        _appIPAddress = @"172.16.16.7";
        _appPortNumber = 5000;
        // 20140917 by wh 命令控制器服务端 IP Port
        _appCmdIPAddress = @"172.16.16.114";
        _appCmdPortNumber = 5000;
        
        // 保存数据
        [_appDefaultsDic setObject:[NSString stringWithFormat:@"%@",_appIPAddress] forKey:kAPPIPADDRESS];           // 20140917 by wh
        [_appDefaultsDic setObject:[NSString stringWithFormat:@"%ld",_appPortNumber] forKey:kAPPPORTNUMBER];         // 20140917 by wh
        [_appDefaultsDic setObject:[NSString stringWithFormat:@"%@",_appCmdIPAddress] forKey:kAPPCMDIPADDRESS];     // 20140917 by wh
        [_appDefaultsDic setObject:[NSString stringWithFormat:@"%ld",_appCmdPortNumber] forKey:kAPPCMDPORTNUMBER];   // 20140917 by wh
        [_appDefaultsDic setObject:[NSString stringWithFormat:@"%ld",_appRows] forKey:kAPPROWS];
        [_appDefaultsDic setObject:[NSString stringWithFormat:@"%ld",_appColumns] forKey:kAPPCOLUMNS];
        [_appDefaultsDic setObject:[NSString stringWithFormat:@"%ld",_appUnitWidth] forKey:kAPPUNITWIDTH];
        [_appDefaultsDic setObject:[NSString stringWithFormat:@"%ld",_appUnitHeight] forKey:kAPPUNITHEIGHT];
        [_appDefaultsDic setObject:[NSString stringWithFormat:@"%ld",_appScreenWidth] forKey:kAPPSCREENWIDTH];
        [_appDefaultsDic setObject:[NSString stringWithFormat:@"%ld",_appScreenHeight] forKey:kAPPSCREENHEIGHT];
        [_appDefaultsDic setObject:[NSString stringWithFormat:@"%ld",_appControllerType] forKey:kAPPCONTROLLERTYPE];
        [_appDefaultsDic setObject:[NSString stringWithFormat:@"%ld",_appCardNum] forKey:kAPPCARDCOUNT];
        [_appDefaultsDic setObject:[NSString stringWithFormat:@"%ld",_appResolution] forKey:kAPPRESOLUTION];
        [_appDefaultsDic setObject:[NSString stringWithFormat:@"%d",_appPowerSave ? 1 : 0] forKey:kAPPPOWERSAVE];
        [_appDefaultsDic setObject:[NSString stringWithFormat:@"%d",_appTemperature ? 1 : 0] forKey:kAPPTEMPERATURE];
        [_appDefaultsDic setObject:[NSString stringWithFormat:@"%d",_appStraight ? 1 : 0] forKey:kAPPSTRAIGHT];
        [_appDefaultsDic setObject:[NSString stringWithFormat:@"%d",_appBuzzer ? 1 : 0] forKey:kAPPBUZZER];
        [_appDefaultsDic setObject:[NSString stringWithFormat:@"%ld",_appProtocolType] forKey:kAPPPROTOCOLTYPE];
        
        // 写入文件
        [_appDefaultsDic writeToFile:appDefaultFileName atomically:YES];
    }
    else
    {
        _appIPAddress = [_appDefaultsDic objectForKey:kAPPIPADDRESS];                           // 20140917 by wh
        _appPortNumber = [[_appDefaultsDic objectForKey:kAPPPORTNUMBER] integerValue];          // 20140917 by wh
        _appCmdIPAddress = [_appDefaultsDic objectForKey:kAPPCMDIPADDRESS];                     // 20140917 by wh
        _appCmdPortNumber = [[_appDefaultsDic objectForKey:kAPPCMDPORTNUMBER] integerValue];    // 20140917 by wh
        _appRows = [[_appDefaultsDic objectForKey:kAPPROWS] integerValue];
        _appColumns = [[_appDefaultsDic objectForKey:kAPPCOLUMNS] integerValue];
        _appUnitWidth = [[_appDefaultsDic objectForKey:kAPPUNITWIDTH] integerValue];
        _appUnitHeight = [[_appDefaultsDic objectForKey:kAPPUNITHEIGHT] integerValue];
        _appScreenWidth = [[_appDefaultsDic objectForKey:kAPPSCREENWIDTH] integerValue];
        _appScreenHeight = [[_appDefaultsDic objectForKey:kAPPSCREENHEIGHT] integerValue];
        _appControllerType = [[_appDefaultsDic objectForKey:kAPPCONTROLLERTYPE] integerValue];
        _appCardNum = [[_appDefaultsDic objectForKey:kAPPCARDCOUNT] integerValue];
        _appResolution = [[_appDefaultsDic objectForKey:kAPPRESOLUTION] integerValue];
        _appPowerSave = [[_appDefaultsDic objectForKey:kAPPPOWERSAVE] integerValue] == 1 ? YES : NO;
        _appTemperature = [[_appDefaultsDic objectForKey:kAPPTEMPERATURE] integerValue] == 1 ? YES : NO;
        _appStraight = [[_appDefaultsDic objectForKey:kAPPSTRAIGHT] integerValue] == 1 ? YES : NO;
        _appBuzzer = [[_appDefaultsDic objectForKey:kAPPBUZZER] integerValue] == 1 ? YES : NO;
        _appProtocolType = [[_appDefaultsDic objectForKey:kAPPPROTOCOLTYPE] integerValue];
    }
}

// 信号源数据初始化
- (void)appSignalInit
{
    NSString *appDefaultsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *appDefaultDir = [appDefaultsPath stringByAppendingPathComponent:@"AppStatus"];
    [[NSFileManager defaultManager] createDirectoryAtPath:appDefaultDir withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *appDefaultFileName = [appDefaultDir stringByAppendingPathComponent:APPSIGNALFILE];
    
    // 从文件中初始化字典
    self.appSignalDic = [[NSMutableDictionary alloc] initWithContentsOfFile:appDefaultFileName];
    
    // 如果没有此文件
    if (!self.appSignalDic)
    {
        // 创建此字典
        self.appSignalDic = [[NSMutableDictionary alloc] init];
        
        // 设置板卡类型 -1 -- NONE  0 -- HDMI  1 -- DVI  2 -- VGA  3 -- CVBS
        for (int i = 1; i <= _appCardNum; i++)
        {
            // 板卡键值
            NSString *cardTypeKeys = [NSString stringWithFormat:@"Card-%d",i];
            NSInteger nValue;
            
            // 分配板卡类型
            if (i <= (int)pow(2, _appControllerType))
            {
                nValue = 3;
            }
            else
            {
                nValue = random() % 3;
            }
            
            // 写入字典
            [_appSignalDic setObject:[NSString stringWithFormat:@"%ld",nValue] forKey:cardTypeKeys];
        }
        
        // 将字典记录进文件
        [_appSignalDic writeToFile:appDefaultFileName atomically:YES];
    }
}

// 情景模式数据初始化
- (void)appModelInit
{
    NSString *appDefaultsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *appDefaultDir = [appDefaultsPath stringByAppendingPathComponent:@"AppStatus"];
    NSString *appModelImageDir = [appDefaultsPath stringByAppendingPathComponent:@"ModelSavedImages"];
    [[NSFileManager defaultManager] createDirectoryAtPath:appDefaultDir withIntermediateDirectories:YES attributes:nil error:nil];
    [[NSFileManager defaultManager] createDirectoryAtPath:appModelImageDir withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *appDefaultFileName = [appDefaultDir stringByAppendingPathComponent:APPMODELFILE];
    
    // 从文件中初始化字典
    self.modelSavedDic = [[NSMutableDictionary alloc] initWithContentsOfFile:appDefaultFileName];
    // 初始化情景图片数组
    self.modelSavedImages = [[NSMutableArray alloc] init];
    
    // 如果没有此文件
    if (!self.modelSavedDic)
    {
        // 创建此字典
        self.modelSavedDic = [[NSMutableDictionary alloc] init];
        
        // 默认数值设定
        for (int i = 1; i <= 18; i++)
        {
            NSString *modelKey = [NSString stringWithFormat:@"Model-%d",i];
            int nValue = 0;
            
            // 写入字典
            [_modelSavedDic setObject:[NSString stringWithFormat:@"%d",nValue] forKey:modelKey];
        }
    }
    
    // 提取图片数组
    for (int i = 1; i <= 18; i++)
    {
        NSString *modelKey = [NSString stringWithFormat:@"Model-%d",i];
        NSInteger nValue = [[_modelSavedDic objectForKey:modelKey] integerValue];
        UIImage *image;
        NSString *imagePath = [appModelImageDir stringByAppendingPathComponent:[NSString stringWithFormat:@"model_%d.png",i]];

        switch (nValue) {
            case 0: // 情景未保存
                image = [UIImage imageNamed:@"notsaved.png"];
                [_modelSavedImages addObject:image];
                break;
                
            case 1: // 情景已经保存
                image = [UIImage imageWithContentsOfFile:imagePath];
                [_modelSavedImages addObject:image];
                break;
        }
    }
}

#pragma mark - skySCXWin DataSource
// 漫游窗口初始化
- (void)initSCXWinDataSource:(id)sender
{
    skySCXWin *scxWin = (skySCXWin *)sender;
    NSInteger nWinNum = scxWin.winNumber;
    
    // 一个窗口一个文件 漫游窗口 skySCXWin_X X-nWinNum
    NSString *appDefaultsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *appStandardDir = [appDefaultsPath stringByAppendingPathComponent:@"AppStandard"];
    [[NSFileManager defaultManager] createDirectoryAtPath:appStandardDir withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *appDefaultFileName = [appStandardDir stringByAppendingPathComponent:[NSString stringWithFormat:@"skySCXWin_%ld",nWinNum]];
    
    // 字典
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:appDefaultFileName];
    // 如果文件不存在
    if (!dict)
    {
        // 如果没有这样的文件 就重新创建字典
        dict = [[NSMutableDictionary alloc] init];
        
        // 用窗口的默认值写入文件
        // 棋盘数据
        scxWin.startPoint = CGPointMake((nWinNum-1)%_appColumns, (nWinNum-1)/_appColumns);
        scxWin.winSize = CGSizeMake(1, 1);
        // 窗口状态开关
        [scxWin setSCXWinMove:NO];
        [scxWin setSCXWinResize:YES];
        [scxWin setSCXWinBigPicture:NO];
        [scxWin setSCXWinOpen:NO];
        // 信号类型与通道数据
        scxWin.winSourceType = 0;       // 默认HDMI
        scxWin.winChannelNum = nWinNum; // 默认一对一
        // 窗口与单元大小设置
        [scxWin setSCXWinBasicWinWidth:_appUnitWidth*2];
        [scxWin setSCXWinBasicWinHeight:_appUnitHeight*2];
        [scxWin setSCXWinCurrentWinWidth:_appUnitWidth*2];
        [scxWin setSCXWinCurrentWinHeight:_appUnitHeight*2];
        
        // 窗口数据写入字典 Key格式 skySCXWin_X-config X-nWinNum
        [dict setObject:[NSString stringWithFormat:@"%f",scxWin.startPoint.x] forKey:kSCXWINSTARTX];
        [dict setObject:[NSString stringWithFormat:@"%f",scxWin.startPoint.y] forKey:kSCXWINSTARTY];
        [dict setObject:[NSString stringWithFormat:@"%f",scxWin.winSize.width] forKey:kSCXWINSIZEW];
        [dict setObject:[NSString stringWithFormat:@"%f",scxWin.winSize.height] forKey:kSCXWINSIZEH];
        [dict setObject:[NSString stringWithFormat:@"%d",[scxWin getSCXWinMove] ? 1:0] forKey:kSCXWINMOVE];
        [dict setObject:[NSString stringWithFormat:@"%d",[scxWin getSCXWinResize] ? 1:0] forKey:kSCXWINRESIZE];
        [dict setObject:[NSString stringWithFormat:@"%d",[scxWin getSCXWinBigPicture] ? 1:0] forKey:kSCXWINBIGPICTURE];
        [dict setObject:[NSString stringWithFormat:@"%d",[scxWin getSCXWinOpen] ? 1:0] forKey:kSCXWINOPENWIN];
        [dict setObject:[NSString stringWithFormat:@"%ld",scxWin.winSourceType] forKey:kSCXWINSIGNALTYPE];
        [dict setObject:[NSString stringWithFormat:@"%ld",scxWin.winChannelNum] forKey:kSCXWINCHANNELNUM];
        [dict setObject:[NSString stringWithFormat:@"%ld",[scxWin getSCXWinBasicWinWidth]] forKey:kSCXWINBWIDTH];
        [dict setObject:[NSString stringWithFormat:@"%ld",[scxWin getSCXWinBasicWinHeight]] forKey:kSCXWINBHEIGHT];
        [dict setObject:[NSString stringWithFormat:@"%ld",[scxWin getSCXWinCurrentWinWidth]] forKey:kSCXWINCWIDTH];
        [dict setObject:[NSString stringWithFormat:@"%ld",[scxWin getSCXWinCurrentWinHeight]] forKey:kSCXWINCHEIGHT];
        
        // 写入文件
        [dict writeToFile:appDefaultFileName atomically:YES];
    }
    else
    {
        // 如果文件存在 从文件字典中读取数据
        scxWin.startPoint = CGPointMake([[dict objectForKey:kSCXWINSTARTX] floatValue],[[dict objectForKey:kSCXWINSTARTY] floatValue]);
        scxWin.winSize = CGSizeMake([[dict objectForKey:kSCXWINSIZEW] floatValue], [[dict objectForKey:kSCXWINSIZEH] floatValue]);
        [scxWin setSCXWinMove:[[dict objectForKey:kSCXWINMOVE] integerValue] == 1 ? YES : NO];
        [scxWin setSCXWinResize:[[dict objectForKey:kSCXWINRESIZE] integerValue] == 1 ? YES : NO];
        [scxWin setSCXWinBigPicture:[[dict objectForKey:kSCXWINBIGPICTURE] integerValue] == 1 ? YES : NO];
        [scxWin setSCXWinOpen:[[dict objectForKey:kSCXWINOPENWIN] integerValue] == 1 ? YES : NO];
        scxWin.winSourceType = [[dict objectForKey:kSCXWINSIGNALTYPE] integerValue];
        scxWin.winChannelNum = [[dict objectForKey:kSCXWINCHANNELNUM] integerValue];
        [scxWin setSCXWinBasicWinWidth:[[dict objectForKey:kSCXWINBWIDTH] integerValue]];
        [scxWin setSCXWinBasicWinHeight:[[dict objectForKey:kSCXWINBHEIGHT] integerValue]];
        [scxWin setSCXWinCurrentWinWidth:[[dict objectForKey:kSCXWINCWIDTH] integerValue]];
        [scxWin setSCXWinCurrentWinHeight:[[dict objectForKey:kSCXWINCHEIGHT] integerValue]];
    }
}

// 保存漫游窗口值到文件
- (void)saveSCXWinDataSource:(id)sender
{
    skySCXWin *scxWin = (skySCXWin *)sender;
    NSInteger nWinNum = scxWin.winNumber;
    
    // 一个窗口一个文件 漫游窗口 skySCXWin_X X-nWinNum
    NSString *appDefaultsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *appStandardDir = [appDefaultsPath stringByAppendingPathComponent:@"AppStandard"];
    [[NSFileManager defaultManager] createDirectoryAtPath:appStandardDir withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *appDefaultFileName = [appStandardDir stringByAppendingPathComponent:[NSString stringWithFormat:@"skySCXWin_%ld",nWinNum]];
    // 字典
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    // 将数据放入字典
    [dict setObject:[NSString stringWithFormat:@"%f",scxWin.startPoint.x] forKey:kSCXWINSTARTX];
    [dict setObject:[NSString stringWithFormat:@"%f",scxWin.startPoint.y] forKey:kSCXWINSTARTY];
    [dict setObject:[NSString stringWithFormat:@"%f",scxWin.winSize.width] forKey:kSCXWINSIZEW];
    [dict setObject:[NSString stringWithFormat:@"%f",scxWin.winSize.height] forKey:kSCXWINSIZEH];
    [dict setObject:[NSString stringWithFormat:@"%d",[scxWin getSCXWinMove] ? 1:0] forKey:kSCXWINMOVE];
    [dict setObject:[NSString stringWithFormat:@"%d",[scxWin getSCXWinResize] ? 1:0] forKey:kSCXWINRESIZE];
    [dict setObject:[NSString stringWithFormat:@"%d",[scxWin getSCXWinBigPicture] ? 1:0] forKey:kSCXWINBIGPICTURE];
    [dict setObject:[NSString stringWithFormat:@"%d",[scxWin getSCXWinOpen] ? 1:0] forKey:kSCXWINOPENWIN];
    [dict setObject:[NSString stringWithFormat:@"%ld",scxWin.winSourceType] forKey:kSCXWINSIGNALTYPE];
    [dict setObject:[NSString stringWithFormat:@"%ld",scxWin.winChannelNum] forKey:kSCXWINCHANNELNUM];
    [dict setObject:[NSString stringWithFormat:@"%ld",[scxWin getSCXWinBasicWinWidth]] forKey:kSCXWINBWIDTH];
    [dict setObject:[NSString stringWithFormat:@"%ld",[scxWin getSCXWinBasicWinHeight]] forKey:kSCXWINBHEIGHT];
    [dict setObject:[NSString stringWithFormat:@"%ld",[scxWin getSCXWinCurrentWinWidth]] forKey:kSCXWINCWIDTH];
    [dict setObject:[NSString stringWithFormat:@"%ld",[scxWin getSCXWinCurrentWinHeight]] forKey:kSCXWINCHEIGHT];
    
    // 将字典写入文件
    [dict writeToFile:appDefaultFileName atomically:YES];
}

// 窗口的情景数据序列化到文件
- (void)saveSCXWinModelDataSource:(id)sender AtIndex:(NSInteger)nIndex
{
    skySCXWin *scxWin = (skySCXWin *)sender;
    NSInteger nWinNum = scxWin.winNumber;
    
    // 创建模式文件夹
    NSString *modelPath = [NSString stringWithFormat:@"ModelDir_%ld",nIndex];
    NSString *appDefaultsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *modelDirPath = [appDefaultsPath stringByAppendingPathComponent:modelPath];
    [[NSFileManager defaultManager] createDirectoryAtPath:modelDirPath withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *savePath = [modelDirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"skySCXWin_%ld",nWinNum]];
    
    // 保存窗口数据
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSString stringWithFormat:@"%f",scxWin.startPoint.x] forKey:kSCXWINSTARTX];
    [dict setObject:[NSString stringWithFormat:@"%f",scxWin.startPoint.y] forKey:kSCXWINSTARTY];
    [dict setObject:[NSString stringWithFormat:@"%f",scxWin.winSize.width] forKey:kSCXWINSIZEW];
    [dict setObject:[NSString stringWithFormat:@"%f",scxWin.winSize.height] forKey:kSCXWINSIZEH];
    [dict setObject:[NSString stringWithFormat:@"%d",[scxWin getSCXWinMove] ? 1:0] forKey:kSCXWINMOVE];
    [dict setObject:[NSString stringWithFormat:@"%d",[scxWin getSCXWinResize] ? 1:0] forKey:kSCXWINRESIZE];
    [dict setObject:[NSString stringWithFormat:@"%d",[scxWin getSCXWinBigPicture] ? 1:0] forKey:kSCXWINBIGPICTURE];
    [dict setObject:[NSString stringWithFormat:@"%d",[scxWin getSCXWinOpen] ? 1:0] forKey:kSCXWINOPENWIN];
    [dict setObject:[NSString stringWithFormat:@"%ld",scxWin.winSourceType] forKey:kSCXWINSIGNALTYPE];
    [dict setObject:[NSString stringWithFormat:@"%ld",scxWin.winChannelNum] forKey:kSCXWINCHANNELNUM];
    [dict setObject:[NSString stringWithFormat:@"%ld",[scxWin getSCXWinBasicWinWidth]] forKey:kSCXWINBWIDTH];
    [dict setObject:[NSString stringWithFormat:@"%ld",[scxWin getSCXWinBasicWinHeight]] forKey:kSCXWINBHEIGHT];
    [dict setObject:[NSString stringWithFormat:@"%ld",[scxWin getSCXWinCurrentWinWidth]] forKey:kSCXWINCWIDTH];
    [dict setObject:[NSString stringWithFormat:@"%ld",[scxWin getSCXWinCurrentWinHeight]] forKey:kSCXWINCHEIGHT];
    
    // 将字典数据写入文件
    [dict writeToFile:savePath atomically:YES];
}

// 反序列化窗口情景模式
- (void)loadSCXWinModelDataSource:(id)sender AtIndex:(NSInteger)nIndex
{
    skySCXWin *scxWin = (skySCXWin *)sender;
    NSInteger nWinNum = scxWin.winNumber;
    
    // 创建模式文件夹
    NSString *modelPath = [NSString stringWithFormat:@"ModelDir_%ld",nIndex];
    NSString *appDefaultsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *modelDirPath = [appDefaultsPath stringByAppendingPathComponent:modelPath];
    [[NSFileManager defaultManager] createDirectoryAtPath:modelDirPath withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *savePath = [modelDirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"skySCXWin_%ld",nWinNum]];
    
    // 字典
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:savePath];

    // 提取数据
    scxWin.startPoint = CGPointMake([[dict objectForKey:kSCXWINSTARTX] floatValue],[[dict objectForKey:kSCXWINSTARTY] floatValue]);
    scxWin.winSize = CGSizeMake([[dict objectForKey:kSCXWINSIZEW] floatValue], [[dict objectForKey:kSCXWINSIZEH] floatValue]);
    [scxWin setSCXWinMove:[[dict objectForKey:kSCXWINMOVE] integerValue] == 1 ? YES : NO];
    [scxWin setSCXWinResize:[[dict objectForKey:kSCXWINRESIZE] integerValue] == 1 ? YES : NO];
    [scxWin setSCXWinBigPicture:[[dict objectForKey:kSCXWINBIGPICTURE] integerValue] == 1 ? YES : NO];
    [scxWin setSCXWinOpen:[[dict objectForKey:kSCXWINOPENWIN] integerValue] == 1 ? YES : NO];
    scxWin.winSourceType = [[dict objectForKey:kSCXWINSIGNALTYPE] integerValue];
    scxWin.winChannelNum = [[dict objectForKey:kSCXWINCHANNELNUM] integerValue];
    [scxWin setSCXWinBasicWinWidth:[[dict objectForKey:kSCXWINBWIDTH] integerValue]];
    [scxWin setSCXWinBasicWinHeight:[[dict objectForKey:kSCXWINBHEIGHT] integerValue]];
    [scxWin setSCXWinCurrentWinWidth:[[dict objectForKey:kSCXWINCWIDTH] integerValue]];
    [scxWin setSCXWinCurrentWinHeight:[[dict objectForKey:kSCXWINCHEIGHT] integerValue]];
}

#pragma mark - skySubWin DataSource
// 叠加窗口数据初始化
- (void)initSubWinDataSource:(id)sender
{
    skySubWin *subWin = (skySubWin *)sender;
    NSInteger nNum = subWin.winNumber;
    
    // 一个叠加窗口一个保存文件 文件名：skySubWin_X X-编号
    NSString *appDefaultsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *appStandardDir = [appDefaultsPath stringByAppendingPathComponent:@"AppStandard"];
    [[NSFileManager defaultManager] createDirectoryAtPath:appStandardDir withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *appDefaultFileName = [appStandardDir stringByAppendingPathComponent:[NSString stringWithFormat:@"skySubWin_%ld",nNum]];
    // 保存字典
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:appDefaultFileName];
    
    // 查找是否存在
    if (!dict)  // 文件不存在
    {
        // 如果字典没有找到文件
        dict = [[NSMutableDictionary alloc] init];
        
        // 叠加窗口默认值写入
        // 窗口是否显示
        [subWin setSubWinVisible:NO];       // 默认隐藏
        // 叠加窗口信号源
        subWin.winSourceType = 0;
        subWin.winChannelNum = nNum;
        // 叠加窗口父窗口范围
        subWin.limitRect = CGRectMake(0, 0, 0, 0);
        // 占父窗口范围百分比
        [subWin setSubWinCentiStartX:0.0f];
        [subWin setSubWinCentiStartY:0.0f];
        [subWin setSubWinCentiWidth:0.0f];
        [subWin setSubWinCentiHeight:0.0f];
        
        // 将数据写入字典
        [dict setObject:[NSString stringWithFormat:@"%d",[subWin getSubWinVisible] ? 1 : 0] forKey:kSUBWINSHOWOUT];
        [dict setObject:[NSString stringWithFormat:@"%ld",subWin.winSourceType] forKey:kSUBWINSIGNALTYPE];
        [dict setObject:[NSString stringWithFormat:@"%ld",subWin.winChannelNum] forKey:kSUBWINCHANNELNUM];
        [dict setObject:[NSString stringWithFormat:@"%f",subWin.limitRect.origin.x] forKey:kSUBWINPARENTSTARTX];
        [dict setObject:[NSString stringWithFormat:@"%f",subWin.limitRect.origin.y] forKey:KSUBWINPARENTSTARTY];
        [dict setObject:[NSString stringWithFormat:@"%f",subWin.limitRect.size.width] forKey:kSUBWINPARENTWIDTH];
        [dict setObject:[NSString stringWithFormat:@"%f",subWin.limitRect.size.height] forKey:kSUBWINPARENTHEIGHT];
        [dict setObject:[NSString stringWithFormat:@"%f",[subWin getSubWinCentiStartX]] forKey:kSUBWINCENTISTARTX];
        [dict setObject:[NSString stringWithFormat:@"%f",[subWin getSubWinCentiStartY]] forKey:kSUBWINCENTISTARTY];
        [dict setObject:[NSString stringWithFormat:@"%f",[subWin getSubWinCentiWidth]] forKey:kSUBWINCENTIWIDTH];
        [dict setObject:[NSString stringWithFormat:@"%f",[subWin getSubWinCentiHeight]] forKey:kSUBWINCENTIHEIGHT];
        
        // 写入文件
        [dict writeToFile:appDefaultFileName atomically:YES];
    }
    else        // 文件存在
    {
        // 从字典中读取数据写入对象
        [subWin setSubWinVisible:[[dict objectForKey:kSUBWINSHOWOUT] integerValue] == 1 ? YES : NO];
        subWin.winSourceType = [[dict objectForKey:kSUBWINSIGNALTYPE] integerValue];
        subWin.winChannelNum = [[dict objectForKey:kSUBWINCHANNELNUM] integerValue];
        subWin.limitRect = CGRectMake([[dict objectForKey:kSUBWINPARENTSTARTX] floatValue], [[dict objectForKey:KSUBWINPARENTSTARTY] floatValue], [[dict objectForKey:kSUBWINPARENTWIDTH] floatValue], [[dict objectForKey:kSUBWINPARENTHEIGHT] floatValue]);
        [subWin setSubWinCentiStartX:[[dict objectForKey:kSUBWINCENTISTARTX] floatValue]];
        [subWin setSubWinCentiStartY:[[dict objectForKey:kSUBWINCENTISTARTY] floatValue]];
        [subWin setSubWinCentiWidth:[[dict objectForKey:kSUBWINCENTIWIDTH] floatValue]];
        [subWin setSubWinCentiHeight:[[dict objectForKey:kSUBWINCENTIHEIGHT] floatValue]];
    }
}

// 保存叠加窗口数据到文件
- (void)saveSubWinDataSource:(id)sender
{
    // 获取传入的窗口对象
    skySubWin *subWin = (skySubWin *)sender;
    NSInteger nNum = subWin.winNumber;
    
    // 存入文件索引
    NSString *appDefaultsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *appStandardDir = [appDefaultsPath stringByAppendingPathComponent:@"AppStandard"];
    [[NSFileManager defaultManager] createDirectoryAtPath:appStandardDir withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *appDefaultFileName = [appStandardDir stringByAppendingPathComponent:[NSString stringWithFormat:@"skySubWin_%ld",nNum]];
    
    // 字典对象
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    // 将数据写入字典
    [dict setObject:[NSString stringWithFormat:@"%d",[subWin getSubWinVisible] ? 1 : 0] forKey:kSUBWINSHOWOUT];
    [dict setObject:[NSString stringWithFormat:@"%ld",subWin.winSourceType] forKey:kSUBWINSIGNALTYPE];
    [dict setObject:[NSString stringWithFormat:@"%ld",subWin.winChannelNum] forKey:kSUBWINCHANNELNUM];
    [dict setObject:[NSString stringWithFormat:@"%f",subWin.limitRect.origin.x] forKey:kSUBWINPARENTSTARTX];
    [dict setObject:[NSString stringWithFormat:@"%f",subWin.limitRect.origin.y] forKey:KSUBWINPARENTSTARTY];
    [dict setObject:[NSString stringWithFormat:@"%f",subWin.limitRect.size.width] forKey:kSUBWINPARENTWIDTH];
    [dict setObject:[NSString stringWithFormat:@"%f",subWin.limitRect.size.height] forKey:kSUBWINPARENTHEIGHT];
    [dict setObject:[NSString stringWithFormat:@"%f",[subWin getSubWinCentiStartX]] forKey:kSUBWINCENTISTARTX];
    [dict setObject:[NSString stringWithFormat:@"%f",[subWin getSubWinCentiStartY]] forKey:kSUBWINCENTISTARTY];
    [dict setObject:[NSString stringWithFormat:@"%f",[subWin getSubWinCentiWidth]] forKey:kSUBWINCENTIWIDTH];
    [dict setObject:[NSString stringWithFormat:@"%f",[subWin getSubWinCentiHeight]] forKey:kSUBWINCENTIHEIGHT];

    // 将字典写入文件
    [dict writeToFile:appDefaultFileName atomically:YES];
}

// 保存叠加窗口情景模式数据
- (void)saveSubWinModelDataSource:(id)sender AtIndex:(NSInteger)nIndex
{
    skySubWin *subWin = (skySubWin *)sender;
    NSInteger nWinNum = subWin.winNumber;
    
    // 创建模式文件夹
    NSString *modelPath = [NSString stringWithFormat:@"ModelDir_%ld",nIndex];
    NSString *appDefaultsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *modelDirPath = [appDefaultsPath stringByAppendingPathComponent:modelPath];
    [[NSFileManager defaultManager] createDirectoryAtPath:modelDirPath withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *savePath = [modelDirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"skySubWin_%ld",nWinNum]];

    // 数据保存
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSString stringWithFormat:@"%d",[subWin getSubWinVisible] ? 1 : 0] forKey:kSUBWINSHOWOUT];
    [dict setObject:[NSString stringWithFormat:@"%ld",subWin.winSourceType] forKey:kSUBWINSIGNALTYPE];
    [dict setObject:[NSString stringWithFormat:@"%ld",subWin.winChannelNum] forKey:kSUBWINCHANNELNUM];
    [dict setObject:[NSString stringWithFormat:@"%f",subWin.limitRect.origin.x] forKey:kSUBWINPARENTSTARTX];
    [dict setObject:[NSString stringWithFormat:@"%f",subWin.limitRect.origin.y] forKey:KSUBWINPARENTSTARTY];
    [dict setObject:[NSString stringWithFormat:@"%f",subWin.limitRect.size.width] forKey:kSUBWINPARENTWIDTH];
    [dict setObject:[NSString stringWithFormat:@"%f",subWin.limitRect.size.height] forKey:kSUBWINPARENTHEIGHT];
    [dict setObject:[NSString stringWithFormat:@"%f",[subWin getSubWinCentiStartX]] forKey:kSUBWINCENTISTARTX];
    [dict setObject:[NSString stringWithFormat:@"%f",[subWin getSubWinCentiStartY]] forKey:kSUBWINCENTISTARTY];
    [dict setObject:[NSString stringWithFormat:@"%f",[subWin getSubWinCentiWidth]] forKey:kSUBWINCENTIWIDTH];
    [dict setObject:[NSString stringWithFormat:@"%f",[subWin getSubWinCentiHeight]] forKey:kSUBWINCENTIHEIGHT];
    
    // 字典写入文件
    [dict writeToFile:savePath atomically:YES];
}

// 反序列化窗口情景模式
- (void)loadSubWinModelDataSource:(id)sender AtIndex:(NSInteger)nIndex
{
    skySubWin *subWin = (skySubWin *)sender;
    NSInteger nWinNum = subWin.winNumber;
    
    // 创建模式文件夹
    NSString *modelPath = [NSString stringWithFormat:@"ModelDir_%ld",nIndex];
    NSString *appDefaultsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *modelDirPath = [appDefaultsPath stringByAppendingPathComponent:modelPath];
    [[NSFileManager defaultManager] createDirectoryAtPath:modelDirPath withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *savePath = [modelDirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"skySubWin_%ld",nWinNum]];
    // 保存字典
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:savePath];

    // 提取数据
    [subWin setSubWinVisible:[[dict objectForKey:kSUBWINSHOWOUT] integerValue] == 1 ? YES : NO];
    subWin.winSourceType = [[dict objectForKey:kSUBWINSIGNALTYPE] integerValue];
    subWin.winChannelNum = [[dict objectForKey:kSUBWINCHANNELNUM] integerValue];
    subWin.limitRect = CGRectMake([[dict objectForKey:kSUBWINPARENTSTARTX] floatValue], [[dict objectForKey:KSUBWINPARENTSTARTY] floatValue], [[dict objectForKey:kSUBWINPARENTWIDTH] floatValue], [[dict objectForKey:kSUBWINPARENTHEIGHT] floatValue]);
    [subWin setSubWinCentiStartX:[[dict objectForKey:kSUBWINCENTISTARTX] floatValue]];
    [subWin setSubWinCentiStartY:[[dict objectForKey:kSUBWINCENTISTARTY] floatValue]];
    [subWin setSubWinCentiWidth:[[dict objectForKey:kSUBWINCENTIWIDTH] floatValue]];
    [subWin setSubWinCentiHeight:[[dict objectForKey:kSUBWINCENTIHEIGHT] floatValue]];
}

#pragma mark - skySignalView Delegate
// 获取信号源列表数据字典
- (NSMutableDictionary *)getTableData
{
    return [_appSignalDic copy];
}

// 获取控制器类型
- (NSInteger)getControllerType
{
    return _appControllerType;
}

#pragma mark - skyModelView DataSource
// 获取运行截图
- (UIImage *)getModelImageAtIndex:(NSInteger)nIndex
{
    return [_modelSavedImages objectAtIndex:nIndex];
}

// 获取保存日期
- (NSString *)getModelSaveDateAtIndex:(NSInteger)nIndex
{
    return @"";
}
// 保存情景模式状态
- (void)saveModelDataSource
{
    // 存入文件索引
    NSString *appDefaultsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *appStandardDir = [appDefaultsPath stringByAppendingPathComponent:@"AppStatus"];
    [[NSFileManager defaultManager] createDirectoryAtPath:appStandardDir withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *appDefaultFileName = [appStandardDir stringByAppendingPathComponent:APPMODELFILE];
    
    [_modelSavedDic writeToFile:appDefaultFileName atomically:YES];
}

// 确认情景模式是否可用
- (BOOL)isModelCanBeUsedAtIndex:(NSInteger)nIndex
{
    NSString *modelKey = [NSString stringWithFormat:@"Model-%ld",nIndex+1];
    
    NSInteger nValue = [[_modelSavedDic objectForKey:modelKey] integerValue];
    
    return (nValue == 1) ? YES : NO;
}

// 20140917 by wh 增加IP Port数据源接口
#pragma mark - skySettingConnection DataSource
// 获取当前IP地址
- (NSString *)getCurrentIPAddress
{
    return _appIPAddress;
}

// 获取当前端口号
- (NSInteger)getCurrentPortNumber
{
    return _appPortNumber;
}

#pragma mark - skySettingController DataSource
// 获取当前屏幕行数
- (NSInteger)getCurrentScreenRows
{
    return _appRows;
}

// 获取当前屏幕列数
- (NSInteger)getCurrentScreenColumns
{
    return _appColumns;
}

// 获取当前屏幕分辨率
- (NSInteger)getCurrentScreenResolution
{
    return _appResolution;
}

// 获取当前控制器类型
- (NSInteger)getCurrentControllerType
{
    return _appControllerType;
}

// 获取当前掉电记忆状态
- (BOOL)getCurrentPowerStatus
{
    return _appPowerSave;
}

// 获取当前温控状态
- (BOOL)getCurrentTemperatureStatus
{
    return _appTemperature;
}

// 获取当前边缘融合状态
- (BOOL)getCurrentStraightStatus
{
    return _appStraight;
}

// 获取当前蜂鸣器状态
- (BOOL)getCurrentBuzzerStatus
{
    return _appBuzzer;
}

#pragma mark - skySettingSignal DataSource
// 获取板卡数目
- (NSInteger)getSignalCardNumbers
{
    return _appCardNum;
}

// 设置输入板卡数目
- (void)setSignalCardNumber:(NSInteger)nNum
{
    _appCardNum = nNum;
}

// 获取板卡类型
- (NSInteger)getCardTypeAtIndex:(NSInteger)nIndex
{
    NSString *strKey = [NSString stringWithFormat:@"Card-%ld",nIndex];
    
    return [[_appSignalDic objectForKey:strKey] integerValue];
}

// 设置板卡类型
- (void)setCardTypeAtIndex:(NSInteger)nIndex withValue:(NSInteger)nType
{
    NSString *strKey = [NSString stringWithFormat:@"Card-%ld",nIndex];

    [_appSignalDic setObject:[NSString stringWithFormat:@"%ld",nType] forKey:strKey];
}

// 重置信号数据
- (void)resetSignalTypeData
{
    [_appSignalDic removeAllObjects];
}

#pragma mark - skyProtocolAdapter Delegate
// 设置控制器协议类型
- (void)adapterDelegateSetType:(NSInteger)nType
{
    _appProtocolType = nType;
}

// 获取控制器协议类型
- (NSInteger)adapterDelegateGetType
{
    return _appProtocolType;
}

#pragma mark - skyTVSettingController DataSource
// 获取命令控制器服务端IP地址
- (NSString *)getCurrnetCmdIPAddress
{
    return _appCmdIPAddress;
}

// 获取命令控制器服务端端口号
- (NSInteger)getCurrentCmdPortNumber
{
    return _appCmdPortNumber;
}

@end
