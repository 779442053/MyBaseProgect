

#import "AnnouncementsCell.h"

@implementation AnnouncementsCell

+(id)xibWithTableView{
  return [[[NSBundle mainBundle] loadNibNamed:@"AnnouncementsCell" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
