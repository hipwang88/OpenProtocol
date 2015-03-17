//
//  skySettingSDKs.m
//  SkyworthSCXPJ
//
//  Created by skyworth on 13-8-8.
//  Copyright (c) 2013年 skyworth. All rights reserved.
//

#import "skySettingSDKs.h"

@interface skySettingSDKs ()

@property (nonatomic, strong) NSMutableArray *protoclNames;

@end

@implementation skySettingSDKs

@synthesize sdkTableView = _sdkTableView;
@synthesize protoclNames = _protoclNames;
@synthesize sdkDelegate = _sdkDelegate;

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
    _protoclNames = [[NSMutableArray alloc] initWithObjects:NSLocalizedString(@"Protocal_Cell1", nil),NSLocalizedString(@"Protocal_Cell2", nil), nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGSize size = CGSizeMake(320.0f, 700.0f);
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

- (void)viewDidUnload {
    [self setSdkTableView:nil];
    [super viewDidUnload];
}

#pragma mark - UITableView DataSource
// Sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_protoclNames count];
}

// Cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"skySDKSettingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [_protoclNames objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    if (indexPath.row == [_sdkDelegate getProtocolType])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
        cell.accessoryType = UITableViewCellAccessoryNone;;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableView Delegate
// Select
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_sdkDelegate setProtocolType:indexPath.row];
    
    [tableView reloadData];
}

@end
