

#import "JSTuiguangListCell.h"

@implementation JSTuiguangListCell

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
    NSString *status = [dict objectForKey:@"status"];
    NSString *statusStr = @"";
    NSString *nickName = [dict objectForKey:@"email"];
    NSString *time = [dict objectForKey:@"time"];
    self.nickNameLab.text = nickName;
    self.timeLab.text = time;
    statusStr =  [status integerValue] == 1 ? @"已注册":@"未注册";
    self.statusLab.text = statusStr;
}

@end
