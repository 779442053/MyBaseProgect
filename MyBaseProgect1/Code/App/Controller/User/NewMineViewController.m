//
//  NewMineViewController.m
//  快猪
//
//  Created by 魏冰杰 on 2019/1/11.
//  Copyright © 2019年 时磊. All rights reserved.
//

#import "NewMineViewController.h"

#import "CustomIOS7AlertView.h"//弹框
#import "MineHeaderView.h"     //表头
#import "InfosModel.h"         //用户信息模型
#import "PriseView.h"          //赞视图

#import "SettingVC.h"
#import "MineUserInfoVC.h"
#import "HelpVC.h"
#import "CollectionViewController.h"

//我的下载
#import "DownloadViewController.h"

//我的上传
#import "MyUploadViewController.h"

//我的钱包
#import "WalletViewController.h"

//粉丝、关注
#import "FansViewController.h"

static NSString * const identiferCell = @"UITableViewCell";

@interface NewMineViewController ()<UITableViewDelegate,UITableViewDataSource,MineHeaderViewDelegate>
{
    NSInteger userId;
}

@property (nonatomic, strong) InfosModel *infoModel;
@property (nonatomic,   copy) NSArray *cellTextArray;

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) MineHeaderView *headerView;
@property (nonatomic, strong) CustomIOS7AlertView *coustomAlert;
@property (nonatomic, strong) PriseView *priseView;

@end

@implementation NewMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    userId = [UserModel shareInstance]?[UserModel shareInstance].id:0;
    
    if ([UserModel userIsLogin]) {
        
        __weak typeof(self) weakSelf = self;
        __block typeof(self) blockSelf = self;
        [Utils getInfosModelForUserId:userId
                           andLoading:NO
                        andFinishback:^(InfosModel * _Nullable model) {
                            blockSelf->_infoModel = model;
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [weakSelf.headerView refreshUIWithModel:blockSelf->_infoModel];
                            });
                        }];
    }
   
    [self.tableView reloadData];
    [self.headerView refreshUIWithModel:_infoModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}


//MARK: - initView
- (void)initView {
    
    [self.view addSubview:self.tableView];
}

-(NSArray *)cellTextArray{
    if (!_cellTextArray) {
        _cellTextArray = @[
                          //@"我的钱包",
                          @"我的推广",
                          @"我的上传",
                          @"我的缓存",
                          @"帮助",
                          @"设置",
                          @"注销登录"
                          ];
    }
    return _cellTextArray;
}

-(UITableView *)tableView{
    if (!_tableView) {
        
        CGFloat h = K_APP_HEIGHT - K_APP_TABBAR_HEIGHT;
        if ([[UIDevice currentDevice] isiPhoneX]) {
            h -= K_APP_IPHONX_BUTTOM;
        }
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, K_APP_WIDTH, h)
                                                  style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
      
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableHeaderView = self.headerView;
        
        UIView *fView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, K_APP_WIDTH - 15, 0.5)];
        fView.backgroundColor = K_APP_SPLIT_LINE_COLOR;
        _tableView.tableFooterView = fView;
    }
    return _tableView;
}

-(MineHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [MineHeaderView createMineHeaderViewInit];
        _headerView.delegate = (id <MineHeaderViewDelegate>)self;
        
        if (_infoModel)
            [_headerView refreshUIWithModel:_infoModel];
    }
    
    return _headerView;
}


//MARK: - 退出登录
- (void)logOut{
    [UserModel removeUserData];
    
    //更新信息
    [self.headerView refreshUIWithModel:_infoModel];
    [self.tableView reloadData];
}


#pragma mark -- alertViewDelegate
- (void)clickOkEvent {
    [_coustomAlert close];
}


//MARK: - MineHeaderViewDelegate
- (void)jumpUserInfoVc {
    MineUserInfoVC *vc = [[MineUserInfoVC alloc] init];
    vc.userId = [NSString stringWithFormat:@"%lD",(long)userId];
    vc.userName = [UserModel shareInstance].name;
    vc.infoModel = self.infoModel;
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)clickLoginEvent{
    if (![UserModel userIsLogin]) {
        [self userToLogin:nil];
    }
    else{
        NSLog(@"已登录");
    }
}

//认证
- (void)joinCertification{
    if (![UserModel userIsLogin]) {
        [self userToLogin:nil];
        return;
    }
    
    NSLog(@"认证");
}

- (void)clickModulesBtnEventWithTag:(NSInteger)tag {
    
    if (![UserModel userIsLogin]) {
        [self userToLogin:nil];
        return;
    }

    switch (tag) {
        //MARK:作品
        case 1: {
            [self jumpUserInfoVc];
        }
            break;
        //MARK:关注
        case 2:{
            FansViewController *fansVC = [[FansViewController alloc] initWithUser:[NSString stringWithFormat:@"%ld",(long)self.infoModel.userId] AndTitle:@"关注"];
            [fansVC.segScroll setContentOffset:CGPointMake(0, 0) animated:YES];
            [self.navigationController pushViewController:fansVC animated:YES];
        }
            break;
        //MARK:粉丝
        case 3:{
            FansViewController *fansVC = [[FansViewController alloc] initWithUser:[NSString stringWithFormat:@"%ld",(long)self.infoModel.userId] AndTitle:@"粉丝"];
            [fansVC.segScroll setContentOffset:CGPointMake(K_APP_WIDTH, 0) animated:YES];
            [self.navigationController pushViewController:fansVC animated:YES];
        }
            break;
        //MARK:获赞
        case 4:{

            if (! _coustomAlert) {
                self.priseView = [PriseView createPriseViewInit];
                self.priseView.delegate = (id<PriseViewDelegate>)self;
               
                CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
                [alertView setContainerView:_priseView];
               
                _priseView.userName.text = _infoModel.name;
                _priseView.desLable.text = [NSString stringWithFormat:@"共获得%ld个赞",(long)_infoModel.heartCount];
                [alertView setButtonTitles:nil];
                [alertView setDelegate:(id<CustomIOS7AlertViewDelegate>)self];
                [alertView setUseMotionEffects:YES];
                [alertView show];
                _coustomAlert = alertView;
            } else {
                [_coustomAlert show];
            }
        }
            break;
        //MARK:我的关注
        case 10: {
            [self.tabBarController setSelectedIndex:1];
            [[CollectionViewController shareInstance].segScroll setContentOffset:CGPointMake(0, 0)
                                                                        animated:YES];
        }
            break;
        //MARK:我的喜欢
        case 20:{
            [self.tabBarController setSelectedIndex:1];
            [[CollectionViewController shareInstance].segScroll setContentOffset:CGPointMake(K_APP_WIDTH, 0) animated:YES];
        }
            break;
        //MARK:我的评论
        case 30:{
            [self.tabBarController setSelectedIndex:1];
            [[CollectionViewController shareInstance].segScroll setContentOffset:CGPointMake(2 * K_APP_WIDTH, 0) animated:YES];
        }
            break;
        //MARK:我的历史
        case 40:{
            [self.tabBarController setSelectedIndex:1];
            [[CollectionViewController shareInstance].segScroll setContentOffset:CGPointMake(3 * K_APP_WIDTH, 0) animated:YES];
        }
            break;

        default:
            break;
    }
}


//MARK: -  UITableViewDataSource、UITableViewDelegate
//MARK:组头、组尾
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

//MARK:表列
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([UserModel userIsLogin])
        return self.cellTextArray.count;
    
    //已退出登录,则没有注销登录
    return self.cellTextArray.count > 0? self.cellTextArray.count - 1:0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identiferCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identiferCell];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = FONT(15);
    }
    
    if (self.cellTextArray && [self.cellTextArray count] > indexPath.row) {
        cell.textLabel.text = self.cellTextArray[indexPath.row];
    }
    
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    if ([self.cellTextArray count] > indexPath.row) {
        NSString *strInfo = [NSString stringWithFormat:@"%@",self.cellTextArray[indexPath.row]];
        
        //MARK:我的钱包
        if([strInfo isEqualToString:@"我的钱包"]){
            if (![UserModel userIsLogin]) {
                [MBProgressHUD showInfo:@"请先登录"];
                return;
            }
            
            WalletViewController *walletVC = [[WalletViewController alloc] init];
            [self.navigationController pushViewController:walletVC animated:YES];
        }
        //MARK:我的推广
        else if([strInfo isEqualToString:@"我的推广"]){
            [self.tabBarController setSelectedIndex:2];
        }
        //MARK:我的上传
        else if([strInfo isEqualToString:@"我的上传"]){
            if (![UserModel userIsLogin]) {
                [MBProgressHUD showInfo:@"请先登录"];
                return;
            }
            
            MyUploadViewController *myuploadVC = [[MyUploadViewController alloc] init];
            [self.navigationController pushViewController:myuploadVC animated:YES];
        }
        //MARK:我的缓存
        else if([strInfo isEqualToString:@"我的缓存"]){
            if (![UserModel userIsLogin]) {
                [MBProgressHUD showInfo:@"请先登录"];
                return;
            }
            
            DownloadViewController *downloadVC = [[DownloadViewController alloc] init];
            [self.navigationController pushViewController:downloadVC animated:YES];
        }
        //MARK:帮助
        else if([strInfo isEqualToString:@"帮助"]){
            HelpVC *helpVC = [[HelpVC alloc] init];
            [self.navigationController pushViewController:helpVC animated:YES];
        }
        //MARK:注销
        else if ([strInfo isEqualToString:@"注销登录"]) {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"确认退出?"
                                                                             message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                 [self logOut];
            }];
            [alertVC addAction:cancle];
            [alertVC addAction:ok];
            
            [self presentViewController:alertVC animated:YES completion:nil];
        }
        //MARK:设置
        else if([strInfo isEqualToString:@"设置"]){
            SettingVC *VC = [[SettingVC alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
        }
    }
}


@end
