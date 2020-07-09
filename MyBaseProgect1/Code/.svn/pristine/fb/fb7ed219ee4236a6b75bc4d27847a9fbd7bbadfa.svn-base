//
//  MineHeaderView.m
//  快猪
//
//  Created by 魏冰杰 on 2019/1/11.
//  Copyright © 2019年 时磊. All rights reserved.
//

#import "MineHeaderView.h"

#define k_user_default_img [UIImage imageNamed:@"我的.png"]

@implementation MineHeaderView

+ (instancetype)createMineHeaderViewInit {
    
    NSArray *nibView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MineHeaderView class]) owner:self options:nil];
    if ([[UIDevice currentDevice] isSmallDevice]) {
        return [nibView firstObject];
    }
    
    return [nibView lastObject];
}


- (void)setFrame:(CGRect)frame {
    [super setFrame:CGRectMake(0, 0, K_APP_WIDTH, 250)];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.accountIcon.layer.cornerRadius = self.accountIcon.frame.size.height/2;
    self.accountIcon.layer.masksToBounds = YES;

}


//MARK: - 订部栏目点击
- (IBAction)clickModulesEvent:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(clickModulesBtnEventWithTag:)]) {
        [self.delegate clickModulesBtnEventWithTag:sender.tag];
    }
}

//MARK: - 认证、取消认证
-(IBAction)btnCertification:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(joinCertification)]) {
        [self.delegate joinCertification];
    }
}

- (void)refreshUIWithModel:(InfosModel *)model{
    
    //用户信息更新
    if ([UserModel userIsLogin]) {
        UserModel *umodel = [UserModel shareInstance];
        
        self.userNameLable.text = umodel.name;
        if ([Utils checkTextEmpty:umodel.photo]) {
            [self.accountIcon setImageWithURL:[umodel.photo mj_url]
                             placeholderImage:k_user_default_img];
        }
        else{
            self.accountIcon.image = k_user_default_img;
        }
        
        self.userNameLable.hidden = NO;
        self.LoginBtn.hidden = YES;
        self.loginLable.hidden = YES;
        self.worksLable.text = [NSString stringWithFormat:@"%lD",(long)model.videoCount];
        self.forceLable.text = [NSString stringWithFormat:@"%lD",(long)model.followCount];
        self.fansLable.text = [NSString stringWithFormat:@"%lD",(long)model.fansCount];
        self.likeLable.text = [NSString stringWithFormat:@"%lD",(long)model.heartCount];
    }
    else {
        self.worksLable.text = @"0";
        self.forceLable.text = @"0";
        self.fansLable.text = @"0";
        self.likeLable.text = @"0";
        self.loginLable.hidden = NO;
        self.userNameLable.text = @"";
        self.loginLable.text = @"登录/注册";
        self.accountIcon.image = k_user_default_img;
        self.LoginBtn.hidden = NO;
        self.userNameLable.hidden = YES;
    }
}

- (IBAction)clickLoginBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickLoginEvent)]) {
        [self.delegate clickLoginEvent];
    }
}

- (IBAction)clickRightBtnEvent:(id)sender {
    if ([self.delegate respondsToSelector:@selector(jumpUserInfoVc)]) {
        [self.delegate jumpUserInfoVc];
    }
}

@end
