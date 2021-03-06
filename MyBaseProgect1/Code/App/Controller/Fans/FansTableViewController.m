//
//  FansTableViewController.m
//  KuaiZhu
//
//  Created by apple on 2019/5/27.
//  Copyright © 2019 su. All rights reserved.
//

#import "FansTableViewController.h"
#import "MyFollowModel.h"
#import "FansModel.h"
#import "FansViewController.h"
#import "NLSliderSwitchProtocol.h"
#import "ZWUserDetialVC.h"
static CGFloat const cell_height = 90;
static NSString *const cell_identify = @"fans_table_view_cell";
#define k_img_default [UIImage imageNamed:@"我的.png"]

@interface FansTableViewController ()<UITableViewDelegate,UITableViewDataSource,NLSliderSwitchProtocol>

@property(nonatomic,strong) UIView *emptyView;

@property(nonatomic,strong) NSMutableArray *arrListData;

@end

@implementation FansTableViewController

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
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cell_identify];
    
    __weak typeof(self) weakSelf = self;
    //MARK:下拉刷新
    weakSelf.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadListData];
    }];
}


//MARK: - 空视图
-(UIView *)emptyView{
    if (!_emptyView) {
        CGFloat h = 150;
        CGFloat y = (K_APP_HEIGHT - K_APP_NAVIGATION_BAR_HEIGHT - h) * 0.5;
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
    
    NSString *strUrl = [NSString stringWithFormat:@"%@follow",K_APP_HOST];
    NSDictionary *dicParams = @{
                                @"uid":[[FansViewController shareInstance] getUserId],
                                @"id":@"0"
                                };
    if ([self.strType containsString:@"粉丝"])
        strUrl = [NSString stringWithFormat:@"%@Fans?%lld",K_APP_HOST,[Utils getCurrentLinuxTime]];
    
    __weak  typeof(self) weakSelf = self;
    __block typeof(self) blockSelf = self;
    [Utils getRequestForServerData:strUrl
                    withParameters:dicParams
                AndHTTPHeaderField:^(AFHTTPRequestSerializer * _Nullable _requestSerializer) {
                    [_requestSerializer setValue:LOGIN_COOKIE forHTTPHeaderField:LOGIN_COOKIE_KEY];
                }
                    AndSuccessBack:^(id  _Nullable _responseData) {
                        if (_responseData) {
                            if ([weakSelf.strType containsString:@"粉丝"]) {
                                FansModel *model = [FansModel mj_objectWithKeyValues:_responseData];
                                blockSelf.arrListData = [NSMutableArray arrayWithArray:model.data];
                            }
                            else{
                                MyFollowModel *model = [MyFollowModel mj_objectWithKeyValues:_responseData];
                                blockSelf.arrListData = [NSMutableArray arrayWithArray:model.data];
                            }
                        }
                        
                        [weakSelf stopAnimation];
                    }
                    AndFailureBack:^(NSString * _Nullable _strError) {
                        ZWWLog(@"加载数据异常！详见：%@",_strError);
                        [MBProgressHUD showError:_strError];
                        
                        [weakSelf stopAnimation];
                    }
                     WithisLoading:NO];
}

-(void)stopAnimation{
    [self.tableView reloadData];
    
    if (self.tableView.mj_header) {
        [self.tableView.mj_header endRefreshing];
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
    
    if (self.arrListData && [self.arrListData count] > 0) {
        [self.emptyView setHidden:YES];
        return [self.arrListData count];
    }
    
    [self.emptyView setHidden:NO];
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id cellData;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_identify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_identify];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    cell.tag = indexPath.row;
    
    //MARK:图像
    CGFloat x,y,w,h;
    NSInteger tag = 123;
    UIImageView *imgPeople = (UIImageView *)[cell viewWithTag:tag];
    if (!imgPeople) {
        x = 15;
        w = 65;
        h = 65;
        y = (cell_height - h) * 0.5;
        imgPeople = [BaseUIView  createImage:CGRectMake(x, y, w, h)
                                    AndImage:k_img_default
                          AndBackgroundColor:nil
                                WithisRadius:YES];
        imgPeople.tag = tag;
        [cell addSubview:imgPeople];
    }
    
    //MARK:用户名
    tag = 124;
    UILabel *labName = (UILabel *)[cell viewWithTag:tag];
    if (!labName) {
        x = imgPeople.frame.size.width + imgPeople.frame.origin.x + 10;
        h = 21;
        y = imgPeople.frame.origin.y;
        w = 120;
        labName = [BaseUIView createLable:CGRectMake(x, y, w, h)
                                   AndText:@""
                              AndTextColor:K_APP_TINT_COLOR
                                AndTxtFont:[UIFont systemFontOfSize:16]
                        AndBackgroundColor:nil];
        
        labName.textAlignment = NSTextAlignmentLeft;
        labName.tag = tag;
        [cell addSubview:labName];
    }
    
    //MARK:描述
    tag = 125;
    UILabel *labDescript = (UILabel *)[cell viewWithTag:tag];
    if (!labDescript) {
        CGRect rect = labName.frame;
        rect.origin.y = imgPeople.frame.origin.y + imgPeople.frame.size.height - rect.size.height;
        labDescript = [BaseUIView createLable:rect
                                   AndText:@""
                              AndTextColor:[UIColor grayColor]
                                AndTxtFont:[UIFont systemFontOfSize:13]
                        AndBackgroundColor:nil];
        
        labDescript.textAlignment = NSTextAlignmentLeft;
        labDescript.tag = tag;
        [cell addSubview:labDescript];
    }
    
    //MARK:关注
    tag = 126;
    UIButton *forceBtn = (UIButton *)[cell viewWithTag:tag];
    if (!forceBtn) {
        w = 80;
        h = 30;
        y = (cell_height - h) * 0.5;
        x = K_APP_WIDTH - w - 20;
        forceBtn = [BaseUIView createBtn:CGRectMake(x, y, w, h)
                                AndTitle:@"关注"
                           AndTitleColor:[UIColor whiteColor]
                              AndTxtFont:[UIFont systemFontOfSize:12]
                                AndImage:nil
                      AndbackgroundColor:nil
                          AndBorderColor:nil
                         AndCornerRadius:0
                            WithIsRadius:NO
                     WithBackgroundImage:[UIImage imageNamed:@"red_btn_bg.png"]
                         WithBorderWidth:0];
        
        [forceBtn setTitle:@"取消关注" forState:UIControlStateSelected];
        if ([self.strType containsString:@"粉丝"])
            [forceBtn setTitle:@"取消互粉" forState:UIControlStateSelected];
        
        forceBtn.tag = tag;
        [cell addSubview:forceBtn];
        
        [forceBtn addTarget:self action:@selector(clickForceBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    forceBtn.hidden = YES;
    //只有当前登录者自己查看自己信息时，才有操作功能，查看其他人为只读
    if ([[NSString stringWithFormat:@"%lD",(long)[UserModel shareInstance].id] isEqualToString:[[FansViewController shareInstance] getUserId]]) {
        forceBtn.hidden = NO;
    }
    
    if(self.arrListData && [self.arrListData count] > indexPath.row){
        if ([self.strType containsString:@"关注"]) {
            FollowArr *model;
            cellData = self.arrListData[indexPath.row];
            if (![cellData isKindOfClass:[FollowArr class]])
                cellData = [FollowArr mj_objectWithKeyValues:cellData];
            model = cellData;
            
            [imgPeople sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:k_img_default];
            labName.text = model.name;
            labDescript.text = [NSString stringWithFormat:@"粉丝数：%lD",(long)model.fansCount];
            forceBtn.selected = YES;
        }
        else {
            FansData *model;
            cellData = self.arrListData[indexPath.row];
            if (![cellData isKindOfClass:[FansData class]])
                cellData = [FansData mj_objectWithKeyValues:cellData];
            model = cellData;
            
            [imgPeople sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:k_img_default];
            labName.text = model.name;
            labDescript.text = [NSString stringWithFormat:@"粉丝数：%lD",(long)model.fansCount];
            
            if (model.isFollowed > 0)//已关注
                forceBtn.selected = YES;
            else
                forceBtn.selected = NO;
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cell_height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.arrListData && [self.arrListData count] > indexPath.row){
        if ([self.strType containsString:@"关注"]) {
            ZWUserDetialVC *vc = [[ZWUserDetialVC alloc] init];
            FollowArr *model = self.arrListData[indexPath.row];
            vc.userId = [NSString stringWithFormat:@"%lD",(long)model.userId];
            vc.userName = model.name;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else {
            ZWUserDetialVC *vc = [[ZWUserDetialVC alloc] init];
            FansData *model = self.arrListData[indexPath.row];
            vc.userId = [NSString stringWithFormat:@"%lD",(long)model.fansId];
            vc.userName = model.name;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}


//MARK: - 关注取、消关注
-(IBAction)clickForceBtn:(UIButton *)sender{
    
    NSInteger index = [sender superview].tag;
    if (self.arrListData && [self.arrListData count] > index) {
        
        id cellData;
        NSString *strUserId;
        FollowArr *model;
        FansData *data;
        
        if ([self.strType containsString:@"关注"]) {
            cellData = self.arrListData[index];
            if (![cellData isKindOfClass:[FollowArr class]])
                cellData = [FollowArr mj_objectWithKeyValues:cellData];
            model = cellData;
            
            strUserId = [NSString stringWithFormat:@"%ld",(long)model.userId];
        }
        else{
            cellData = self.arrListData[index];
            if (![cellData isKindOfClass:[FansData class]])
                cellData = [FansData mj_objectWithKeyValues:cellData];
            data = cellData;
            strUserId = [NSString stringWithFormat:@"%ld",(long)data.fansId];
        }
        
        __weak typeof(self) weakSelf = self;
        __block typeof(self) blockSelf = self;
        if ([Utils checkTextEmpty:strUserId]) {
            [Utils collectionUserOrNoWithId:strUserId
                                    AndFlow:!sender.selected
                                 AndLoading:YES
                             withFinishback:^(BOOL isSuccess) {
                                 if (isSuccess) {
                                     if ([weakSelf.strType containsString:@"关注"] && weakSelf.tableView.mj_header)
                                         [weakSelf.tableView.mj_header beginRefreshing];
                                     else{
                                         data.isFollowed = sender.selected?0:1;
                                         
                                         blockSelf.arrListData[index] = data;
                                         [weakSelf.tableView reloadData];
                                     }
                                 }
                             }];
        }
    }
}
-(void)viewDidScrollToVisiableArea{
    NSLog(@"当前滑动到了‘’页面");
}
@end
