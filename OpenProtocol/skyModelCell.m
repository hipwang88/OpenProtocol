//
//  skyModelCell.m
//  SkyworthSCXPJ
//
//  Created by skyworth on 13-9-4.
//  Copyright (c) 2013年 skyworth. All rights reserved.
//

#import "skyModelCell.h"

@interface skyModelCell()

@property (strong, nonatomic) IBOutlet UIView *backView;

@end

@implementation skyModelCell

@synthesize modelImage = _modelImage;
@synthesize modelName = _modelName;
@synthesize saveDate = _saveDate;
@synthesize backView = _backView;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];

    if (self)
    {
        _backView.backgroundColor = [UIColor colorWithRed:0 green:143.0f/255.0f blue:88.0f/255.0f alpha:1];
    }
    
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

@end
