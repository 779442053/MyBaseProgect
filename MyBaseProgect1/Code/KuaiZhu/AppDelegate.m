//
//  AppDelegate.m
//  KuaiZhu
//
//  Created by Ghy on 2019/5/9.
//  Copyright © 2019年 su. All rights reserved.
//

// 5dd2900e0cafb2689d000eff   iphone    

#import "AppDelegate.h"
#import "LuanchADModel.h"
#import<CoreTelephony/CTCellularData.h>//ios9之后.配置网络层

#import "JSGetServerViewController.h"

#import <UMCommon/UMCommon.h>
#import <UMAnalytics/MobClick.h>
@interface AppDelegate ()<UIScrollViewDelegate,BuglyDelegate>{
    LuanchADModel *model;
}
//引导视图
@property (nonatomic,strong) UIScrollView    *guidanceScrollView;
//引导视图数量
@property (nonatomic,assign) CGFloat         guideCount;
//网络类型
@property (nonatomic,  copy) NSString        *netWorkType;

//////////////////////////////////////////////////////////////

@property (nonatomic,strong) UIView              *launchADView;
@property (nonatomic,strong) FLAnimatedImageView *launchFimg;
@property (nonatomic,strong) NSTimer             *launchADTimer;
@property (nonatomic,strong) UIButton            *btnGo;
@property (nonatomic,strong) UIButton            *GoBtn;
@property (nonatomic,assign) NSInteger           timerNo;
@property(nonatomic,copy)NSString *umkey;

@end

static id _shareInstance = nil;

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [ZWDataManager readUserData];
    
    //网络监测
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
           [self netWorkCheck];
        }
    });
    
    //设置App 主容器
    //开始获取15个 服务器地址
//    JSGetServerViewController *severVC = [[JSGetServerViewController alloc] init];
//    severVC.HasAvailableServerBlock = ^(NSString * _Nonnull urlStr, NSString * _Nonnull uploadURL ,NSString * _Nonnull Umkey) {
//        ZWWLog(@"===url\n = %@   =\n %@",urlStr,uploadURL)
//        [[NSUserDefaults standardUserDefaults]setObject:urlStr forKey:K_APP_CONFIG_KEY];
//        [[NSUserDefaults standardUserDefaults]setObject:uploadURL forKey:AppUrlUploadFile];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        [self loadLaunchADData];//加载广告数据=这时候的ip 就是可以使用的ip
//        self.umkey = Umkey;
//        self.window.rootViewController = self.navigation;
//        [self initUMeng];
//        [UMConfigure setLogEnabled:NO];//设置打开日志
//        [self showLaunchADView];//启动广告
//    };
//
//    self.window.rootViewController = severVC;
    self.window.rootViewController = self.navigation;

    
    //设置引导视图(没有则设为0，并注释下面的调用方法)
    self.guideCount = 0;
    //[self showGuideView:NO];
    
    //IQKeyboardManager 启用
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    //启动图动画
    ///[self startAnimation];
    


    
    // [S] Bugly配置
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self initBugly];
    });
    // [E]

    
    //数据库初始化
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
            BOOL isSuccess = [[FMDBUtils shareInstance] initDBAndTables];
            ZWWLog(@"数据库(表)初始：%@",isSuccess ? @"成功":@"失败");
        }
    });
    return YES;
}
-(void)initUMeng{
    [UMConfigure initWithAppkey:self.umkey channel:@"App Store"];
    [MobClick setScenarioType:E_UM_NORMAL];//支持普通场景
}
- (void)applicationWillResignActive:(UIApplication *)application {
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [ZWDataManager saveUserData];
    [[UIApplication alloc] setApplicationIconBadgeNumber:0];
}

//将要进入前台
- (void)applicationWillEnterForeground:(UIApplication *)application {

}

//已经进入前台
- (void)applicationDidBecomeActive:(UIApplication *)application {
    //加载启动广告
    [[UIApplication alloc] setApplicationIconBadgeNumber:0];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
            [self loadLaunchADData];
        }
    });
}


- (void)applicationWillTerminate:(UIApplication *)application {
    [ZWDataManager saveUserData];
    [[UIApplication alloc] setApplicationIconBadgeNumber:0];
}

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    ZWWLog(@"url:%@",url);
    [MBProgressHUD showInfo:url.absoluteString];
    
    return YES;
}
-(UIWindow *)window{
    if (!_window) {
        _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _window.backgroundColor = K_APP_VIEWCONTROLLER_BACKGROUND_COLOR;
        
        //设置系统主题色
        if (@available(iOS 7.0, *)) {
            _window.tintColor = K_APP_TINT_COLOR;
        }
        
        [_window makeKeyAndVisible];
    }
    return _window;
}

-(UINavigationController *)navigation{
    if (!_navigation) {
        //工具栏
        BaseTabBarController *tabBarController = [BaseTabBarController shareInstance];
        //导航视图
        _navigation = [[UINavigationController alloc] init];
        [_navigation pushViewController:tabBarController animated:NO];
        [_navigation.navigationBar setHidden:YES];
        [_navigation.toolbar setHidden:YES];
    }
    return _navigation;
}

//网络监测
-(void)netWorkCheck{
    
    @autoreleasepool {
        [K_APP_REACHABILITY setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusNotReachable:
                    self.netWorkType = K_APP_NO_NETWORK_INFO;
                    [[NSNotificationCenter defaultCenter] postNotificationName:K_APP_IS_NET_WORK
                                                                        object:nil
                                                                      userInfo:@{@"code":@"404",@"type":self.netWorkType}];
                    
                    [YJProgressHUD showError:K_APP_NO_NETWORK_INFO];
                    break;
                    
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    self.netWorkType = @"WIFI";
                    break;
                    
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    self.netWorkType = @"蜂窝网络";
                    break;
                    
                default:
                    self.netWorkType = @"未知网络";
                    break;
            }
            
            if (status != AFNetworkReachabilityStatusNotReachable) {
                //发送本地通知，方便后面使用
                [[NSNotificationCenter defaultCenter] postNotificationName:K_APP_IS_NET_WORK
                                                                    object:nil
                                                                  userInfo:@{@"code":@"200",@"type":self.netWorkType}];
            }
        }];
        
        [K_APP_REACHABILITY startMonitoring];
        // [E] 网络监测
    }
}

/** Bugly */
-(void)initBugly{
    
    @autoreleasepool {
        //开启Bugly配置
        BuglyConfig *config = [[BuglyConfig alloc] init];
        
        config.delegate = self;
        //SDK Debug信息
#if DEBUG
        config.debugMode = YES;
        config.consolelogEnable = YES;
#else
        config.debugMode = NO;
        config.consolelogEnable = NO;
#endif
        
        //卡顿监控开关，默认关闭
        config.blockMonitorEnable = YES;
        
        //卡顿监控判断间隔，单位为秒
        config.blockMonitorTimeout = 1.0;
        
        //非正常退出事件记录开关，默认关闭
        config.unexpectedTerminatingDetectionEnable = YES;
        
        //设置自定义日志上报的级别，默认不上报自定义日志
        config.reportLogLevel = BuglyLogLevelDebug;
        [Bugly startWithAppId:K_APP_BUGLY_APP_ID config:config];
    }
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

- (NSString * BLY_NULLABLE)attachmentForException:(NSException * BLY_NULLABLE)exception{
    NSArray *arr = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    ZWWLog(@"++++++ callStackSymbols ++++++\n%@\n++++++ reason ++++++\n%@\n++++++ name ++++++\n%@",arr, reason, name);
    
    NSString *strLog = [NSString stringWithFormat:@"callStackSymbols：%@\n reason：%@\n name：%@",exception.callStackSymbols,exception.reason,exception.name];
    return strLog;
}


////////////////////////////////////////////////////////////////////////////////
//MARK: - App 引导视图设置
////////////////////////////////////////////////////////////////////////////////
//引导视图
-(void)showGuideView:(BOOL)isVideo {
    
    //判断是否首次启动
    BOOL isNotFirst = [[NSUserDefaults standardUserDefaults] boolForKey:K_APP_START_GUIDE_VIEW_KEY];
    if (isNotFirst == YES) {
        
        //切换回来
        if (isVideo == YES) {
            self.window.rootViewController = self.navigation;
        }
        
        //无启动视频
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:K_APP_START_GUIDE_VIEW_HAS_KEY];
        
        return;
    }
    
    //有启动视频
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:K_APP_START_GUIDE_VIEW_HAS_KEY];
    
    //视频引导
    if (isVideo == true) {
        ZWWLog(@"引导视频暂未添加");
    }
    //图片引导
    else {
        //设置引导视图
        if (self.guidanceScrollView == nil) {
            self.guidanceScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, K_APP_WIDTH, K_APP_HEIGHT)];
            
            if (isVideo == YES)
                self.guidanceScrollView.contentSize = CGSizeMake(K_APP_WIDTH, K_APP_HEIGHT);
            else
                self.guidanceScrollView.contentSize = CGSizeMake(self.guideCount * K_APP_WIDTH, K_APP_HEIGHT);
            
            self.guidanceScrollView.backgroundColor = K_APP_VIEWCONTROLLER_BACKGROUND_COLOR;
            [self.guidanceScrollView setPagingEnabled:YES];
            self.guidanceScrollView.delegate = self;
            
            [self.window addSubview:self.guidanceScrollView];
            [self.window bringSubviewToFront:self.guidanceScrollView]; //至于顶层
        }
        
        //清除子视图
        [self.guidanceScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        CGFloat x = 0.0;
        NSString *strName;
        UIImageView *guideImg;
        for (NSInteger i = 1; i <= self.guideCount; i++) {
            strName = [NSString stringWithFormat:@"guide_%lD.png",(long)i];
            
            x = (i - 1) * K_APP_WIDTH;
            guideImg = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, K_APP_WIDTH, K_APP_HEIGHT)];
            guideImg.image = [UIImage imageNamed:strName];
            
            [self.guidanceScrollView addSubview:guideImg];
        }
    }
    
    //已引导,设置为 true
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:K_APP_START_GUIDE_VIEW_KEY];
}

//移除引导图
-(void)hideGuideView:(BOOL)isVideo {
    //视频引导结束
    if (isVideo == true) {
        ZWWLog(@"引导视频功能暂未添加");
    }
    //图片引导结束
    else {
        [self.guidanceScrollView setScrollEnabled:NO];
        
        [UIView animateWithDuration:1 animations:^{
            CGRect rect = self.guidanceScrollView.frame;
            rect.origin.x = -K_APP_WIDTH;
            self.guidanceScrollView.frame = rect;
        } completion:^(BOOL finished) {
            //移除
            [self.guidanceScrollView removeFromSuperview];
            self.guidanceScrollView = nil;
        }];
    }
}


//MARK: - 启动图动画
/** 启动图动画 */
-(void)startAnimation{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *strStoryboardName = [NSString stringWithFormat:@"%@",infoDictionary[@"UILaunchStoryboardName"]];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:strStoryboardName bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"LaunchScreen"];
    
    UIView *launchView = viewController.view;
    if (launchView) {
        
        [self.window addSubview:launchView];
        
        //执行动画
        [UIView animateWithDuration:0.85 animations:^{
            launchView.alpha = 0.85;
            
            //图片变大为原来的1.3倍
            launchView.transform = CGAffineTransformMakeScale(1.5, 1.5);
        } completion:^(BOOL finished) {
            //动画结束，移除imageView，呈现主界面
            [launchView removeFromSuperview];
        }];
    }
}


//MARK: - 启动广告
-(void)showLaunchADView{
    id objData = [[NSUserDefaults standardUserDefaults] objectForKey:K_APP_LAUNCH_AD_DATA];
    if(objData){
        //字典转换为模型
        model = [LuanchADModel mj_objectWithKeyValues:objData];
    }
    if (!model) return;
    [self.window addSubview:self.launchADView];
    
    UIImage *img = [UIImage imageNamed:@"launch_1242_2280.png"];
    if ([model.url hasSuffix:@"gif"]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [Utils loadGIFImage:self->model.url
         AndFLAnimatedImageView:self.launchFimg];
        });
    }
    else{
        [self.launchFimg sd_setImageWithURL:[model.url mj_url]
                           placeholderImage:img];
    }
    
    //倒计时
    [self performSelector:@selector(startCountDown) withObject:self afterDelay:1];
}

-(UIView *)launchADView{
    if (!_launchADView) {
        _launchADView = [[UIView alloc] initWithFrame:UIScreen.mainScreen.bounds];
        _launchADView.userInteractionEnabled = YES;
        
        //广告
        [_launchADView addSubview:self.launchFimg];
        
        //倒计时按钮
        [_launchADView addSubview:self.btnGo];
        //点击进入  btn
        [_launchADView addSubview:self.GoBtn];
        //点击进入详情
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showADDetailsAction:)];
        [_launchADView addGestureRecognizer:tap];
    }
    return _launchADView;
}
-(UIButton *)GoBtn{
    if (_GoBtn == nil) {
        CGFloat w = 80;
        CGFloat h = 30;
        CGFloat x = K_APP_WIDTH - w - 20;
        CGFloat y = 20 + ([[UIDevice currentDevice] isiPhoneX]?K_APP_IPHONX_TOP:20);
        _GoBtn = [BaseUIView createBtn:CGRectMake(x, y, w, h)
                              AndTitle:[NSString stringWithFormat:@"点击进入"]
                         AndTitleColor:[UIColor whiteColor]
                            AndTxtFont:[UIFont systemFontOfSize:12]
                              AndImage:nil
                    AndbackgroundColor:[[UIColor alloc] colorFromHexInt:0x000000 AndAlpha:0.65]
                        AndBorderColor:nil
                       AndCornerRadius:15
                          WithIsRadius:YES
                   WithBackgroundImage:nil
                       WithBorderWidth:0];
        [_GoBtn addTarget:self action:@selector(btnGoAction:)
         forControlEvents:UIControlEventTouchUpInside];

    }
    return _GoBtn;
}

-(UIButton *)btnGo{
    if (!_btnGo) {
        CGFloat w = 30;
        CGFloat h = 30;
        CGFloat x = K_APP_WIDTH - w - 110;
        CGFloat y = 20 + ([[UIDevice currentDevice] isiPhoneX]?K_APP_IPHONX_TOP:20);
        _btnGo = [BaseUIView createBtn:CGRectMake(x, y, w, h)
                              AndTitle:[NSString stringWithFormat:@"%lds",(long)K_LAUNCH_AD_INTERVAL]
                        AndTitleColor:[UIColor whiteColor]
                           AndTxtFont:[UIFont systemFontOfSize:12]
                             AndImage:nil
                   AndbackgroundColor:[[UIColor alloc] colorFromHexInt:0x000000 AndAlpha:0.65]
                       AndBorderColor:nil
                      AndCornerRadius:15
                         WithIsRadius:YES
                  WithBackgroundImage:nil
                       WithBorderWidth:0];
    }
    return _btnGo;
}

-(IBAction)btnGoAction:(UIButton * _Nullable)sender{
    //执行动画
    [UIView animateWithDuration:0.85 animations:^{
        self.launchADView.alpha = 0.85;
        //图片变大为原来的1.3倍
        self.launchADView.transform = CGAffineTransformMakeScale(1.5, 1.5);
    } completion:^(BOOL finished) {
        //动画结束，移除imageView，呈现主界面
        [self.btnGo removeFromSuperview];
        [self.launchFimg removeFromSuperview];
        [self.launchADView removeFromSuperview];
        self.btnGo = nil;
        self.GoBtn = nil;
        self.launchFimg= nil;
        self.launchADView = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:K_APP_BOX_SHOW_NOTICE object:nil];
    }];
}

-(FLAnimatedImageView *)launchFimg{
    if (!_launchFimg) {
        _launchFimg = [[FLAnimatedImageView alloc] initWithFrame:UIScreen.mainScreen.bounds];
        [Utils imgNoTransformation:_launchFimg];
    }
    return _launchFimg;
}
/** 加载启动广告 */
-(void)loadLaunchADData{
    NSString *strUrl = [NSString stringWithFormat:@"%@LaunchImages",K_APP_STATIC_HOST];
    NSDictionary *dicParam = @{@"p":@"0"};
    [Utils getRequestForServerData:strUrl
                    withParameters:dicParam
                AndHTTPHeaderField:nil
                    AndSuccessBack:^(id _responseData) {
                        ZWWLog(@"启动广告数据：%@",_responseData);
                        if (_responseData && [[_responseData allKeys] containsObject:@"data"]) {
                            //只取数组中的第一张广告
                            NSArray *tmpArr = _responseData[@"data"];
                            [[NSUserDefaults standardUserDefaults] setObject:tmpArr.firstObject forKey:K_APP_LAUNCH_AD_DATA];
                            
                            //广告时间
                            if ([[_responseData allKeys] containsObject:@"remainTime"]) {
                                [[NSUserDefaults standardUserDefaults] setInteger:[_responseData[@"remainTime"] integerValue] forKey:K_LAUNCH_TIME];
                            }
                        }
                        else{
                            [[NSUserDefaults standardUserDefaults] removeObjectForKey:K_APP_LAUNCH_AD_DATA];
                        }
                }
                    AndFailureBack:^(NSString *_strError) {
                        ZWWLog(@"启动页广告加载失败！详见：%@",_strError);
                    }
                     WithisLoading:NO];
}

-(void)showADDetailsAction:(id)sender{
    id objData = [[NSUserDefaults standardUserDefaults] objectForKey:K_APP_LAUNCH_AD_DATA];
    if(objData){
        //字典转换为模型
        model = [LuanchADModel mj_objectWithKeyValues:objData];
    }
    NSString *strAddress = [NSString stringWithFormat:@"%@",model.Address];
    if ([Utils checkTextEmpty:strAddress]) {
        if ([[UIApplication sharedApplication] canOpenURL:[model.Address mj_url]]) {
            [[UIApplication sharedApplication] openURL:[model.Address mj_url] options:@{} completionHandler:nil];
        }
    }
    else{
        //直接进入应用
        [self btnGoAction:nil];
        ZWWLog(@"广告地址未设置,直接进入应用");
    }
}


//MARK: - 倒计时
/** 开始倒计时 */
-(void)startCountDown{
    self.timerNo = 0;
    //按钮禁用
    //[self.btnGo setEnabled:NO];
    //开启计时
    self.launchADTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateUIInfo) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.launchADTimer forMode:NSRunLoopCommonModes];
    [self.launchADTimer fire];
}
/** 停止计时 */
-(void)stopCountDown{
    //停止
    if (self.launchADTimer != nil) {
        [self.launchADTimer invalidate];
        self.launchADTimer = nil;
    }
    //按钮启用
    self.btnGo.enabled = YES;
    [self.btnGo setTitle: @"进入" forState:UIControlStateNormal];
}

//更新UI
-(IBAction)updateUIInfo{
    self.timerNo = self.timerNo + 1;
    if (self.timerNo < K_LAUNCH_AD_INTERVAL) {
        NSString *strInfo = [NSString stringWithFormat:@"%lds",(K_LAUNCH_AD_INTERVAL - (long)self.timerNo)];
        [self.btnGo setTitle:strInfo forState:UIControlStateNormal];
    }
    else{
        //停止计时
        [self stopCountDown];
        //自动进入
        [self btnGoAction:nil];
    }
}


//MARK: - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //引导图，滑动后自动关闭,无需自动关闭请注释以下代码
    //    CGFloat offsetX = (self.guideCount - 1) * K_APP_WIDTH;
    //
    //    if (scrollView == self.guidanceScrollView && scrollView.contentOffset.x > offsetX) {
    //        [self hideGuideView:NO];
    //    }
}
-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    SDWebImageManager *mgr = [SDWebImageManager sharedManager];
    [mgr cancelAll];
    [mgr.imageCache clearWithCacheType:SDImageCacheTypeAll completion:nil];
}
@end
