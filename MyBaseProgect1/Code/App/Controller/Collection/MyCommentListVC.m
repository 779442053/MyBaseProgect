

#import "MyCommentListVC.h"
#import "UserFavoritesModel.h"
#import "PriseListModel.h"
#import "CommontsListModel.h"
#import "CommonViewCell.h"
#import "MovieDetailModel.h"
#import "ZWMoviseDetailsVC.h"

#import "ZWUserDetialVC.h"
#import "InfosModel.h"
static NSString * const ad_cell_identify = @"ad_cell_identify";
@interface MyCommentListVC ()<UITableViewDelegate,UITableViewDataSource,MoviesDetailsVCDelegate>
@property(nonatomic, assign) BOOL hasNextPage;   //是否加载更多
@property(nonatomic, assign) NSInteger pIndex;   //页码
@property(nonatomic, assign) NSInteger  lastId;  //支持分段读取，传视频列表中的最后一个值
@property(nonatomic, assign) NSInteger  lastAid; //支持分段读取，传广告列表中的最后一个值

@property(nonatomic, strong) NSMutableArray *totalArr; //列表数据
@property (nonatomic,strong) UIView *emptyView;
@end

@implementation MyCommentListVC
-(instancetype)initWithStyle:(UITableViewStyle)style{
    if (self = [super initWithStyle:style]) {
        self.tableView.tableFooterView = [UIView new];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    [self initView];

    //注册
    [self registerClass];

    // Do any additional setup after loading the view.
    [self loadRequestForAnimation:YES andIsRefresh:YES];

}
//MARK: - initView
-(void)initView{
    self.pIndex = 0;       //默认第一页
    self.lastId = 0;
    self.lastAid = 0;
    self.hasNextPage = NO;

    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = K_APP_SPLIT_LINE_COLOR;

    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView addSubview:self.emptyView];

    self.view.backgroundColor = K_APP_VIEWCONTROLLER_BACKGROUND_COLOR;

    __weak typeof(self) weakSelf = self;
    //MARK:下拉刷新
    weakSelf.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadRequestForAnimation:YES andIsRefresh:YES];
    }];
}
//注册
-(void)registerClass{
    [self.tableView registerNib:[UINib nibWithNibName:@"CommonViewCell" bundle:nil] forCellReuseIdentifier:[CommonViewCell cellIdentify]];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ad_cell_identify];
}
//MARK: - 空视图
-(UIView *)emptyView{
    if (!_emptyView) {
        CGFloat h = 150;
        CGFloat y = (K_APP_HEIGHT - K_APP_TABBAR_HEIGHT - K_APP_NAVIGATION_BAR_HEIGHT - h) * 0.5;
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
//MARK: - 请求数据
-(void)loadHistoryData{

    _totalArr = [NSMutableArray array];
    NSArray *arrData = [[FMDBUtils shareInstance] getAllValuesFromTable:K_FMDB_MOVIES_HISTORY_INFO
                                                               AndWhere:nil
                                                            WithOrderBy:@"ORDER BY mid DESC"];
    NSArray *listArr = [MovieDetailModel mj_objectArrayWithKeyValuesArray:arrData];

    NSString *strUrl = [NSString stringWithFormat:@"%@VideoListAdvs",K_APP_HOST];
    NSDictionary *dicParam = @{
                               @"size":listArr?[NSString stringWithFormat:@"%lu",(unsigned long)[listArr count]]:@"0"};

    __weak typeof(self) weakSelf = self;
    __block typeof(self) blockSelf = self;

    [Utils getRequestForServerData:strUrl
                    withParameters:dicParam
                AndHTTPHeaderField:nil
                    AndSuccessBack:^(id  _Nullable _responseData) {
                        NSInteger interval = 0;
                        NSArray *adData;

                        if (_responseData && [[_responseData allKeys] containsObject:@"data"]) {
                            adData = [Advertisements mj_objectArrayWithKeyValuesArray:_responseData[@"data"]];

                            interval = [_responseData[@"advertisementSpan"] integerValue];
                        }

                        if (!blockSelf->_totalArr)
                            blockSelf->_totalArr = [NSMutableArray array];

                        [Utils mergeData:adData
                             AndInterval:interval
                             andListData:listArr
                           withTotalData:blockSelf->_totalArr];

                        blockSelf.hasNextPage = NO;
                        [weakSelf stoploadingAnimationForMore:NO];

                        [weakSelf.tableView reloadData];
                    } AndFailureBack:^(NSString * _Nullable _strError) {
                        NSLog(@"历史记录，广告加载失败!详见：%@",_strError);

                        blockSelf.hasNextPage = NO;
                        [weakSelf stoploadingAnimationForMore:NO];

                        [weakSelf.tableView reloadData];
                    }
                     WithisLoading:YES];
}

-(void)loadRequestForAnimation:(BOOL)animation andIsRefresh:(BOOL)refresh{
    if (![UserModel userIsLogin]) {
        NSLog(@"用户未登录");
        [self stoploadingAnimationForMore:!refresh];
        return;
    }

    //[self loadHistoryData];

    if (!refresh) self.pIndex += 1;
    else self.pIndex = 0;
    self.lastId = 0;
    NSString * strUrl = [NSString stringWithFormat:@"%@MyComments",K_APP_HOST];
    __block typeof(self) blockSelf = self;
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dicParams = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                       @"id":[NSString stringWithFormat:@"%lD",(long)weakSelf.lastId],
                                                                                       @"aid":@"0",
                                                                                       @"ve":@"0"
                                                                                       }];
    [Utils getRequestForServerData:strUrl
                    withParameters:dicParams
                AndHTTPHeaderField:^(AFHTTPRequestSerializer *_requestSerializer) {
                    [_requestSerializer setValue:LOGIN_COOKIE forHTTPHeaderField:LOGIN_COOKIE_KEY];
                }
                    AndSuccessBack:^(id _responseData) {
                        if(!blockSelf.totalArr) blockSelf.totalArr = [NSMutableArray array];
                        if (refresh) [blockSelf.totalArr removeAllObjects];
                        //请求成功
                        if (_responseData) {
                            ZWWLog(@"评论=%@",_responseData)
                            CommontsListModel *model = [CommontsListModel mj_objectWithKeyValues:_responseData];
                            [self.totalArr removeAllObjects];
                            self.totalArr = [NSMutableArray arrayWithArray:model.data];
                            ZWWLog(@"评论=====\n%@",_responseData[@"data"])

//                            [Utils mergeData:model.advertisements
//                                 AndInterval:model.advertisementSpan
//                                 andListData:model.data
//                               withTotalData:blockSelf->_totalArr];
                            blockSelf.hasNextPage = [model.data count] > 0?YES:NO;
                        }
                        else{
                            [YJProgressHUD showInfo:@"请求失败"];
                        }
                        [weakSelf.tableView reloadData];
                        [weakSelf stoploadingAnimationForMore:!refresh];
                    } AndFailureBack:^(NSString *_strError) {
                        NSLog(@"关注列表请求异常！详见：%@",_strError);
                        [YJProgressHUD showError:_strError];
                        [weakSelf stoploadingAnimationForMore:!refresh];
                    } WithisLoading:animation];
}
- (void)stoploadingAnimationForMore:(BOOL)loadMore{
    dispatch_async(dispatch_get_main_queue(), ^{
        //结束刷新
        if(loadMore) {
            if (!self.hasNextPage) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            else{
                [self.tableView.mj_footer endRefreshing];
                [self.tableView.mj_footer resetNoMoreData];
            }
        }
        else{
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer resetNoMoreData];

            if (!self.hasNextPage) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    });
}
-(void)userPhotosAction:(UITapGestureRecognizer *)sender{
    id cellData;
    NSInteger index = [sender.view tag];
    ZWUserDetialVC *vc = [[ZWUserDetialVC alloc] init];
    if (self.totalArr && [self.totalArr count] > index) {
        CommontData *data;
        cellData = self.totalArr[index];

        if (![cellData isKindOfClass:[PriseData class]])
            data = [CommontData mj_objectWithKeyValues:cellData];
        else
            data = cellData;

        vc.userId = [NSString stringWithFormat:@"%lD",(long)data.userID];
        vc.userName = data.userName;

        [self getUserInfo:vc.userId withViewController:vc];
        return;
    }
}
//获取当前用户信息
- (void)getUserInfo:(NSString *)strUserId withViewController:(ZWUserDetialVC *)mineVC {

    if (![Utils checkTextEmpty:strUserId]) {
        [YJProgressHUD showInfo:@"用户信息不存在"];
        return;
    }

    [Utils getInfosModelForUserId:strUserId.integerValue
                       andLoading:YES
                    andFinishback:^(InfosModel * _Nullable model) {
                        mineVC.infoModel = model;

                        [[AppDelegate shareInstance].navigation pushViewController:mineVC animated:YES];
                    }];
}
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
    if (self.totalArr && [self.totalArr count] > 0) {
        [self.emptyView setHidden:YES];
        return [self.totalArr count];
    }
    [self.emptyView setHidden:NO];
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.totalArr && [self.totalArr count] > indexPath.row){
         CommontData *data = self.totalArr[indexPath.row];
        return data.cellHeight;
    }
    return K_APP_HEIGHT/667*343;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.totalArr && [self.totalArr count] > indexPath.row){
        NSString *strVid;
        id cellData = self.totalArr[indexPath.row];
        if([self.typeName isEqualToString:@"评论"] && [cellData isKindOfClass:[CommontData class]]){
            CommontData *data = cellData;
            strVid = [NSString stringWithFormat:@"%lD",(long)data.commontId];
            __weak typeof(self) weakSelf = self;
            [Utils loadMoviesDetailsDataWithVId:strVid
                                    abdCallback:^(id  _Nullable responseData, NSString * _Nullable strMsg) {
                                        ZWMoviseDetailsVC *vc = [[ZWMoviseDetailsVC alloc] init];
                                        vc.videoId = strVid.integerValue;
                                        vc.indexPath = indexPath;
                                        vc.delegate = (id<MoviesDetailsVCDelegate>)weakSelf;
                                        if (responseData && [MovieDetailModel mj_objectWithKeyValues:responseData]) {
                                            MovieDetailModel *_movieModel = [MovieDetailModel mj_objectWithKeyValues:responseData];
                                            vc.movieModel = _movieModel;
                                            vc.movieUrl = _movieModel.url;
                                            vc.IsVerticalScreen = _movieModel.IsVerticalScreen;
                                            //添加观看历史记录
                                            [[FMDBUtils shareInstance] addHistoryMoves:_movieModel];
                                        }
                                        [[AppDelegate shareInstance].navigation pushViewController:vc animated:YES];
                                    } andisLoading:YES];
        }
    }else{
        [YJProgressHUD showInfo:@"视频编号有误"];
    }
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    id cellData;
    CommonViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[CommonViewCell cellIdentify]];
    if (!cell) cell = [CommonViewCell xibWithTableView];

    //MARK:用户图像点击事件
    cell.userPhoto.tag = indexPath.row;
    cell.userPhoto.userInteractionEnabled = YES;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userPhotosAction:)];
    [cell.userPhoto addGestureRecognizer:tap];
    if (self.totalArr && [self.totalArr count] > indexPath.row){
        cellData = self.totalArr[indexPath.row];
        CommontData *data = cellData;

        NSString *cover = data.videoCover;
        cover = [cover stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
        
        [cell.bgImage sd_setImageWithURL:[cover mj_url] placeholderImage:K_APP_DEFAULT_IMAGE_BIG];
        [Utils imgNoTransformation:cell.bgImage];

        NSString *UserImageUrl = data.photo;
        UserImageUrl = [UserImageUrl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
        [cell.userPhoto sd_setImageWithURL:[UserImageUrl mj_url] placeholderImage:K_APP_DEFAULT_USER_IMAGE];
        [cell.userPhoto wyh_autoSetImageCornerRedius:cell.userPhoto.width/2 ConrnerType:UIRectCornerAllCorners];
        cell.commenLB.text = data.context;
        //下面 需要字符串分割
        NSString *desTitleStr = [NSString stringWithFormat:@"@%@  %@",data.videoUserName,data.title];
        cell.desLable.attributedText = [self changeLabelWithText:desTitleStr];
        cell.timeLale.text = data.sendTime;
        cell.userName.text= data.userName;
        cell.ScanLB.text = [NSString stringWithFormat:@"%ld阅读",(long)data.videoViewCount];

        //[cell.browseCount setTitle:[NSString stringWithFormat:@"%lD",(long)data.videoViewCount] forState:UIControlStateNormal];//浏览
        //[cell.commontCount setTitle:[NSString stringWithFormat:@"%lD",(long)data.commentCount] forState:UIControlStateNormal];//评论
        //[cell.favoriteCount setTitle:[NSString stringWithFormat:@"%lD",(long)data.heartCount] forState:UIControlStateNormal];
    }
    return cell;
}
-(NSMutableAttributedString *)changeLabelWithText:(NSString*)needText
{
    NSRange range = [needText rangeOfString:@" "];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:needText];
    UIFont *font = [UIFont systemFontOfSize:13];
    [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,range.location)];
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#66B1FE"] range:NSMakeRange(0,range.location)];
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#202020"] range:NSMakeRange(range.location,needText.length-range.location)];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(range.location,needText.length-range.location)];
    //ZWWLog(@"==========%@",attrString)
    return attrString;
}
-(void)moviesDetailsCommentsUpdateActionForValue:(NSInteger)_cvalue AndIndexPath:(NSIndexPath *)_indexPath{

    if (self.totalArr && [self.totalArr count] > _indexPath.row) {
        [self updateCellInfo:self.totalArr[_indexPath.row]
                AndIndexPath:_indexPath
                    AndValue:_cvalue
                AndIsComment:YES];
    }

}
-(void)moviesDetailsHeartUpdateActionForValue:(NSInteger)_cvalue AndIndexPath:(NSIndexPath *)_indexPath{
    if (self.totalArr && [self.totalArr count] > _indexPath.row) {
        [self updateCellInfo:self.totalArr[_indexPath.row]
                AndIndexPath:_indexPath
                    AndValue:_cvalue
                AndIsComment:NO];
    }
}
-(void)updateCellInfo:(id)cellData AndIndexPath:(NSIndexPath *)_indexPath AndValue:(NSInteger)value AndIsComment:(BOOL)isC{
    MovieDetailModel *model = cellData;
    if (isC) model.commentCount = value;
    else model.heartCount = value;
    [self.tableView reloadData];
}
@end
