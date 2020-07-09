
#import "JSMyAccountCell.h"

@implementation JSMyAccountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWitData:(NSDictionary *)dict
{
    if ([[dict objectForKey:@"bankName"] isEqualToString:@""]) {
        self.mainView.hidden = YES;
    }else{
        self.mainView.hidden = NO;
        self.logoImageView.image = [UIImage imageNamed:[dict objectForKey:@"logo"]];
        self.nameLab.text = [dict objectForKey:@"bankName"];
        self.numberLab.text = [dict objectForKey:@"account"];
    }
}

@end