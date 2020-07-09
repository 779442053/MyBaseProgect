

#import <UIKit/UIKit.h>

@interface UpVideoCell : UITableViewCell

@property (nonatomic, strong) UIImageView *uploadImageView;

@property (nonatomic, strong) UIButton *uploadBtn;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
