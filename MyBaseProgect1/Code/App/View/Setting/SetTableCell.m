

#import "SetTableCell.h"

@implementation SetTableCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

+(instancetype)xinWithTableView{
  return [[[NSBundle mainBundle] loadNibNamed:@"SetTableCell" owner:nil options:nil] lastObject];
}


@end

