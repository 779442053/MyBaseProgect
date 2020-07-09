

#import "ZWDaShangTableViewCell.h"

@interface ZWDaShangTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *DaShangLB;
@property (weak, nonatomic) IBOutlet UILabel *TimeLB;

@property (weak, nonatomic) IBOutlet UILabel *MoneyLB;


@end


@implementation ZWDaShangTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
