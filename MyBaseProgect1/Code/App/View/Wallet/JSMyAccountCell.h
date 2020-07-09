

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSMyAccountCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *numberLab;
@property (weak, nonatomic) IBOutlet UIView *mainView;

- (void)configWitData:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
