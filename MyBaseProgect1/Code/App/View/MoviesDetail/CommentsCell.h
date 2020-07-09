

#import <UIKit/UIKit.h>

@interface CommentsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nickName;

@property (weak, nonatomic) IBOutlet UILabel *subContext;

@property (weak, nonatomic) IBOutlet UILabel *desLB;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;

+(id)xibWithTableView;

@end
