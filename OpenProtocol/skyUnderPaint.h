//
//  2013年8月12日   主界面底图
//  界面底视图 绘制单元框架与水印logo
//  1. 绘制logo水印
//  2. 实现X*Y线条框架

#import <UIKit/UIKit.h>

// delegate skyUnderPaintDelegate
@protocol skyUnderPaintDelegate <NSObject>

@optional
- (NSInteger)getSplitRows;                                  // 获取拼接行数
- (NSInteger)getSplitColumns;                               // 获取拼接列数
- (NSInteger)getSplitUnitWidth;                             // 获取单元宽度
- (NSInteger)getSplitUnitHeight;                            // 获取单元高度
- (NSInteger)getScreenWidth;                                // 获取主控区域宽度
- (NSInteger)getScreenHeight;                               // 获取主控区域高度

@end

// class skyUnderPaint
@interface skyUnderPaint : UIView

////////////////// Property /////////////////////
// 代理
@property (nonatomic, assign) id<skyUnderPaintDelegate> delegate;
// 拼接行数
@property (nonatomic, assign) NSInteger nRows;
@property (nonatomic, assign) NSInteger nColumns;
// 拼接区域
@property (nonatomic, assign) NSInteger nUnitWidth;
@property (nonatomic, assign) NSInteger nUnitHeight;
@property (nonatomic, assign) NSInteger nSplitWidth;
@property (nonatomic, assign) NSInteger nSplitHeight;

////////////////// Methods //////////////////////
// 获取规格
- (void)getUnderSpecification;
// 获取起始点
- (CGPoint)getStartPoint;

////////////////// Ends /////////////////////////


@end
