

#import "ChangePwdCell.h"

@implementation ChangePwdCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    //密码框
    self.changeField.secureTextEntry = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(instancetype)xibWithTableView{
  return [[[NSBundle mainBundle] loadNibNamed:@"ChangePwdCell" owner:nil options:nil] lastObject];
}

@end