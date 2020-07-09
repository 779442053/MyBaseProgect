

#import "ZWMessageListVC.h"
#import "InformationViewCell.h"

#import "ZWMessageModel.h"
#import "FansModel.h"
#import "MyFollowModel.h"

#import "FansTableViewCell.h"

#import "MessageVC.h"
#import "ZWUserDetialVC.h"

#import "ZWMessageViewModel.h"

@interface ZWMessageListVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray< ZWMessageModel *> *OrderARR;
@property(nonatomic,strong)NSMutableArray< FansData *> *FancesARR;
@property(nonatomic,strong)NSMutableArray< FollowArr *> *FollowARR;
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, assign) ZWWMessageType type;
@property (nonatomic, strong) ZWMessageViewModel *ViewModel;
@end

@implementation ZWMessageListVC
- (instancetype)initWithFrame:(CGRect)frame andStyle:(ZWWMessageType)type{
    self = [super init];
    if (self) {
        _type = type;
        _frame = frame;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    [self setupRefresh];
}
- (void)setupRefresh{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    self.tableView.mj_header.lastUpdatedTimeKey = [NSString stringWithFormat:@"%@--%u", [self class],  self.type];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];

    // footer
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
    self.tableView.mj_footer.hidden = NO;
}

- (void)loadNewTopics{
    //请求
    @weakify(self)
    switch (self.type) {
        case TableViewMessage:
        {
            [[self.ViewModel.RefreshDataCommand3 execute:nil] subscribeNext:^(NSMutableDictionary* x) {
                @strongify(self)
                if ([x[@"code"] intValue] == 0) {
                    [self.OrderARR removeAllObjects];
                    [self.OrderARR addObjectsFromArray:x[@"res"]];
                    [self.tableView reloadData];
                }
                [self.tableView.mj_header endRefreshing];
            }completed:^{
                [self.tableView.mj_header endRefreshing];
            }];
        }
            break;
        case TableViewFollow:
        {
            [[self.ViewModel.RefreshDataCommand2 execute:nil] subscribeNext:^(NSMutableDictionary* x) {
                @strongify(self)
                if ([x[@"code"] intValue] == 0) {
                    [self.FollowARR removeAllObjects];
                    [self.FollowARR addObjectsFromArray:x[@"res"]];
                    [self.tableView reloadData];
                }
                [self.tableView.mj_header endRefreshing];

            }completed:^{
                [self.tableView.mj_header endRefreshing];
            }];

        }
            break;
        case TableViewFans:
        {
            [[self.ViewModel.RefreshDataCommand execute:nil] subscribeNext:^(NSMutableDictionary* x) {
                if ([x[@"code"] intValue] == 0) {
                    [self.FancesARR removeAllObjects];
                    [self.FancesARR addObjectsFromArray:x[@"res"]];
                    [self.tableView reloadData];
                }
                [self.tableView.mj_header endRefreshing];
            } completed:^{
                [self.tableView.mj_header endRefreshing];
            }];
        }
            break;
        case TableViewkefu:
        {
//            [[self.ViewModel.RefreshDataCommand execute:nil] subscribeNext:^(NSMutableDictionary* x) {
//                if ([x[@"code"] intValue] == 0) {
//                    [self.FancesARR removeAllObjects];
//                    [self.FancesARR addObjectsFromArray:x[@"res"]];
//                    [self.tableView reloadData];
//                }
//                [self.tableView.mj_header endRefreshing];
//            } completed:^{
//                [self.tableView.mj_header endRefreshing];
//            }];
             [self.tableView.mj_header endRefreshing];
        }
            break;

        default:
            break;
    }
}
- (void)loadMoreTopics{
    //请求
    @weakify(self)
    switch (self.type) {
        case TableViewMessage:
        {
            [[self.ViewModel.LoadMoreDataCommand3 execute:nil] subscribeNext:^(NSMutableDictionary* x) {
                @strongify(self)
                if ([x[@"code"] intValue] == 0) {
                    [self.OrderARR addObjectsFromArray:x[@"res"]];
                    [self.tableView reloadData];
                    if ([x count] == 10) {
                        [self.tableView.mj_footer endRefreshing];
                    }else{
                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    }
                }

            } completed:^{
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }];

        }
            break;
        case TableViewFollow:
        {
            [[self.ViewModel.LoadMoreDataCommand2 execute:nil] subscribeNext:^(NSMutableDictionary* x) {
                @strongify(self)
                if ([x[@"code"] intValue] == 0) {
                    [self.FollowARR addObjectsFromArray:x[@"res"]];
                    [self.tableView reloadData];
                    if ([x count] == 10) {
                        [self.tableView.mj_footer endRefreshing];
                    }else{
                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    }
                }
            }completed:^{
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }];

        }
            break;
        case TableViewFans:
        {
            [[self.ViewModel.LoadMoreDataCommand execute:nil] subscribeNext:^(NSMutableDictionary* x) {
                @strongify(self)
                if ([x[@"code"] intValue] == 0) {
                    [self.FancesARR addObjectsFromArray:x[@"res"]];
                    [self.tableView reloadData];
                    if ([x count] == 10) {
                        [self.tableView.mj_footer endRefreshing];
                    }else{
                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    }
                }
            }completed:^{
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }];
        }
            break;
        case TableViewkefu:
        {
//            [[self.ViewModel.LoadMoreDataCommand execute:nil] subscribeNext:^(NSMutableDictionary* x) {
//                @strongify(self)
//                if ([x[@"code"] intValue] == 0) {
//                    [self.FancesARR addObjectsFromArray:x[@"res"]];
//                    [self.tableView reloadData];
//                    if ([x count] == 10) {
//                        [self.tableView.mj_footer endRefreshing];
//                    }else{
//                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
//                    }
//                }
//            }completed:^{
//                [self.tableView.mj_footer endRefreshingWithNoMoreData];
//            }];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
            break;

        default:
            break;
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (self.type) {
        case TableViewMessage:
        {
            return self.OrderARR.count;
        }
            break;
        case TableViewFollow:
        {
            return self.FollowARR.count;
        }
            break;
        case TableViewFans:
        {
            return self.FancesARR.count;
        }
            break;
        case TableViewkefu:
        {
            return 0;
        }
            break;

        default:
            break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (self.type) {
        case TableViewMessage:
        {
            InformationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InformationViewCell" forIndexPath:indexPath];
            if (cell == nil) {
                cell = [[InformationViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"InformationViewCell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.Model = self.OrderARR[indexPath.row];
            return cell;
        }
            break;
        case TableViewkefu:
        {
            InformationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InformationViewCell" forIndexPath:indexPath];
            if (cell == nil) {
                cell = [[InformationViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"InformationViewCell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //cell.Model = self.OrderARR[indexPath.row];
            return cell;
        }
            break;
        case TableViewFollow:
        {
            FansTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"FansTableViewCell" forIndexPath:indexPath];
            if (cell == nil) {
                cell = [[FansTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FansTableViewCell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.FollowModel = self.FollowARR[indexPath.row];
            cell.Subject = [RACSubject subject];
            [cell.Subject subscribeNext:^(id  _Nullable x) {
                if ([x[@"code"] intValue] == 0) {
                    FollowArr *Model = x[@"Model"];
                    MessageVC *meesageVC = [[MessageVC alloc]init];
                    meesageVC.userId = [NSString stringWithFormat:@"%ld",(long)Model.followid];
                    [self.navigationController pushViewController:meesageVC animated:YES];
                }else if ([x[@"code"] intValue] == 1){
                    FollowArr *Model = x[@"Model"];
                    [[self.ViewModel.FollowCommand execute:@{@"code":@"1",@"Model":Model}] subscribeNext:^(NSMutableDictionary * x) {
                        if ([x[@"code"] intValue] == 0) {
                             @weakify(self)
                            [[self.ViewModel.RefreshDataCommand2 execute:nil] subscribeNext:^(NSMutableDictionary* x) {
                                @strongify(self)
                                if ([x[@"code"] intValue] == 0) {
                                    [self.FollowARR removeAllObjects];
                                    [self.FollowARR addObjectsFromArray:x[@"res"]];
                                    [self.tableView reloadData];
                                }
                                [self.tableView.mj_header endRefreshing];
                            }completed:^{
                                [self.tableView.mj_header endRefreshing];
                            }];

                        }
                    }];

                }
            }];
            return cell;
        }
            break;
        case TableViewFans:
        {
            FansTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"FansTableViewCell" forIndexPath:indexPath];
            if (cell == nil) {
                cell = [[FansTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FansTableViewCell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.FansModel = self.FancesARR[indexPath.row];
            cell.Subject = [RACSubject subject];
            [cell.Subject subscribeNext:^(id  _Nullable x) {
                if ([x[@"code"] intValue] == 0) {
                    FansData *Model = x[@"Model"];
                    MessageVC *meesageVC = [[MessageVC alloc]init];
                    meesageVC.userId = [NSString stringWithFormat:@"%ld",(long)Model.fansId];
                    [self.navigationController pushViewController:meesageVC animated:YES];
                }else if ([x[@"code"] intValue] == 1){
                    FansData *Model = x[@"Model"];
                    [[self.ViewModel.FollowCommand execute:@{@"code":@"0",@"Model":Model}] subscribeNext:^(NSMutableDictionary * x) {
                        if ([x[@"code"] intValue] == 0) {
                            @weakify(self)
                            [[self.ViewModel.RefreshDataCommand execute:nil] subscribeNext:^(NSMutableDictionary* x) {
                                @strongify(self)
                                if ([x[@"code"] intValue] == 0) {
                                    [self.FancesARR removeAllObjects];
                                    [self.FancesARR addObjectsFromArray:x[@"res"]];
                                    [self.tableView reloadData];
                                }
                                [self.tableView.mj_header endRefreshing];

                            }completed:^{
                                [self.tableView.mj_header endRefreshing];
                            }];

                        }else if ([x[@"code"] intValue] == 0){
                            @weakify(self)
                            [[self.ViewModel.LoadMoreDataCommand execute:nil] subscribeNext:^(NSMutableDictionary* x) {
                                @strongify(self)
                                if ([x[@"code"] intValue] == 0) {
                                    [self.FancesARR addObjectsFromArray:x[@"res"]];
                                    [self.tableView reloadData];
                                    if ([x count] == 10) {
                                        [self.tableView.mj_footer endRefreshing];
                                    }else{
                                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                                    }
                                }
                            }completed:^{
                                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                            }];
                        }
                    }];
                }
            }];
            return cell;
        }
            break;

        default:
            break;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (self.type) {
        case TableViewkefu:
        {
            ZWWLog(@"消息点击")


        }
            break;
        case TableViewMessage:
        {
            ZWMessageModel *Model = self.OrderARR[indexPath.row];
            if ([Model.name isEqualToString:@"admin"]) {
                return;
            }
            MessageVC *meesageVC = [[MessageVC alloc]init];
            meesageVC.userId = [NSString stringWithFormat:@"%ld",(long)Model.userID];
            [self.navigationController pushViewController:meesageVC animated:YES];
        }
            break;
        case TableViewFollow:
        {
            ZWWLog(@"关注点击")
            ZWUserDetialVC *vc = [[ZWUserDetialVC alloc] init];
            FollowArr *model = self.FollowARR[indexPath.row];
            vc.userId = [NSString stringWithFormat:@"%lD",(long)model.userId];
            vc.userName = model.name;
            [self.navigationController pushViewController:vc animated:YES];

        }
            break;
        case TableViewFans:
        {
            ZWWLog(@"粉丝点击")//
            ZWUserDetialVC *vc = [[ZWUserDetialVC alloc] init];
            FansData *model = self.FancesARR[indexPath.row];
            vc.userId = [NSString stringWithFormat:@"%lD",(long)model.fansId];
            vc.userName = model.name;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;

        default:
            break;
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (self.type) {
        case TableViewkefu:
        {
            return 90.0f;
        }
            break;
        case TableViewMessage:
        {
            return 90.0f;
        }
            break;
        case TableViewFollow:
        {
            return 101;
        }
            break;
        case TableViewFans:
        {
            return 101;
        }
            break;

        default:
            break;
    }
}
-(NSMutableArray<ZWMessageModel *> *)OrderARR{
    if (_OrderARR == nil) {
        _OrderARR = [[NSMutableArray alloc]init];
    }
    return _OrderARR;
}
-(NSMutableArray<FansData *> *)FancesARR{
    if (_FancesARR == nil) {
        _FancesARR = [[NSMutableArray alloc]init];
    }
    return _FancesARR;
}
-(NSMutableArray<FollowArr *> *)FollowARR{
    if (_FollowARR == nil) {
        _FollowARR = [[NSMutableArray alloc]init];
    }
    return _FollowARR;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.frame
                                                  style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.mj_header.ignoredScrollViewContentInsetTop =20;
        [_tableView registerClass:InformationViewCell.class forCellReuseIdentifier:@"InformationViewCell"];
        [_tableView registerClass:FansTableViewCell.class forCellReuseIdentifier:@"FansTableViewCell"];
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollIndicatorInsets = self.tableView.contentInset;
    }
    return _tableView;
}
-(ZWMessageViewModel *)ViewModel{
    if (_ViewModel == nil) {
        _ViewModel = [[ZWMessageViewModel alloc]init];
    }
    return _ViewModel;
}
@end
