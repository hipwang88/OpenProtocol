//
//  skyTableStepperCell.h
//  SkyworthSCXPJ
//
//  Created by skyworth on 13-9-10.
//  Copyright (c) 2013年 skyworth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface skyTableStepperCell : UITableViewCell

/////////////////// Property ////////////////////////
@property (strong, nonatomic) IBOutlet UILabel *labelTitle;
@property (strong, nonatomic) IBOutlet UILabel *lableValue;
@property (strong, nonatomic) IBOutlet UIStepper *valueStepper;

/////////////////// Methods /////////////////////////

/////////////////// Ends ////////////////////////////


@end
