

#import <UIKit/UIKit.h>

@interface ChangePwdCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *changeField;
@property (weak, nonatomic) IBOutlet UILabel *TitleLB;

+(instancetype)xibWithTableView;
@end
