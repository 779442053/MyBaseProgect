

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSTixianListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;

- (void)configWitData:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END