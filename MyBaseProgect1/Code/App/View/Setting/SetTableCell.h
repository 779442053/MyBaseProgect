

#import <UIKit/UIKit.h>

@interface SetTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
+(instancetype)xinWithTableView;

@end
