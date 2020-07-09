

#import "MyBillsViewController.h"
#import "ZWMyBillsHeaderView.h"
#import "ZWMyBillsCell.h"
@interface MyBillsViewController ()<UITableViewDelegate,UITableViewDataSource>
/** 表格*/
@property (nonatomic, strong) UITableView *tableView;

/** 数据*/
@property (nonatomic, strong) NSMutableArray *dataSource;


@end
static NSString * const k_tableview_myBillsCell_identifier = @"tableview_myBillsCell_identifier";
static NSString * const k_tableview_headerCell_identifier = @"tableview_headerCell_identifier";
@implementation MyBillsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initNavgationBar:K_APP_NAVIGATION_BACKGROUND_COLOR AndHasBottomLine:YES AndHasShadow:YES WithHasOffset:0];
    [self initNavigationBack:K_APP_BLACK_BACK];
    [self initViewControllerTitle:@"账单"
                     AndFontColor:K_APP_VIEWCONTROLLER_TITLE_COLOR
                       AndHasBold:NO
                      AndFontSize:K_APP_VIEWCONTROLLER_TITLE_FONT];

    
    //2.添加表格
    [self.view addSubview:self.tableView];

    __typeof(self) weakSelf = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //2.1等待刷新请求数据
        [weakSelf loadData];
    }];

    //3.开始刷新
    [_tableView.mj_header beginRefreshing];
}

/// 加载数据
- (void)loadData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@MyBills",K_APP_HOST];
    NSDictionary *param = @{
                            @"id":@"1",
                            };
   __weak typeof(self) weakSelf = self;
    [Utils getRequestForServerData:urlStr withParameters:param AndHTTPHeaderField:^(AFHTTPRequestSerializer * _Nullable _requestSerializer) {
        [_requestSerializer setValue:LOGIN_COOKIE forHTTPHeaderField:LOGIN_COOKIE_KEY];
    } AndSuccessBack:^(id  _Nullable _responseData) {
        [YJProgressHUD showSuccess:@"获取成功"];
        ZWWLog(@"%@",_responseData)
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
        });
        if (_responseData && kRequestOK([_responseData[K_APP_REQUEST_CODE] integerValue])) {
            if ([_responseData[@"data"] count]) {
                ZWMyBillsModel *model = [ZWMyBillsModel mj_objectWithKeyValues:_responseData];
                weakSelf.dataSource = model.data.mutableCopy;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }

    } AndFailureBack:^(NSString * _Nullable _strError) {
        [YJProgressHUD showError:@"系统错误,请稍后再来"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
        });
    } WithisLoading:YES];


}
#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataSource.count > section) {
        MyBillsData *billData = self.dataSource[section];
        return billData.infoList.count;
    }
    return 0;
}

//Income：收入
//Expenditure：支出
//Type：交易类型 0红包 1充值 2 提现 3 （红包）收藏奖励 4 （红包）点赞奖励 5 （红包）上传视频奖励

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZWMyBillsCell *cell = [tableView dequeueReusableCellWithIdentifier:k_tableview_myBillsCell_identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataSource.count > indexPath.section) {
        MyBillsData *billData = self.dataSource[indexPath.section];
        if (billData.infoList.count > indexPath.row) {
            cell.data = billData.infoList[indexPath.row];
        }
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 55.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ZWMyBillsHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:k_tableview_headerCell_identifier];
    MyBillsData *data = self.dataSource[section];
    if (data) {
        header.data = data;
    }
    return header;
}

#pragma mark - Getter

- (UITableView *)tableView
{
    if (!_tableView) {
        CGRect frame = CGRectMake(0, K_APP_NAVIGATION_BAR_HEIGHT, K_APP_WIDTH, K_APP_HEIGHT - K_APP_NAVIGATION_BAR_HEIGHT);
        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];

        _tableView.delegate = (id <UITableViewDelegate>)self;
        _tableView.dataSource = (id <UITableViewDataSource>)self;

        _tableView.backgroundColor = [UIColor colorWithHexString:@"#F3F3F3"];
        _tableView.tableFooterView = [UIView new];

        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;


        [_tableView registerClass:[ZWMyBillsCell class] forCellReuseIdentifier:k_tableview_myBillsCell_identifier];
        [_tableView registerClass:[ZWMyBillsHeaderView class] forHeaderFooterViewReuseIdentifier:k_tableview_headerCell_identifier];

        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }

    }
    return _tableView;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

@end
