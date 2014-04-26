//
//  2013年8月26日 叠加子窗口视图
//  叠加子窗口视图 负责程序叠加窗口交互功能
//  功能：1.模拟现实窗口
//       2.模拟现实信号通道与类型
//       3.实现信号切换
//       4.叠加窗口漫游与缩放
//

#import <UIKit/UIKit.h>
#import "skySubWinPopover.h"
#import "skySignalView.h"
#import "skyWinBoarder.h"
#import "definition.h"
 
// skySubWin DataSource 提供数据代理协议给状态管理对象来完成数据的保持与同步
@protocol skySubWinDataSource <NSObject>

// 子窗口初始化
- (void)initSubWinDataSource:(id)sender;
// 保存窗口数据到文件
- (void)saveSubWinDataSource:(id)sender;
// 保存叠加窗口情景模式数据
- (void)saveSubWinModelDataSource:(id)sender AtIndex:(int)nIndex;
// 反序列化窗口情景模式
- (void)loadSubWinModelDataSource:(id)sender AtIndex:(int)nIndex;

@end

// skySubWin Delegate 提供代理协议给控制器实现基本功能
@protocol skySubWinDelegate <NSObject>

// 开始进行缩放或移动
- (void)subWinBeginEditing:(id)sender;
// 添加子窗口
- (void)subWinAdd:(id)sender;
// 关闭子窗口
- (void)subWinDelete:(id)sender;
// 子窗口位置改变
- (void)subWinMove:(id)sender;
// 信号切换
- (void)subWin:(id)sender Signal:(int)nType SwitchTo:(int)nChannel;
// 获取数据代理
- (id<skySignalViewDataSource>)subWinSignalDataSource;

@end

// class skySubWin
@interface skySubWin : UIView <UIGestureRecognizerDelegate,skySubWinPopoverDelegate,skySignalViewDelegate>
{
    // 漫游窗口属性
    BOOL bVisible;                                                  // 窗口是否显示
    int nWinNumber;                                                 // 窗口编号
    int nSourceType;                                                // 信号源类型
    int nChannelNum;                                                // 矩阵通道
    CGRect rectSub;                                                 // 叠加子窗位置与大小
    CGRect rectParent;                                              // 子窗父窗口的位置与大小 —— 限制子窗范围
    CGFloat fCentiStartX;                                           // 起始点与长宽 占父窗口的百分比
    CGFloat fCentiStartY;
    CGFloat fCentiWidth;
    CGFloat fCentiHeight;
}

//////////////////// Property ////////////////////////
// 窗口属性
@property (nonatomic, assign) int winNumber;                        // 窗口编号
@property (nonatomic, assign) int winSourceType;                    // 信号类型
@property (nonatomic, assign) int winChannelNum;                    // 矩阵通道
@property (nonatomic, assign) CGRect limitRect;                     // 限制范围
// 控制代理与数据代理
@property (nonatomic, assign) id<skySubWinDelegate> delegate;       // 控制代理
@property (nonatomic, assign) id<skySubWinDataSource> dataSource;   // 数据源代理
// 窗口内组件
@property (nonatomic, strong) UIButton *funcBtn;                    // 窗口扩展按钮 - 支持弹出菜单
@property (nonatomic, strong) skyWinBoarder *boarderView;           // 窗口外框
@property (nonatomic, strong) UIPopoverController *popView;         // 弹出菜单
@property (nonatomic, strong) skySubWinPopover *subPop;             // 子窗口弹出菜单项目
// 手势识别器
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;   // 拖动手势识别器
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;   // 点击手势识别器

//////////////////// Methods /////////////////////////
// 窗口数据初始化
- (void)initializeSubWin:(int)nNum;
// 更新窗口
- (void)updateWindowUI;
// 保存窗口值
- (void)saveSubWinToFile;
// 切换矩阵
- (void)switchSignal:(int)nType toChannel:(int)nChannel;
// 计算窗口位置
- (void)calculateSubWinFrame;
// 添加子窗
- (void)addSubWinWithParentFrame:(CGRect)parentFrame sourceType:(int)nType andChannel:(int)nChannel;
// 删除子窗口
- (void)deleteSubWin;
// 转换为可控制状态
- (void)changeToControllStatus;
// 转换为不可控制状态
- (void)changeToUnControllStatus;
// 保存子窗的情景模式状态
- (void)saveSubWinModelStatusAtIndex:(int)nIndex;
// 加载子窗情景模式
- (void)loadSubWinModelStatusAtIndex:(int)nIndex;

//////////////////////////////////////////////////////
// 属性函数
- (void)setSubWinVisible:(BOOL)bShow;                               // 窗口是否可以显示
- (BOOL)getSubWinVisible;
- (void)setSubWinCentiStartX:(CGFloat)fValue;                       // 叠加窗口占父窗口百分比
- (CGFloat)getSubWinCentiStartX;
- (void)setSubWinCentiStartY:(CGFloat)fValue;
- (CGFloat)getSubWinCentiStartY;
- (void)setSubWinCentiWidth:(CGFloat)fValue;
- (CGFloat)getSubWinCentiWidth;
- (void)setSubWinCentiHeight:(CGFloat)fValue;
- (CGFloat)getSubWinCentiHeight;

//////////////////// Ends ////////////////////////////

@end
