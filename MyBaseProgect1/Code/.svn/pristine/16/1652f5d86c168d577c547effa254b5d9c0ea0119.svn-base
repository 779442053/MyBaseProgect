

#import "ZWMyBillsHeaderView.h"
@interface ZWMyBillsHeaderView()
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *expenditureLabel;
@property (nonatomic, strong) UILabel *incomeLabel;
@end
@implementation ZWMyBillsHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.expenditureLabel];
    [self.contentView addSubview:self.incomeLabel];
}

- (void)setData:(MyBillsData *)data
{
    _data = data;
    if ([data.date containsString:@"T"]) {
        NSArray *dataarr = [data.date componentsSeparatedByString:@"T"];
        if (dataarr.count) {
            NSString *time = dataarr[0];
            _timeLabel.text = time;
        }else{
          _timeLabel.text = data.date;
        }
    }else{
        _timeLabel.text = data.date;
    }
    _expenditureLabel.text = [NSString stringWithFormat:@"支出 ¥%.2f",data.expenditure];
    _incomeLabel.text = [NSString stringWithFormat:@"收入 ¥%.2f",data.income];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(8);
        make.top.mas_equalTo(self.contentView.mas_top).offset(8);
    }];

    [self.expenditureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.timeLabel.mas_left);
        make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(8);
    }];

    [self.incomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.expenditureLabel.mas_right).offset(8);
        make.top.mas_equalTo(self.expenditureLabel.mas_top);
    }];
}

#pragma mark - Getter

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.text = @"时间";
        _timeLabel.font = FONT(15);
    }
    return _timeLabel;
}


- (UILabel *)expenditureLabel
{
    if (!_expenditureLabel) {
        _expenditureLabel = [[UILabel alloc] init];
        _expenditureLabel.text = @"支出";
        _expenditureLabel.font = FONT(13);
        _expenditureLabel.textColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    }
    return _expenditureLabel;
}

- (UILabel *)incomeLabel
{
    if (!_incomeLabel) {
        _incomeLabel = [[UILabel alloc] init];
        _incomeLabel.text = @"收入";
        _incomeLabel.font = FONT(13);
        _incomeLabel.textColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    }
    return _incomeLabel;
}

@end
