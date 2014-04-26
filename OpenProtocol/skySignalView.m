//
//  skySignalView.m
//  SkyworthSCXPJ
//
//  Created by skyworth on 13-8-6.
//  Copyright (c) 2013年 skyworth. All rights reserved.
//

#import "skySignalView.h"
#import "skyCell1.h"
#import "skyCell2.h"

@interface skySignalView ()

////////////////////// Property ///////////////////////
@property (nonatomic, assign) NSInteger nControllerType;                // 控制器类型
@property (nonatomic, assign) BOOL isOpen;                              // 板卡是否展开
@property (nonatomic, strong) NSIndexPath *selectIndex;                 // 选择项
@property (nonatomic, strong) NSMutableDictionary *dictData;            // 列表数据
@property (nonatomic, assign) NSInteger selectSourceType;               // 选择的信号源类型
@property (nonatomic, assign) NSInteger selectChannelNum;               // 选择的信号通道

////////////////////// Methods ////////////////////////
// 列表初始化
- (void)initSignalTable;
// 初始化数据
- (void)initDefaultDatas;
// 获取板卡数据
- (NSString *)getCardNameWithIndexPath:(NSIndexPath *)indexPath;
// 获取板卡信号图片
- (UIImage *)getCardImageWithIndexPath:(NSIndexPath *)indexPath;
// 控制Row的显示与隐藏
- (void)didSelectCellRowFirstDo:(BOOL)firstDoInsert nextDo:(BOOL)nextDoInsert;
// 计算选择的信号类型与通道
- (void)calculateSelectionDatas:(NSIndexPath *)indexPath;

////////////////////// Ends ///////////////////////////

@end

@implementation skySignalView

@synthesize dictData = _dictData;
@synthesize signalDelegate = _signalDelegate;
@synthesize dataSource = _dataSource;
@synthesize isOpen = _isOpen;
@synthesize nControllerType = _nControllerType;
@synthesize selectSourceType = _selectSourceType;
@synthesize selectChannelNum = _selectChannelNum;

#pragma mark - Basic Methods
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Initialize
        [self initDefaultDatas];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"信号切换";
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
    
    [self initialSignalTable];
    
    [self.tableView reloadData];
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

#pragma mark - Private Methods
// 列表初始化
- (void)initSignalTable
{
    // 从代理对象中获取列表字典数据
    _dictData = [_dataSource getTableData];
    // 从代理对象中获取控制器类型
    _nControllerType = [_dataSource getControllerType];
}

// 初始化数据
- (void)initDefaultDatas
{
    _isOpen = NO;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.sectionHeaderHeight = 0;
}

// 获取板卡数据
- (NSString *)getCardNameWithIndexPath:(NSIndexPath *)indexPath
{
    NSString *stringValue,*stringType;
    int nIndex,nType;
    
    // 获取板卡类型
    nType = [[_dictData objectForKey:[NSString stringWithFormat:@"Card-%d",indexPath.section+1]] integerValue];
    switch (nType) {
        case 0:
            stringType = [NSString stringWithFormat:@"HDMI - "];
            break;
            
        case 1:
            stringType = [NSString stringWithFormat:@"DVI - "];
            break;
            
        case 2:
            stringType = [NSString stringWithFormat:@"VGA - "];
            break;
            
        case 3:
            stringType = [NSString stringWithFormat:@"CVBS - "];
            break;
    }
    
    // 根据控制器类型设置板卡数据
    switch (_nControllerType)
    {
        case 1:     // 16x16
            if (indexPath.section < 2)
                nIndex = indexPath.section*8 + indexPath.row;
            else
                nIndex = (indexPath.section-2)*4 + indexPath.row;
            break;
            
        case 2:     // 32x32
            if (indexPath.section < 4)
                nIndex = indexPath.section*8 + indexPath.row;
            else
                nIndex = (indexPath.section-4)*4 + indexPath.row;
            break;
            
        case 3:     // 64x64
            if (indexPath.section < 8)
                nIndex = indexPath.section*8 + indexPath.row;
            else
                nIndex = (indexPath.section-8)*4 + indexPath.row;
            break;
    }
    
    // 设置数据
    stringValue = [NSString stringWithFormat:@"%@%d",stringType,nIndex];

    return stringValue;
}

// 获取板卡信号图片
- (UIImage *)getCardImageWithIndexPath:(NSIndexPath *)indexPath
{
    int nType;
    UIImage *image;
    
    // 获取板卡类型
    nType = [[_dictData objectForKey:[NSString stringWithFormat:@"Card-%d",indexPath.section+1]] integerValue];
    switch (nType) {
        case 0:
            image = [UIImage imageNamed:@"signal_HDMI-Small"];
            break;
            
        case 1:
            image = [UIImage imageNamed:@"signal_DVI-Small"];
            break;
            
        case 2:
            image = [UIImage imageNamed:@"signal_VGA-Small"];
            break;
            
        case 3:
            image = [UIImage imageNamed:@"signal_CVBS-Small"];
            break;
    }

    return image;
}

// 计算选择的信号类型与通道
- (void)calculateSelectionDatas:(NSIndexPath *)indexPath
{
    // 获取信号类型
    _selectSourceType = [[_dictData objectForKey:[NSString stringWithFormat:@"Card-%d",indexPath.section+1]] integerValue];
    
    // 计算通道
    // 根据控制器类型设置板卡数据
    switch (_nControllerType)
    {
        case 1:     // 16x16
            if (indexPath.section < 2)
                _selectChannelNum = indexPath.section*8 + indexPath.row;
            else
                _selectChannelNum = (indexPath.section-2)*4 + indexPath.row;
            break;
            
        case 2:     // 32x32
            if (indexPath.section < 4)
                _selectChannelNum = indexPath.section*8 + indexPath.row;
            else
                _selectChannelNum = (indexPath.section-4)*4 + indexPath.row;
            break;
            
        case 3:     // 64x64
            if (indexPath.section < 8)
                _selectChannelNum = indexPath.section*8 + indexPath.row;
            else
                _selectChannelNum = (indexPath.section-8)*4 + indexPath.row;
            break;
    }
}
 
#pragma mark - Public Methods
// 初始化
- (void)initialSignalTable
{
    [self initSignalTable];
}

#pragma mark - Table view data source
// Sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dictData count];
}

// Rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isOpen)
    {
        // 选择Section
        if (self.selectIndex.section == section)
        {
            if ([[_dictData objectForKey:[NSString stringWithFormat:@"Card-%d",_selectIndex.section+1]] integerValue] == 3)
                return 8 + 1;
            else
                return 4 + 1;
        }
    }
    
    return 1;
}

// Cell Height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

// Table Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isOpen && _selectIndex.section == indexPath.section && indexPath.row != 0)
    {
        static NSString *CellIdentifier = @"Cell2";
        skyCell2 *cell = (skyCell2 *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"skyCell2" owner:self options:nil] objectAtIndex:0];
        }
        
        cell.titleLabel.text = [self getCardNameWithIndexPath:indexPath];
        cell.imageShow.image = [self getCardImageWithIndexPath:indexPath];
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"Cell1";
        skyCell1 *cell = (skyCell1 *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"skyCell1" owner:self options:nil] objectAtIndex:0];
        }
        
        NSString *stringType;
        switch ([[_dictData objectForKey:[NSString stringWithFormat:@"Card-%d",indexPath.section+1]] integerValue])
        {
            case 0: stringType = [NSString stringWithFormat:@"HDMI"]; break;
            case 1: stringType = [NSString stringWithFormat:@"DVI"]; break;
            case 2: stringType = [NSString stringWithFormat:@"VGA"]; break;
            case 3: stringType = [NSString stringWithFormat:@"CVBS"]; break;
        }
        cell.titleLabel.text = [NSString stringWithFormat:@"Card.%d - %@",indexPath.section+1,stringType];
        cell.imageView.image = [UIImage imageNamed:@"signal_Card-Small"];
        [cell changeArrowWithUp:([self.selectIndex isEqual:indexPath] ? YES : NO)];
        return cell;
    }
}

#pragma mark - Table view delegate
// 选择某个Cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        if ([indexPath isEqual:self.selectIndex])
        {
            self.isOpen = NO;
            [self didSelectCellRowFirstDo:NO nextDo:NO];
            self.selectIndex = nil;
        }
        else
        {
            if (!self.selectIndex)
            {
                self.selectIndex = indexPath;
                [self didSelectCellRowFirstDo:YES nextDo:NO];
            }
            else
            {
                [self didSelectCellRowFirstDo:NO nextDo:YES];
            }
        }
    }
    else
    {
        // 先获取选择的数据
        [self calculateSelectionDatas:indexPath];
        // 代理调用进行切换
        [_signalDelegate haveSignal:_selectSourceType SwitchTo:_selectChannelNum];
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// 控制Row的显示与隐藏
- (void)didSelectCellRowFirstDo:(BOOL)firstDoInsert nextDo:(BOOL)nextDoInsert
{
    self.isOpen = firstDoInsert;
    
    skyCell1 *cell = (skyCell1 *)[self.tableView cellForRowAtIndexPath:self.selectIndex];
    [cell changeArrowWithUp:firstDoInsert];
    
    [self.tableView beginUpdates];
    
    int section = self.selectIndex.section;
    int contentCount;
    switch (_nControllerType)
    {
        case 1:
            if (section < 2)
                contentCount = 8;
            else
                contentCount = 4;
            break;
            
        case 2:
            if (section < 4)
                contentCount = 8;
            else
                contentCount = 4;
            break;
            
        case 3:
            if (section < 8)
                contentCount = 8;
            else
                contentCount = 4;
    }
	NSMutableArray* rowToInsert = [[NSMutableArray alloc] init];
	for (NSUInteger i = 1; i <= contentCount; i++)
    {
		NSIndexPath* indexPathToInsert = [NSIndexPath indexPathForRow:i inSection:section];
		[rowToInsert addObject:indexPathToInsert];
	}
	
	if (firstDoInsert)
    {
        [self.tableView insertRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }
	else
    {
        [self.tableView deleteRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }
    	
	[self.tableView endUpdates];
    
    if (nextDoInsert)
    {
        self.isOpen = YES;
        self.selectIndex = [self.tableView indexPathForSelectedRow];
        [self didSelectCellRowFirstDo:YES nextDo:NO];
    }
    
    if (self.isOpen)
        [self.tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
}

@end
