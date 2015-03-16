//
//  skySettingController.m
//  SkyworthSCXPJ
//
//  Created by skyworth on 13-8-8.
//  Copyright (c) 2013年 skyworth. All rights reserved.
//

#import "skySettingController.h"
#import "skyTableStepperCell.h"
#import "skyTableSliderCell.h"
#import "skyTableButtonCell.h"

#define kTableStepperCell   @"skyTableStepperCell"
#define kTableSliderCell    @"skyTableSliderCell"
#define kTableButtonCell    @"skyTableButtonCell"

@interface skySettingController ()

///////////////////////// Property ///////////////////////////
@property (nonatomic,strong) NSArray *resArray;
@property (nonatomic,strong) NSArray *typeArray;
@property (nonatomic,assign) NSInteger screenRow;
@property (nonatomic,assign) NSInteger screenColumn;
@property (nonatomic,assign) NSInteger screenResolution;

///////////////////////// Methods ////////////////////////////
// 初始化组件
- (void)initComponents;
// 屏幕行数调整函数
- (void)screenRowsStepperEvent;
// 屏幕列数调整函数
- (void)screenColumnsStepperEvent;
// 屏幕分辨率调整函数
- (void)screenResolutionSliderEvent;
// 控制器类型调整函数
- (void)controllerTypeSliderEvent;
// 掉电记忆功能函数
- (void)switchPowerSaveEvent;
// 温控开关函数
- (void)switchTemperatureEvent;
// 边缘融合功能
- (void)switchStraightEvent;
// 蜂鸣器功能
- (void)switchBuzzerEvent;
// 确认控制器设置
- (void)confirmControllerSettingEvent;

///////////////////////// Ends ////////////////////////////////

@end

@implementation skySettingController

@synthesize switchPowerSave = _switchPowerSave;
@synthesize switchTemperature = _switchTemperature;
@synthesize switchStraight = _switchStraight;
@synthesize switchBuzzer = _switchBuzzer;
@synthesize myDataSource = _myDataSource;
@synthesize myDelegate = _myDelegate;
@synthesize tableView = _tableView;
@synthesize resArray = _resArray;
@synthesize typeArray = _typeArray;
@synthesize screenRow = _screenRow;
@synthesize screenColumn = _screenColumn;
@synthesize screenResolution = _screenResolution;

#pragma mark - Basic Methods
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // 组件初始化
    [self initComponents];
    
    _resArray = [[NSArray alloc] initWithObjects:@"1024x768",@"1280x720",@"1366x768",@"1440x900",@"1280x1024",@"1600x1200",@"1920x1080",@"1920x1200", nil];
    _typeArray = [[NSArray alloc] initWithObjects:@"none",@"16x16",@"32x32",@"64x64", nil];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGSize size = CGSizeMake(320.0f, 700.0f);
    //self.contentSizeForViewInPopover = size;
    self.preferredContentSize = size;
    
    [_tableView reloadData];
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

#pragma mark - Public Methods

#pragma mark - Private Methods
// 初始化组件
- (void)initComponents
{
    // 初始化nib
    [_tableView registerNib:[UINib nibWithNibName:@"skyTableStepperCell" bundle:nil] forCellReuseIdentifier:kTableStepperCell];
    [_tableView registerNib:[UINib nibWithNibName:@"skyTableSliderCell" bundle:nil] forCellReuseIdentifier:kTableSliderCell];
    [_tableView registerNib:[UINib nibWithNibName:@"skyTableButtonCell" bundle:nil] forCellReuseIdentifier:kTableButtonCell];
    
    // 初始化切换控件
    _switchPowerSave = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [_switchPowerSave addTarget:self action:@selector(switchPowerSaveEvent) forControlEvents:UIControlEventValueChanged];
    _switchTemperature = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [_switchTemperature addTarget:self action:@selector(switchTemperatureEvent) forControlEvents:UIControlEventValueChanged];
    _switchStraight = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [_switchStraight addTarget:self action:@selector(switchStraightEvent) forControlEvents:UIControlEventValueChanged];
    _switchBuzzer = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [_switchBuzzer addTarget:self action:@selector(switchBuzzerEvent) forControlEvents:UIControlEventValueChanged];
}

// 屏幕行数调整函数
- (void)screenRowsStepperEvent
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    skyTableStepperCell *cell = (skyTableStepperCell *)[_tableView cellForRowAtIndexPath:indexPath];
    
    cell.lableValue.text = [NSString stringWithFormat:@"%d",(int)cell.valueStepper.value];
    
    _screenRow = (int)cell.valueStepper.value;
}

// 屏幕列数调整函数
- (void)screenColumnsStepperEvent
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    
    skyTableStepperCell *cell = (skyTableStepperCell *)[_tableView cellForRowAtIndexPath:indexPath];
    
    cell.lableValue.text = [NSString stringWithFormat:@"%d",(int)cell.valueStepper.value];
    
    _screenColumn = (int)cell.valueStepper.value;
}

// 屏幕分辨率调整函数
- (void)screenResolutionSliderEvent
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    
    skyTableSliderCell *cell = (skyTableSliderCell *)[_tableView cellForRowAtIndexPath:indexPath];
    
    cell.cellSlider.value = (int)(cell.cellSlider.value + 0.5);
    cell.cellDetail.text = [_resArray objectAtIndex:(int)cell.cellSlider.value];
    
    _screenResolution = (int)cell.cellSlider.value;
    
    NSLog(@"Changed");
}

// 控制器类型调整函数
- (void)controllerTypeSliderEvent
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
    
    skyTableSliderCell *cell = (skyTableSliderCell *)[_tableView cellForRowAtIndexPath:indexPath];
    
    cell.cellSlider.value = (int)(cell.cellSlider.value + 0.5);
    cell.cellDetail.text = [_typeArray objectAtIndex:(int)cell.cellSlider.value];
    
    // 代理调用
    [_myDelegate setCurrentControllerType:(int)cell.cellSlider.value];
}

// 掉电记忆功能函数
- (void)switchPowerSaveEvent
{
    BOOL bFlag = _switchPowerSave.on;
    
    // 协议发送
    [_myDelegate setCurrentPowerStatus:bFlag];
}

// 温控开关函数
- (void)switchTemperatureEvent
{
    BOOL bFlag = _switchTemperature.on;
    
    // 协议发送
    [_myDelegate setCurrentTemperatureStatus:bFlag];
}

// 边缘融合功能
- (void)switchStraightEvent
{
    BOOL bFlag = _switchStraight.on;
    
    // 协议发送
    [_myDelegate setCurrentStraightStatus:bFlag];
}

// 蜂鸣器功能
- (void)switchBuzzerEvent
{
    BOOL bFlag = _switchBuzzer.on;
    
    // 协议发送
    [_myDelegate setCurrentBuzzerStatus:bFlag];
}

// 确认控制器设置
- (void)confirmControllerSettingEvent
{
    // 协议发送
    [_myDelegate setCurrentRow:_screenRow Column:_screenColumn Resolution:_screenResolution];
}

#pragma mark - UITableView DataSource
// section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

// rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int nResult = 0;
    
    if (section == 0)
    {
        nResult = 2;
    }
    else if (section == 1)
    {
        nResult = 2;
    }
    else if (section == 2)
    {
        nResult = 4;
    }
    else if (section == 3)
    {
        nResult = 1;
    }
    
    return nResult;
}

// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 屏幕规格设置
    if (indexPath.section == 0)
    {
        skyTableStepperCell *cell = (skyTableStepperCell *)[tableView dequeueReusableCellWithIdentifier:kTableStepperCell];
        
        switch (indexPath.row)
        {
            case 0:
                cell.labelTitle.text = @"屏幕行数:";
                cell.lableValue.text = [NSString stringWithFormat:@"%ld",[_myDataSource getCurrentScreenRows]];
                cell.valueStepper.minimumValue = 1;
                cell.valueStepper.maximumValue = 16;
                cell.valueStepper.stepValue = 1;
                cell.valueStepper.value = [_myDataSource getCurrentScreenRows];
                [cell.valueStepper addTarget:self action:@selector(screenRowsStepperEvent) forControlEvents:UIControlEventValueChanged];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                // 同步行数
                _screenRow = [_myDataSource getCurrentScreenRows];
                break;
                
            case 1:
                cell.labelTitle.text = @"屏幕列数:";
                cell.lableValue.text = [NSString stringWithFormat:@"%ld",[_myDataSource getCurrentScreenColumns]];
                cell.valueStepper.minimumValue = 1;
                cell.valueStepper.maximumValue = 16;
                cell.valueStepper.stepValue = 1;
                cell.valueStepper.value = [_myDataSource getCurrentScreenColumns];
                [cell.valueStepper addTarget:self action:@selector(screenColumnsStepperEvent) forControlEvents:UIControlEventValueChanged];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                // 同步列数
                _screenColumn = [_myDataSource getCurrentScreenColumns];
                break;
        }
        
        return cell;
    }
    else if (indexPath.section == 1)
    {
        skyTableSliderCell *cell = (skyTableSliderCell *)[tableView dequeueReusableCellWithIdentifier:kTableSliderCell];
        
        switch (indexPath.row)
        {
            case 0:
                cell.cellTitle.text = @"屏幕输出分辨率";
                cell.cellDetail.text = [_resArray objectAtIndex:[_myDataSource getCurrentScreenResolution]];
                cell.cellSlider.minimumValue = 0;
                cell.cellSlider.maximumValue = 7;
                cell.cellSlider.continuous = NO;
                cell.cellSlider.value = [_myDataSource getCurrentScreenResolution];
                [cell.cellSlider addTarget:self action:@selector(screenResolutionSliderEvent) forControlEvents:UIControlEventValueChanged];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                // 同步分辨率
                _screenResolution = [_myDataSource getCurrentScreenResolution];
                break;
                
            case 1:
                cell.cellTitle.text = @"控制器类型选择";
                cell.cellDetail.text = [_typeArray objectAtIndex:[_myDataSource getCurrentControllerType]];
                cell.cellSlider.minimumValue = 1;
                cell.cellSlider.maximumValue = 3;
                cell.cellSlider.continuous = NO;
                cell.cellSlider.value = [_myDataSource getCurrentControllerType];
                [cell.cellSlider addTarget:self action:@selector(controllerTypeSliderEvent) forControlEvents:UIControlEventValueChanged];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
        }
        
        return cell;
    }
    else if (indexPath.section == 3)
    {
        static NSString *cellIdentifier = @"ButtonCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        cell.textLabel.text = @"确认控制器设置";
        cell.textLabel.textColor = [UIColor colorWithRed:0.9 green:0.1 blue:0.0 alpha:1.0];
        //cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
        return cell;
    }
    else
    {
        static NSString *cellIdentifier = @"Cells";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        switch (indexPath.row)
        {
            case 0:     // 掉电记忆
                cell.textLabel.text = @"掉电记忆功能";
                cell.accessoryView = _switchPowerSave;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [_switchPowerSave setOn:[_myDataSource getCurrentPowerStatus]];
                [_switchPowerSave addTarget:self action:@selector(switchPowerSaveEvent) forControlEvents:UIControlEventValueChanged];
                break;
                
            case 1:     // 温控开关
                cell.textLabel.text = @"智能温控功能";
                cell.accessoryView = _switchTemperature;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [_switchTemperature setOn:[_myDataSource getCurrentTemperatureStatus]];
                [_switchTemperature addTarget:self action:@selector(switchTemperatureEvent) forControlEvents:UIControlEventValueChanged];
                break;
                
            case 2:     // 边缘融合
                cell.textLabel.text = @"边缘融合功能";
                cell.accessoryView = _switchStraight;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [_switchStraight setOn:[_myDataSource getCurrentStraightStatus]];
                [_switchStraight addTarget:self action:@selector(switchStraightEvent) forControlEvents:UIControlEventValueChanged];
                break;
                
            case 3:     // 蜂鸣器开关
                cell.textLabel.text = @"蜂鸣器开关";
                cell.accessoryView = _switchBuzzer;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [_switchBuzzer setOn:[_myDataSource getCurrentBuzzerStatus]];
                [_switchBuzzer addTarget:self action:@selector(switchBuzzerEvent) forControlEvents:UIControlEventValueChanged];
                break;
        }
        
        return cell;
    }
}

// Section Header String
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *strResult;
    
    if (section == 0)
    {
        strResult = @"大屏幕拼接规格";
    }
    else if (section == 1)
    {
        strResult = @"控制器类型与输出分辨率";
    }
    else if (section == 2)
    {
        strResult = @"控制器常规参数设置";
    }
    
    return strResult;
}

// Row Height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        return 75;
    }
    else
        return 44;
}

#pragma mark - UITableView Delegate
// 选择功能
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3)
    {
        [self confirmControllerSettingEvent];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
