//
//  CollectionViewController.m
//  KuaiZhu
//
//  Created by Ghy on 2019/5/9.
//  Copyright © 2019年 su. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionListViewController.h"
#import "LoginViewController.h"
#import "MyCommentListVC.h"

//栏目
#define column_type_arr @[@"关注",@"喜欢",@"评论",@"历史"]
//栏目高度
#define type_header_height 44.0
//顶部图标高度
#define type_header_icon_height 47.0

static id _shareInstance = nil;

/**
 * 关注(收藏)
 */
@interface CollectionViewController ()<LoginViewControllerDelegate>

//头部菜单
@property(nonatomic,strong) MLMSegmentHead *segHead;
//顶部图标视图
@property(nonatomic,strong) UIView *topIconView;
//当前选中的索引
@property(nonatomic,assign) NSInteger selectIndex;

@end


@implementation CollectionViewController
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    [self initView];
    //登录判断
    __weak typeof(self) weakSelf = self;
    if (![UserModel userIsLogin]) {
        [self userToLogin:(LoginViewControllerDelegate *)weakSelf];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
//MARK: - initView
-(void)initView{
    //MARK:导航
    [self initNavgationBar:UIColor.clearColor
          AndHasBottomLine:NO
              AndHasShadow:NO
             WithHasOffset:type_header_icon_height];
    //MARK:图标视图
    [self.navView addSubview:self.topIconView];
    [self.topIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(type_header_icon_height);
        make.top.mas_equalTo(K_APP_STATUS_BAR_HEIGHT + 5);
    }];
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
    //MARK:背景
    [self setBackgroundColor];
}
//MARK: - 图标点击
-(void)btnIconClickAction:(UIButton *)sender{
    for (UIView *obj in [self.topIconView subviews]) {
        if([obj isKindOfClass:[UIButton class]]){
            UIButton *btnTemp = (UIButton *)obj;
            btnTemp.selected = sender == btnTemp ? YES:NO;
            NSInteger tag = sender.tag;
            [self.segScroll setContentOffset:CGPointMake(K_APP_WIDTH * tag, 0) animated:YES];
        }
    }
}
-(void)setBtnSelectStyle:(NSInteger)selectIndex{
    for (UIView *obj in [self.topIconView subviews]) {
        if([obj isKindOfClass:[UIButton class]]){
            UIButton *btnTemp = (UIButton *)obj;
            btnTemp.selected = selectIndex == btnTemp.tag ? YES:NO;
        }
    }
}
//MARK: - lazy load
-(UIView *)topIconView{
    if (!_topIconView) {
        _topIconView = [[UIView alloc] init];
        NSArray *arrNormal = @[@"collect_guanzhu",@"collect_xihuan",@"collect_pinglun",@"collect_lishi"];
        NSArray *arrSelect = @[@"collect_guanzhu_hover",@"collect_xihuan_hover",@"collect_pinglun_hover",@"collect_lishi_hover"];
        CGFloat x = 0;
        CGFloat w = K_APP_WIDTH/4;
        UIButton *btnIcon;
        for (NSInteger i = 0,count = arrNormal.count; i < count; i++) {
            x = i * w;
            btnIcon = [UIButton buttonWithType:UIButtonTypeCustom];
            btnIcon.frame = CGRectMake(x, 0, w, type_header_icon_height);
            [btnIcon setImage:[UIImage imageNamed:arrNormal[i]] forState:UIControlStateNormal];
            [btnIcon setImage:[UIImage imageNamed:arrSelect[i]] forState:UIControlStateSelected];
            [btnIcon addTarget:self
                        action:@selector(btnIconClickAction:)
              forControlEvents:UIControlEventTouchUpInside];
            btnIcon.selected = i == self.selectIndex ? YES:NO;
            btnIcon.tag = i;
            [_topIconView addSubview:btnIcon];
        }
    }
    return _topIconView;
}
-(MLMSegmentHead *)segHead{
    if (!_segHead) {
        CGFloat y = self.navView.frame.size.height - type_header_height;
        CGRect rect = CGRectMake(0, y, K_APP_WIDTH, type_header_height);
        _segHead = [[MLMSegmentHead alloc] initWithFrame:rect
                                                  titles:column_type_arr
                                               headStyle:SegmentHeadStyleLine layoutStyle:MLMSegmentLayoutDefault];
        _segHead.bottomLineHeight = 0;                      //底部线
        _segHead.headColor = [UIColor clearColor];          //背景色
        _segHead.selectColor = K_HEAD_MENU_SELECT_COLOR;    //选中的颜色
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
        CGFloat y = K_APP_NAVIGATION_BAR_HEIGHT + type_header_icon_height;
        CGFloat h = K_APP_HEIGHT - y - K_APP_TABBAR_HEIGHT;
        _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, y, K_APP_WIDTH, h)
                                                   vcOrViews:[self collectionViewArr:[column_type_arr count]]];
        _segScroll.loadAll = NO;
        __weak typeof(self) weakSelf = self;
        __block typeof(self) blockSelf = self;
        _segScroll.scrollEndAction = ^(NSInteger currentIndex, BOOL isLeft, BOOL isRight) {
            //UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] init];
            
            //滑动上一个大栏目
            if (currentIndex == 0 && isRight == NO) {

            }
            //滑动下一个大栏目
            else if (currentIndex == [column_type_arr count] - 1 && isLeft == NO) {
//                swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
//                [weakSelf swipeHandelAction:swipeGesture];
            }
            else{
                blockSelf.selectIndex = currentIndex;
                [weakSelf setBtnSelectStyle:currentIndex];
            }
        };
    }
    return _segScroll;
}
//添加视图
-(NSArray *)collectionViewArr:(NSUInteger)count{
    NSMutableArray *_arr = [NSMutableArray array];
    MyCommentListVC * commentVC;
    CollectionListViewController *_cv;
    for (NSUInteger i = 0; i < count; i++) {
        NSString *typeName = [NSString stringWithFormat:@"%@",[column_type_arr objectAtIndex:i]];
        if ([typeName isEqualToString:@"评论"]) {
            commentVC = [[MyCommentListVC alloc]initWithStyle:UITableViewStylePlain];
            commentVC.typeName = typeName;
            [_arr addObject:commentVC];
        }else{
            _cv = [[CollectionListViewController alloc] initWithType:typeName];
            [_arr addObject:_cv];
        }
    }
    return [_arr copy];
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
//MARK: - LoginViewControllerDelegate
-(void)loginFinishBack{
    //刷新
    if([[self childViewControllers] count] > self.selectIndex){
        if (self.selectIndex == 3) {
            MyCommentListVC *vcTemp = [self childViewControllers][self.selectIndex];
            if (vcTemp && vcTemp.tableView && vcTemp.tableView.mj_header) {
                [vcTemp.tableView.mj_header beginRefreshing];
            }
        }else{
            CollectionListViewController *vcTemp = [self childViewControllers][self.selectIndex];
            if (vcTemp && vcTemp.collectionView && vcTemp.collectionView.mj_header) {
                [vcTemp.collectionView.mj_header beginRefreshing];
            }
        }

    }
}
@end
