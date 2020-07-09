

#import "UserInfoView.h"

@implementation UserInfoView

+ (instancetype)createUserInfoViewInit {
    
    NSArray *nibView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([UserInfoView class]) owner:self options:nil];
    
    return [nibView objectAtIndex:0];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:CGRectMake(0, 0, K_APP_WIDTH, K_APP_HEIGHT/667*100)];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];

    self.accountIcon.layer.cornerRadius = self.accountIcon.frame.size.width/2;
    self.accountIcon.layer.masksToBounds = YES;
    
    [self.forceBtn setTitle:@"关注" forState:UIControlStateNormal];
    [self.forceBtn setTitle:@"取消关注" forState:UIControlStateSelected];
    
    [self.forceBtn setBackgroundImage:[UIImage imageNamed:@"red_btn_bg.png"] forState:UIControlStateNormal];
    [self.forceBtn setBackgroundImage:[UIImage imageNamed:@"red_btn_bg.png"] forState:UIControlStateSelected];
}

- (IBAction)clickBtnsEvent:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickBtnEventWithTag:)]) {
        [self.delegate clickBtnEventWithTag:sender.tag];
    }
}
- (IBAction)clickForceBtnEvent:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickForceBtnEvent:AndSender:)]) {
        [self.delegate clickForceBtnEvent:sender.selected AndSender:sender];
    }
}

- (void)setInfoModel:(InfosModel *)infoModel {
    _infoModel = infoModel;
    self.worksLable.text = [NSString stringWithFormat:@"%lD",(long)infoModel.videoCount];
    self.forceLable.text = [NSString stringWithFormat:@"%lD",(long)infoModel.followCount];
    self.fansLable.text = [NSString stringWithFormat:@"%lD",(long)infoModel.fansCount];
    self.likeLable.text = [NSString stringWithFormat:@"%lD",(long)infoModel.heartCount];

    [self.accountIcon setImageWithURL:[infoModel.photo mj_url] placeholderImage:[UIImage imageNamed:@"我的.png"]];
    
    //1是关注
    if ([infoModel.isFollowed integerValue] == 1)
        self.forceBtn.selected = YES;
    //0是取消关注
    else self.forceBtn.selected = NO;
}

@end
