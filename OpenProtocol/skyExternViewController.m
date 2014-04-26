//
//  2013年8月14日 扩展飞入视图控制器
//  提供飞入视图功能 扩展主控界面功能
//

#import "skyExternViewController.h"

@interface skyExternViewController ()

@end

@implementation skyExternViewController

@synthesize sideAnimationDuration = _sideAnimationDuration;
@synthesize contentView = _contentView;

// 初始化
- (id)init
{
    self = [super init];
    if (self)
    {
        _sideAnimationDuration = 0.3f;
    }
    return self;
}

// 控制器载入
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置上下文视图
    self.view.backgroundColor = [UIColor clearColor];
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    // 设置范围位置
    CGRect selfViewFrame = self.view.bounds;
    self.contentView.frame = selfViewFrame;
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin;
        
    [self.view addSubview:self.contentView];
}

// 移入父控制器
- (void)willMoveToParentViewController:(UIViewController *)parent
{
    [UIView animateWithDuration:self.sideAnimationDuration animations:^{
        CGRect selfViewFrame = self.view.frame;
        selfViewFrame.origin.x = 0.0f;
        selfViewFrame.origin.y = 65.0f;
        self.view.frame = selfViewFrame;
    } completion:^(BOOL finished) {
        [super willMoveToParentViewController:parent];
    }];
}

// 移出父控制器
- (void)dismissController:(id)sender
{
    [self willMoveToParentViewController:nil];
    CGRect pareViewRect = self.parentViewController.view.bounds;
    
    [UIView animateWithDuration:self.sideAnimationDuration animations:^{
        self.view.frame = CGRectMake(0, -44, pareViewRect.size.width, 44);
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
    [self removeFromParentViewController];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
