//
//  InformationViewController.m
//  KuaiZhu
//
//  Created by apple on 2019/10/5.
//  Copyright © 2019 su. All rights reserved.
//

#import "InformationViewController.h"
#import "MesssageType.h"
#import "LoginViewController.h"
#import "ZWMessageListVC.h"
//#import "ZWIMViewControler.h"
#import "ZWWIMViewController.h"

#import "ZWMessageViewModel.h"
static id _shareInstance = nil;

@interface InformationViewController ()<LoginViewControllerDelegate>
@property (nonatomic, strong) UIView *customNavView;
@property(nonatomic,assign) NSInteger selectIndex;
@property(nonatomic,strong) MLMSegmentHead *segHead;
@property(nonatomic,strong) UIView *topIconView;

@property (nonatomic, strong) ZWMessageViewModel *ViewModel;
@end
#define type_header_icon_height 53.0
#define column_type_arr @[@"私信",@"客服",@"关注",@"粉丝"]//栏目
#define type_header_height 44.0//栏目高度

#define Start_X          26.0f      // 第一个View的X坐标
#define Start_Y          13.0f     // 第一个View的Y坐标

static CGFloat const custom_nav_height = 110;

@implementation InformationViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];

    //登录判断
    __weak typeof(self) weakSelf = self;
    if (![UserModel userIsLogin]) {
        [self userToLogin:(LoginViewControllerDelegate *)weakSelf];
    }

    [[self.ViewModel.GetCurrentConstUserCommand execute:nil] subscribeNext:^(id  _Nullable x) {
        if ([x[@"code"] intValue] == 0) {
            ZWWLog(@"===当前客服")
        }

    }];
}


//MARK: - initView
-(void)initView{
    //MARK:背景
    [self setBackgroundColor];
    [self.view addSubview:self.customNavView];
    [self.customNavView addSubview:self.topIconView];
    [self.topIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(type_header_icon_height);
        make.top.mas_equalTo(self.customNavView);
    }];
    [MLMSegmentManager associateHead:self.segHead
                          withScroll:self.segScroll
                          completion:^{
                              [self.customNavView addSubview:self.segHead];
                              [self.view addSubview:self.segScroll];
                              [self.segHead getScrollLineView].layer.cornerRadius = K_HEAD_BOTTOM_LINE_CORNER;
                              [self.segHead getScrollLineView].layer.masksToBounds = YES;
                          }];

}
- (NSArray *)createWithViewArr:(NSUInteger)count andFrameHeight:(CGFloat)height;
{
    NSMutableArray *_arr = [NSMutableArray array];
    ZWMessageListVC *_childMessage;
    ZWWIMViewController *_childIMMessage;
    CGRect rect = CGRectMake(0, 0, K_APP_WIDTH, height);
    for (NSUInteger i = 0; i < count; i++) {
        switch (i) {
            case 0:
                _childMessage = [[ZWMessageListVC alloc] initWithFrame:rect andStyle:TableViewMessage];
                [_arr addObject:_childMessage];
                break;
            case 1:
                _childIMMessage = [[ZWWIMViewController alloc] initWithFrame:rect andStyle:TableViewkefu];
                [_arr addObject:_childIMMessage];
                break;
            case 2:
                _childMessage = [[ZWMessageListVC alloc] initWithFrame:rect andStyle:TableViewFollow];
                [_arr addObject:_childMessage];
                break;
            case 3:
                _childMessage = [[ZWMessageListVC alloc] initWithFrame:rect andStyle:TableViewFans];
                [_arr addObject:_childMessage];
                break;

            default:
                break;
        }
    }
    return [_arr copy];
}
-(UIView *)topIconView{
    if (!_topIconView) {
        _topIconView = [[UIView alloc] init];
        NSArray *arrNormal = @[@"message_icon",@"kefuzww",@"message_focus",@"message_fensi"];
        NSArray *arrSelect = @[@"message_icon",@"kefuzww",@"message_focus",@"message_fensi"];
        CGFloat x = 0;
        CGFloat w = K_APP_WIDTH/4;
        UIButton *btnIcon;
        for (NSInteger i = 0,count = arrNormal.count; i < count; i++) {
            x = i * w;
            btnIcon = [UIButton buttonWithType:UIButtonTypeCustom];
            btnIcon.frame = CGRectMake(x, Start_Y, w, type_header_icon_height);
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
#pragma mark - Getter

- (UIView *)customNavView
{
    if (!_customNavView) {
        CGRect rect = CGRectMake(0, K_APP_STATUS_BAR_HEIGHT, K_APP_WIDTH, custom_nav_height);
        _customNavView = [[UIView alloc] initWithFrame:rect];
        [_customNavView setBackgroundColor:[UIColor clearColor]];
    }
    return _customNavView;
}

-(MLMSegmentHead *)segHead{
    if (!_segHead) {
        CGFloat w = K_APP_WIDTH;
        CGFloat y = custom_nav_height - type_header_height;
        CGFloat x = 0;
        CGRect rect = CGRectMake(x, y, w, type_header_height);
        _segHead = [[MLMSegmentHead alloc] initWithFrame:rect
                                                  titles:column_type_arr
                                               headStyle:SegmentHeadStyleLine
                                             layoutStyle:MLMSegmentLayoutDefault];
        _segHead.bottomLineHeight = 0;                      //底部线
        _segHead.headColor = [UIColor clearColor];          //背景色

        _segHead.selectColor = [UIColor colorWithHexString:@"#000000"];    //选中的颜色
        _segHead.deSelectColor = K_HEAD_MENU_DEFAULT_COLOR; //默认颜色

        _segHead.fontSize = K_HEAD_MENU_FONT_SIZE;          //字体大小
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
        CGFloat h = K_APP_HEIGHT - K_APP_STATUS_BAR_HEIGHT - K_APP_TABBAR_HEIGHT - custom_nav_height ;//110
        CGRect rect = CGRectMake(0, K_APP_STATUS_BAR_HEIGHT + custom_nav_height, K_APP_WIDTH, h);

        _segScroll = [[MLMSegmentScroll alloc] initWithFrame: rect
                                                   vcOrViews:[self createWithViewArr:[column_type_arr count]
                                                                      andFrameHeight:h]];
        _segScroll.loadAll = NO;
        _segScroll.backgroundColor = [UIColor clearColor];
        __weak typeof(self) weakSelf = self;
        __block typeof(self) blockSelf = self;
        _segScroll.scrollEndAction = ^(NSInteger currentIndex, BOOL isLeft, BOOL isRight) {
            blockSelf.selectIndex = currentIndex;
            if ([[self childViewControllers] count] > blockSelf.selectIndex) {
                if (blockSelf.selectIndex != 1) {
                    [weakSelf.view endEditing:YES];
                    ZWMessageListVC *vcTemp = [weakSelf childViewControllers][weakSelf.selectIndex];
                    [vcTemp.tableView.mj_header beginRefreshing];
                }else{

                }

            }
        };
    }
    return _segScroll;
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
        switch (self.selectIndex) {
            case 0:
            {//登录之后,进行刷新操作
               ZWMessageListVC *vcTemp = [self childViewControllers][self.selectIndex];
                if (vcTemp && vcTemp.tableView && vcTemp.tableView.mj_header) {
                    [vcTemp.tableView.mj_header beginRefreshing];

                }
            }
                break;
            case 1:
            {//登录之后,进行刷新操作
                ZWWIMViewController *vcTemp = [self childViewControllers][self.selectIndex];
                if (vcTemp && vcTemp.tableView && vcTemp.tableView.mj_header) {
                    [vcTemp.tableView.mj_header beginRefreshing];
                }
            }
                break;
            case 3:
            {
                ZWMessageListVC *vcTemp = [self childViewControllers][self.selectIndex];
                if (vcTemp && vcTemp.tableView && vcTemp.tableView.mj_header) {
                    [vcTemp.tableView.mj_header beginRefreshing];

                }

            }
                break;
            case 2:
            {
                ZWMessageListVC *vcTemp = [self childViewControllers][self.selectIndex];
                if (vcTemp && vcTemp.tableView && vcTemp.tableView.mj_header) {
                    [vcTemp.tableView.mj_header beginRefreshing];

                }

            }
                break;

            default:
                break;
        }
    }
}
-(ZWMessageViewModel *)ViewModel{
    if (_ViewModel == nil) {
        _ViewModel = [[ZWMessageViewModel alloc]init];
    }
    return _ViewModel;
}
@end
