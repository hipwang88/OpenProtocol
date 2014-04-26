//
//  2013年8月12日 应用程序状态管理类
//  拼接应用基本数据管理 全局唯一对象存在
//

#import <Foundation/Foundation.h>
#import "skySCXWin.h"
#import "skySubWin.h"
#import "skySignalView.h"
#import "skyModelView.h"
#import "skySettingController.h"
#import "skySettingSignal.h"
#import "skyProtocolAdapter.h"

//
// Screen Size
#define APPVIEWWIDTH        1024                // 用户操作界面宽度
#define APPVIEWHEIGHT       704                 // 用户操作界面高度
//
// Files Name
#define APPDEFAULTFILE      @"appDefaultDatas"
#define APPSIGNALFILE       @"appSignalDatas"
#define APPMODELFILE        @"appModelDatas"
//
// Data's Keys
#define kAPPROWS            @"appRows"
#define kAPPCOLUMNS         @"appColumns"
#define kAPPUNITWIDTH       @"appUnitWidth"
#define kAPPUNITHEIGHT      @"appUnitHeight"
#define kAPPSCREENWIDTH     @"appScreenWidth"
#define kAPPSCREENHEIGHT    @"appScreenHeight"
#define kAPPCONTROLLERTYPE  @"appControllerType"
#define kAPPCARDCOUNT       @"appCardCount"
#define kAPPRESOLUTION      @"appResolution"
#define kAPPPOWERSAVE       @"appPowerSave"
#define kAPPTEMPERATURE     @"appTemperature"
#define kAPPSTRAIGHT        @"appStraight"
#define kAPPBUZZER          @"appBuzzer"
#define kAPPPROTOCOLTYPE    @"appProtocolType"
//
// skySCXWin Keys
#define kSCXWINSTARTX       @"skySCXWin_Start.x"
#define kSCXWINSTARTY       @"skySCXWin_Start.y"
#define kSCXWINSIZEW        @"skySCXWin_Size.W"
#define kSCXWINSIZEH        @"skySCXWin_Size.H"
#define kSCXWINMOVE         @"skySCXWin_Move"
#define kSCXWINRESIZE       @"skySCXWin_Resize"
#define kSCXWINBIGPICTURE   @"skySCXWin_BigPicture"
#define kSCXWINOPENWIN      @"skySCXWin_OpenWin"
#define kSCXWINSIGNALTYPE   @"skySCXWin_SignalType"
#define kSCXWINCHANNELNUM   @"skySCXWin_ChannelNum"
#define kSCXWINBWIDTH       @"skySCXWin_BasicWidth"
#define kSCXWINBHEIGHT      @"skySCXWin_BasicHeight"
#define kSCXWINCWIDTH       @"skySCXWin_CurrentWidth"
#define kSCXWINCHEIGHT      @"skySCXWin_CurrentHeight"
//
// skySubWin Keys
#define kSUBWINSHOWOUT      @"skySubWin_ShowOut"
#define kSUBWINSIGNALTYPE   @"skySubWin_SignalType"
#define kSUBWINCHANNELNUM   @"skySubWin_ChannelNum"
#define kSUBWINCENTISTARTX  @"skySubWin_CentiStartX"
#define kSUBWINCENTISTARTY  @"skySubWin_CentiStartY"
#define kSUBWINCENTIWIDTH   @"skySubWin_CentiWidth"
#define kSUBWINCENTIHEIGHT  @"skySubWin_CentiHeight"
#define kSUBWINPARENTSTARTX @"skySubWin_ParentStartX"
#define KSUBWINPARENTSTARTY @"skySubWin_ParentStartY"
#define kSUBWINPARENTWIDTH  @"skySubWin_ParentWidth"
#define kSUBWINPARENTHEIGHT @"skySubWin_ParentHeight"



// class skyAppStatus
@interface skyAppStatus : NSObject<skySCXWinDataSource,skySubWinDataSource,skySignalViewDataSource,
        skyModelViewDataSource,skySettingControllerDataSource,skySettingSignalDataSource,skyProtocolAdapterDelegate>

///////////////// Property /////////////////////
// 程序基本数据字典
@property (nonatomic, strong) NSMutableDictionary *appDefaultsDic;
// 信号源数据字典
@property (nonatomic, strong) NSMutableDictionary *appSignalDic;
// 情景模式保存图片数组
@property (nonatomic, strong) NSMutableArray *modelSavedImages;
// 情景模式数据字典
@property (nonatomic, strong) NSMutableDictionary *modelSavedDic;
// 拼接规格数据
@property (nonatomic, assign) NSInteger appRows;            // 行数
@property (nonatomic, assign) NSInteger appColumns;         // 列数
@property (nonatomic, assign) NSInteger appUnitWidth;       // 单元宽度
@property (nonatomic, assign) NSInteger appUnitHeight;      // 单元高度
@property (nonatomic, assign) NSInteger appScreenWidth;     // 区域宽度
@property (nonatomic, assign) NSInteger appScreenHeight;    // 区域高度
@property (nonatomic, assign) NSInteger appControllerType;  // 控制器类型
@property (nonatomic, assign) NSInteger appCardNum;         // 输入板卡个数
@property (nonatomic, assign) NSInteger appResolution;      // 输出分辨率
@property (nonatomic, assign) NSInteger appProtocolType;    // 协议类型
@property (nonatomic, assign) BOOL      appPowerSave;       // 控制器掉电记忆
@property (nonatomic, assign) BOOL      appTemperature;     // 温控开关
@property (nonatomic, assign) BOOL      appStraight;        // 边缘融合
@property (nonatomic, assign) BOOL      appBuzzer;          // 蜂鸣器开关

///////////////// Methods //////////////////////
// 初始化
- (void)appDefaultInit;
// 情景保存图片存储
- (void)saveModelImage:(UIImage *)image toIndex:(int)nIndex;
// 情景保存图片删除
- (void)deleteModelImageAtIndex:(int)nIndex;
// 保存程序基本数据
- (void)appDefaultDatasSave;
// 计算区域矩形
- (void)calculateScreenSize;
// 删除普通窗口数据文件
- (void)deleteSCXWindowData;
// 删除情景模式记录
- (void)deleteAllModelData;

///////////////// Ends /////////////////////////

@end
