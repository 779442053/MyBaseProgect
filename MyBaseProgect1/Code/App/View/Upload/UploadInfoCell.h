

#import <UIKit/UIKit.h>

@interface UploadInfoCell : UITableViewCell

@property (strong, nonatomic) UITextView *infoTextView;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,copy) void (^GetTextView)(NSString *infos);

@end
