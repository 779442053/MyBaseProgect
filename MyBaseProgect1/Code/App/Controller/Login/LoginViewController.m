//
//  LoginViewController.m
//  KuaiZhu
//
//  Created by Ghy on 2019/5/13.
//  Copyright © 2019年 su. All rights reserved.
//

#import "LoginViewController.h"

#import "LoginVC.h"
#import "RegisterViewController.h"
#import "NLSliderSwitch.h"

static id _shareInstance = nil;
@interface LoginViewController ()<NLSliderSwitchDelegate,UIScrollViewDelegate>
@property(nonatomic,strong) UIButton *backBtn;
@property (nonatomic, strong) UIScrollView * backScrollV;
@property (nonatomic, strong) NLSliderSwitch *sliderSwitch;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    self.selectIndex = 1;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8F7"];
}
//状态栏颜色
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
-(BOOL)prefersStatusBarHidden {
    return NO;
}

//MARK: - initView
-(void)initView{
    //MARK:关闭
    [self.view addSubview:self.backBtn];
     NSArray *titarr = @[@"注册",@"登录"];
    self.backScrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, K_APP_NAVIGATION_BAR_HEIGHT + K_APP_STATUS_BAR_HEIGHT + 100, K_APP_WIDTH,K_APP_HEIGHT - K_APP_NAVIGATION_BAR_HEIGHT - K_APP_STATUS_BAR_HEIGHT  - 50)];
    self.backScrollV.pagingEnabled = YES;
    self.backScrollV.delegate = (id)self;
    self.backScrollV.showsVerticalScrollIndicator = NO;
    self.backScrollV.showsHorizontalScrollIndicator = NO;
    self.backScrollV.bounces = NO;
    self.backScrollV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backScrollV];
    self.backScrollV.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * 2, 1);//禁止竖向滚动
    NSMutableArray *viewARR = [[NSMutableArray alloc] init];
    for (int i = 0; i< titarr.count; i++) {
        if (i == 1) {
            LoginVC *viewVC = [[LoginVC alloc]init];
            [viewARR addObject:viewVC];
            [viewVC.view setFrame:CGRectMake(i*K_APP_WIDTH, 0, K_APP_WIDTH, self.backScrollV.frame.size.height)];
            viewVC.delegateVC = self;
            [self.backScrollV addSubview:viewVC.view];
            [self addChildViewController:viewVC];
        }else{
            RegisterViewController *viewVC = [[RegisterViewController alloc]init];
            [viewARR addObject:viewVC];
            [viewVC.view setFrame:CGRectMake(i*K_APP_WIDTH, 0, K_APP_WIDTH, self.backScrollV.frame.size.height)];
            viewVC.delegateVC = self;
            [self.backScrollV addSubview:viewVC.view];
            [self addChildViewController:viewVC];
        }
    }
    self.sliderSwitch = [[NLSliderSwitch alloc]initWithFrame:CGRectMake((K_APP_WIDTH - 70*2)/2, K_APP_NAVIGATION_BAR_HEIGHT + K_APP_STATUS_BAR_HEIGHT, 70*2, 50) buttonSize:CGSizeMake(70, 30)];
    self.sliderSwitch.titleArray = titarr;
    self.sliderSwitch.normalTitleColor = [UIColor colorWithHexString:@"#666666"];
    self.sliderSwitch.selectedTitleColor = [UIColor colorWithHexString:@"#000000"];
    self.sliderSwitch.selectedButtonColor = [UIColor colorWithHexString:@"#FF1493"];
    self.sliderSwitch.titleFont = [UIFont systemFontOfSize:15];
    self.sliderSwitch.backgroundColor = [UIColor clearColor];
    self.sliderSwitch.delegate = (id)self;
    self.sliderSwitch.viewControllers = viewARR;
    [self.sliderSwitch slideToIndex:self.selectIndex animated:YES];
    [self.view addSubview:self.sliderSwitch];
   
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.backScrollV) {
        float xx = scrollView.contentOffset.x;
        int rate = round(xx/K_APP_WIDTH);
        if (rate != self.sliderSwitch.selectedIndex) {
            [self.sliderSwitch slideToIndex:rate];
        }
    }
}
-(void)sliderSwitch:(NLSliderSwitch *)sliderSwitch didSelectedIndex:(NSInteger)selectedIndex{
    [self.backScrollV scrollRectToVisible:CGRectMake(selectedIndex*K_APP_WIDTH,0, K_APP_WIDTH, 1) animated:YES];
}
-(UIButton *)backBtn{
    if (!_backBtn) {
        CGFloat w = 40;
        CGFloat h = 40;
        CGFloat x = 30;
        CGFloat y = [[UIDevice currentDevice] isiPhoneX] ? K_APP_IPHONX_TOP : 20.0;
        CGRect rect = CGRectMake(x, y, w, h);
        _backBtn = [BaseUIView createBtn:rect
                                AndTitle:nil
                           AndTitleColor:nil
                              AndTxtFont:nil
                                AndImage:[UIImage imageNamed:@"login_exit"]
                      AndbackgroundColor:nil
                          AndBorderColor:nil
                         AndCornerRadius:0
                            WithIsRadius:NO
                     WithBackgroundImage:nil
                         WithBorderWidth:0];
        
        [_backBtn addTarget:self action:@selector(btnCloaseAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}
//MARK: - 单例
/** 控制器单例 */
+(instancetype)shareInstance{
    if(_shareInstance != nil){
        return _shareInstance;
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(_shareInstance == nil){
            _shareInstance = [[self alloc] init];
        }
    });
    return _shareInstance;
}
-(id)copyWithZone:(NSZone *)zone{
    return _shareInstance;
}
+(id)allocWithZone:(struct _NSZone *)zone{
    
    if(_shareInstance != nil){
        return _shareInstance;
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(_shareInstance == nil){
            _shareInstance = [super allocWithZone:zone];
        }
    });
    
    return _shareInstance;
}


//MARK: - 返回(关闭)
-(IBAction)btnCloaseAction:(UIButton * _Nullable)sender{
    [UIView animateWithDuration:0.25 animations:^{
        self.backBtn.transform = CGAffineTransformMakeRotation(M_PI);
    } completion:^(BOOL finished) {
        if (finished) {
            self.backBtn.transform = CGAffineTransformMakeRotation(0);
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}


//MARK: - 登录
-(void)logininApp:(NSDictionary *)dicParas{
    NSString *strUrl = [NSString stringWithFormat:@"%@Login",K_APP_HOST];
    
    __weak typeof(self) weakSelf = self;
    [Utils putRequestForServerData:strUrl
                    withParameters:dicParas
                    AndSuccessBack:^(id _responseData, NSString *strMsg) {
                        //登录成功
                        if (_responseData) {
                            //获取Cookie
                            ZWWLog(@"登录成功=%@",_responseData)
                            NSArray *cookiesArr = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
                            NSDictionary *cookieDic = [NSHTTPCookie requestHeaderFieldsWithCookies:cookiesArr];
                            NSString *cookie = [cookieDic objectForKey:LOGIN_COOKIE_KEY];
                            
                            NSMutableDictionary *dicTemp = [NSMutableDictionary dictionary];
                            [dicTemp setValue:cookie forKey:@"LoginCookie"];
                            [dicTemp addEntriesFromDictionary:_responseData];
                            
                            [UserModel setUserData:[dicTemp copy]];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginApp" object:nil];
                            
                            //设置回调
                            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(loginFinishBack)]) {
                                [weakSelf.delegate loginFinishBack];
                            }
                            
                            //关闭
                            dispatch_after(DISPATCH_TIME_NOW + 0.25, dispatch_get_main_queue(), ^{
                                [weakSelf btnCloaseAction:nil];
                            });
                        }
                        else{
                            [YJProgressHUD showInfo:(strMsg != nil && ![strMsg isKindOfClass:[NSNull class]])?strMsg:@"登录失败"];
                        }
                    } AndFailureBack:^(NSString *_strError) {
                        ZWWLog(@"登录失败！详见：%@",_strError);
                        [YJProgressHUD showError:_strError];
                    }
                     WithisLoading:YES];
}
-(void)getCode:(NSDictionary *)dicParas{
    [YJProgressHUD showLoading:@"验证码发送中..."];
    NSString *strUrl = [NSString stringWithFormat:@"%@SendSMSCode?Phone=%@",K_APP_HOST,dicParas[@"Phone"]];
//    __weak  typeof(self) weakSelf = self;
//    __block typeof(self) blockSelf = self;
    [Utils getRequestForServerData:strUrl
                    withParameters:nil
                AndHTTPHeaderField:^(AFHTTPRequestSerializer * _Nullable _requestSerializer) {
                    [_requestSerializer setValue:LOGIN_COOKIE forHTTPHeaderField:LOGIN_COOKIE_KEY];
                }
                    AndSuccessBack:^(id  _Nullable _responseData) {
                        [YJProgressHUD showSuccess:@"发送成功"];
                        if (_responseData) {

                        }
                    }
                    AndFailureBack:^(NSString * _Nullable _strError) {
                        ZWWLog(@"加载数据异常！详见：%@",_strError);
                        [YJProgressHUD showError:_strError];

                    }
                     WithisLoading:NO];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
}
@end
