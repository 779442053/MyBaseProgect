//
//  MyUserCollectionVC.m
//  KuaiZhu
//
//  Created by step_zhang on 2019/11/21.
//  Copyright © 2019 su. All rights reserved.
//

#import "MyUserCollectionVC.h"
#import "MyUserCollectionListVC.h"
#import "ZWUserHistoryListVC.h"
#import "NLSliderSwitch.h"
static const CGFloat k_top_offset_h = 44;
@interface MyUserCollectionVC ()<NLSliderSwitchDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView * backScrollV;
//滑条
@property (nonatomic, strong) NLSliderSwitch *sliderSwitch;
@end

@implementation MyUserCollectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self initView];
}
//MARK: - initView
-(void)initView{
    //MARK:导航
    [self initNavgationBar:[UIColor clearColor]
          AndHasBottomLine:NO
              AndHasShadow:YES
             WithHasOffset:k_top_offset_h];
    //MARK:返回
    [self initNavigationBack:K_APP_BLACK_BACK];
    //MARK:标题
       [self initViewControllerTitle:@""
                        AndFontColor:K_APP_VIEWCONTROLLER_TITLE_COLOR
                          AndHasBold:NO
                         AndFontSize:K_APP_VIEWCONTROLLER_TITLE_FONT];
    NSArray *titarr = @[@"关注",@"喜欢",@"评论",@"历史"];
    self.backScrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, K_APP_NAVIGATION_BAR_HEIGHT, K_APP_WIDTH,K_APP_HEIGHT - K_APP_NAVIGATION_BAR_HEIGHT - K_APP_STATUS_BAR_HEIGHT)];
    self.backScrollV.pagingEnabled = YES;
    self.backScrollV.delegate = (id)self;
    self.backScrollV.showsVerticalScrollIndicator = NO;
    self.backScrollV.showsHorizontalScrollIndicator = NO;
    self.backScrollV.bounces = NO;
    self.backScrollV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backScrollV];
    self.backScrollV.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * 4, 1);//禁止竖向滚动
    NSMutableArray *viewARR = [[NSMutableArray alloc] init];
    for (int i = 0; i< titarr.count; i++) {
        NSString *type = titarr[i];
        if (i == 2) {
            ZWUserHistoryListVC *viewVC = [[ZWUserHistoryListVC alloc]initWithStyle:UITableViewStylePlain];
            viewVC.typeName = type;
            [viewARR addObject:viewVC];
            [viewVC.view setFrame:CGRectMake(i*K_APP_WIDTH, 0, K_APP_WIDTH, self.backScrollV.frame.size.height)];
            viewVC.delegateVC = self;
            [viewVC.tableView.mj_header beginRefreshing];
            [self.backScrollV addSubview:viewVC.view];
            [self addChildViewController:viewVC];
        }else{
            MyUserCollectionListVC *viewVC = [[MyUserCollectionListVC alloc]initWithType:type];
            [viewARR addObject:viewVC];
            [viewVC.view setFrame:CGRectMake(i*K_APP_WIDTH, 0, K_APP_WIDTH, self.backScrollV.frame.size.height)];
            viewVC.delegateVC = self;
            [viewVC.collectionView.mj_header beginRefreshing];
            [self.backScrollV addSubview:viewVC.view];
            [self addChildViewController:viewVC];
        }
        
    }
    self.sliderSwitch = [[NLSliderSwitch alloc]initWithFrame:CGRectMake(50, K_APP_STATUS_BAR_HEIGHT - 5, K_APP_WIDTH - 100, 50) buttonSize:CGSizeMake((K_APP_WIDTH - 100)*0.25, 30)];
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
    //MARK:背景
    [self setBackgroundColor];
    
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

@end
