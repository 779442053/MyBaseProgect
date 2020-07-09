

#import "UserHeadCell.h"

@implementation UserHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.UserHeadImage.layer.cornerRadius = self.UserHeadImage.frame.size.height/2;
    self.UserHeadImage.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(instancetype)xibWithTableView{
  return [[[NSBundle mainBundle] loadNibNamed:@"UserHeadCell" owner:nil options:nil] lastObject];
}

@end