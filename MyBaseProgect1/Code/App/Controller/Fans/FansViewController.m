//
//  FansViewController.m
//  KuaiZhu
//
//  Created by apple on 2019/5/27.
//  Copyright © 2019 su. All rights reserved.
//

#import "FansViewController.h"
#import "FansTableViewController.h"
#import "NLSliderSwitch.h"

static id _shareInstance = nil;
static const CGFloat k_top_offset_h = 44;
#define column_array (([UserModel shareInstance] && [UserModel shareInstance].id == _strUserId.integerValue)?@[@"我的关注",@"我的粉丝"]:@[@"TA的关注",@"TA的粉丝"])

@interface FansViewController ()<NLSliderSwitchDelegate,UIScrollViewDelegate>{
    NSString *_strUserId;
    NSString *_strTitle;
}
@property (nonatomic, strong) UIScrollView * backScrollV;
//滑条
@property (nonatomic, strong) NLSliderSwitch *sliderSwitch;

@end

@implementation FansViewController

-(instancetype)initWithUser:(NSString *)strUser AndTitle:(NSString *)strTitle{
    _strUserId = strUser;
    _strTitle = strTitle;
    
    if(self = [super init]){
        @autoreleasepool {
            [self initView];
        }
    }
    return self;
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
-(void)updateControllerWithUser:(NSString *)strUser AndTitle:(NSString *)strTitle{
    _strUserId = strUser;
    _strTitle = strTitle;
    [self loadViewIfNeeded];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navView removeFromSuperview];
    [self.labPageTitle removeFromSuperview];
    [self.btnNavigationBack removeFromSuperview];
    self.navView = nil;
    self.labPageTitle = nil;
    self.btnNavigationBack = nil;
    
    ZWWLog(@"注销了");
}


//MARK: - initView
-(void)initView{
    //MARK:导航
    [self initNavgationBar:K_APP_NAVIGATION_BACKGROUND_COLOR
          AndHasBottomLine:NO
              AndHasShadow:YES
             WithHasOffset:k_top_offset_h];
    
    //MARK:返回
    [self initNavigationBack:K_APP_BLACK_BACK];
    
    //MARK:标题
    [self initViewControllerTitle:_strTitle
                     AndFontColor:K_APP_VIEWCONTROLLER_TITLE_COLOR
                       AndHasBold:NO
                      AndFontSize:K_APP_VIEWCONTROLLER_TITLE_FONT];
   CGFloat h = K_APP_HEIGHT - K_APP_NAVIGATION_BAR_HEIGHT - k_top_offset_h;
    if ([[UIDevice currentDevice] isiPhoneX]) {
        h -= K_APP_IPHONX_BUTTOM;
    }
    self.backScrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, K_APP_NAVIGATION_BAR_HEIGHT + k_top_offset_h, K_APP_WIDTH,h)];
    self.backScrollV.pagingEnabled = YES;
    self.backScrollV.delegate = (id)self;
    self.backScrollV.showsVerticalScrollIndicator = NO;
    self.backScrollV.showsHorizontalScrollIndicator = NO;
    self.backScrollV.bounces = NO;
    self.backScrollV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backScrollV];
    self.backScrollV.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * 2, 1);//禁止竖向滚动
    NSMutableArray *viewARR = [[NSMutableArray alloc] init];
    for (int i = 0; i< column_array.count; i++) {
        NSString *strType = column_array[i];
        FansTableViewController *viewVC = [[FansTableViewController alloc] initWithStyle:UITableViewStylePlain];
        viewVC.strType = strType;
        [viewARR addObject:viewVC];
        [viewVC.view setFrame:CGRectMake(i*K_APP_WIDTH, 0, K_APP_WIDTH, self.backScrollV.frame.size.height)];
        viewVC.delegateVC = self;
        [viewVC.tableView.mj_header beginRefreshing];
        [self.backScrollV addSubview:viewVC.view];
        [self addChildViewController:viewVC];
    }
   self.sliderSwitch = [[NLSliderSwitch alloc]initWithFrame:CGRectMake(0, K_APP_NAVIGATION_BAR_HEIGHT - 5, K_APP_WIDTH , 50) buttonSize:CGSizeMake(K_APP_WIDTH*0.5, 30)];
    self.sliderSwitch.titleArray = column_array;
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
-(NSString *)getUserId{
    return _strUserId?_strUserId:@"";
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

@end
