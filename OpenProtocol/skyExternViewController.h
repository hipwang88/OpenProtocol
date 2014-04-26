//
//  2013年8月14日 扩展飞入视图控制器
//  提供飞入视图功能 扩展主控界面功能
//

#import <UIKit/UIKit.h>

@interface skyExternViewController : UIViewController

@property (nonatomic, assign) CGFloat sideAnimationDuration;              // 飞入动画时间
@property (nonatomic, strong) UIView *contentView;                        // 上下文视图

- (void)dismissController:(id)sender;

@end
