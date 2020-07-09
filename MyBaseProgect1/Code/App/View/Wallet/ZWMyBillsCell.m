

#import "ZWMyBillsCell.h"
@interface ZWMyBillsCell()

@property (nonatomic, strong) UIImageView *rewardIcon;//奖励图标
@property (nonatomic, strong) UILabel *rewardTitle;//奖励标题
@property (nonatomic, strong) UILabel *rewardTime;//奖励时间
@property (nonatomic, strong) UILabel *rewardMoney;//奖励收入
@property (nonatomic, strong) UILabel *rewardDesc;//奖励描述 hongbao3
@end
@implementation ZWMyBillsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        [self setupUI];
    }
    return self;
}
- (void)setupUI
{
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#F3F3F3"]; ;
    [self.contentView addSubview:self.rewardIcon];
    [self.contentView addSubview:self.rewardTitle];
    [self.contentView addSubview:self.rewardTime];
    [self.contentView addSubview:self.rewardMoney];
    [self.contentView addSubview:self.rewardDesc];
}
- (void)setData:(InfoData *)data
{
    _data = data;
    //Income：收入
    //Expenditure：支出
    //Type：交易类型 0红包 1充值 2 提现 3 （红包）收藏奖励 4 （红包）点赞奖励 5 （红包）上传视频奖励
    _rewardTime.text = data.time;
    _rewardMoney.text = data.money;

    switch ([data.type intValue]) {
        case 0:
        {
            _rewardTitle.text = @"红包";
            _rewardDesc.text = @"";
        }
            break;
        case 1:
        {
            _rewardTitle.text = @"充值";
            _rewardDesc.text = @"";
        }
            break;
        case 2:
        {
            _rewardTitle.text = @"提现";
            _rewardDesc.text = @"";
        }
            break;
        case 3:
        {
            _rewardTitle.text = @"红包-系统奖励";
            _rewardDesc.text = @"收藏奖励";
        }
            break;
        case 4:
        {
            _rewardTitle.text = @"红包-系统奖励";
            _rewardDesc.text = @"点赞奖励";
        }
            break;
        case 5:
        {
            _rewardTitle.text = @"红包-系统奖励";
            _rewardDesc.text = @"上传视频奖励";
        }
            break;

        default:
            break;
    }
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];


    [self.rewardIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(39, 39));
    }];

    [self.rewardTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView.mas_centerY).offset(-5);
        make.left.mas_equalTo(self.rewardIcon.mas_right).offset(10);
    }];

    [self.rewardTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rewardIcon.mas_right).offset(10);
        make.top.mas_equalTo(self.contentView.mas_centerY).offset(5);
    }];

    [self.rewardMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        make.top.mas_equalTo(self.rewardTitle.mas_top);
    }];

    [self.rewardDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        make.top.mas_equalTo(self.rewardTime.mas_top);
    }];

}

#pragma mark - Getter

- (UIImageView *)rewardIcon
{
    if (!_rewardIcon) {
        _rewardIcon = [[UIImageView alloc] init];
        _rewardIcon.image = KZImage(@"hongbao3");
    }
    return _rewardIcon;
}

- (UILabel *)rewardTitle
{
    if (!_rewardTitle) {
        _rewardTitle = [[UILabel alloc] init];
        _rewardTitle.text = @"红包";
        _rewardTitle.font = FONT(15);
    }
    return _rewardTitle;
}

- (UILabel *)rewardTime
{
    if (!_rewardTime) {
        _rewardTime = [[UILabel alloc] init];
        _rewardTime.text = @"2019/10/10";
        _rewardTime.font = FONT(13);
        _rewardTime.textColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    }
    return _rewardTime;
}

- (UILabel *)rewardDesc
{
    if (!_rewardDesc) {
        _rewardDesc = [[UILabel alloc] init];
        _rewardDesc.text = @"点赞奖励";
        _rewardDesc.font = FONT(13);
        _rewardDesc.textColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    }
    return _rewardDesc;
}

- (UILabel *)rewardMoney
{
    if (!_rewardMoney) {
        _rewardMoney = [[UILabel alloc] init];
        _rewardMoney.text = @"0.0";
        _rewardDesc.font = FONT(14);
    }
    return _rewardMoney;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
