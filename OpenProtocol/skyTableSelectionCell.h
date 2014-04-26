//
//  skyTableSelectionCell.h
//  SkyworthSCXPJ
//
//  Created by skyworth on 13-9-13.
//  Copyright (c) 2013年 skyworth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface skyTableSelectionCell : UITableViewCell

//////////////////// Property ///////////////////////////
@property (strong, nonatomic) IBOutlet UILabel *cellTitle;
@property (strong, nonatomic) IBOutlet UIButton *btnCVBS;
@property (strong, nonatomic) IBOutlet UIButton *btnHDMI;
@property (strong, nonatomic) IBOutlet UIButton *btnDVI;
@property (strong, nonatomic) IBOutlet UIButton *btnVGA;
@property (assign, nonatomic) int selectionIndex;

//////////////////// Methods ////////////////////////////
// 获取选择状态
- (int)getCurrentSelectionType;
// 设置选择状态
- (void)setCurrentSelectionType:(int)nType;

//////////////////// Ends ///////////////////////////////

@end
