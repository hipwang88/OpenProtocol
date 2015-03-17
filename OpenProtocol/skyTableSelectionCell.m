//
//  skyTableSelectionCell.m
//  SkyworthSCXPJ
//
//  Created by skyworth on 13-9-13.
//  Copyright (c) 2013年 skyworth. All rights reserved.
//

#import "skyTableSelectionCell.h"

@interface skyTableSelectionCell()


@end

@implementation skyTableSelectionCell

@synthesize cellTitle = _cellTitle;
@synthesize btnCVBS = _btnCVBS;
@synthesize btnHDMI = _btnHDMI;
@synthesize btnDVI = _btnDVI;
@synthesize btnVGA = _btnVGA;
@synthesize selectionIndex = _selectionIndex;

#pragma mark - Basic Methods
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Public Methods
// 获取选择状态
- (NSInteger)getCurrentSelectionType
{
    return _selectionIndex;
}

// 设置选择状态
- (void)setCurrentSelectionType:(NSInteger)nType
{
    _selectionIndex = nType;
    
    switch (nType)
    {
        case 0: // HDMI
            _btnCVBS.selected = NO;
            _btnDVI.selected = NO;
            _btnHDMI.selected = YES;
            _btnVGA.selected = NO;
            break;
            
        case 1: // DVI
            _btnCVBS.selected = NO;
            _btnDVI.selected = YES;
            _btnHDMI.selected = NO;
            _btnVGA.selected = NO;
            break;
            
        case 2: // VGA
            _btnCVBS.selected = NO;
            _btnDVI.selected = NO;
            _btnHDMI.selected = NO;
            _btnVGA.selected = YES;
            break;
            
        case 3: // CVBS
            _btnCVBS.selected = YES;
            _btnDVI.selected = NO;
            _btnHDMI.selected = NO;
            _btnVGA.selected = NO;
            break;
    }
}

#pragma mark - Private Methods
// 按钮事件
- (IBAction)btnCVBSEvent:(id)sender
{
    _btnCVBS.selected = !_btnCVBS.selected;
    [self setCurrentSelectionType:3];
}

- (IBAction)btnHDMIEvent:(id)sender
{
    _btnHDMI.selected = !_btnHDMI.selected;
    [self setCurrentSelectionType:0];
}

- (IBAction)btnDVIEvent:(id)sender
{
    _btnDVI.selected = !_btnDVI.selected;
    [self setCurrentSelectionType:1];
}

- (IBAction)btnVGAEvent:(id)sender
{
    _btnVGA.selected = !_btnVGA.selected;
    [self setCurrentSelectionType:2];
}

@end
