//
//  SearchListViewController.m
//  KuaiZhu
//
//  Created by apple on 2019/6/5.
//  Copyright © 2019 su. All rights reserved.
//

#import "SearchListViewController.h"
#import "SearchModel.h"
#import "FansModel.h"
#import "SearchUserCell.h"

#import "ZWUserDetialVC.h"
static CGFloat const cell_user_height = 101;

@interface SearchListViewController ()

@property(nonatomic,strong) UIView *emptyView;

@property(nonatomic,strong) NSMutableArray *arrListData;

@end

@implementation SearchListViewController

-(instancetype)initWithStyle:(UITableViewStyle)style{
    if (self = [super initWithStyle:style]) {
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    //加载数据
    [self loadListData];
}
//MARK: - initView
-(void)initView{
    //MARK:tableView
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView addSubview:self.emptyView];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = K_APP_SPLIT_LINE_COLOR;
    //注册
    [self registerClass];
    __weak typeof(self) weakSelf = self;
    //MARK:下拉刷新
    weakSelf.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadListData];
    }];
}
-(void)registerClass{
  [self.tableView registerClass:SearchUserCell.class forCellReuseIdentifier:@"SearchUserCell"];
}
//MARK: - 空视图
-(UIView *)emptyView{
    if (!_emptyView) {
        CGFloat h = 150;
        CGFloat y = (K_APP_HEIGHT - h) * 0.5 - K_APP_NAVIGATION_BAR_HEIGHT - 44;
        CGFloat w = 100;
        CGFloat x = (K_APP_WIDTH - w) * 0.5;
        _emptyView = [[UIView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        
        //MARK:图片
        w = 85;
        h = 103;
        x = (_emptyView.frame.size.width - w) * 0.5;
        CGRect rect = CGRectMake(x, 0, w, h);
        UIImageView *imgBg = [BaseUIView createImage:rect
                                            AndImage:[UIImage imageNamed:@"search_empty_img.png"] AndBackgroundColor:nil WithisRadius:NO];
        [_emptyView addSubview:imgBg];
        
        //MARK:标题
        h = 21;
        w = _emptyView.frame.size.width;
        x = 0;
        y = _emptyView.frame.size.height - h - 20;
        UILabel *labInfo = [BaseUIView createLable:CGRectMake(x, y, w, h)
                                           AndText:@"暂无数据显示"
                                      AndTextColor:K_APP_TINT_COLOR
                                        AndTxtFont:[UIFont systemFontOfSize:16]
                                AndBackgroundColor:nil];
        labInfo.textAlignment = NSTextAlignmentCenter;
        [_emptyView addSubview:labInfo];
        
        //默认隐藏
        [_emptyView setHidden:YES];
    }
    return _emptyView;
}
//MARK: - loadListData
-(void)loadListData{
    NSString *strUrl = [NSString stringWithFormat:@"%@SearchVideos",K_APP_HOST];
    NSDictionary *dicParmas = @{
                                @"id":@"0",
                                @"key" : self.strKeyWord,
                                @"short":@"1"
                                };
    if ([self.strType isEqualToString:@"用户"]) {
        strUrl = [NSString stringWithFormat:@"%@Users",K_APP_HOST];
        dicParmas = @{
                      @"id":@"0",
                      @"key" : self.strKeyWord,
                      };
    }
    __weak typeof(self) weakSelf = self;
    __block typeof(self) blockSelf = self;
    [Utils getRequestForServerData:strUrl
                    withParameters:dicParmas
                AndHTTPHeaderField:nil
                    AndSuccessBack:^(id _responseData) {
                        if (_responseData) {
                            if ([self.strType isEqualToString:@"用户"]) {
                                FansModel *model = [FansModel mj_objectWithKeyValues:_responseData];
                                blockSelf.arrListData = [NSMutableArray arrayWithArray:model.data];
                            }
                            else{
                                SearchModel *model = [SearchModel mj_objectWithKeyValues:_responseData];
                                blockSelf.arrListData = [NSMutableArray arrayWithArray:model.videos];
                            }
                        }
                        [weakSelf stoploadingAnimation];
                    } AndFailureBack:^(NSString *_strError) {
                        ZWWLog(@"视频搜索异常！详见：%@",_strError);
                        [MBProgressHUD showError:_strError];
                        [weakSelf stoploadingAnimation];
                    } WithisLoading:YES];

}

-(void)stoploadingAnimation{
    [self.tableView reloadData];
    if (self.tableView.mj_header) {
        [self.tableView.mj_header endRefreshing];
    }
}
//MARK: - 关注取、消关注
-(IBAction)clickForceBtn:(UIButton *)sender{
    NSInteger index = [sender superview].tag;
    if (self.arrListData && [self.arrListData count] > index) {
        FansData *data;
        NSString *strUserId;
        if ([self.strType containsString:@"用户"]) {
            data = self.arrListData[index];
            if (![data isKindOfClass:[FansData class]])
                data = [FansData mj_objectWithKeyValues:data];

            strUserId = [NSString stringWithFormat:@"%ld",(long)data.fansId];
            
            __weak typeof(self) weakSelf = self;
            __block typeof(self) blockSelf = self;
            if ([Utils checkTextEmpty:strUserId]) {
                [Utils collectionUserOrNoWithId:strUserId
                                        AndFlow:!sender.selected
                                     AndLoading:YES
                                 withFinishback:^(BOOL isSuccess) {
                                     if (isSuccess) {
                                         data.isFollowed = sender.selected?0:1;
                                         data.followid = sender.selected?0:[UserModel shareInstance].id;
                                         
                                         blockSelf.arrListData[index] = data;
                                         [weakSelf.tableView reloadData];
                                     }
                                 }];
            }
        }
        else{
            ZWWLog(@"异常操作");
            [YJProgressHUD showError:@"异常操作"];
        }
    }
}


//MARK: - 用户图像点击
-(void)userPhotosAction:(UITapGestureRecognizer *)sender{
    NSInteger index = [sender.view.superview tag];
    if (!self.arrListData || [self.arrListData count] <= index || ![self.strType isEqualToString:@"用户"]) {
        [YJProgressHUD showInfo:@"用户信息不存在"];
        return;
    }
    FansData *data = self.arrListData[index];
    if (![data isKindOfClass:[FansData class]])
        data = [FansData mj_objectWithKeyValues:data];
    
    ZWUserDetialVC *vc = [[ZWUserDetialVC alloc] init];
    vc.userId = [NSString stringWithFormat:@"%lD",(long)data.fansId];
    vc.userName = data.name;
    __weak typeof(self) weakSelf = self;
    [Utils getInfosModelForUserId:data.fansId
                       andLoading:YES
                    andFinishback:^(InfosModel * _Nullable model) {
                        vc.infoModel = model;
                        
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                    }];
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
    if (self.arrListData && [self.arrListData count] > 0) {
        [self.emptyView setHidden:YES];
        return [self.arrListData count];
    }
    [self.emptyView setHidden:NO];
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchUserCell*cell = [tableView dequeueReusableCellWithIdentifier:@"SearchUserCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[SearchUserCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchUserCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tag = indexPath.row;
    if (self.arrListData && [self.arrListData count] > indexPath.row) {
        FansData* cellData = self.arrListData[indexPath.row];
        cell.FansModel = cellData;
        cell.Subject = [RACSubject subject];
        [cell.Subject subscribeNext:^(id  _Nullable x) {
             if ([x[@"code"] intValue] == 1){
                FansData *Model = x[@"Model"];
                NSString * strUserId = [NSString stringWithFormat:@"%ld",(long)Model.fansId];
                 BOOL isFollowed = Model.isFollowed > 0?YES:NO;
                 __block typeof(self) blockSelf = self;
                 __weak typeof(self) weakSelf = self;
                 if ([Utils checkTextEmpty:strUserId]) {
                     [Utils collectionUserOrNoWithId:strUserId
                                             AndFlow:!isFollowed
                                          AndLoading:YES
                                      withFinishback:^(BOOL isSuccess) {
                                          if (isSuccess) {
                                              Model.isFollowed = isFollowed?0:1;
                                              Model.followid = isFollowed?0:[UserModel shareInstance].id;
                                              blockSelf.arrListData[indexPath.row] = Model;
                                              [weakSelf.tableView reloadData];
                                          }
                                      }];
                 }
            }
        }];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.arrListData && [self.arrListData count] > indexPath.row) {
        id cellData = self.arrListData[indexPath.row];
        if ([cellData isKindOfClass:[FansData class]])
            return cell_user_height;
    }
    
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.arrListData && [self.arrListData count] > indexPath.row) {
        FansData * cellData = self.arrListData[indexPath.row];
        ZWUserDetialVC *vc = [[ZWUserDetialVC alloc] init];
        vc.userId = [NSString stringWithFormat:@"%lD",(long)cellData.fansId];
        vc.userName = cellData.name;
        [self.navigationController pushViewController:vc animated:YES];
    }
}




@end
