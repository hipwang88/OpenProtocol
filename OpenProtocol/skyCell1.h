
#import <UIKit/UIKit.h>

@interface skyCell1: UITableViewCell


@property (nonatomic,retain)IBOutlet UILabel *titleLabel;
@property (nonatomic,retain)IBOutlet UIImageView *arrowImageView;

- (void)changeArrowWithUp:(BOOL)up;
@end
