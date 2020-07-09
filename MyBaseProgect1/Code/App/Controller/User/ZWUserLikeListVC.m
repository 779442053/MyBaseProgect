

#import "ZWUserLikeListVC.h"
#import "WaterfallLayout.h"

#import "ZWVideosModel.h"
#import "PriseListModel.h"
#import "UserVideosModel.h"

#import "MovieDetailModel.h"

#import "ZWMoviseDetailsVC.h"

#import "ZWMainVideosCell.h"

#import "MyCollecCell.h"//我的作品

static CGFloat const cell_margin = 3;
static NSString * const newsCellIdentifier = @"MyCollecCell";
static NSString * const newsAdCellIdentifier = @"ZWMainVideosCell";
@interface ZWUserLikeListVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,WaterfallLayoutDelegate>
{
    NSString *_strLayouType;
}

@property(nonatomic, strong) WaterfallLayout *wlayout;
@property(nonatomic, assign) BOOL hasNextPage;   //是否加载更多
@property(nonatomic, assign) NSInteger pIndex;   //页码
@property(nonatomic, assign) NSInteger  lastId;  //支持分段读取，传视频列表中的最后一个值
@property(nonatomic, assign) NSInteger  lastAid; //支持分段读取，传广告列表中的最后一个值

@property(nonatomic, strong) NSMutableArray *totalArray; //列表数据
@property(nonatomic, strong) NSMutableArray *LikeArray;

@property (nonatomic,strong) UIView *emptyView;
@end

@implementation ZWUserLikeListVC
- (instancetype)initWithType:(NSString *)strType{
    _strLayouType = strType;
    if(self = [super initWithCollectionViewLayout:self.wlayout]){

    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ZWMainVideosCell" bundle:nil] forCellWithReuseIdentifier:newsAdCellIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"MyCollecCell" bundle:nil] forCellWithReuseIdentifier:newsCellIdentifier];
    [self initView];
    [self loadRequestForAnimation:YES andIsRefresh:YES];
}
//MARK: - initView
-(void)initView{
    self.pIndex = 0;       //默认第一页
    self.lastId = 0;
    self.lastAid = 0;
    self.hasNextPage = NO;

    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView addSubview:self.emptyView];
    self.view.backgroundColor = [UIColor clearColor];

    __weak typeof(self) weakSelf = self;
    //MARK:下拉刷新
    weakSelf.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadRequestForAnimation:YES andIsRefresh:YES];
    }];

    //MARK:上拉加载更多
    weakSelf.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadRequestForAnimation:YES andIsRefresh:NO];
    }];
    [weakSelf.collectionView.mj_header beginRefreshing];
}
-(void)loadRequestForAnimation:(BOOL)animation andIsRefresh:(BOOL)refresh{
    //页码
    /*
     获取关注用户发布的视频列表  VideoFollowed
     id：当前页码 0 第一页|
     aid：广告数据编号，支持分段读取，传广告列表中的最后一个值|
     ve：距离最后一次显示广告，又显示了多少个视频|

     获取某用户点赞的视频列表    ThumbsUpVideos
     ThumbsUpVideos?id=0&uid=145&aid=0&ve=0
     id  视频数据编号，支持分段读取，传视频列表中的最后一个值
     uid 用户ID
     aid  广告数据编号，支持分段读取，传广告列表中的最后一个值
     ve  距离最后一次显示广告，又显示了多少个视频

     */
    if (!refresh) self.pIndex += 1;
    else self.pIndex = 0;
    self.lastId = 0;
    __block typeof(self) blockSelf = self;
    __weak typeof(self) weakSelf = self;
    NSString *strUrl = [self getUrlString];
    NSMutableDictionary *dicParams = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                       @"id":[NSString stringWithFormat:@"%lD",(long)weakSelf.lastId],
                                                                                       @"aid":@"0",
                                                                 @"ve":@"0"
                                                                                       }];
    if ([_strLayouType isEqualToString:@"喜欢"]) {
        ZWWLog(@"请求我的喜欢作品")
        [dicParams setValue:[NSString stringWithFormat:@"%@",self.userId] forKey:@"uid"];
    }
    ZWWLog(@"请求我的作品地址=%@ 参数=%@",strUrl,dicParams)
    [Utils getRequestForServerData:strUrl
                    withParameters:dicParams
                AndHTTPHeaderField:^(AFHTTPRequestSerializer *_requestSerializer) {
                    [_requestSerializer setValue:LOGIN_COOKIE forHTTPHeaderField:LOGIN_COOKIE_KEY];
                }
                    AndSuccessBack:^(id _responseData) {
                        if(!blockSelf.totalArray) blockSelf.totalArray = [NSMutableArray array];
                        if (refresh) [blockSelf.totalArray removeAllObjects];
                        //请求成功
                        if (_responseData) {
                          
                            if ([self->_strLayouType isEqualToString:@"作品"]) {
                                ZWVideosModel *model = [ZWVideosModel mj_objectWithKeyValues:_responseData];
                                blockSelf.totalArray = [NSMutableArray arrayWithArray:model.videos];
                                blockSelf.hasNextPage = [model.videos count] > 0?YES:NO;
                            }
                            //MARK:喜欢
                            else if ([self->_strLayouType isEqualToString:@"喜欢"]) {

                                PriseListModel *_priseModel = [PriseListModel mj_objectWithKeyValues:_responseData];
                                blockSelf.LikeArray = [NSMutableArray arrayWithArray:_priseModel.videos];
                                blockSelf.hasNextPage = [_priseModel.videos count] > 0?YES:NO;
                            }
                            //[weakSelf getPicSize];
                            [self.collectionView reloadData];
                        }
                        else{
                            [YJProgressHUD showError:@"请求失败"];
                        }
                        [weakSelf stoploadingAnimationForMore:!refresh];
                    } AndFailureBack:^(NSString *_strError) {
                        ZWWLog(@"关注列表请求异常！详见：%@",_strError);
                        [YJProgressHUD showError:_strError];
                        [weakSelf.collectionView reloadData];
                        [weakSelf stoploadingAnimationForMore:!refresh];
                    } WithisLoading:animation];
}
- (void)stoploadingAnimationForMore:(BOOL)loadMore{
    dispatch_async(dispatch_get_main_queue(), ^{
        //结束刷新
        if(loadMore) {
            if (!self.hasNextPage) {
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            }
            else{
                [self.collectionView.mj_footer endRefreshing];
                [self.collectionView.mj_footer resetNoMoreData];
            }
        }
        else{
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer resetNoMoreData];
            if (!self.hasNextPage) {
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    });
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *strVid;
    id cellData;
    //MARK:喜欢
    if ([_strLayouType isEqualToString:@"喜欢"]){
        if (self.LikeArray) {
            PriseData *data;
            cellData = self.LikeArray[indexPath.row];
            if (![cellData isKindOfClass:[PriseData class]])
                data = [PriseData mj_objectWithKeyValues:cellData];
            else
                data = cellData;
            strVid = [NSString stringWithFormat:@"%ld",(long)data.priseId];
        }
    }
    //MARK:作品
    else{
        if (self.totalArray) {
            VideosData *model;
            cellData = self.totalArray[indexPath.row];
            if (![cellData isKindOfClass:[VideosData class]])
                model = [VideosData mj_objectWithKeyValues:cellData];
            else model = cellData;
            strVid = [NSString stringWithFormat:@"%lD",(long)model.videoId];
        }
    }
    if (strVid && ![strVid isEqualToString:@""] && ![strVid isEqualToString:@"0"]) {
        __weak typeof(self) weakSelf = self;
        [Utils loadMoviesDetailsDataWithVId:strVid
                                abdCallback:^(id  _Nullable responseData, NSString * _Nullable strMsg) {
                                    ZWMoviseDetailsVC *vc = [[ZWMoviseDetailsVC alloc] init];
                                    vc.videoId = strVid.integerValue;
                                    if (responseData && [MovieDetailModel mj_objectWithKeyValues:responseData]) {
                                        MovieDetailModel *_movieModel = [MovieDetailModel mj_objectWithKeyValues:responseData];
                                        vc.movieModel = _movieModel;
                                        vc.movieUrl = _movieModel.url;
                                        vc.IsVerticalScreen = _movieModel.IsVerticalScreen;
                                        //添加观看历史记录
                                        [[FMDBUtils shareInstance] addHistoryMoves:_movieModel];
                                    }
                                    [weakSelf.navigationController pushViewController:vc animated:YES];
                                } andisLoading:YES];
    }
    else{
        [YJProgressHUD showInfo:@"视频编号有误"];
    }
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([_strLayouType isEqualToString:@"作品"]) {
        NSString *cover;
        MyCollecCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:newsCellIdentifier forIndexPath:indexPath];
        if (self.totalArray) {
            id cellData;
            ZWVideos *videoModel;
            cellData = [_totalArray objectAtIndex:indexPath.row];
            videoModel = (ZWVideos *)cellData;
            if ([cellData isKindOfClass:[ZWVideos class]]) {
                ZWVideos *comm = (ZWVideos *)videoModel;
                cover = comm.cover;
                cell.videoTitle.text = comm.title;
            }
            else{
                cover = videoModel.cover;
                cell.videoTitle.text = videoModel.title;
            }
            cover = [cover stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
            [cell.bgImageView sd_setImageWithURL:[cover mj_url] placeholderImage:K_APP_DEFAULT_IMAGE_SMALL];
            return cell;
        }
        return cell;
    }else{//喜欢
        NSString *cover;
        ZWMainVideosCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:newsAdCellIdentifier forIndexPath:indexPath];
        if (self.LikeArray) {
            id cellData;
            PriseData *videoModel;
            cellData = [_LikeArray objectAtIndex:indexPath.row];
            videoModel = (PriseData *)cellData;
            NSString *strUserPic;
            NSString *strUserName;
            NSString *strHeart;
            if ([cellData isKindOfClass:[ZWVideos class]]) {
                PriseData *comm = (PriseData *)videoModel;
                cover = comm.cover;
                cell.DesLb.text = comm.title;
                strUserName = comm.userName;
                strHeart = [NSString stringWithFormat:@"%lD",(long)comm.heartCount];
                [cell.DesLb alignTop];
            }
            else{
                cell.DesLb.text = @"";
                cover = videoModel.cover;
                cell.DesLb.text = videoModel.title;
                strUserPic = videoModel.userPhoto;
                strUserName = videoModel.userName;
                strHeart = [NSString stringWithFormat:@"%lD",(long)videoModel.heartCount];
            }
            cover = [cover stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
            [cell.BgImageView sd_setImageWithURL:[cover mj_url] placeholderImage:K_APP_DEFAULT_IMAGE_SMALL];
            //[cell.BgImageView wyh_autoSetImageCornerRedius:13 ConrnerType:UIRectCornerAllCorners];
            [cell.UserImageView sd_setImageWithURL:[strUserPic mj_url] placeholderImage:K_APP_DEFAULT_USER_IMAGE];
            [cell.UserImageView wyh_autoSetImageCornerRedius:14 ConrnerType:UIRectCornerAllCorners];
                cell.NameLB.text = strUserName;
                cell.heardLB.text = strHeart;
            return cell;
        }
        return cell;
    }

}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([_strLayouType isEqualToString:@"作品"]) {
        if (self.totalArray && [self.totalArray count] > 0) {
            [self.emptyView setHidden:YES];
            return self.totalArray.count;
        }
        [self.emptyView setHidden:NO];
        return 0;
    }else{
        if (self.LikeArray && [self.LikeArray count] > 0) {
            [self.emptyView setHidden:YES];
            return self.LikeArray.count;
        }
        [self.emptyView setHidden:NO];
        return 0;
    }

}
-(NSString *)getUrlString{
    NSString * strUrl;
    if ([_strLayouType isEqualToString:@"喜欢"]) {
        strUrl = [NSString stringWithFormat:@"%@ThumbsUpVideos",K_APP_HOST];
    }
    else if([_strLayouType isEqualToString:@"作品"]){
        strUrl = [NSString stringWithFormat:@"%@VideoFollowed",K_APP_HOST];
    }
    return strUrl;
}
//MARK: - 数据处理
-(void)getPicSize{
    [YJProgressHUD showLoading:@"正在计算高度..."];
    if ([_strLayouType isEqualToString:@"喜欢"]){
        if (_LikeArray && [_LikeArray count] > 0) {
            __block id cellData;
            __block NSString *strUrl;
            __block typeof(self) blockSelf = self;
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            dispatch_group_t group = dispatch_group_create();
            dispatch_queue_t queue = dispatch_queue_create("dispatchGroupMethod.queue", DISPATCH_QUEUE_CONCURRENT);
            dispatch_group_async(group, queue, ^{
                dispatch_async(queue, ^{
                    for (NSUInteger i = 0,count = [blockSelf.LikeArray count]; i < count; i++) {
                        PriseData *videoModel;
                        cellData = [blockSelf.LikeArray objectAtIndex:i];
                        videoModel = (PriseData *)cellData;
                        strUrl = videoModel.cover;
                        if ([cellData isKindOfClass:[PriseData class]]) {
                            strUrl = ((PriseData *)videoModel).cover;
                        }
                        //已存在
                        if (videoModel.width > 0 && videoModel.height > 0) continue;
                        [manager loadImageWithURL:[strUrl mj_url]
                                          options:0
                                         progress:nil
                                        completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                                            if (!error && image) {
                                                videoModel.width = image.size.width;
                                                videoModel.height = image.size.height;
                                            }
                                        }];
                    }
                });
            });
            [YJProgressHUD hideHUD];
            dispatch_group_notify(group, queue, ^{
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    [self.collectionView reloadData];
                });
            });
        }

    }else{
        if (_totalArray && [_totalArray count] > 0) {
            __block id cellData;
            __block NSString *strUrl;
            __block typeof(self) blockSelf = self;
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            dispatch_group_t group = dispatch_group_create();
            dispatch_queue_t queue = dispatch_queue_create("dispatchGroupMethod.queue", DISPATCH_QUEUE_CONCURRENT);
            dispatch_group_async(group, queue, ^{
                dispatch_async(queue, ^{
                    for (NSUInteger i = 0,count = [blockSelf.totalArray count]; i < count; i++) {
                        ZWVideos *videoModel;
                        cellData = [blockSelf.totalArray objectAtIndex:i];
                        videoModel = (ZWVideos *)cellData;
                        strUrl = videoModel.cover;
                        if ([cellData isKindOfClass:[ZWVideos class]]) {
                            strUrl = ((ZWVideos *)videoModel).cover;
                        }
                        //已存在
                        if (videoModel.width > 0 && videoModel.height > 0) continue;
                        [manager loadImageWithURL:[strUrl mj_url]
                                          options:0
                                         progress:nil
                                        completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                                            if (!error && image) {
                                                videoModel.width = image.size.width;
                                                videoModel.height = image.size.height;
                                            }
                                        }];
                    }
                });
            });
            [YJProgressHUD hideHUD];
            dispatch_group_notify(group, queue, ^{
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    [self.collectionView reloadData];
                });
            });
        }

    }

}
- (CGFloat)waterfallLayout:(WaterfallLayout *)waterfallLayout itemHeightForWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath{
    id cellData;
    //CGFloat h = 165;
    CGFloat _h = 165;
    CGFloat _w = (K_APP_WIDTH - 3 * cell_margin) * 0.5;
    if ([_strLayouType isEqualToString:@"喜欢"]) {
        if (self.LikeArray && [self.LikeArray count] > indexPath.row) {
            PriseData *videoModel;
            cellData = [_LikeArray objectAtIndex:indexPath.row];
            videoModel = (PriseData *)cellData;
            _w = videoModel.ItemWidth;
            _h = videoModel.ItemHeight;
            //h = _h * (K_APP_WIDTH - 3 * cell_margin) * 0.5 / _w;
        }
        return _h;
    }else{
        if (self.totalArray && [self.totalArray count] > indexPath.row) {
            ZWVideos *videoModel;
            cellData = [_totalArray objectAtIndex:indexPath.row];
            videoModel = (ZWVideos *)cellData;
            _w = videoModel.ItemWidth;
            _h = videoModel.ItemHeight;
            //h = _h * (K_APP_WIDTH - 3 * cell_margin) * 0.5 / _w;
        }
        return _h;

    }

}
-(UIView *)emptyView{
    if (!_emptyView) {
        CGFloat h = 150;
        CGFloat y = (K_APP_HEIGHT - K_APP_TABBAR_HEIGHT - K_APP_NAVIGATION_BAR_HEIGHT - h - 170) * 0.5;
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
//MARK: - lazy load
-(WaterfallLayout *)wlayout{
    if (!_wlayout) {
        _wlayout = [WaterfallLayout waterFallLayoutWithColumnCount:2];
        _wlayout.headerReferenceSize = CGSizeZero;
        [_wlayout setColumnSpacing:cell_margin
                        rowSpacing:cell_margin
                      sectionInset:UIEdgeInsetsMake(0, cell_margin, cell_margin, cell_margin)];
        _wlayout.delegate = self;
    }
    return _wlayout;
}
//MARK: - UICollectionViewDelegate、UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//MARK:头尾视图
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeZero;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeZero;
}
-(NSMutableArray *)LikeArray{
    if (_LikeArray == nil) {
        _LikeArray = [[NSMutableArray alloc]init];
    }
    return _LikeArray;
}
@end
