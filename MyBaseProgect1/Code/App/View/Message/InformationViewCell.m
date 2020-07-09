//
//  InformationViewCell.m
//  KuaiZhu
//
//  Created by apple on 2019/10/5.
//  Copyright © 2019 su. All rights reserved.
//

#import "InformationViewCell.h"

//static const CGFloat cell_height = 89;
static const CGFloat cell_margin = 10;

@interface InformationViewCell()

@property(nonatomic,strong) UIImageView *imgPic;
@property(nonatomic,strong) UILabel *labTitle;
@property(nonatomic,strong) UILabel *labDescription;
@property(nonatomic,strong) UILabel *labTime;

@end

@implementation InformationViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initCell];
    }
    
    return self;
}

-(void)setModel:(ZWMessageModel *)Model{
    if (Model) {
        _Model = Model;
        if ([Model.name isEqualToString:@"admin"]) {
            self.imgPic.image = [UIImage imageNamed:@"message_system"];
            self.labTitle.textColor = [UIColor colorWithHexString:@"#FF7500"];
            self.labDescription.textColor = [UIColor colorWithHexString:@"#FFA901"];
            self.labTitle.text = @"系统消息";
        }else{
            [self.imgPic sd_setImageWithURL:[NSURL URLWithString:Model.photo] placeholderImage:[UIImage imageNamed:@"我的"]];
            self.labTitle.text = Model.name;
            self.labTitle.textColor = [UIColor colorWithHexString:@"#000000"];
            self.labDescription.textColor = [UIColor colorWithHexString:@"#A7A7A8"];
        }

        [self.imgPic wyh_autoSetImageCornerRedius:56/2 ConrnerType:UIRectCornerAllCorners];
        self.labDescription.text = Model.content;
        NSArray *timearr = [Model.sendTime componentsSeparatedByString:@" "];
        if (timearr.count) {
            NSString *firstStr = timearr[0];
            NSArray *dataARR = [firstStr componentsSeparatedByString:@"-"];
            if (dataARR.count == 3) {
                NSString *time = [NSString stringWithFormat:@"%@-%@",dataARR[1],dataARR[2]];
                self.labTime.text = time;
            }else{
                self.labTime.text = Model.sendTime;
            }
        }else{
                self.labTime.text = Model.sendTime;
        }
    }
}
//MARK: - initCell
-(void)initCell{
    self.backgroundColor = UIColor.clearColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.imgPic];
    [self.imgPic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cell_margin);
        make.height.width.mas_equalTo(56);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    [self.contentView addSubview:self.labTitle];
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imgPic.mas_right).mas_offset(12);
        make.height.mas_equalTo(21);
        make.width.mas_equalTo(100);
        make.top.mas_equalTo(self.imgPic.mas_top);
    }];
    
    [self.contentView addSubview:self.labDescription];
    [self.labDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imgPic.mas_right).mas_offset(12);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(-cell_margin);
        make.bottom.mas_equalTo(self.imgPic.mas_bottom);
    }];
    
    [self.contentView addSubview:self.labTime];
    [self.labTime mas_makeConstraints:^(MASConstraintMaker *make) {
       make.height.mas_equalTo(21);
       make.width.mas_equalTo(80);
       make.right.mas_equalTo(-cell_margin);
       make.top.mas_equalTo(self.labTitle.mas_top);
    }];

    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#CEDAF9"];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imgPic.mas_left);
        make.right.mas_equalTo(self.labTime.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
}


//MARK: - lazy load
-(UIImageView *)imgPic{
    if (!_imgPic) {
        _imgPic = [[UIImageView alloc] init];
        _imgPic.image = K_APP_DEFAULT_USER_IMAGE;
    }
    return _imgPic;
}

-(UILabel *)labTitle{
    if (!_labTitle) {
        _labTitle = [[UILabel alloc] init];
        _labTitle.textColor = [UIColor colorWithHexString:@"#000000"];
        _labTitle.font = ADOBE_FONT(19);
        _labTitle.textAlignment = NSTextAlignmentLeft;
    }
    return _labTitle;
}

-(UILabel *)labDescription{
    if (!_labDescription) {
        _labDescription = [[UILabel alloc] init];
        _labDescription.text = @"你好";
        _labDescription.textColor = [UIColor colorWithHexString:@"#A7A7A8"];
        _labDescription.font = ADOBE_FONT(15);
        _labDescription.textAlignment = NSTextAlignmentLeft;
        _labDescription.numberOfLines = 0;
    }
    return _labDescription;
}

-(UILabel *)labTime{
    if (!_labTime) {
        _labTime = [[UILabel alloc] init];
        _labTime.text = @"10分钟前";
        _labTime.textColor = [[UIColor alloc] colorFromHexInt:0xA7A7A8 AndAlpha:1];
        _labTime.font = ADOBE_FONT(15);
        _labTime.textAlignment = NSTextAlignmentRight;
    }
    return _labTime;
}





@end
