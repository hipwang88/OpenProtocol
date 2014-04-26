//
//  skySubWinPopover.m
//  SkyworthSCXPJ
//
//  Created by skyworth on 13-9-3.
//  Copyright (c) 2013年 skyworth. All rights reserved.
//

#import "skySubWinPopover.h"

@interface skySubWinPopover ()

///////////////////// Property ///////////////////////
@property (nonatomic, strong) NSMutableArray *imageArray;           // 图像列表

///////////////////// Methods ////////////////////////

///////////////////// Ends ///////////////////////////

@end

@implementation skySubWinPopover


@synthesize tableData = _tableData;
@synthesize popDelegate = _popDelegate;
@synthesize signalView = _signalView;
@synthesize imageArray = _imageArray;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"子窗口功能菜单";
    _tableData = [[NSMutableArray alloc] initWithObjects:@"关闭子窗口",@"信号切换", nil];
    
    // 初始图像序列
    _imageArray = [[NSMutableArray alloc] init];
    [_imageArray addObject:[UIImage imageNamed:@"cut.png"]];
    [_imageArray addObject:[UIImage imageNamed:@"switch.png"]];
    
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGSize size = CGSizeMake(320.0f, 450.0f);
    //self.contentSizeForViewInPopover = size;
    self.preferredContentSize = size;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self forcePopoverSize];
}

- (void)forcePopoverSize
{
    CGSize currentSetSizeForPopover  = self.preferredContentSize;//self.contentSizeForViewInPopover;
    CGSize fakeMomentarySize = CGSizeMake(currentSetSizeForPopover.width, currentSetSizeForPopover.height);
    //self.contentSizeForViewInPopover = fakeMomentarySize;
    //self.contentSizeForViewInPopover = currentSetSizeForPopover;
    self.preferredContentSize = fakeMomentarySize;
    self.preferredContentSize = currentSetSizeForPopover;
}

#pragma mark - Table view data source

// 列表块数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// 列表列数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

// 列表单元
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SubWinPopoverIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [_tableData objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.image = [_imageArray objectAtIndex:indexPath.row];
    
    return cell;
}

// 表头描述
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"功能项选择";
}

// 表尾描述
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSString *footerString = [NSString stringWithFormat:@"关闭子窗口：将当前子窗口关闭\n信号切换：点击进入信号切换页面选择输入信号"];
    
    return footerString;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 状态选择
    switch (indexPath.row)
    {
        case 0:
            // 关闭子窗
            [_popDelegate deleteSubWindow];
            break;
            
        case 1:
            // 推入信号切换视图
            [self.navigationController pushViewController:_signalView animated:YES];
            break;
    }
}

@end
