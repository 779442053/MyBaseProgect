//
//  WalletViewController.m
//  KuaiZhu
//
//  Created by apple on 2019/5/22.
//  Copyright © 2019 su. All rights reserved.
//

#import "WalletViewController.h"
#import "JSCurrentUserModel.h"

#import "JSTixianListCell.h"
#import "JSTuiguangListCell.h"
#import "ZWDaShangTableViewCell.h"

#import "JSMyAccountViewController.h"//我的账户
#import "JSTixianViewController.h"//提现
#import "MyBillsViewController.h"//账单


#define NAVBAR_COLORCHANGE_POINT (-IMAGE_HEIGHT + K_APP_NAVIGATION_BAR_HEIGHT*2)
#define IMAGE_HEIGHT 210
#define SCROLL_DOWN_LIMIT 25
#define LIMIT_OFFSET_Y -(IMAGE_HEIGHT + SCROLL_DOWN_LIMIT)

static CGFloat const headview_height = 286;
static CGFloat const section_headview_height = 49;
static CGFloat const section_headview2_height = 44;

static NSString *const tixian_cell_identify = @"JSTixianListCell";
static NSString *const tuiguan_cell_identify = @"JSTuiguangListCell";
static NSInteger const tag_ti_xian = 1234;
static NSInteger const tag_tui_guan = 1235;
static NSInteger const tag_line = 1236;
static NSInteger const tag_section2 = 666111;

#define select_color [[UIColor alloc] colorFromHexInt:0x007ef6 AndAlpha:1]

@interface WalletViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UITableView *listTableView;
@property(nonatomic, strong) NSArray *dataArray;
@property (nonatomic,strong) JSCurrentUserModel *currentUserModel;
@property(nonatomic,strong)ZWUserModel *UserModel;

/////////////////////////////////////////////////////////
@property(nonatomic, strong) UIView   *headTopView;
@property(nonatomic, strong) UILabel  *labTotalMoney;   //总资产
@property(nonatomic, strong) UIButton *btnTiXian;       //申请提现
@property(nonatomic, strong) UIButton *btnAccount;      //我的账号
@property(nonatomic, strong) UIButton *btnContact;      //联系客服
@property(nonatomic, strong) UILabel  *labCumulative;   //累计收益

/////////////////////////////////////////////////////////
@property(nonatomic, strong) UIView *headBottomView;   //底部视图
@property(nonatomic, strong) UILabel *labCurrentMoney; //当前金额
@property(nonatomic, strong) UILabel *labReviewMoney;  //审核中的

/////////////////////////////////////////////////////////
@property(nonatomic, strong) UIView *sectionHeadView;  //组头
@property(nonatomic, strong) UIView *sectionHeadView2; //组头2
@property (nonatomic, strong) UIButton *btnOk;//imgView
@property (nonatomic, strong) UIImageView *imgView;
@end

@implementation WalletViewController{
    NSString *strUserId;
    NSString *strType;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initView];
    
    //加载记录
    [self getWithdrawRecordAndUserPromotion];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //加载钱包数据
    [self getWalletData];
}
-(void)BackBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

//MARK: - initView
-(void)initView{
    self.view.backgroundColor = [UIColor colorWithHexString:@"#eaefff"];
    [self.view addSubview:self.imgView];

    float w = K_APP_WIDTH - 80;
    float h = 21;
    float y = (44 - h) * 0.5 + ([[UIDevice currentDevice] isiPhoneX]?K_APP_IPHONX_TOP:20);
    float x = (K_APP_WIDTH - w) / 2.f;
    UILabel *labPageTitle = [BaseUIView createLable:CGRectMake(x, y, w, h)
                                            AndText:@"我的钱包"
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
    UIButton *BackBTN = [BaseUIView createBtn:CGRectMake(x1,y1, w1, h1) AndTitle:nil AndTitleColor:nil AndTxtFont:nil AndImage:nil AndbackgroundColor:nil AndBorderColor:nil AndCornerRadius:0 WithIsRadius:NO WithBackgroundImage:[UIImage imageNamed:@"nav_camera_back_black"] WithBorderWidth:0];
    [BackBTN addTarget:self action:@selector(BackBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:BackBTN];
    [self.view addSubview:self.btnOk];


    
    
    //MARK:列表
    [self.view addSubview:self.listTableView];
    
    strType = @"提现";
    strUserId = [UserModel shareInstance]?[NSString stringWithFormat:@"%lD",(long)[UserModel shareInstance].id]:@"";
}


-(UITableView *)listTableView{
    if (!_listTableView) {
        CGFloat y = K_APP_NAVIGATION_BAR_HEIGHT;
        CGFloat h = K_APP_HEIGHT - y;
        if ([[UIDevice currentDevice] isiPhoneX]) {
            h -= K_APP_IPHONX_BUTTOM;
        }
        
        CGRect rect = CGRectMake(15, y, K_APP_WIDTH - 30, h);
        _listTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        _listTableView.backgroundColor = [UIColor clearColor];
        
        _listTableView.delegate = self;
        _listTableView.dataSource = self;
        
        //注册
        [_listTableView registerClass:[JSTuiguangListCell class] forCellReuseIdentifier:tuiguan_cell_identify];
        [_listTableView registerClass:[JSTixianListCell class] forCellReuseIdentifier:tixian_cell_identify];
        
        _listTableView.tableHeaderView = self.headTopView;
        _listTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _listTableView.layer.cornerRadius = 13;
        _listTableView.layer.masksToBounds = YES;
    }
    return _listTableView;
}


//MARK: - 表头
-(UIView *)headTopView{
    if (!_headTopView) {
        CGRect rect = CGRectMake(0, 0, K_APP_WIDTH, headview_height);
        _headTopView = [[UIView alloc] initWithFrame:rect];
        
        //MARK:背景图
        CGFloat x = 0;
        CGFloat w = K_APP_WIDTH - 30;
        CGFloat y = 0;
        CGFloat h = 177;
        rect = CGRectMake(x, y, w, h);
        UIImageView *bgImg = [BaseUIView createImage:rect
                                            AndImage:[UIImage imageNamed:@"ico_wallet_bg"]
                                  AndBackgroundColor:nil
                                           AndRadius:YES
                                         WithCorners:10];
        [_headTopView addSubview:bgImg];
        
        //MARK:总资产
        x = 34 ;
        y = 30;
        w = 120;
        h = 19;
        rect = CGRectMake(x, y, w, h);
        UILabel *title = [BaseUIView createLable:rect
                                         AndText:@"总资产(元)"
                                    AndTextColor:[UIColor colorWithHexString:@"#7AA2ED"]
                                      AndTxtFont:[UIFont systemFontOfSize:19]
                              AndBackgroundColor:nil];
        [_headTopView addSubview:title];
        [_headTopView addSubview:self.labTotalMoney];
        
        //MARK:提现
        [_headTopView addSubview:self.btnTiXian];
        
        //MARK:我的账号
        [_headTopView addSubview:self.btnAccount];
        //联系客服
        [_headTopView addSubview:self.btnContact];
        
        //MARK:累计收益
        [_headTopView addSubview:self.labCumulative];
        
        //MARK:底部视图
        [_headTopView addSubview:self.headBottomView];
    }
    return _headTopView;
}

-(UILabel *)labTotalMoney{
    if (!_labTotalMoney) {
        CGFloat x = 34;
        CGFloat h = 35;
        CGFloat y = 70;
        CGFloat w = 150;
        _labTotalMoney = [BaseUIView createLable:CGRectMake(x, y, w, h)
                                         AndText:@"0.00"
                                    AndTextColor:[UIColor colorWithHexString:@"#7AA2ED"]
                                      AndTxtFont:[UIFont boldSystemFontOfSize:45]
                              AndBackgroundColor:nil];
        _labTotalMoney.textAlignment = NSTextAlignmentLeft;
    }
    return _labTotalMoney;
}

-(UIButton *)btnTiXian{
    if (!_btnTiXian) {
        CGFloat y = 34;
        CGFloat w = 99;
        CGFloat h = 30;
        CGFloat x = K_APP_WIDTH - 30 - w - 32;
        _btnTiXian = [BaseUIView createBtn:CGRectMake(x, y, w, h)
                                  AndTitle:@"申请提现"
                             AndTitleColor:[UIColor whiteColor]
                                AndTxtFont:[UIFont systemFontOfSize:13]
                                  AndImage:nil
                        AndbackgroundColor:nil
                            AndBorderColor:nil
                           AndCornerRadius:0
                              WithIsRadius:NO
                       WithBackgroundImage:[UIImage imageNamed:@"btn_bg1"]
                           WithBorderWidth:0];
        
        [_btnTiXian addTarget:self action:@selector(btnTiXianAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnTiXian;
}

-(UIButton *)btnAccount{
    if (!_btnAccount) {
        CGRect rect = self.btnTiXian.frame;
        rect.origin.y += rect.size.height + 14;
        _btnAccount = [BaseUIView createBtn:rect
                                  AndTitle:@"我的账户"
                             AndTitleColor:[UIColor whiteColor]
                                AndTxtFont:[UIFont systemFontOfSize:13]
                                  AndImage:nil
                        AndbackgroundColor:nil
                            AndBorderColor:nil
                           AndCornerRadius:0
                              WithIsRadius:NO
                       WithBackgroundImage:[UIImage imageNamed:@"btn_bg1"]
                           WithBorderWidth:0];
        
        [_btnAccount addTarget:self action:@selector(btnAccountAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnAccount;
}
-(UIButton *)btnContact{
    if (!_btnContact) {
        CGRect rect = self.btnAccount.frame;
        rect.origin.y += rect.size.height + 14;
        _btnContact = [BaseUIView createBtn:rect
                                   AndTitle:@"联系客服"
                              AndTitleColor:[UIColor whiteColor]
                                 AndTxtFont:[UIFont systemFontOfSize:13]
                                   AndImage:nil
                         AndbackgroundColor:nil
                             AndBorderColor:nil
                            AndCornerRadius:0
                               WithIsRadius:NO
                        WithBackgroundImage:[UIImage imageNamed:@"btn_bg1"]
                            WithBorderWidth:0];
        [_btnContact addTarget:self action:@selector(btnContactAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnContact;
}

-(UILabel *)labCumulative{
    if (!_labCumulative) {
        CGRect rect = self.labTotalMoney.frame;
        rect.size.width = 200;
        rect.origin.y = rect.origin.y + rect.size.height + 29;
        _labCumulative = [BaseUIView createLable:rect
                                         AndText:@"累计收益：0.00"
                                    AndTextColor:[UIColor colorWithHexString:@"#7AA2ED"]
                                      AndTxtFont:[UIFont systemFontOfSize:19]
                              AndBackgroundColor:nil];
    }
    return _labCumulative;
}

-(UIView *)headBottomView{
    if (!_headBottomView) {
        CGFloat x = 0;
        CGFloat w = K_APP_WIDTH - 30;
        CGFloat y = 187;
        CGFloat h = 85;
       
        _headBottomView = [BaseUIView createView:CGRectMake(x, y, w, h)
                              AndBackgroundColor:[[UIColor alloc] colorFromHexInt:0xf5f5f5 AndAlpha:1]
                                     AndisRadius:YES
                                       AndRadiuc:13
                                  AndBorderWidth:0
                                  AndBorderColor:nil];
        
        //MARK:当前零钱
        [_headBottomView addSubview:self.labCurrentMoney];
        //描述
        UILabel* leftBottomLB = [[UILabel alloc]init];
        leftBottomLB.frame = CGRectMake(0, CGRectGetMaxY(self.labCurrentMoney.frame) + 15, _headBottomView.frame.size.width / 2, 15);
        leftBottomLB.text = @"当前零钱";
        leftBottomLB.textAlignment = NSTextAlignmentCenter;
        leftBottomLB.textColor = [UIColor colorWithHexString:@"#A7A7A8"];
        leftBottomLB.font = [UIFont systemFontOfSize:15];
        [_headBottomView addSubview:leftBottomLB];

        
        //MARK:中间线
        y = 10;
        h = _headBottomView.frame.size.height - 2 * y;
        w = 1;
        x = (_headBottomView.frame.size.width - w) * 0.5;
        UIView *line = [BaseUIView createView:CGRectMake(x, y, w, h)
                           AndBackgroundColor:[UIColor colorWithHexString:@"#d6e0fa"]
                                  AndisRadius:NO
                                    AndRadiuc:0
                               AndBorderWidth:0
                               AndBorderColor:nil];
        [_headBottomView addSubview:line];
        
        //MARK:审核金额
        [_headBottomView addSubview:self.labReviewMoney];

        UILabel* rightBottomLB = [[UILabel alloc]init];
        rightBottomLB.frame = CGRectMake( x, CGRectGetMaxY(self.labReviewMoney.frame) + 15, _headBottomView.frame.size.width / 2, 15);
        rightBottomLB.text = @"审核中现金";
        rightBottomLB.textAlignment = NSTextAlignmentCenter;
        rightBottomLB.textColor = [UIColor colorWithHexString:@"#A7A7A8"];
        rightBottomLB.font = [UIFont systemFontOfSize:15];
        [_headBottomView addSubview:rightBottomLB];
    }
    return _headBottomView;
}

///
-(UILabel *)labCurrentMoney{
    if (!_labCurrentMoney) {
        CGFloat x = 0;
        CGFloat h = 21;
        CGFloat w = (self.headBottomView.frame.size.width - 2 * x) * 0.5;
        CGFloat y = 19;
        _labCurrentMoney = [BaseUIView createLable:CGRectMake(x, y, w, h)
                                           AndText:@"0.00"
                                      AndTextColor:[UIColor blackColor]
                                        AndTxtFont:[UIFont systemFontOfSize:23] AndBackgroundColor:nil];
        _labCurrentMoney.textAlignment = NSTextAlignmentCenter;
    }
    return _labCurrentMoney;
}

-(UILabel *)labReviewMoney{
    if (!_labReviewMoney) {
        CGRect rect = _labCurrentMoney.frame;
        rect.origin.x = self.headBottomView.frame.size.width - rect.size.width - rect.origin.x;
        _labReviewMoney = [BaseUIView createLable:rect
                                           AndText:@"0.0"
                                      AndTextColor:[UIColor blackColor]
                                        AndTxtFont:[UIFont systemFontOfSize:23] AndBackgroundColor:nil];
        _labReviewMoney.textAlignment = NSTextAlignmentCenter;
    }
    return _labReviewMoney;
}


//MARK: - 组头
-(UIView *)sectionHeadView{
    if (!_sectionHeadView) {
        _sectionHeadView = [self createSectionHeadView];
    }
    else{
        [self updateUI:_sectionHeadView
              andTitle:strType
                andSet:NO];
    }
    
    return _sectionHeadView;
}

-(UIView *)sectionHeadView2{
    if (!_sectionHeadView2) {
        CGFloat h = section_headview_height + section_headview2_height;
        CGFloat x = 0;
        CGFloat w = K_APP_WIDTH - 2 * x;
        _sectionHeadView2 = [BaseUIView createView:CGRectMake(x, 0, w, h)
                                AndBackgroundColor:[UIColor clearColor]
                                       AndisRadius:NO
                                         AndRadiuc:0
                                    AndBorderWidth:0
                                    AndBorderColor:nil];
        
        //MARK:添加头一
        UIView *headView1 = [self createSectionHeadView];
        headView1.tag = tag_section2;
        [_sectionHeadView2 addSubview:headView1];
        
        //MARK:手机昵称
        h = 21;
        x = _sectionHeadView2.frame.origin.x;
        w = _sectionHeadView2.frame.size.width/3;
        CGFloat y = section_headview_height + (section_headview2_height - h) * 0.5;
        UILabel *lab1 = [BaseUIView createLable:CGRectMake(x, y, w, h)
                                        AndText:@"手机昵称"
                                   AndTextColor:[UIColor colorWithHexString:@"#999999"] AndTxtFont:[UIFont systemFontOfSize:14]
                             AndBackgroundColor:nil];
        lab1.textAlignment = NSTextAlignmentCenter;
        [_sectionHeadView2 addSubview:lab1];
        
        //MARK:推广时间
        CGRect rect = lab1.frame;
        rect.origin.x += rect.size.width;
        UILabel *lab2 = [BaseUIView createLable:rect
                                        AndText:@"推广时间"
                                   AndTextColor:[UIColor colorWithHexString:@"#999999"] AndTxtFont:[UIFont systemFontOfSize:14]
                             AndBackgroundColor:nil];
        lab2.textAlignment = NSTextAlignmentCenter;
        [_sectionHeadView2 addSubview:lab2];
        
        //MARK:手机昵称
        rect = lab2.frame;
        rect.origin.x += rect.size.width;
        UILabel *lab3 = [BaseUIView createLable:rect
                                        AndText:@"状态"
                                   AndTextColor:[UIColor colorWithHexString:@"#999999"] AndTxtFont:[UIFont systemFontOfSize:14]
                             AndBackgroundColor:nil];
        lab3.textAlignment = NSTextAlignmentCenter;
        [_sectionHeadView2 addSubview:lab3];
    }
    else{
        [self updateUI:[_sectionHeadView2 viewWithTag:tag_section2]
              andTitle:strType
                andSet:NO];
    }
    
    return _sectionHeadView2;
}

-(UIView *)createSectionHeadView{
    
    CGFloat x = 0;
    CGFloat w = K_APP_WIDTH - 2 * x;
    UIView *tmp = [BaseUIView createView:CGRectMake(x, 0, w, section_headview_height)
                      AndBackgroundColor:[UIColor whiteColor]
                             AndisRadius:NO
                               AndRadiuc:0
                          AndBorderWidth:0
                          AndBorderColor:nil];
//    //MARK:提现记录
    w = 62;
    CGFloat h = 30;
    CGFloat y = (section_headview_height - h) * 0.5;
    x = ((K_APP_WIDTH - 20) * 0.5 - w) * 0.5;
    UIButton *_btnTXRecord = [BaseUIView createBtn:CGRectMake(x, y, w, h)
                                         AndTitle:@"提现记录"
                                    AndTitleColor:[UIColor colorWithHexString:@"#A7A7A8"]
                                       AndTxtFont:[UIFont systemFontOfSize:15]
                                         AndImage:nil
                               AndbackgroundColor:nil
                                   AndBorderColor:nil
                                  AndCornerRadius:0
                                     WithIsRadius:NO
                              WithBackgroundImage:nil
                                  WithBorderWidth:0];

    _btnTXRecord.tag = tag_ti_xian;
    [_btnTXRecord setSelected:[strType isEqualToString:@"提现"]?YES:NO];
    [_btnTXRecord setTitleColor:[UIColor colorWithHexString:@"#000000"] forState:UIControlStateSelected];

    [_btnTXRecord addTarget:self action:@selector(btnSectionHeadAction:) forControlEvents:UIControlEventTouchUpInside];
    [tmp addSubview:_btnTXRecord];

    //MARK:推广记录
    CGRect rect = _btnTXRecord.frame;
    rect.origin.x = (K_APP_WIDTH - 20) - rect.origin.x - rect.size.width;
    UIButton *_btnTGRecord = [BaseUIView createBtn:rect
                                          AndTitle:@"推广记录"
                                     AndTitleColor:[UIColor colorWithHexString:@"#A7A7A8"]
                                        AndTxtFont:[UIFont systemFontOfSize:15]
                                          AndImage:nil
                                AndbackgroundColor:nil
                                    AndBorderColor:nil
                                   AndCornerRadius:0
                                      WithIsRadius:NO
                               WithBackgroundImage:nil
                                   WithBorderWidth:0];

    _btnTGRecord.tag = tag_tui_guan;
    [_btnTGRecord setSelected:[strType isEqualToString:@"提现"]?NO:YES];
    [_btnTGRecord setTitleColor:[UIColor colorWithHexString:@"#000000"] forState:UIControlStateSelected];

    [_btnTGRecord addTarget:self action:@selector(btnSectionHeadAction:) forControlEvents:UIControlEventTouchUpInside];
    [tmp addSubview:_btnTGRecord];

    //MARK:指示条
    rect = [strType isEqualToString:@"提现"]?_btnTXRecord.frame:_btnTGRecord.frame;
    rect.size.height = 3;
    rect.size.height = 3;
    rect.origin.y = section_headview_height - rect.size.height;
    UIView *_bottomLine = [BaseUIView createView:rect
                              AndBackgroundColor:[UIColor colorWithHexString:@"#FF4C4C"]
                                     AndisRadius:YES
                                       AndRadiuc:1.5
                                  AndBorderWidth:0
                                  AndBorderColor:nil];
    _bottomLine.tag = tag_line;
    [tmp addSubview:_bottomLine];

//    MARK:底部线
    CGFloat h1 = 0.5;
    CGFloat x1 = 10;
    CGFloat w1 = K_APP_WIDTH - 2 * x1;
    UIView *line = [BaseUIView createView:CGRectMake(x1, section_headview_height - h, w1, h1)
                       AndBackgroundColor:[UIColor clearColor]
                              AndisRadius:NO
                                AndRadiuc:0
                           AndBorderWidth:0
                           AndBorderColor:nil];
    [tmp addSubview:line];
    return tmp;
}


//MARK: - 加载钱包数据
-(void)getWalletData{
    NSString *strURL = [NSString stringWithFormat:@"%@CurrentUser",K_APP_HOST];
    NSDictionary *dicParams = @{@"id":strUserId};
    __weak typeof(self) weakSelf = self;
    __block typeof(self) blockSelf = self;
    [Utils getRequestForServerData:strURL
                    withParameters:dicParams
                AndHTTPHeaderField:^(AFHTTPRequestSerializer * _Nullable _requestSerializer) {
                    [_requestSerializer setValue:LOGIN_COOKIE forHTTPHeaderField:LOGIN_COOKIE_KEY];
                } AndSuccessBack:^(id  _Nullable _responseData) {
                    if (_responseData) {
                        blockSelf.currentUserModel = [JSCurrentUserModel mj_objectWithKeyValues:_responseData];
                        self.UserModel = [ZWUserModel mj_objectWithKeyValues:_responseData];
                        [ZWDataManager saveUserData];
                    }
                    
                    [weakSelf updateTopUI];
                }
                    AndFailureBack:^(NSString * _Nullable _strError) {
                        ZWWLog(@"加载钱包数据异常！详见：%@",_strError);
                    }
                     WithisLoading:NO];
}

-(void)updateTopUI{
    
    NSString *strTotal = @"0.00";
    NSString *strLJSY = @"累计收益:0.00";
    NSString *strMoney = @"0.00";
    NSString *strReview = @"0.00";
    if (self.currentUserModel) {
        strTotal = [NSString stringWithFormat:@"%.2f",self.currentUserModel.balance + self.currentUserModel.frozen];
        
        strLJSY = [NSString stringWithFormat:@"累计收益:%.2f",self.currentUserModel.profit];
        
        strMoney = [NSString stringWithFormat:@"%.2f",self.currentUserModel.balance];
        
        strReview = [NSString stringWithFormat:@"%.2f",self.currentUserModel.frozen];
    }
    
    //总资产
    self.labTotalMoney.text = strTotal;
    //累计收益
    self.labCumulative.text = strLJSY;
    //当前零钱
    self.labCurrentMoney.text = strMoney;
    //审核中的
    self.labReviewMoney.text = strReview;
}
//MARK: - 加载记录
-(void)getWithdrawRecordAndUserPromotion{
    NSString *strUrl = [NSString stringWithFormat:@"%@GetWithdrawRecord",K_APP_HOST];
    NSDictionary *dicParams = @{@"PageIndex":@"0",@"PageSize":@"10"};
    __weak typeof(self) weakSelf = self;
    if (![strType isEqualToString:@"提现"]) {
        strUrl = [NSString stringWithFormat:@"%@KTT_UserPromotion",K_APP_STATIC_HOST];
        dicParams = @{@"p":@"0",@"v":@"0"};
        [Utils getRequestForServerData:strUrl
                        withParameters:dicParams
                    AndHTTPHeaderField:^(AFHTTPRequestSerializer * _Nullable _requestSerializer) {
                        [_requestSerializer setValue:LOGIN_COOKIE forHTTPHeaderField:LOGIN_COOKIE_KEY];
                    }
                        AndSuccessBack:^(id  _Nullable _responseData) {
                            [weakSelf dealData:_responseData
                                    AndMessage:@"暂无记录"];
                        } AndFailureBack:^(NSString * _Nullable _strError) {
                            ZWWLog(@"获取记录异常！详见：%@",_strError);
                            [MBProgressHUD showError:_strError];
                            
                            [weakSelf.listTableView reloadData];
                        } WithisLoading:NO];
    }
    else{
        [Utils putRequestForServerData:strUrl
                        withParameters:dicParams
                        AndSuccessBack:^(id  _Nullable _responseData, NSString * _Nullable strMsg) {
                            [weakSelf dealData:_responseData
                                    AndMessage:strMsg];
                        }
                        AndFailureBack:^(NSString * _Nullable _strError) {
                            ZWWLog(@"获取记录异常！详见：%@",_strError);
                            [MBProgressHUD showError:_strError];
                            
                            [weakSelf.listTableView reloadData];
                        }
                         WithisLoading:NO];
    }
}

-(void)dealData:(id _Nullable)_responseData AndMessage:(NSString * _Nullable)strMsg{
    __block typeof(self) blockSelf = self;
    if (_responseData) {
        if ([[_responseData allKeys] containsObject:@"record"]) {
            blockSelf.dataArray = _responseData[@"record"];
        }
        else if([[_responseData allKeys] containsObject:@"data"]){
            blockSelf.dataArray = _responseData[@"data"];
        }
    }
    else{
        [MBProgressHUD showError:strMsg?strMsg:@"获取记录失败"];
    }
    [self.listTableView reloadData];
}


//MARK: - 提现
-(IBAction)btnTiXianAction:(UIButton *)sender{
    ZWWLog(@"提现");
    JSTixianViewController *vc= [[JSTixianViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)btnChangePwd:(UIButton *)sender{
    ZWWLog(@"账单");
    MyBillsViewController * vc = [[MyBillsViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)btnContactAction:(UIButton *)sender{
    [YJProgressHUD showMessage:@"开发中..."];
}
//MARK: - 我的账号
-(IBAction)btnAccountAction:(UIButton *)sender{
    ZWWLog(@"我的账号");
    [YJProgressHUD showMessage:@"即将推出,敬请期待"];
//    JSMyAccountViewController *vc = [[JSMyAccountViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
}

//MARK: - 组头点击事件
-(IBAction)btnSectionHeadAction:(UIButton *)sender{
    
    self.dataArray = nil;
    [self updateUI:sender.superview
          andTitle:sender.titleLabel.text
            andSet:YES];
    
    //加载数据
    [self getWithdrawRecordAndUserPromotion];
}

-(void)updateUI:(UIView *)superView andTitle:(NSString *)strTitle andSet:(BOOL)set{
    
    //提现
    UIButton *btnTX = (UIButton *)[superView viewWithTag:tag_ti_xian];
    //退广
    UIButton *btnTG = (UIButton *)[superView viewWithTag:tag_tui_guan];
    //指示条
    UIView *line = [superView viewWithTag:tag_line];
    
    CGFloat offsetX;
    if([strTitle containsString:@"提现"]){
        btnTG.selected = NO;
        btnTX.selected = YES;
        offsetX = btnTX.frame.origin.x;
        
        if (set) strType = @"提现";
    }
    else{
        btnTX.selected = NO;
        btnTG.selected = YES;
        offsetX = btnTG.frame.origin.x;
        
        if (set) strType = @"推广";
    }
    
    [UIView animateWithDuration:0.35
                     animations:^{
                         CGRect rect = line.frame;
                         rect.origin.x = offsetX;
                         line.frame = rect;
                     }
                     completion:nil];
}


//MARK: -  UITableViewDataSource、UITableViewDelegate
//MARK:组头、组尾
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([strType isEqualToString:@"推广"]) {
        return section_headview_height + section_headview2_height;
    }
    return section_headview_height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if ([strType isEqualToString:@"推广"]) {
        return self.sectionHeadView2;
    }
    return self.sectionHeadView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

//MARK:表列
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataArray && [self.dataArray count] > 0) {
        return [self.dataArray count];
    }
    return 0;
}

//添加其余的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict;
    if ([strType isEqualToString:@"提现"]) {
        JSTixianListCell *cell = [[[NSBundle mainBundle] loadNibNamed:tixian_cell_identify owner:self options:nil] lastObject];
        
        if (self.dataArray && [self.dataArray count] > indexPath.row) {
            dict = [self.dataArray objectAtIndex:indexPath.row];
            [cell configWitData:dict];
        }
        
        return cell;
    }
    else{
        JSTuiguangListCell *cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([JSTuiguangListCell class]) owner:self options:nil] lastObject];
        
        if (self.dataArray && [self.dataArray count] > indexPath.row) {
            dict = [self.dataArray objectAtIndex:indexPath.row];
            [cell configWitData:dict];
        }
       
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([strType isEqualToString:@"推广"])
        return 40;
    else return 60;
}
-(UIButton *)btnOk{
    if (!_btnOk) {
        float y = (44 - 21) * 0.5 + ([[UIDevice currentDevice] isiPhoneX]?K_APP_IPHONX_TOP:20);
        CGRect rect = CGRectMake(0, y, 35, 17);
        rect.origin.x = K_APP_WIDTH - 20 - rect.size.width;
        _btnOk = [BaseUIView createBtn:rect
                              AndTitle:@"账单"
                         AndTitleColor:[UIColor whiteColor]
                            AndTxtFont:[UIFont systemFontOfSize:15]
                              AndImage:nil
                    AndbackgroundColor:nil
                        AndBorderColor:nil
                       AndCornerRadius:0.0
                          WithIsRadius:NO
                   WithBackgroundImage:nil
                       WithBorderWidth:0];

        [_btnOk addTarget:self
                   action:@selector(btnChangePwd:)
         forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnOk;
}
- (UIImageView *)imgView
{
    if (_imgView == nil) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, K_APP_WIDTH, IMAGE_HEIGHT)];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.clipsToBounds = YES;
        _imgView.userInteractionEnabled = YES;
        _imgView.image = [self imageWithImageSimple:[UIImage imageNamed:@"mine_head_icon"] scaledToSize:CGSizeMake(K_APP_WIDTH, IMAGE_HEIGHT+SCROLL_DOWN_LIMIT)];
    }
    return _imgView;
}
- (UIImage *)imageWithImageSimple:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(CGSizeMake(newSize.width*2, newSize.height*2));
    [image drawInRect:CGRectMake (0, 0, newSize.width*2, newSize.height*2)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
