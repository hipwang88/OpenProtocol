//
//  skyExternViewController+skyExternViewCategory.m
//  SkyworthSCXPJ
//
//  Created by skyworth on 13-8-14.
//  Copyright (c) 2013年 skyworth. All rights reserved.
//

#import "skyExternViewController+skyExternViewCategory.h"
#import "skyExternViewController.h"

@implementation UIViewController (skyExternViewCategory)

@dynamic topExternViewController;

// topExternViewController Setter
- (void)setTopExternViewController:(skyExternViewController *)topExternViewController
{
    CGRect selfFrame = CGRectMake(0, 0, self.view.bounds.size.width, 44);
    selfFrame.origin.y -= selfFrame.size.height;
    
    topExternViewController.view.frame = selfFrame;
    
    [self.view addSubview:topExternViewController.view];
    [self addChildViewController:topExternViewController];
    [topExternViewController willMoveToParentViewController:self];
}

@end
