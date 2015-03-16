//
//  2013年8月14日 漫游窗口视图
//  主控漫游窗口视图 负责程序的主要交互功能
//  功能：1.模拟现实窗口
//       2.模拟现实信号通道与类型
//       3.实现信号切换
//       4.实现拼接与分解功能
//       5.实现叠加开窗功能
//

#import <UIKit/UIKit.h>
#import "skySCXWinPopover.h"
#import "skySignalView.h"
#import "skyWinBoarder.h"
#import "definition.h"

// skySCXWin Delegate 提供代理接口给控制器使用实现基本功能
@protocol skySCXWinDelegate <NSObject>

// 开始进行缩放或者移动
- (void)scxWinBeginEditing:(id)sender;
// 全局数组数值更新 -- 父控制器中一个维持大画面状态值的数组
- (void)updateBigPicStatusWithStart:(CGPoint)ptStart andSize:(CGSize)szArea withWinNum:(NSInteger)nNum;
// 判断窗口是否遇到大画面
- (BOOL)isSCXWinCanReachBigPicture:(CGRect)rectFrame;
// 窗口拼接
- (void)scxWinSpliceScreen:(id)sender;
// 窗口满屏
- (void)scxWinFullScreen:(id)sender;
// 窗口大画面分解
- (void)scxWinResolveScreen:(id)sender;
// 窗口进入叠加开窗状态
- (void)scxWinEnterOpenStatus:(id)sender;
// 窗口离开叠加开窗状态
- (void)scxWinLeaveOpenStatus:(id)sender;
// 添加叠加子窗口
- (void)scxWinAddSubWindow:(id)sender;
// 信号切换
- (void)scxWin:(id)sender Signal:(NSInteger)nType SwitchTo:(NSInteger)nChannel;
// 获取数据代理
- (id<skySignalViewDataSource>)scxWinSignalDataSource;
// 获取窗口输出分辨率
- (NSInteger)scxWinGetResolution;

@end

// skySCXWin DataSource 提供数据源代理
@protocol skySCXWinDataSource <NSObject>

// 数据源初始化
- (void)initSCXWinDataSource:(id)sender;
// 数据序列化到文件
- (void)saveSCXWinDataSource:(id)sender;
// 窗口的情景数据序列化到文件
- (void)saveSCXWinModelDataSource:(id)sender AtIndex:(NSInteger)nIndex;
// 反序列化窗口情景模式
- (void)loadSCXWinModelDataSource:(id)sender AtIndex:(NSInteger)nIndex;

@end

// class skySCXWin
@interface skySCXWin : UIView <UIGestureRecognizerDelegate,skySCXWinPopoverDelegate,skySignalViewDelegate>
{
    // 状态开关
    BOOL          bRemovable;                                           // 可移动
    BOOL          bScalable;                                            // 可缩放
    BOOL          bBigPicture;                                          // 是否大画面
    BOOL          bOverlying;                                           // 是否叠加开窗
    // 窗口属性
    NSInteger     nWinNumber;                                           // 窗口编号
    NSInteger     nSignalType;                                          // 信号类型 0-HDMI 1-DVI 2-VGA 3-CVBS 4-SDI
    NSInteger     nChannelNum;                                          // 信号通道号
    NSInteger     nBasicWinWidth;                                       // 单元窗口宽度
    NSInteger     nBasicWinHeight;                                      // 单元窗口高度
    NSInteger     nCurrentWinWidth;                                     // 当前窗口宽度
    NSInteger     nCurrentWinHeight;                                    // 当前窗口高度
    // 窗口范围
    CGRect  windowRect;                                                 // 窗口范围
}

////////////////// Property //////////////////////
// 窗口属性
@property (nonatomic, assign) NSInteger winNumber;                      // 窗口编号
@property (nonatomic, assign) NSInteger winSourceType;                  // 信号类型
@property (nonatomic, assign) NSInteger winChannelNum;                  // 信号通道
@property (nonatomic, assign) CGPoint startPoint;                       // 窗口起始点
@property (nonatomic, assign) CGSize winSize;                           // 窗口纵横跨屏大小
@property (nonatomic, assign) CGPoint startCanvas;                      // 画布起始点
@property (nonatomic, assign) CGRect limitRect;                         // 范围限制
// 窗口内组件
@property (nonatomic, strong) UILabel *winNumLabel;                     // 窗口编号
@property (nonatomic, strong) UILabel *signalLabel;                     // 信源通道
@property (nonatomic, strong) UILabel *posLabel;                        // 窗口位置
@property (nonatomic, strong) UILabel *sizeLabel;                       // 窗口大小
@property (nonatomic, strong) UIButton *funcBtn;                        // 窗口扩展按钮 - 支持弹出菜单
// 窗口支持组件
@property (nonatomic, strong) skyWinBoarder *boarderView;               // 可缩放外框
@property (nonatomic, strong) UIPopoverController *popView;             // 弹出式菜单
@property (nonatomic, strong) skySCXWinPopover *scxPop;                 // 窗口弹出菜单主控制器
@property (nonatomic, assign) id<skySCXWinDelegate> delegate;           // 代理对象
@property (nonatomic, assign) id<skySCXWinDataSource> dataSource;       // 数据源对象
// 手势识别器
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;       // 拖动手势识别器
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;       // 点击手势识别器

////////////////// Methods ///////////////////////
// 窗口初始
- (id)initWithFrame:(CGRect)frame withRow:(NSInteger)nRow andColumn:(NSInteger)nColumn;
// 窗口数据初始化
- (void)initializeSCXWin:(NSInteger)nwinNum;
// 窗口UI更新
- (void)updateWindowUI;
// 切换矩阵
- (void)switchSignal:(NSInteger)nType toChannel:(NSInteger)nChannel;
// 窗口大小改变
- (void)splitWinStartX:(NSInteger)startx StartY:(NSInteger)starty HCount:(NSInteger)nHcount VCount:(NSInteger)nVCount;
// CVBS新建
- (void)newWithCVBS;
// HDMI新建
- (void)newWithHDMI;
// 保存状态到文件
- (void)saveSCXWinToFile;
// 显示外框
- (void)showBoarderView;
// 隐藏外框
- (void)hideBoarderView;
// 结束缩放后重新刷新窗口 --- 让窗口满屏
- (void)reCaculateSCXWinToFullScreen;
// 窗口单屏状态
- (void)setSCXWinToSingleStatus;
// 窗口全屏状态
- (void)setSCXWinToFullStatus;
// 窗口叠加状态
- (void)setSCXWinToOpenStatus;
// 窗口普通状态
- (void)setSCXWinToNormalStatus;
// 保存当前窗口的情景模式
- (void)saveSCXWinModelStatusAtIndex:(NSInteger)nIndex;
// 加载窗口情景模式
- (void)loadSCXWinModelStatusAtIndex:(NSInteger)nIndex;

//////////////////////////////////////////////////
// 属性函数
- (void)setSCXWinMove:(BOOL)bMove;                                      // 设置移动属性
- (BOOL)getSCXWinMove;                                                  // 获取移动属性
- (void)setSCXWinResize:(BOOL)bResize;                                  // ..
- (BOOL)getSCXWinResize;                                                // ..
- (void)setSCXWinBigPicture:(BOOL)bBigPic;                              // ..
- (BOOL)getSCXWinBigPicture;                                            // ..
- (void)setSCXWinOpen:(BOOL)bOpen;                                      // ..
- (BOOL)getSCXWinOpen;                                                  // ..
// 窗口规格
- (void)setSCXWinBasicWinWidth:(NSInteger)nBasicWidth;
- (NSInteger)getSCXWinBasicWinWidth;
- (void)setSCXWinBasicWinHeight:(NSInteger)nBasicHeight;
- (NSInteger)getSCXWinBasicWinHeight;
- (void)setSCXWinCurrentWinWidth:(NSInteger)nCurrentWidth;
- (NSInteger)getSCXWinCurrentWinWidth;
- (void)setSCXWinCurrentWinHeight:(NSInteger)nCurrentHeight;
- (NSInteger)getSCXWinCurrentWinHeight;

////////////////// Ends //////////////////////////

@end
