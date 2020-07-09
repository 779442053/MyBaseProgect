

#import "UserNickNameCell.h"

@implementation UserNickNameCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(instancetype)xibWithTableView{
  return [[[NSBundle mainBundle] loadNibNamed:@"UserNickNameCell" owner:nil options:nil] lastObject];
}



@end
