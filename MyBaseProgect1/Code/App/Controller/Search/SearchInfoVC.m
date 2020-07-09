//


#import "SearchInfoVC.h"
#import "SearchListViewController.h"

#import "MySearchListViewController.h"

static NSString * const newsCellIdentifier = @"MyCollecCell";
static const CGFloat k_top_offset_h = 44;

#define column_array @[@"短视频",@"用户"]

@interface SearchInfoVC ()

//信息列表
@property(nonatomic, strong, nullable) MLMSegmentScroll *segScroll;

//头部菜单
@property(nonatomic,strong) MLMSegmentHead *segHead;

//当前选中的索引
@property(nonatomic,assign) NSInteger selectIndex;

@end

@implementation SearchInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//MARK: - initUI
- (void)initUI{
    //MARK:导航
    [self initNavgationBar:K_APP_NAVIGATION_BACKGROUND_COLOR
          AndHasBottomLine:NO
              AndHasShadow:YES
             WithHasOffset:k_top_offset_h];
    
    //MARK:返回
    [self initNavigationBack:K_APP_BLACK_BACK];
    
    //MARK:标题
    [self initViewControllerTitle:@"搜索"
                     AndFontColor:K_APP_VIEWCONTROLLER_TITLE_COLOR
                       AndHasBold:NO
                      AndFontSize:K_APP_VIEWCONTROLLER_TITLE_FONT];
    
    //MARK:头部菜单
    __weak typeof(self) weakSelf = self;
    [MLMSegmentManager associateHead:weakSelf.segHead
                          withScroll:weakSelf.segScroll
                          completion:^{
                              [weakSelf.navView addSubview:weakSelf.segHead];
                              [weakSelf.view addSubview:weakSelf.segScroll];
        
                              [weakSelf.segHead getScrollLineView].layer.cornerRadius = K_HEAD_BOTTOM_LINE_CORNER;
                              [weakSelf.segHead getScrollLineView].layer.masksToBounds = YES;
                          }];
    
    [self.view sendSubviewToBack:self.segScroll];
}


//MARK: -  lazy load
-(MLMSegmentHead *)segHead{
    if (!_segHead) {
        __weak typeof(self) weakSelf = self;
        CGFloat x = 40;
        CGFloat w = K_APP_WIDTH - 2 * x;
        CGFloat y = weakSelf.navView.frame.size.height - k_top_offset_h;
        CGRect rect = CGRectMake(x, y, w, k_top_offset_h);
        _segHead = [[MLMSegmentHead alloc] initWithFrame:rect
                                                  titles:column_array
                                               headStyle:SegmentHeadStyleLine layoutStyle:MLMSegmentLayoutDefault];
        
        _segHead.bottomLineHeight = 0;                      //底部线
        _segHead.headColor = [UIColor clearColor];          //背景色
        
        _segHead.selectColor = K_HEAD_MENU_LINE_COLOR;      //选中的颜色
        _segHead.deSelectColor = K_HEAD_MENU_DEFAULT_COLOR; //默认颜色
        
        _segHead.fontSize = K_HEAD_MENU_FONT_SIZE;          //字体大小
        _segHead.fontScale = K_HEAD_MENU_SCALE;             //缩放大小
        
        _segHead.lineColor = K_HEAD_MENU_LINE_COLOR;        //下划线颜色
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
        
        CGFloat h = K_APP_HEIGHT - K_APP_NAVIGATION_BAR_HEIGHT - k_top_offset_h;
        if ([[UIDevice currentDevice] isiPhoneX]) {
            h -= K_APP_IPHONX_BUTTOM;
        }
        _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, K_APP_NAVIGATION_BAR_HEIGHT + k_top_offset_h, K_APP_WIDTH, h)
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
    SearchListViewController *_cv;
    MySearchListViewController *VoideVC;
    NSString *strType;
    for (NSUInteger i = 0; i < count; i++) {
        strType = [NSString stringWithFormat:@"%@",[column_array objectAtIndex:i]];
        if (i == 0) {
            VoideVC = [[MySearchListViewController alloc] initWithType:strType];
            VoideVC.strKeyWord = self.keyWordStr;
            [_arr addObject:VoideVC];
        }else{
            _cv = [[SearchListViewController alloc] initWithStyle:UITableViewStylePlain];
            _cv.strType = strType;
            _cv.strKeyWord = self.keyWordStr;
            [_arr addObject:_cv];
        }
    }
    return [_arr copy];
}


@end

