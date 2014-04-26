//
//  skyTableSliderCell.h
//  SkyworthSCXPJ
//
//  Created by skyworth on 13-9-11.
//  Copyright (c) 2013年 skyworth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface skyTableSliderCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *cellTitle;
@property (strong, nonatomic) IBOutlet UILabel *cellDetail;
@property (strong, nonatomic) IBOutlet UISlider *cellSlider;


@end
