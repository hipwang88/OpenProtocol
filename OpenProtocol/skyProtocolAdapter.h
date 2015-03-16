//
// 2013年9月6日 skyProtocolAdapter class
// 协议解析器 --- 解析各种协议内容
//

#import <Foundation/Foundation.h>
#import "definition.h"
#import "skySCXProtocol.h"              // 创维混合高清开发协议
#import "skyOpenSCXProtocol.h"          // 创维混合高清开放协议

// skyProtocolAdapter Delegate
@protocol skyProtocolAdapterDelegate <NSObject>

// 设置控制器协议类型
- (void)adapterDelegateSetType:(NSInteger)nType;
// 获取控制器协议类型
- (NSInteger)adapterDelegateGetType;

@end

// skyProtocolAdapter
@interface skyProtocolAdapter : NSObject

/////////////////// Property //////////////////////
@property (nonatomic, assign) NSInteger adapterType;                        // 协议类型
@property (nonatomic, assign) id<skyProtocolAdapterDelegate> delegate;      // 代理对象

/////////////////// Methods ///////////////////////
// 初始化类
- (id)initAdapterWithProtocolType:(NSInteger)nProtocolType;
// 状态初始
- (void)initialAdapter;
// 控制器连接
- (BOOL)adapterConnectToController:(NSString *)ipAddress Port:(NSInteger)nPort;
// 断开控制器连接
- (void)adapterDisconnection;
// 控制器重连
- (void)adapterReconnectToController;
// 控制器进入后台
- (void)adapterConnectEnterBackground;
// 设置控制器类型
- (void)setAdapterType:(NSInteger)nType;

/************************************协议代理输出接口***************************************/
// 1.控制器设置
- (void)adapterInitialControllerRow:(NSInteger)nRow Column:(NSInteger)nColumn Resolution:(NSInteger)nRes;
// 2.蜂鸣器开关
- (void)adapterBuzzerStatus:(BOOL)bFlag;
// 3.掉电记忆开关
- (void)adapterPowerMemoryStatus:(BOOL)bFlag;
// 4.温控开关
- (void)adapterTemperatureStatus:(BOOL)bFlag;
// 5.边缘屏蔽功能
- (void)adapterStraightStatus:(BOOL)bFlag;
// 6.情景新建 - CVBS
- (void)adapterModelNewWithCVBS;
// 7.情景新建 - HDMI
- (void)adapterModelNewWithHDMI;
// 8.情景保存
- (void)adapterSaveModelAtIndex:(NSInteger)nIndex;
// 9.情景加载
- (void)adapterLoadModelAtIndex:(NSInteger)nIndex;
// 10.情景删除
- (void)adapterDeleteModelAtIndex:(NSInteger)nIndex;
// 11.普通窗口信号切换
- (void)adapterSignalSwitchSCXWin:(NSInteger)nWinID ofType:(NSInteger)nSrcType toChannel:(NSInteger)nSrcPath X:(NSInteger)nStartX Y:(NSInteger)nStartY H:(NSInteger)nHCount V:(NSInteger)nVCount;
// 12.叠加底图窗口信号切换
- (void)adapterSignalSwitchOpenUnderWin:(NSInteger)nWinID ofType:(NSInteger)nSrcType toChannel:(NSInteger)nSrcPath;
// 13.叠加子窗口信号切换
- (void)adapterSignalSwitchSubWin:(NSInteger)nWinID ofType:(NSInteger)nSrcType toChannel:(NSInteger)nSrcPath;
// 14.大画面拼接
- (void)adapterSpliceSCXWin:(NSInteger)nWinID StartPanel:(NSInteger)nStart X:(NSInteger)nStartX Y:(NSInteger)nStartY V:(NSInteger)nVCount H:(NSInteger)nHCount ofType:(NSInteger)nSrcType toChannel:(NSInteger)nSrcPath;
// 15.大画面分解
- (void)adapterResolveSCXWin:(NSInteger)nWinID X:(NSInteger)nStartX Y:(NSInteger)nStartY H:(NSInteger)nHCount V:(NSInteger)nVCount;
// 16.进入叠加开窗
- (void)adapterEnterOpenStatus:(NSInteger)nWinID ofType:(NSInteger)nSrcType toChannel:(NSInteger)nSrcPath;
// 17.退出叠加开窗
- (void)adapterLeaveOpenStatus:(NSInteger)nWinID ofType:(NSInteger)nSrcType toChannel:(NSInteger)nSrcPath;
// 18.添加子窗口
- (void)adapterAddSubWin:(NSInteger)nSubID ofType:(NSInteger)nSrcType toChannel:(NSInteger)nSrcPath;
// 19.关闭子窗口
- (void)adapterDeleteSubWin:(NSInteger)nSubID ofType:(NSInteger)nSrcType toChannel:(NSInteger)nSrcPath;
// 20.移动子窗口 同时包括位置与大小
- (void)adapterMoveSubWin:(NSInteger)nSubID StartX:(NSInteger)nStartX StartY:(NSInteger)nStartY Width:(NSInteger)nWidth Height:(NSInteger)nHeight;
/*******************************************************************************************/

/////////////////// Ends //////////////////////////

@end
