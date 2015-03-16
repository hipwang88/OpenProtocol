//
//  skyModelView.m
//  SkyworthSCXPJ
//
//  Created by skyworth on 13-8-6.
//  Copyright (c) 2013年 skyworth. All rights reserved.
//

#import "skyModelView.h"
#import "skyModelCell.h"

@interface skyModelView ()

////////////////// Property /////////////////////
@property (nonatomic, strong) NSIndexPath *selectionIndex;

////////////////// Methods //////////////////////
// 长按手势识别器
- (void)handleLongPressEvent:(UILongPressGestureRecognizer *)gesture;
// 情景模式保存
- (void)handleModelSaveEvent:(id)sender;
// 情景模式删除
- (void)handleModelDeleteEvent:(id)sender;

////////////////// Ends /////////////////////////

@end

@implementation skyModelView

@synthesize tableData = _tableData;
@synthesize modelSaveDate = _modelSaveDate;
@synthesize modelDelegate = _modelDelegate;
@synthesize selectionIndex = _selectionIndex;
@synthesize modelDataSource = _modelDataSource;

#pragma mark - Basic Methods

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

    self.title = @"情景模式";
    _tableData = [[NSMutableArray alloc] init];
    for (int i = 1; i <= 18; i++)
    {
        NSString *stringName = [NSString stringWithFormat:@"情景模式 - %d",i];
        [_tableData addObject:stringName];
    }
    
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
    
    [self.tableView reloadData];
}

#pragma mark - Public Methods
// 情景模式状态保存
- (void)saveModelStatusToFile
{
    [_modelDataSource saveModelDataSource];
}

#pragma mark - Table view data source
// 表的块数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// 表列数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 18;
}

// 表单元数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"skyModelCell";
    skyModelCell *cell = (skyModelCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"skyModelCell" owner:self options:nil] objectAtIndex:0];
    }
    
    // 设置各个表项
    cell.modelName.text = [_tableData objectAtIndex:indexPath.row];
    cell.saveDate.text = [_modelDataSource getModelSaveDateAtIndex:(int)indexPath.row];
    cell.modelImage.image = [_modelDataSource getModelImageAtIndex:(int)indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    // 给cell添加手势识别
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressEvent:)];
    longGesture.minimumPressDuration = 0.5f;
    [cell addGestureRecognizer:longGesture];
    
    return cell;
}

// 设置表高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 220;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int nIndex = (int)indexPath.row;
    
    // 判断情景是否可用
    if ([_modelDataSource isModelCanBeUsedAtIndex:nIndex])
    {
        // 调用情景模式
        [_modelDelegate loadModelStatus:nIndex];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前情景没有保存" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Private Methods
// 长按手势识别器
- (void)handleLongPressEvent:(UILongPressGestureRecognizer *)gesture
{
    // 开始识别手势
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        skyModelCell *cell = (skyModelCell *)gesture.view;
        [cell becomeFirstResponder];
        _selectionIndex = [self.tableView indexPathForCell:cell];   // 获取选择的Cell
        
        UIMenuItem *itemSave = [[UIMenuItem alloc] initWithTitle:@"保存情景" action:@selector(handleModelSaveEvent:)];
        UIMenuItem *itemDelete = [[UIMenuItem alloc] initWithTitle:@"删除情景" action:@selector(handleModelDeleteEvent:)];
        
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setMenuItems:[NSArray arrayWithObjects:itemSave,itemDelete, nil]];
        [menu setTargetRect:cell.frame inView:self.tableView];
        [menu setMenuVisible:YES animated:YES];
    }
}

// 情景模式保存
- (void)handleModelSaveEvent:(id)sender
{
    int nRow = (int)_selectionIndex.row;
    
    // 保存情景模式
    [_modelDelegate shootAppToImage:nRow];
    
    NSArray *array = [NSArray arrayWithObject:_selectionIndex];
    [self.tableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
}

// 情景模式删除
- (void)handleModelDeleteEvent:(id)sender
{
    int nRow = (int)_selectionIndex.row;
    
    // 删除情景模式
    [_modelDelegate removeModelImage:nRow];
    
    NSArray *array = [NSArray arrayWithObject:_selectionIndex];
    [self.tableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

@end
