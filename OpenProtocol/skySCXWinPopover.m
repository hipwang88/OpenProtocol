//
//  skySCXWinPopover.m
//  SkyworthSCXPJ
//
//  Created by skyworth on 13-8-19.
//  Copyright (c) 2013年 skyworth. All rights reserved.
//

#import "skySCXWinPopover.h"

@interface skySCXWinPopover ()

@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation skySCXWinPopover

@synthesize delegatePop = _delegatePop;
@synthesize tableData = _tableData;
@synthesize array = _array;
@synthesize signalView = _signalView;

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

    self.title = @"窗口功能菜单";
    _array = [[NSMutableArray alloc] init];
    [_array addObject:[UIImage imageNamed:@"BigPic.png"]];
    [_array addObject:[UIImage imageNamed:@"Unit.png"]];
    [_array addObject:[UIImage imageNamed:@"switch.png"]];
    [_array addObject:[UIImage imageNamed:@"SCX.png"]];
    [_array addObject:[UIImage imageNamed:@"Add.png"]];
    
    self.tableView.sectionFooterHeight = 0;
    self.tableView.sectionHeaderHeight = 0;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_delegatePop getTableViewCellNum];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"skySCXWinPopoverIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [_tableData removeAllObjects];
    _tableData = [_delegatePop getTableViewCellData];
    
    cell.textLabel.text = [_tableData objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.image = [_array objectAtIndex:indexPath.row];
        
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"功能项选择";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSString *footString = [NSString stringWithFormat:@"全屏：让拼接墙全屏显示本窗口\n大画面分解：将大画面状态窗口分解成单画面\n信号切换：点击进入信号切换页面选择输入信号\n叠加开窗：实现窗口叠加功能，一个画面上叠加四个子窗口"];
    
    // 如果现在是大画面状态
    if ([_delegatePop isOverlying])
    {
        footString = [NSString stringWithFormat:@"全屏：让拼接墙全屏显示本窗口\n大画面分解：将大画面状态窗口分解成单画面\n信号切换：点击进入信号切换页面选择输入信号\n退出叠加状态：还原窗口为普通状态\n添加子窗口：在画面上加入一个叠加子窗"];
    }
    
    return footString;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 状态选择
    switch (indexPath.row) {
        case 0: // 全屏
            [_delegatePop fullScreen];
            break;
            
        case 1: // 大画面分解
            [_delegatePop resolveScreen];
            break;
            
        case 2: // 信号切换
            [self.navigationController pushViewController:_signalView animated:YES];
            break;
            
        case 3: // SCX
            if ([_delegatePop isOverlying])
                [_delegatePop leaveSCXStatus];      // 大画面状态离开叠加开窗
            else
                [_delegatePop enterSCXStatus];      // 普通窗口进入大画面状态
            break;
            
        case 4: // 添加子窗口
            [_delegatePop addSubWin];
            break;
    }
    
    [tableView reloadData];
}

@end
