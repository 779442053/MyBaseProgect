
#import <UIKit/UIKit.h>

@interface AnnouncementsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *context;

+(id)xibWithTableView;

@end
