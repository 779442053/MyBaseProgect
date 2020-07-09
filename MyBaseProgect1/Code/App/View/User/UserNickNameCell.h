

#import <UIKit/UIKit.h>

@interface UserNickNameCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

+(instancetype)xibWithTableView;

@end
