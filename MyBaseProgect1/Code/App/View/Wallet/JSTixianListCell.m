

#import "JSTixianListCell.h"

@implementation JSTixianListCell

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
    NSString *titleText = [dict objectForKey:@"type"];
    NSString *time = [dict objectForKey:@"time"];
    NSString *money = [dict objectForKey:@"money"];
    if ([status integerValue] == 0) {
        self.statusLab.textColor = [[UIColor alloc] colorFromHexInt:0xFF7200 AndAlpha:1.0];
        statusStr = @"待审核";
    }
    else if ([status integerValue] == 1){
        self.statusLab.textColor = [[UIColor alloc] colorFromHexInt:0x04BC00 AndAlpha:1.0];
        statusStr = @"已审核";
    }
    
    if ([titleText integerValue] == 0){
        titleText = @"支付宝";
    }else if ([titleText integerValue] == 1){
        titleText = @"微信";
    }else{
        titleText = @"银行卡";
    }
    
    self.statusLab.text = statusStr;
    self.titleLab.text = titleText;
    self.moneyLab.text = [NSString stringWithFormat:@"%@元",money];
    self.timeLab.text = time;
}

@end
