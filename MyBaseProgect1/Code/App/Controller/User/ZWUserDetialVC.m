

#import "ZWUserDetialVC.h"
#import "ZWUserLikeListVC.h"
#import "InfosModel.h"

#import "CustomIOS7AlertView.h"
#import "PriseView.h"

//私信
#import "MessageVC.h"
#import "FansViewController.h"
@interface ZWUserDetialVC ()<PriseViewDelegate>
//我的评论,我的关注,我的喜欢,我的历史
@property (nonatomic, strong) UIView *myActionView;
//头不是图
@property (nonatomic, strong) UIView *myInfoView;
/** 关注 */
@property (nonatomic, strong) UILabel *labFocus;
/** 粉丝 */
@property (nonatomic, strong) UILabel *labFans;
/** 喜欢 */
@property (nonatomic, strong) UILabel *labLike;
/** 获赞 */
@property (nonatomic, strong) UILabel *labGood;
//头像
@property (nonatomic, strong) UIImageView *headImage;
//名字
@property (nonatomic, strong) UILabel *nameLabel;
//发送私信
@property (nonatomic, strong) UIButton *infoBtn;
//关注和不关注
@property (nonatomic, strong) UIButton *followBtn;

//信息列表
@property(nonatomic, strong, nullable) MLMSegmentScroll *segScroll;
//头部菜单
@property(nonatomic,strong) MLMSegmentHead *segHead;
//当前选中的索引
@property(nonatomic,assign) NSInteger selectIndex;

@property (nonatomic, strong) CustomIOS7AlertView *coustomAlert;
@property (nonatomic, strong) PriseView *priseView;
@end
#define column_array @[@"作品",@"喜欢"]//栏目
@implementation ZWUserDetialVC
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.userId) {
        __block typeof(self) blockSelf = self;
        __weak typeof(self) weakSelf = self;
        [Utils getInfosModelForUserId:self.userId.integerValue
                           andLoading:NO
                        andFinishback:^(InfosModel * _Nullable model) {
                            blockSelf.infoModel = model;
                            weakSelf.labFocus.text = [NSString stringWithFormat:@"%lD",(long)model.videoCount];
                            weakSelf.labFans.text = [NSString stringWithFormat:@"%lD",(long)model.followCount];
                            weakSelf.labLike.text = [NSString stringWithFormat:@"%lD",(long)model.fansCount];
                            weakSelf.labGood.text = [NSString stringWithFormat:@"%lD",(long)model.heartCount];
                            [weakSelf.headImage sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"我的"]];
                            weakSelf.nameLabel.text = model.name;
                            //1是关注
                            if (model.isFollowed)
                                self.followBtn.selected = YES;
                            //0是取消关注
                            else self.followBtn.selected = NO;

                        }];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackgroundColor];
    if ([self.userId isEqualToString: [NSString stringWithFormat:@"%d",[UserModel shareInstance].id]]) {
        self.followBtn.hidden = YES;
        self.infoBtn.hidden = YES;
    }
    UIImageView *headImageview = [[UIImageView alloc]init];
    headImageview.image = [UIImage imageNamed:@"userInfoBGImageView"];
    headImageview.frame = CGRectMake(0, 0,K_APP_WIDTH, 467);
    [self.view addSubview:headImageview];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"nav_camera_back_black.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"nav_camera_back_black.png"] forState:UIControlStateHighlighted];
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    button.frame = CGRectMake(18, 35, 40, 40);
    [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [self.view addSubview:self.myInfoView];


    UIView *middleView = [[UIView alloc]init];
    CGFloat x = 0;
    CGFloat w = K_APP_WIDTH;
    CGFloat y = CGRectGetMaxY(self.myInfoView.frame);
    CGRect rect = CGRectMake(x, y, w, K_APP_HEIGHT - y + 40);
    middleView.frame = rect;
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,K_APP_WIDTH,K_APP_HEIGHT );
    gl.startPoint = CGPointMake(0, 0);
    gl.endPoint = CGPointMake(1, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:215/255.0 green:225/255.0 blue:255/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0.0),@(1.0f)];
    self.view.backgroundColor = [UIColor clearColor];
    [middleView.layer insertSublayer:gl atIndex:0];
    [self.view addSubview:middleView];
    middleView.layer.cornerRadius = 13;
    middleView.layer.masksToBounds = YES;

    UIView *bgview = [[UIView alloc]init];
    CGFloat x1 = 0;
    CGFloat w1 = K_APP_WIDTH/2;
    CGFloat y1 = 0;
    CGRect rect1 = CGRectMake(x1, y1, w1, 72);
    bgview.frame = rect1;
    bgview.backgroundColor = [UIColor clearColor];
    [middleView addSubview:bgview];
    __weak typeof(self) weakSelf = self;
    [MLMSegmentManager associateHead:weakSelf.segHead
                          withScroll:weakSelf.segScroll
                          completion:^{
                              [bgview addSubview:weakSelf.segHead];
                              [middleView addSubview:weakSelf.segScroll];
                              [weakSelf.segHead getScrollLineView].layer.cornerRadius = K_HEAD_BOTTOM_LINE_CORNER;
                              [weakSelf.segHead getScrollLineView].layer.masksToBounds = YES;
                          }];
    self.nameLabel.text = self.userName;

    if (self.type && self.type == 100) {
      [self.segScroll setContentOffset:CGPointMake(K_APP_WIDTH * 1, 0) animated:YES];
    }

    
}
-(void)sendMessage:(UIButton *)sender{
    MessageVC *vc = [[MessageVC alloc] init];
    vc.userId = self.userId;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)followUserAndUnFollow:(UIButton *)sender{
    BOOL isSel = [self.infoModel.isFollowed intValue] == 1 ? NO : YES;
    __weak typeof(self) weakSelf = self;
    __block typeof(self) blockSelf = self;
    [Utils collectionUserOrNoWithId:[NSString stringWithFormat:@"%lD",(long)self.infoModel.userId]
                            AndFlow:isSel
                         AndLoading:YES
                     withFinishback:^(BOOL isSuccess) {
                         if (isSuccess) {
                             blockSelf.infoModel.isFollowed = (!isSel)?@"1":@"0";
                             NSInteger followCount = blockSelf.infoModel.followCount;
                             followCount = (!isSel)?++followCount:--followCount;
                             if (followCount <= 0) followCount = 0;
                             blockSelf.infoModel.followCount = followCount;
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 sender.selected = !sender.selected;
                                  weakSelf.labFans.text = [NSString stringWithFormat:@"%lD",(long)blockSelf.infoModel.followCount];
                             });
                         }
                     }];
}
-(void)btnTopAction:(UIButton *)sender{
    switch (sender.tag) {
        case 0:
        {//作品
          ZWWLog(@"作品")
         [self.segScroll setContentOffset:CGPointMake(K_APP_WIDTH * 0, 0) animated:YES];
        }
            break;
        case 1:
        {
          ZWWLog(@"关注")
            FansViewController *fansVC = [[FansViewController alloc] initWithUser:self.userId AndTitle:@"关注"];
            if (![[self.navigationController childViewControllers] containsObject:fansVC]) {
                [self.navigationController pushViewController:fansVC animated:YES];
            }
            else{
                [fansVC updateControllerWithUser:self.userId
                                        AndTitle:@"关注"];
                [self.navigationController popToViewController:fansVC animated:YES];
            }
            
        }
            break;
        case 2:
        {
            ZWWLog(@"粉丝")
            FansViewController *fansVC = [[FansViewController alloc] initWithUser:self.userId AndTitle:@"粉丝"];
            if (![[self.navigationController childViewControllers] containsObject:fansVC]) {
                fansVC.selectIndex = 1;
                [self.navigationController pushViewController:fansVC animated:YES];
            }
            else{
                fansVC.selectIndex = 1;
                [fansVC updateControllerWithUser:self.userId
                                        AndTitle:@"粉丝"];
                [self.navigationController popToViewController:fansVC animated:YES];
            }

        }
            break;
        case 3:
        {
            ZWWLog(@"点赞")
            if (!_coustomAlert) {
                self.priseView = [PriseView createPriseViewInit];
                self.priseView.delegate = (id<PriseViewDelegate>)self;

                CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
                [alertView setContainerView:_priseView];

                _priseView.userName.text = _infoModel.name;
                _priseView.desLable.text = [NSString stringWithFormat:@"共获得%ld个赞",(long)_infoModel.heartCount];
                [alertView setButtonTitles:nil];
                [alertView setDelegate:(id<CustomIOS7AlertViewDelegate>)self];
                [alertView setUseMotionEffects:YES];
                [alertView show];
                _coustomAlert = alertView;
            } else {
                [_coustomAlert show];
            }
        }
            break;

        default:
            break;
    }

}
-(MLMSegmentHead *)segHead{
    if (!_segHead) {
        CGFloat x = 0;
        CGFloat w = K_APP_WIDTH /2;
        CGFloat y = 0;
        CGRect rect = CGRectMake(x, y, w, 53);
        _segHead = [[MLMSegmentHead alloc] initWithFrame:rect
                                                  titles:column_array
                                               headStyle:SegmentHeadStyleLine layoutStyle:MLMSegmentLayoutDefault];

        _segHead.bottomLineHeight = 0;                      //底部线
        _segHead.headColor = [UIColor clearColor];          //背景色
        _segHead.selectColor = [UIColor blackColor];      //选中的颜色
        _segHead.deSelectColor = [UIColor colorWithHexString:@"#A7A7A8"]; //默认颜色
        _segHead.fontSize = 19;          //字体大小
        _segHead.fontScale = K_HEAD_MENU_SCALE;             //缩放大小
        _segHead.lineColor = [UIColor redColor];        //下划线颜色
        _segHead.lineHeight = K_HEAD_BOTTOM_LINE_HEIGHT;    //下划线高度
        _segHead.lineWidth = K_HEAD_BOTTOM_LINE_WIDTH;      //下划线宽度
        _segHead.slideCorner = K_HEAD_BOTTOM_LINE_CORNER;
    }
    return _segHead;
}
-(MLMSegmentScroll *)segScroll{
    if (!_segScroll) {
        __weak typeof(self) weakSelf = self;
        __block typeof(self) blockSelf = self;
        CGFloat h = K_APP_HEIGHT - CGRectGetMaxY(self.myInfoView.frame) - 64;
        if ([[UIDevice currentDevice] isiPhoneX]) {
            h -= K_APP_IPHONX_BUTTOM;
        }
        _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, 70, K_APP_WIDTH, h)
                                                   vcOrViews:[weakSelf collectionViewArr:[column_array count]]];
        _segScroll.loadAll = NO;
        _segScroll.scrollEndAction = ^(NSInteger currentIndex, BOOL isLeft, BOOL isRight) {
            blockSelf.selectIndex = currentIndex;
        };
    }
    return _segScroll;
}

//添加视图
-(NSArray *)collectionViewArr:(NSUInteger)count{
    NSMutableArray *_arr = [NSMutableArray array];
    ZWUserLikeListVC *_cv;
    NSString *strType;
    for (NSUInteger i = 0; i < count; i++) {
        strType = [NSString stringWithFormat:@"%@",[column_array objectAtIndex:i]];
        _cv = [[ZWUserLikeListVC alloc] initWithType:strType];
        _cv.userId = self.userId;
        [_arr addObject:_cv];
    }
    return [_arr copy];
}
- (UIView *)myActionView
{
    if (!_myActionView) {
        CGRect rect = CGRectMake(15, CGRectGetMaxY(self.nameLabel.frame) + 30, K_APP_WIDTH - 2*15, 64);
        _myActionView = [[UIView alloc] initWithFrame:rect];
        [_myActionView setBackgroundColor:[UIColor clearColor]];
        NSInteger i = 0;
        UIButton *btnInfo;
        NSArray *arrInfo = @[@"作品",@"关注",@"粉丝",@"称赞"];
        CGFloat x = 0;
        CGFloat w = rect.size.width/arrInfo.count;
        for (NSString *name in arrInfo) {
            x = i * w;
            btnInfo = [BaseUIView createBtn:CGRectMake(x, 0, w, rect.size.height)
                                   AndTitle:name
                              AndTitleColor:[UIColor colorWithHexString:@"#000000"]
                                 AndTxtFont:ADOBE_FONT(15)
                                   AndImage:nil
                         AndbackgroundColor:nil
                             AndBorderColor:nil
                            AndCornerRadius:0
                               WithIsRadius:NO
                        WithBackgroundImage:nil
                            WithBorderWidth:0];
            btnInfo.tag = i;
            btnInfo.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 12, 0);
            [btnInfo addTarget:self action:@selector(btnTopAction:) forControlEvents:UIControlEventTouchUpInside];
            [_myActionView addSubview:btnInfo];

            CGFloat top = 13;
            switch (i) {
                case 0:
                {
                    [btnInfo addSubview:self.labFocus];
                    [self.labFocus mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.right.mas_equalTo(0);
                        make.top.mas_equalTo(top);
                    }];
                }
                    break;

                case 1:
                {
                    [btnInfo addSubview:self.labFans];
                    [self.labFans mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.right.mas_equalTo(0);
                        make.top.mas_equalTo(top);
                    }];
                }
                    break;

                case 2:
                {
                    [btnInfo addSubview:self.labLike];
                    [self.labLike mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.right.mas_equalTo(0);
                        make.top.mas_equalTo(top);
                    }];
                }
                    break;

                case 3:
                {
                    [btnInfo addSubview:self.labGood];
                    [self.labGood mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.right.mas_equalTo(0);
                        make.top.mas_equalTo(top);
                    }];
                }
                    break;
                default:
                    break;
            }
            btnInfo.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            btnInfo.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;

            i++;
        }
    }
    return _myActionView;
}
- (UIView *)myInfoView
{
    if (!_myInfoView) {
        CGRect rect = CGRectMake(0, K_APP_NAVIGATION_BAR_HEIGHT, K_APP_WIDTH, 215);
        _myInfoView = [[UIView alloc] initWithFrame:rect];
        _myInfoView.backgroundColor = UIColor.clearColor;
        [_myInfoView addSubview:self.headImage];
        [_myInfoView addSubview:self.nameLabel];
        [_myInfoView addSubview:self.infoBtn];
        [_myInfoView addSubview:self.followBtn];
        [_myInfoView addSubview:self.myActionView];
    }
    return _myInfoView;
}

- (UIImageView *)headImage
{
    if (!_headImage) {
        _headImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 6, 73, 73)];
        [_headImage setImage:KZImage(@"我的")];
        [_headImage.layer setCornerRadius:73/2];
        [_headImage.layer setMasksToBounds:YES];
    }
    return _headImage;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(21, 79+16, 200, 18)];
        [_nameLabel setFont:[UIFont boldSystemFontOfSize:19]];
        [_nameLabel setText:@"userName"];
        _nameLabel.textColor = [UIColor whiteColor];
    }
    return _nameLabel;
}

- (UIButton *)infoBtn
{
    if (!_infoBtn) {
        _infoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat w = 31;
        CGFloat x = K_APP_WIDTH - w - 11;
        [_infoBtn setFrame:CGRectMake(x, 25+6, w, 31)];
         [_infoBtn setBackgroundImage:[UIImage imageNamed:@"Messageicon"] forState:UIControlStateNormal];
        [_infoBtn addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _infoBtn;
}
- (UIButton *)followBtn
{
    if (!_followBtn) {
        _followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat w = 100;
        CGFloat x = K_APP_WIDTH - w - 51;
        [_followBtn setFrame:CGRectMake(x, 25+6, w, 28)];
        [_followBtn setBackgroundImage:[UIImage imageNamed:@"关注"] forState:UIControlStateNormal];//取消关注
        [_followBtn setBackgroundImage:[UIImage imageNamed:@"取消关注"] forState:UIControlStateSelected];//取消关注
        [_followBtn addTarget:self action:@selector(followUserAndUnFollow:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _followBtn;
}
-(UILabel *)labFocus{
    if (!_labFocus) {
        _labFocus = [[UILabel alloc] init];
        _labFocus.text = @"0";
        _labFocus.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _labFocus.font = ADOBE_FONT(21);
        _labFocus.textAlignment = NSTextAlignmentCenter;
    }

    return _labFocus;
}

-(UILabel *)labFans{
    if (!_labFans) {
        _labFans = [[UILabel alloc] init];
        _labFans.text = @"0";
        _labFans.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _labFans.font = ADOBE_FONT(21);
        _labFans.textAlignment = NSTextAlignmentCenter;
    }
    return _labFans;
}

-(UILabel *)labLike{
    if (!_labLike) {
        _labLike = [[UILabel alloc] init];
        _labLike.text = @"0";
        _labLike.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _labLike.font = ADOBE_FONT(21);
        _labLike.textAlignment = NSTextAlignmentCenter;
    }
    return _labLike;
}

-(UILabel *)labGood{
    if (!_labGood) {
        _labGood = [[UILabel alloc] init];
        _labGood.text = @"0";
        _labGood.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _labGood.font = ADOBE_FONT(21);
        _labGood.textAlignment = NSTextAlignmentCenter;
    }
    return _labGood;
}
- (void)backAction {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)clickOkEvent {
    [_coustomAlert close];
}
@end
