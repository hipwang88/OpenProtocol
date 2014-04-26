//
//  2013年8月29日 信号源选择列表
//  信号源切换选择列表 负责对信号源的拖入式切换
//

#import <UIKit/UIKit.h>

//  控制代理
@protocol skySignalViewDelegate <NSObject>

// 进行信号切换
- (void)haveSignal:(int)nSourceType SwitchTo:(int)nChannelNum;

@end

// 数据源代理
@protocol skySignalViewDataSource <NSObject>

// 通过代理获取列表数据
- (NSMutableDictionary *)getTableData;
// 获取控制器类型
- (NSInteger)getControllerType;

@end

// class skySignalView
@interface skySignalView : UITableViewController

///////////////////// Property ////////////////////////
@property (nonatomic, assign) id<skySignalViewDataSource> dataSource;           // 信号源列表数据代理对象
@property (nonatomic, assign) id<skySignalViewDelegate> signalDelegate;         // 信号源列表代理

///////////////////// Methods /////////////////////////
// 初始化
- (void)initialSignalTable;

///////////////////// Ends ////////////////////////////

@end
