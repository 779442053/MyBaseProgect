//
//  MainViewController.m
//  QuanPaiPai
//
//  Created by XianXin on 2018/12/13.
//  Copyright © 2018 XianXin. All rights reserved.
//

#import "MainViewController.h"
#import "MainListCollectionViewController.h"
#import "VideoModel.h"
#import "AnnouncementsModel.h"
#import "AnnouncementsView.h"
#import "CustomIOS7AlertView.h"
#import "RecentVC.h"
#import "SearchVC.h"
#import "LoginViewController.h"
#import <WebKit/WebKit.h>
#import "NLSliderSwitch.h"
//栏目高度
#define type_header_height 40.0

static id _shareInstance = nil;

@interface MainViewController ()<NLSliderSwitchDelegate,AnnouncementsViewDelegate,LoginViewControllerDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView * backScrollV;
@property (nonatomic, strong) NLSliderSwitch *sliderSwitch;

@property(nonatomic,assign) NSInteger selectIndex;

//公告数据
@property(nonatomic,  copy) NSArray<AnnouncementsModel *> *arrNotice;
//公告视图
@property(nonatomic,strong) AnnouncementsView *noticeView;
@property(nonatomic,strong) CustomIOS7AlertView *alertView;

@property(nonatomic,strong) UIButton *btnSearch;
@property(nonatomic,strong) UIButton *btnHistory;

@property(nonatomic,strong)WKWebView *wkwebView;
@property(nonatomic,strong) WKUserContentController * userContentController;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    @autoreleasepool {
        [self initView];
    }
    NSString *Url = [[NSUserDefaults standardUserDefaults] objectForKey:@"html"];
    //ZWWLog(@"tongjiapiAPI = %@",Url)
    WKWebViewConfiguration * configuration = [[WKWebViewConfiguration alloc]init];//先实例化配置类 以前UIWebView的属性有的放到了这里
    _userContentController =[[WKUserContentController alloc]init];
    configuration.userContentController = _userContentController;
    configuration.preferences.javaScriptEnabled = NO;//打开js交互
    _wkwebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) configuration:configuration];
    [self.view addSubview:_wkwebView];
    _wkwebView.backgroundColor = [UIColor clearColor];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:Url]];
    [_wkwebView loadRequest:request];
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showNoticeView)
                                                 name:K_APP_BOX_SHOW_NOTICE object:nil];
    [self getAppInfo];
}
//检查版本更新
-(void)getAppInfo{
    NSString *strUrl = [NSString stringWithFormat:@"%@Version",K_APP_HOST];
    NSDictionary *dicParam = @{@"d":@"IOS"};
    [Utils getRequestForServerData:strUrl
                    withParameters:dicParam
                AndHTTPHeaderField:nil
                    AndSuccessBack:^(id _responseData) {
                        ZWWLog(@"版本信息==：%@",_responseData);
                        //拿出本地的版本进行判断,如需更新.将提示框加在window层上面.更新,就打开网址即可
                        NSString *version = _responseData[@"version"];
                        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                        NSString *Currentversion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
                        //Bundle version
                        NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
                        if ([app_build floatValue] < [version floatValue]){
                            NSString *strInfo = [NSString stringWithFormat:@"当前版本：%@，最新版本：%@,请点击更新",Currentversion,[_responseData objectForKey:@"info"]];
                            NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:strInfo];
                            NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
                            paragraph.alignment = NSTextAlignmentLeft;
                            [alertControllerMessageStr setAttributes:@{NSParagraphStyleAttributeName:paragraph} range:NSMakeRange(0, alertControllerMessageStr.length)];
                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"发现新版本" message:@""
                                                                                    preferredStyle:UIAlertControllerStyleAlert];
                            [alert setValue:alertControllerMessageStr forKey:@"attributedMessage"];
                            UIAlertAction *download = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                NSString *str = _responseData[@"url"];
                                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:str]]) {
                                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:^(BOOL success) {
                                        if (!success) {
                                            [YJProgressHUD showError:@"URL 无效"];
                                        }
                                    }];
                                }
                            }];
                            //强制更新，没有取消按钮
                            UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                            [alert addAction:download];
                            [alert addAction:cancle];
                            [self presentViewController:alert animated:YES completion:nil];


                        }
                    }
                    AndFailureBack:^(NSString *_strError) {
                        ZWWLog(@"版本信息载失败！详见：%@",_strError);
                    }
                     WithisLoading:NO];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //加载幻灯片广告
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @autoreleasepool {
            [self loadBannelADData];
        }
    });
    //加载公告
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @autoreleasepool {
            [self loadNoticeData];
        }
    });
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:K_APP_BOX_SHOW_NOTICE object:nil];
}
//MARK: - initView
-(void)initView{
    self.selectIndex = 0;
    //MARK:导航
    [self initNavgationBar:[UIColor clearColor]
          AndHasBottomLine:NO
              AndHasShadow:NO
             WithHasOffset:0.0];

    NSArray *titarr = @[@"关注", @"最热", @"最新"];
    CGFloat h = K_APP_HEIGHT - K_APP_NAVIGATION_BAR_HEIGHT - K_APP_TABBAR_HEIGHT;
    self.backScrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, K_APP_NAVIGATION_BAR_HEIGHT, K_APP_WIDTH,h)];
    self.backScrollV.pagingEnabled = YES;
    self.backScrollV.delegate = (id)self;
    self.backScrollV.showsVerticalScrollIndicator = NO;
    self.backScrollV.showsHorizontalScrollIndicator = NO;
    self.backScrollV.bounces = NO;
    self.backScrollV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backScrollV];
    self.backScrollV.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * 3, 1);//禁止竖向滚动
    NSMutableArray *viewARR = [[NSMutableArray alloc] init];
    for (int i = 0; i< titarr.count; i++) {
        NSString *type = titarr[i];
        MainListCollectionViewController *viewVC = [[MainListCollectionViewController alloc]initWithType:type];
        [viewARR addObject:viewVC];
        [viewVC.view setFrame:CGRectMake(i*K_APP_WIDTH, 0, K_APP_WIDTH, self.backScrollV.frame.size.height)];
        viewVC.delegateVC = self;
        [viewVC.collectionView.mj_header beginRefreshing];
        [self.backScrollV addSubview:viewVC.view];
        [self addChildViewController:viewVC];
    }
    CGFloat y = [[UIDevice currentDevice] isiPhoneX] ? K_APP_IPHONX_TOP : 20.0;
    y += (44.0 - type_header_height) * 0.5;
    self.sliderSwitch = [[NLSliderSwitch alloc]initWithFrame:CGRectMake((K_APP_WIDTH - 159 - 30)/2, y, 159+30, type_header_height) buttonSize:CGSizeMake(189/3, 30)];
    self.sliderSwitch.titleArray = titarr;
    self.sliderSwitch.normalTitleColor = [UIColor colorWithHexString:@"#666666"];
    self.sliderSwitch.selectedTitleColor = [UIColor colorWithHexString:@"#000000"];
    self.sliderSwitch.selectedButtonColor = [UIColor colorWithHexString:@"#FF1493"];
    self.sliderSwitch.titleFont = [UIFont systemFontOfSize:19];
    self.sliderSwitch.backgroundColor = [UIColor clearColor];
    self.sliderSwitch.delegate = (id)self;
    self.sliderSwitch.viewControllers = viewARR;
    [self.sliderSwitch slideToIndex:1 animated:YES];
    [self.navView addSubview:self.sliderSwitch];
    
    //MARK:搜索
    [self.view addSubview:self.btnSearch];
    
    //MARK:历史
    [self.view addSubview:self.btnHistory];
    //MARK:背景
    [self setBackgroundColor];
}
-(AnnouncementsView *)noticeView{
    if (!_noticeView) {
        _noticeView = [[AnnouncementsView alloc] init];
        _noticeView.delegate = self;
    }
    return _noticeView;
}

-(CustomIOS7AlertView *)alertView{
    if (!_alertView) {
        _alertView = [[CustomIOS7AlertView alloc] init];
        [_alertView setButtonTitles:nil];
        [_alertView setUseMotionEffects:YES];
    }
    return _alertView;
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


//MARK: - 搜索
-(UIButton *)btnSearch{
    if (!_btnSearch) {
        CGFloat w = 35;
        CGFloat x = [[UIDevice currentDevice] isSmallDevice]?15:25;
        CGFloat h = 35;
        CGFloat y = ([[UIDevice currentDevice] isiPhoneX]?K_APP_IPHONX_TOP:20) + (44 - h) * 0.5;
        _btnSearch =[BaseUIView createBtn:CGRectMake(x, y, w, h)
                                 AndTitle:nil
                            AndTitleColor:nil
                               AndTxtFont:nil
                                 AndImage:[UIImage imageNamed:@"search_seek_gray"]
                       AndbackgroundColor:nil
                           AndBorderColor:nil
                          AndCornerRadius:0
                             WithIsRadius:NO
                      WithBackgroundImage:nil
                          WithBorderWidth:0];
        
        [_btnSearch addTarget:self action:@selector(btnSearchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnSearch;
}

-(IBAction)btnSearchAction:(UIButton *)sender{
    SearchVC *vc = [SearchVC new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


//MARK: - 历史
-(UIButton *)btnHistory{
    if (!_btnHistory) {
        CGFloat w = 35;
        CGFloat h = 35;
        CGFloat x = K_APP_WIDTH - w - self.btnSearch.frame.origin.x;
        CGFloat y = ([[UIDevice currentDevice] isiPhoneX]?K_APP_IPHONX_TOP:20) + (44 - h) * 0.5;
        _btnHistory =[BaseUIView createBtn:CGRectMake(x, y, w, h)
                                 AndTitle:nil
                            AndTitleColor:nil
                               AndTxtFont:nil
                                 AndImage:[UIImage imageNamed:@"main_history.png"]
                       AndbackgroundColor:nil
                           AndBorderColor:nil
                          AndCornerRadius:0
                             WithIsRadius:NO
                      WithBackgroundImage:nil
                          WithBorderWidth:0];
        
        [_btnHistory addTarget:self action:@selector(btnHistoryhAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnHistory;
}

-(IBAction)btnHistoryhAction:(UIButton *)sender{
    if (![UserModel userIsLogin]) {
        [self userToLogin:(LoginViewControllerDelegate *)self];
        return;
    }
    
    [self togoHistory];
}

-(void)togoHistory{
    RecentVC *recentVC = [[RecentVC alloc] init];
    [self.navigationController pushViewController:recentVC animated:YES];
}


//MARK: - LoginViewControllerDelegate
-(void)loginFinishBack{
    [self togoHistory];
}


//MARK: - 公告
-(void)showNoticeView{
    if (self.arrNotice && [self.arrNotice count] > 0) {
        [self showNoticeViewIndex:0 withButtonString:@"下一个"];
        [self.alertView setContainerView:self.noticeView];
        [self.alertView show];
    }
}

-(void)showNoticeViewIndex:(NSInteger)index withButtonString:(NSString *)strbtn{
    
    if (!self.arrNotice || [self.arrNotice count] <= index) {
        ZWWLog(@"数据不存在，或索引越界");
        return;
    }
    
    AnnouncementsModel *model;
    id tmp = self.arrNotice[index];
    if ([tmp isKindOfClass:[AnnouncementsModel class]]) {
        model = tmp;
    }
    else{
        model = [AnnouncementsModel mj_objectWithKeyValues:tmp];
    }
    
    CGRect rect = self.noticeView.frame;
    CGFloat h = [Utils getHeightForString:model.content andFontSize:self.noticeView.labContent.font andWidth:self.noticeView.labContent.frame.size.width];
    rect.size = CGSizeMake(K_APP_BOX_WIDTH, h + [AnnouncementsView minViewHeight]);
    self.noticeView.frame = rect;
    
    [self.noticeView initUpdateView:model
                      AndButtonInfo:strbtn
                           AndIndex:index
                        WithOffsetH:h];
}

//加载公告
-(void)loadNoticeData{
    NSString *strUrl = [NSString stringWithFormat:@"%@Announcements",K_APP_HOST];
    NSDictionary *dicParams = @{@"id":@"0"};
    
    __block typeof(self) blockSelf = self;
    [Utils getRequestForServerData:strUrl
                    withParameters:dicParams
                AndHTTPHeaderField:nil
                    AndSuccessBack:^(id _responseData) {
                        if (_responseData && [[_responseData allKeys] containsObject:@"data"]) {
                            NSArray *tmpArr = _responseData[@"data"];
                            blockSelf.arrNotice = [AnnouncementsModel
                                                 mj_keyValuesArrayWithObjectArray:tmpArr];
                        }
                        else{
                            ZWWLog(@"加载公告请求失败！详见：%@",_responseData);
                        }
                    } AndFailureBack:^(NSString *_strError) {
                        ZWWLog(@"加载公告请求异常！详见：%@",_strError);
                    } WithisLoading:NO];
}


//MARK: - AnnouncementsViewDelegate
-(void)announcementsViewDelegateNextIndex:(NSInteger)index{
    if (self.arrNotice) {
        if ([self.arrNotice count] > index + 1) {
            [self showNoticeViewIndex:index+1
                     withButtonString:([self.arrNotice count] - 1 > index + 1)?@"下一个":@"关闭"];
            
            [self.alertView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self.alertView show];
        }
        else{
             [self.alertView close];
        }
    }
}

-(void)announcementsViewDelegateClose{
    
    [self.alertView close];
    ZWWLog(@"关闭");
}


//MARK: - 加载幻灯片广告
-(void)loadBannelADData{
    /**
     * pos：1视频列表 2视频列表顶端（最新）3视频列表顶端（最热） 4视频列表顶端（关注） 5视频播放之前 6视频播放界面关注栏目以下 7视频切换广告
     */
    NSString *strUrl = [NSString stringWithFormat:@"%@Adv",K_APP_STATIC_HOST];
    NSDictionary *dicParams = @{
                                @"pos":@"2",//目前最新和发现一样
                                @"size":@"10"
                                };
    
    [Utils getRequestForServerData:strUrl
                    withParameters:dicParams
                AndHTTPHeaderField:nil
                    AndSuccessBack:^(id _responseData) {
                        if (_responseData && [[_responseData allKeys] containsObject:@"data"]) {
                            NSArray *tmpArr = _responseData[@"data"];
                            [[NSUserDefaults standardUserDefaults] setObject: [Advertisements mj_keyValuesArrayWithObjectArray:tmpArr] forKey:K_MAIN_AD_DATA];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                        }
                        else{
                            ZWWLog(@"头部幻灯片广告请求失败！详见：%@",_responseData);
                        }
                    } AndFailureBack:^(NSString *_strError) {
                        ZWWLog(@"头部幻灯片广告请求异常！详见：%@",_strError);
                    } WithisLoading:NO];
}
-(void)sliderSwitch:(NLSliderSwitch *)sliderSwitch didSelectedIndex:(NSInteger)selectedIndex{
     [self.backScrollV scrollRectToVisible:CGRectMake(selectedIndex*K_APP_WIDTH,0, K_APP_WIDTH, 1) animated:YES];
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
@end
