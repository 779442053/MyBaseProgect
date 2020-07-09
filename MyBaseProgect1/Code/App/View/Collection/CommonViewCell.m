//

#import "CommonViewCell.h"

@implementation CommonViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.backgroundColor = UIColor.clearColor;
    
//    self.userPhoto.layer.cornerRadius = self.userPhoto.width/2;
//    self.userPhoto.layer.masksToBounds = YES;
    
    
    //无选中样式
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(instancetype)xibWithTableView{
    return [[[NSBundle mainBundle] loadNibNamed:@"CommonViewCell" owner:nil options:nil] lastObject];
}

+(NSString *)cellIdentify{
    return @"CommonViewCell";
}

@end
