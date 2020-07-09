//
//  SearchUserCell.m
//  KuaiZhu
//
//  Created by step_zhang on 2019/11/12.
//  Copyright © 2019 su. All rights reserved.
//

#import "SearchUserCell.h"
@interface SearchUserCell()

@property(nonatomic,strong)UIImageView *headIMageView;
@property(nonatomic,strong)UILabel *MessageNumLB;
@property(nonatomic,strong)UILabel *NameLB;
@property(nonatomic,strong)UILabel *DesLB;
@property(nonatomic,strong)UIButton *MessageBtn;
@property(nonatomic,strong)UIButton *FollowBtn;

@end
@implementation SearchUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setFansModel:(FansData *)FansModel{
    if (FansModel) {
        _FansModel = FansModel;
        self.MessageBtn.hidden = YES;
        [self.headIMageView sd_setImageWithURL:[NSURL URLWithString:FansModel.photo] placeholderImage:[UIImage imageNamed:@"我的"]];
        [self.headIMageView wyh_autoSetImageCornerRedius:56/2 ConrnerType:UIRectCornerAllCorners];
        self.MessageNumLB.hidden = YES;
        self.NameLB.text = FansModel.name;
        self.DesLB.text = [NSString stringWithFormat:@"粉丝数: %ld",(long)FansModel.fansCount];
        if (FansModel.isFollowed == 0) {//我没有关注
            [self.FollowBtn setBackgroundImage:[UIImage imageNamed:@"关注"] forState:UIControlStateNormal];
        }else{
            [self.FollowBtn setBackgroundImage:[UIImage imageNamed:@"取消关注"] forState:UIControlStateNormal];
        }
    }
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self zw_setupViews];
    }
    return self;
}
-(void)zw_setupViews{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.headIMageView];
    [self.headIMageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(56, 56));
        make.left.mas_equalTo(self.contentView.mas_left).with.mas_offset(13);
    }];

    [self.contentView addSubview:self.MessageNumLB];
    [self.MessageNumLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headIMageView.mas_top).with.mas_offset(-3);
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.right.mas_equalTo(self.headIMageView.mas_right).with.mas_offset(-3);
    }];

    [self.contentView addSubview:self.NameLB];
    [self.NameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headIMageView.mas_top);
        make.height.mas_equalTo(18);
        make.left.mas_equalTo(self.headIMageView.mas_right).with.mas_offset(12);
    }];

    [self.contentView addSubview:self.DesLB];
    [self.DesLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.headIMageView.mas_bottom);
        make.height.mas_equalTo(14);
        make.left.mas_equalTo(self.headIMageView.mas_right).with.mas_offset(12);
    }];
    [self.contentView addSubview:self.FollowBtn];
    [self.FollowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(100, 28));
        make.right.mas_equalTo(self.contentView.mas_right).with.mas_offset(-15);
    }];

    [self.contentView addSubview:self.MessageBtn];
    [self.MessageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(31, 31));
        make.right.mas_equalTo(self.FollowBtn.mas_left).with.mas_offset(-15);
    }];
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#CEDAF9"];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headIMageView.mas_left);
        make.right.mas_equalTo(self.FollowBtn.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    [[self.MessageBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self.Subject sendNext:@{@"code":@"0",@"Model":self.FansModel}];

    }];

    [[self.FollowBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self.Subject sendNext:@{@"code":@"1",@"Model":self.FansModel}];
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
-(UIImageView *)headIMageView{
    if (_headIMageView == nil) {
        _headIMageView = [[UIImageView alloc]init];
    }
    return _headIMageView;
}
-(UILabel *)MessageNumLB{
    if (_MessageNumLB == nil) {
        _MessageNumLB = [[UILabel alloc]init];
        _MessageNumLB.backgroundColor = [UIColor redColor];
        _MessageNumLB.textColor = [UIColor whiteColor];
        _MessageNumLB.textAlignment = NSTextAlignmentCenter;
        _MessageNumLB.font = [UIFont systemFontOfSize:13];
        _MessageNumLB.layer.cornerRadius = 10;
        _MessageNumLB.layer.masksToBounds = YES;
    }
    return _MessageNumLB;
}
-(UILabel *)NameLB{
    if (_NameLB == nil) {
        _NameLB = [[UILabel alloc]init];
        _NameLB.textColor = [UIColor colorWithHexString:@"#000000"];
        _NameLB.textAlignment = NSTextAlignmentLeft;
        _NameLB.font = [UIFont systemFontOfSize:19];
    }
    return _NameLB;
}
-(UILabel *)DesLB{
    if (_DesLB == nil) {
        _DesLB = [[UILabel alloc]init];
        _DesLB.textColor = [UIColor colorWithHexString:@"#A7A7A8"];
        _DesLB.textAlignment = NSTextAlignmentLeft;
        _DesLB.font = [UIFont systemFontOfSize:15];
    }
    return _DesLB;
}
- (UIButton *)MessageBtn{
    if (_MessageBtn == nil) {
        _MessageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_MessageBtn setBackgroundImage:[UIImage imageNamed:@"Messageicon"] forState:UIControlStateNormal];
    }
    return _MessageBtn;
}
-(UIButton *)FollowBtn{
    if (_FollowBtn == nil) {
        _FollowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_FollowBtn setBackgroundImage:[UIImage imageNamed:@"BTNBGImage"] forState:UIControlStateNormal];
    }
    return _FollowBtn;
}

@end
