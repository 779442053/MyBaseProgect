//
//  BaseTabBarController.m
//  QuanPaiPai
//
//  Created by XianXin on 2018/12/13.
//  Copyright © 2018 XianXin. All rights reserved.
//

#import "BaseTabBarController.h"
#import "MainViewController.h"
#import "CollectionViewController.h"

#import "UserViewController.h"
#import "UpLoadViewController.h"
#import "InformationViewController.h"

@interface BaseTabBarController ()<UITabBarControllerDelegate,CAAnimationDelegate>

@property(nonatomic,strong) MainViewController *mainVC;
@property(nonatomic,strong) CollectionViewController *collectionVC;
@property(nonatomic,strong) UserViewController *userVC;
@property(nonatomic,strong) InformationViewController *mssageVC;
@property(nonatomic,strong) UIButton *btnMiddle;

@property(nonatomic,assign) CGFloat offsetTitleY;
@property(nonatomic,assign) CGFloat offsetImageY;

@end

static BaseTabBarController *_shareInstance = nil;

@implementation BaseTabBarController

-(MainViewController *)mainVC{
    if (!_mainVC) {
        _mainVC = [[MainViewController alloc] init];
    }
    return _mainVC;
}

-(CollectionViewController *)collectionVC{
    if (!_collectionVC) {
        _collectionVC = [[CollectionViewController alloc] init];
    }
    return _collectionVC;
}

-(InformationViewController *)mssageVC{
    if (!_mssageVC) {
        _mssageVC = [[InformationViewController alloc] init];
    }
    return _mssageVC;
}

-(UserViewController *)userVC{
    if (!_userVC) {
        _userVC = [[UserViewController alloc] init];
    }
    return _userVC;
}

-(UIButton *)btnMiddle{
    if (!_btnMiddle) {
        CGFloat w = 71;
        CGFloat h = 71;
        CGFloat x = (K_APP_WIDTH - w) * 0.5;
        CGFloat y = (K_APP_TABBAR_HEIGHT - 5) - h + 7;
        if ([[UIDevice currentDevice] isiPhoneX]) {
            y += -(K_APP_IPHONX_BUTTOM - 5);
        }
        CGRect rect = CGRectMake(x, y, w, h);
        
        _btnMiddle = [BaseUIView createBtn:rect
                                AndTitle:nil
                           AndTitleColor:nil
                              AndTxtFont:nil
                                AndImage:[UIImage imageNamed:@"tab_upload.png"]
                      AndbackgroundColor:UIColor.whiteColor
                          AndBorderColor:nil
                         AndCornerRadius:h * 0.5
                            WithIsRadius:YES
                     WithBackgroundImage:nil
                         WithBorderWidth:0];
        
        _btnMiddle.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _btnMiddle.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        [_btnMiddle addTarget:self
                       action:@selector(btnMiddleAction:)
             forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnMiddle;
}
+ (void)initialize {
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"#000000"];

    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = normalAttrs[NSFontAttributeName];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"#62C2FF"];
    UITabBarItem *appearance = [UITabBarItem appearance];
    [appearance setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [appearance setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    [[UITabBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#FFFFFF"]]];
    [UITabBar appearance].translucent = NO;
}

- (instancetype)init{
    if (self = [super init]) {
        [self initView];
        
        //中间(上传)
        [self.tabBar addSubview:self.btnMiddle];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 不置前点击中间按钮会导致黑屏
    [self.tabBar bringSubviewToFront:self.btnMiddle];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    //设置tabbar 高度
    //[Utils setTabbarHeight:self.tabBar];
}


//MARK: - initView
-(void)initView{
    //指定委托
    self.delegate = self;
    
    _offsetTitleY = -4;
    _offsetImageY = 1;
    if ([[UIDevice currentDevice] isiPhoneX]) {
        _offsetTitleY = 6;
        _offsetImageY = -3;
    }
    
    //首页(视频)
    [self setViewControler:[self setViewController:self.mainVC]
                  AndTitle:@"视频"
                  AndImage:@"tab_videos.png"
           WithSelectImage:@"tab_videos_hover.png"
           AndTitleOffsetX:0
             AndImgOffsetY:0];
    
    //关注(收藏)
    [self setViewControler:[self setViewController:self.collectionVC]
                  AndTitle:@"关注"
                  AndImage:@"tab_colloct.png"
           WithSelectImage:@"tab_colloct_hover.png"
           AndTitleOffsetX:-25
             AndImgOffsetY:0];
    
    //推广
    [self setViewControler:self.mssageVC
                  AndTitle:@"消息"
                  AndImage:@"tab_apps.png"
           WithSelectImage:@"tab_apps_hover.png"
           AndTitleOffsetX:25
             AndImgOffsetY:0];
    
    //我的
    [self setViewControler:self.userVC
                  AndTitle:@"我的"
                  AndImage:@"tab_mine.png"
           WithSelectImage:@"tab_mine_hover.png"
           AndTitleOffsetX:0
             AndImgOffsetY:0];
    
    //清除顶部线
    [Utils clearnTabBarTopLine:self.tabBar];
    
    //设置上阴影
    [Utils setViewShadowStyle:self.tabBar
               AndShadowColor:K_APP_VIEW_SHADOW_COLOR
             AndShadowOpacity:K_APP_VIEW_CELL_SHADOW_OPACITY
              AndShadowRadius:4.0
             WithShadowOffset:CGSizeMake(0.0, -0.8)];
    
    //背景
    self.tabBar.backgroundColor = [UIColor whiteColor];
}


/** 设置子视图 */
-(void)setViewControler:(UIViewController *)viewController AndTitle:(NSString *) _title AndImage:(NSString *)_image WithSelectImage:(NSString *)_selectImage AndTitleOffsetX:(CGFloat)_offsetX AndImgOffsetY:(CGFloat)_offsetY{
    
    viewController.title = _title;
    viewController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, _offsetTitleY);
    if (_offsetX) {
        viewController.tabBarItem.titlePositionAdjustment = UIOffsetMake(_offsetX, _offsetTitleY);
    }
    
    viewController.tabBarItem.image = [[UIImage imageNamed:_image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.selectedImage = [[UIImage imageNamed:_selectImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    viewController.tabBarItem.imageInsets = UIEdgeInsetsMake(-_offsetImageY, 0, _offsetImageY, 0);
    if (_offsetY) {
        viewController.tabBarItem.imageInsets = UIEdgeInsetsMake(_offsetImageY, 0, -_offsetImageY, 0);
    }
    
    [self addChildViewController:viewController];
}

-(UIViewController *)setViewController:(UIViewController *)vc{
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [nav.navigationBar setHidden:YES];
    [nav.toolbar setHidden:YES];
    
    return nav;
}


//MARK: - 单例
/** 控制器单例 */
+(BaseTabBarController *)shareInstance{
    
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


//MARK: - 中间上传
-(IBAction)btnMiddleAction:(UIButton *)sender{
    
    //执行动画
    [UIView animateWithDuration:0.25 animations:^{
        //变大为原来的1.3倍
        sender.transform = CGAffineTransformMakeScale(1.25, 1.25);
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.25 animations:^{
                sender.transform = CGAffineTransformMakeScale(0.75, 0.75);
            } completion:^(BOOL finished) {
                if (finished) {
                    //还原
                    [UIView animateWithDuration:0.35 animations:^{
                        sender.transform = CGAffineTransformMakeScale(1, 1);
                    } completion:^(BOOL finished) {
                        if (finished) {
                            
                            UpLoadViewController *upLoad = [[UpLoadViewController alloc] init];
                            UINavigationController *nav= [[UINavigationController alloc] initWithRootViewController:upLoad];
                            
                            [nav.navigationBar setHidden:YES];
                            [nav.toolbar setHidden:YES];
                            
                            nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
                            [self presentViewController:nav animated:YES completion:nil];
                        }
                    }];
                }
            }];
        }
    }];
}


//MARK: - UITabBarControllerDelegate
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
    //侧滑控制
    BOOL isSwipe = [[NSUserDefaults standardUserDefaults] boolForKey:K_APP_LATERAL_SPREADS];
    if (!isSwipe) return YES;
    
    NSUInteger _currentIndex = tabBarController.selectedIndex;
    NSUInteger _willToIndex = [[tabBarController childViewControllers] indexOfObject:viewController];
    
    if (_willToIndex != _currentIndex) {
        CATransition *animation = [[CATransition alloc] init];
        animation.duration = 0.2;
        
        animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionDefault];
        
        animation.type = kCATransitionMoveIn;
        animation.subtype = kCATransitionFromRight;
        if (_willToIndex < _currentIndex) {
            animation.subtype = kCATransitionFromLeft;
        }
        
        [[[tabBarController view] layer] addAnimation:animation forKey:@"reveal"];
    }
    
    return YES;
}

@end
