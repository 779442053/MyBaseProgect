//
//  UserVipVC.m
//  KuaiZhu
//
//  Created by step_zhang on 2019/11/20.
//  Copyright © 2019 su. All rights reserved.
//

#import "UserVipVC.h"
#import "UIButton+ZWWImageBtn.h"
#import "InfosModel.h"
#define NAVBAR_COLORCHANGE_POINT (-IMAGE_HEIGHT + K_APP_NAVIGATION_BAR_HEIGHT*2)
#define IMAGE_HEIGHT 280
#define SCROLL_DOWN_LIMIT 25
#define LIMIT_OFFSET_Y -(IMAGE_HEIGHT + SCROLL_DOWN_LIMIT)
@interface UserVipVC ()
@property(nonatomic,strong) UIImageView *backImg;
@property(nonatomic,strong)UIImageView *headImageView;
@property(nonatomic,strong)UIImageView *VIPImageView;
@property(nonatomic,strong)UILabel *nameLb;
@property(nonatomic,strong)UILabel *finishDataLb;
@property(nonatomic,strong)UIButton *chargBtn;
@end

@implementation UserVipVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}
- (void)initUI{
    self.edgesForExtendedLayout = UIRectEdgeAll;
    [self setBackgroundColor];
    //我的信息
    [self.view addSubview:self.backImg];
    float w = K_APP_WIDTH - 80;
    float h = 21;
    float y = (44 - h) * 0.5 + ([[UIDevice currentDevice] isiPhoneX]?K_APP_IPHONX_TOP:20);
    float x = (K_APP_WIDTH - w) / 2.f;
    UILabel *labPageTitle = [BaseUIView createLable:CGRectMake(x, y, w, h)
                                    AndText:@"会员中心"
                                       AndTextColor:[UIColor whiteColor]
                                 AndTxtFont:[UIFont systemFontOfSize:24]
                         AndBackgroundColor:nil];
    labPageTitle.textAlignment = NSTextAlignmentCenter;
    labPageTitle.textColor = [UIColor whiteColor];
    labPageTitle.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:labPageTitle];
    CGFloat w1 = 35;
    CGFloat x1 = [[UIDevice currentDevice] isSmallDevice]?15:25;
    CGFloat h1 = 35;
    CGFloat y1 = ([[UIDevice currentDevice] isiPhoneX]?K_APP_IPHONX_TOP:20) + (44 - h1) * 0.5;
    UIButton *BackBTN = [BaseUIView createBtn:CGRectMake(x1, y1, w1, h1) AndTitle:nil AndTitleColor:nil AndTxtFont:nil AndImage:nil AndbackgroundColor:nil AndBorderColor:nil AndCornerRadius:0 WithIsRadius:NO WithBackgroundImage:[UIImage imageNamed:@"nav_camera_back_black.png"] WithBorderWidth:0];
    [BackBTN addTarget:self action:@selector(BackBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:BackBTN];
    
    //下面的view
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(12, y1 + h1 +15, K_APP_WIDTH - 24, 120)];
    topView.layer.cornerRadius = 12;
    topView.layer.masksToBounds = YES;
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    //
    [topView addSubview:self.headImageView];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(17);
        make.left.mas_offset(13);
        make.size.mas_equalTo(CGSizeMake(56, 56));
    }];
    
    [topView addSubview:self.nameLb];
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headImageView.mas_top).with.mas_offset(9);
        make.left.mas_equalTo(self.headImageView.mas_right).with.mas_offset(18);
        make.height.mas_equalTo(15);
    }];
    [topView addSubview:self.VIPImageView];
    [self.VIPImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLb.mas_bottom).with.mas_offset(10);
        make.left.mas_equalTo(self.headImageView.mas_right).with.mas_offset(18);
        make.size.mas_equalTo(CGSizeMake(21, 21));
    }];
    
    [topView addSubview:self.finishDataLb];
    [self.finishDataLb mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.mas_equalTo(self.VIPImageView.mas_right).with.mas_offset(7);
        make.height.mas_equalTo(12);
        make.centerY.mas_equalTo(self.VIPImageView.mas_centerY);
    }];
    
    [topView addSubview:self.chargBtn];
    [self.chargBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(topView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(80, 22));
        make.right.mas_equalTo(topView.mas_right).with.mas_offset(-10);
    }];
    
    
    
    
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(topView.frame)+15, K_APP_WIDTH - 24, K_APP_HEIGHT -CGRectGetMaxY(topView.frame)-15 - 30 )];
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView.layer.cornerRadius = 12;
    bottomView.layer.masksToBounds = YES;
    [self.view addSubview:bottomView];
    
    //vip3   线路
    UILabel *titlb = [[UILabel alloc]initWithFrame:CGRectMake(10, 35, K_APP_WIDTH - 44, 15)];
    titlb.font = [UIFont systemFontOfSize:15];
    titlb.textColor = [UIColor colorWithHexString:@"#000000"];
    titlb.text = @"会员权限介绍";
    titlb.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:titlb];
    
    UIButton *vipBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [vipBtn setImage:[UIImage imageNamed:@"VIP3"] forState:UIControlStateNormal];
    [vipBtn setTitle:@"VIP专属标识" forState:UIControlStateNormal];
    vipBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [vipBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [vipBtn setImgViewStyle:ButtonImgViewStyleTop imageSize:CGSizeMake(70, 70) space:9];
    vipBtn.frame = CGRectMake(65, CGRectGetMaxY(titlb.frame)+33, 70, 70);
    [bottomView addSubview:vipBtn];
    
    UIButton *vipBtn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [vipBtn2 setImage:[UIImage imageNamed:@"线路"] forState:UIControlStateNormal];
    [vipBtn2 setTitle:@"vip观看线路" forState:UIControlStateNormal];
    vipBtn2.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [vipBtn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [vipBtn2 setImgViewStyle:ButtonImgViewStyleTop imageSize:CGSizeMake(70, 70) space:9];
    vipBtn2.frame = CGRectMake(65 + 70 + K_APP_WIDTH - 24 - (65 + 70)*2, CGRectGetMaxY(titlb.frame)+33, 70, 70);
    [bottomView addSubview:vipBtn2];
    
    self.nameLb.text = self.userName;
    NSURL *url = [NSURL URLWithString:self.infoModel.photo];
    [self.headImageView setImageWithURL:url placeholderImage:KZImage(@"我的")];
    [self.headImageView wyh_autoSetImageCornerRedius:28 ConrnerType:UIRectCornerAllCorners];
    
    

}
-(void)BackBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(UIImageView *)backImg{
    if (_backImg == nil) {
        _backImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, K_APP_WIDTH, IMAGE_HEIGHT)];
        _backImg.contentMode = UIViewContentModeScaleAspectFill;
        _backImg.clipsToBounds = YES;
        _backImg.userInteractionEnabled = YES;
        _backImg.image = [self imageWithImageSimple:[UIImage imageNamed:@"mine_head_icon"] scaledToSize:CGSizeMake(K_APP_WIDTH, IMAGE_HEIGHT+SCROLL_DOWN_LIMIT)];
    }
    return _backImg;
}
- (UIImage *)imageWithImageSimple:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(CGSizeMake(newSize.width*2, newSize.height*2));
    [image drawInRect:CGRectMake (0, 0, newSize.width*2, newSize.height*2)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
- (UIImageView *)headImageView{
    if (_headImageView == nil) {
        _headImageView = [[UIImageView alloc]init];
        _headImageView.image = [UIImage imageNamed:@"我的"];
    }
    return _headImageView;
}
- (UIImageView *)VIPImageView{
    if (_VIPImageView == nil) {
        _VIPImageView = [[UIImageView alloc]init];
        _VIPImageView.image = [UIImage imageNamed:@"vipIcon"];
        _VIPImageView.hidden = YES;
    }
    return _VIPImageView;
}
-(UILabel *)nameLb{
    if (_nameLb == nil) {
        _nameLb = [[UILabel alloc]init];
        _nameLb.font = [UIFont systemFontOfSize:15];
        _nameLb.textColor = [UIColor colorWithHexString:@"#000000"];
    }
    return _nameLb;
}
-(UILabel *)finishDataLb{
    if (_finishDataLb == nil) {
        _finishDataLb = [[UILabel alloc]init];
        _finishDataLb.font = [UIFont systemFontOfSize:12];
        _finishDataLb.textColor = [UIColor colorWithHexString:@"#333333"];
        _finishDataLb.hidden = YES;
    }
    return _finishDataLb;
}
- (UIButton *)chargBtn{
    if (_chargBtn == nil) {
        _chargBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _chargBtn.backgroundColor = [UIColor colorWithHexString:@"#7FB8FF"];
        _chargBtn.layer.cornerRadius = 11;
        _chargBtn.layer.masksToBounds = YES;
        [_chargBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_chargBtn setTitle:@"充值" forState:UIControlStateNormal];
        _chargBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _chargBtn;
}
@end
