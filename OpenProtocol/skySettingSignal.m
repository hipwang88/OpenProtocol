//
//  skySettingSignal.m
//  SkyworthSCXPJ
//
//  Created by skyworth on 13-8-8.
//  Copyright (c) 2013年 skyworth. All rights reserved.
//

#import "skySettingSignal.h"
#import "skyTableStepperCell.h"
#import "skyTableSelectionCell.h"

#define kTableStepperCell       @"skyTableStepperCell"
#define kTableSelectionCell     @"skyTableSelectionCell"

@interface skySettingSignal ()
{
    NSInteger nCardNum;
}

// 初始化组件
- (void)initComponents;
// 步进控件函数
- (void)handleStepperEvent;

@end

@implementation skySettingSignal

@synthesize signalTableView = _signalTableView;
@synthesize myDataSource = _myDataSource;

#pragma mark - Basic Methods
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initComponents];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGSize size = CGSizeMake(320.0f, 700.0f);
    //self.contentSizeForViewInPopover = size;
    self.preferredContentSize = size;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    // 先重置
    [_myDataSource resetSignalTypeData];
    // 然后设置
    for (int i = 0; i < nCardNum; i++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:1];
        skyTableSelectionCell *cell = (skyTableSelectionCell *)[_signalTableView cellForRowAtIndexPath:indexPath];
        
        [_myDataSource setCardTypeAtIndex:i+1 withValue:[cell getCurrentSelectionType]];
    }
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

- (void)viewDidUnload {
    [self setSignalTableView:nil];
    [super viewDidUnload];
}

#pragma mark - Private Methods
// 初始化组件
- (void)initComponents
{
    // 自定义Cell初始化
    [_signalTableView registerNib:[UINib nibWithNibName:@"skyTableStepperCell" bundle:nil] forCellReuseIdentifier:kTableStepperCell];
    [_signalTableView registerNib:[UINib nibWithNibName:@"skyTableSelectionCell" bundle:nil] forCellReuseIdentifier:kTableSelectionCell];
}

// 步进控件函数
- (void)handleStepperEvent
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    skyTableStepperCell *cell = (skyTableStepperCell *)[_signalTableView cellForRowAtIndexPath:indexPath];
    
    [_myDataSource setSignalCardNumber:(int)cell.valueStepper.value];
    
    nCardNum = (int)cell.valueStepper.value;
    
    [_signalTableView reloadData];
}

#pragma mark - TableView DataSource
// Sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

// Rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger nRowNumber = 0;
    
    if (section == 0)
    {
        nRowNumber = 1;
    }
    else
        nRowNumber = [_myDataSource getSignalCardNumbers];
    
    return nRowNumber;
}

// Cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 板卡数目调整
    if (indexPath.section == 0)
    {
        skyTableStepperCell *cell = (skyTableStepperCell *)[tableView dequeueReusableCellWithIdentifier:kTableStepperCell];
        
        //cell.labelTitle.text = @"板卡数目:";
        cell.labelTitle.text = NSLocalizedString(@"SignalSet_Num", nil);
        cell.lableValue.text = [NSString stringWithFormat:@"%ld",[_myDataSource getSignalCardNumbers]];
        cell.valueStepper.minimumValue = 1;
        cell.valueStepper.maximumValue = 24;
        cell.valueStepper.stepValue = 1;
        cell.valueStepper.value = (int)[_myDataSource getSignalCardNumbers];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        nCardNum = cell.valueStepper.value;
        [cell.valueStepper addTarget:self action:@selector(handleStepperEvent) forControlEvents:UIControlEventValueChanged];
        
        return cell;
    }
    else
    {
        skyTableSelectionCell *cell = (skyTableSelectionCell *)[tableView dequeueReusableCellWithIdentifier:kTableSelectionCell];
        
        cell.cellTitle.text = [NSString stringWithFormat:@"Card.%ld",indexPath.row+1];
        [cell setCurrentSelectionType:[_myDataSource getCardTypeAtIndex:indexPath.row+1]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *strResult;
    
    if (section == 0)
    {
        //strResult = @"输入信号板卡数目选择";
        strResult = NSLocalizedString(@"SignalSet_Info_CardNum", nil);
    }
    else
        //strResult = @"选择每张输入板卡的信号类型";
        strResult = NSLocalizedString(@"SignalSet_Info_CardType", nil);
    
    return strResult;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        return 68;
    }
    else
        return 44;
}

@end
