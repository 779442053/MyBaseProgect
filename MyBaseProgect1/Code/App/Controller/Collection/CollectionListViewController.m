//
//  CollectionListViewController.m
//  KuaiZhu
//
//  Created by apple on 2019/10/5.
//  Copyright © 2019 su. All rights reserved.
//

#import "CollectionListViewController.h"
#import "ZWMoviseDetailsVC.h"
#import "WaterfallLayout.h"

#import "UserFavoritesModel.h"
#import "VideoModel.h"
#import "ZWMainVideosCell.h"
#import "VideosAdCell.h"

#import "CommontsListModel.h"
#import "PriseListModel.h"
#import "MovieDetailModel.h"


static CGFloat const cell_margin = 3;
static NSString * const newsCellIdentifier = @"ZWMainVideosCell";
static NSString * const newsAdCellIdentifier = @"VideosAdCell";

@interface CollectionListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,WaterfallLayoutDelegate>
{
    NSString *_strLayouType;
}

@property(nonatomic, strong) WaterfallLayout *wlayout;    //瀑布流Layer

@property(nonatomic, assign) BOOL hasNextPage;   //是否加载更多
@property(nonatomic, assign) NSInteger pIndex;   //页码
@property(nonatomic, assign) NSInteger  lastId;  //支持分段读取，传视频列表中的最后一个值
@property(nonatomic, assign) NSInteger  lastAid; //支持分段读取，传广告列表中的最后一个值

@property(nonatomic, strong) NSMutableArray *totalArray; //列表数据

@property (nonatomic,strong) UIView *emptyView;

@end

@implementation CollectionListViewController


- (instancetype)initWithType:(NSString *)strType{
    _strLayouType = strType;
    
    if(self = [super initWithCollectionViewLayout:self.wlayout]){
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //初始化
    [self initView];
   
    //注册
    [self registerClass];
   
    //加载
    [self loadRequestForAnimation:YES andIsRefresh:YES];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView:) name:@"loginApp" object:nil];
}
- (void)refreshTableView: (NSNotification *) notification{
    [self loadRequestForAnimation:YES andIsRefresh:YES];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
}

//注册
-(void)registerClass{
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"ZWMainVideosCell" bundle:nil] forCellWithReuseIdentifier:newsCellIdentifier];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"VideosAdCell" bundle:nil] forCellWithReuseIdentifier:newsAdCellIdentifier];
}


//MARK: - 请求数据
-(void)loadHistoryData{
    
    _totalArray = [NSMutableArray array];
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
                        if (_responseData && [[_responseData allKeys] containsObject:@"data"] &&[[_responseData allKeys] containsObject:@"advertisementSpan"]) {
                            adData = [Advertisements mj_objectArrayWithKeyValuesArray:_responseData[@"data"]];

                            interval = [_responseData[@"advertisementSpan"] integerValue];
                        }
                        
                        if (!blockSelf->_totalArray)
                            blockSelf->_totalArray = [NSMutableArray array];
                        
                        [Utils mergeData:adData
                             AndInterval:interval
                             andListData:listArr
                           withTotalData:blockSelf->_totalArray];
        
                        //[weakSelf getPicSize];
                        [self.collectionView reloadData];
                        
                        blockSelf.hasNextPage = NO;
                        [weakSelf stoploadingAnimationForMore:NO];
                    } AndFailureBack:^(NSString * _Nullable _strError) {
                        ZWWLog(@"历史记录，广告加载失败!详见：%@",_strError);
                        blockSelf.hasNextPage = NO;
                        [weakSelf stoploadingAnimationForMore:NO];
                        [weakSelf.collectionView reloadData];
                    }
                     WithisLoading:YES];
}

-(void)loadRequestForAnimation:(BOOL)animation andIsRefresh:(BOOL)refresh{
    
    if (![UserModel userIsLogin]) {
        ZWWLog(@"用户未登录");
        [self stoploadingAnimationForMore:!refresh];
        return;
    }
    
    if ([_strLayouType isEqualToString:@"历史"]) {
        [self loadHistoryData];
        return;
    }
    
    //页码
    if (!refresh) self.pIndex += 1;
    else self.pIndex = 0;
    
    self.lastId = 0;
    if ([_strLayouType isEqualToString:@"关注"]) {
        if(self.totalArray && [self.totalArray count] > 0){
            FavoritesData *model = self.totalArray.lastObject;
            if (![model isKindOfClass:[FavoritesData class]])
                model = [FavoritesData mj_objectWithKeyValues:model];
            self.lastId = model.videoId;
        }
    }
    [YJProgressHUD showLoading:@"loading..."];
    __block typeof(self) blockSelf = self;
    __weak typeof(self) weakSelf = self;
    NSString *strUrl = [self getUrlString];
    NSMutableDictionary *dicParams = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                       @"id":[NSString stringWithFormat:@"%lD",(long)weakSelf.lastId],
                                                                                       @"aid":@"0",
                                                                                       @"ve":@"0"
                                                                                       }];
    if ([_strLayouType isEqualToString:@"喜欢"]) {
        [dicParams setValue:[NSString stringWithFormat:@"%lD",(long)[UserModel shareInstance].id] forKey:@"uid"];
    }
    
    [Utils getRequestForServerData:strUrl
                    withParameters:dicParams
                AndHTTPHeaderField:^(AFHTTPRequestSerializer *_requestSerializer) {
                    [_requestSerializer setValue:LOGIN_COOKIE forHTTPHeaderField:LOGIN_COOKIE_KEY];
                }
                    AndSuccessBack:^(id _responseData) {
                        [YJProgressHUD hideHUD];
                        if(!blockSelf.totalArray) blockSelf.totalArray = [NSMutableArray array];
                        if (refresh) [blockSelf.totalArray removeAllObjects];
                        
                        //请求成功
                        if (_responseData) {
                            //MARK:关注
                            if ([self->_strLayouType isEqualToString:@"关注"]) {
                                UserFavoritesModel *model = [UserFavoritesModel mj_objectWithKeyValues:_responseData];
                                [Utils mergeData:model.advertisements
                                     AndInterval:model.advertisementSpan
                                     andListData:model.videos
                                   withTotalData:blockSelf->_totalArray];
                                [self.collectionView reloadData];
                                blockSelf.hasNextPage = [model.videos count] > 0?YES:NO;
                            }
                            //MARK:喜欢
                            else if ([self->_strLayouType isEqualToString:@"喜欢"]) {
                                PriseListModel *_priseModel = [PriseListModel mj_objectWithKeyValues:_responseData];
                                
                                [Utils mergeData:_priseModel.advertisements
                                     AndInterval:_priseModel.advertisementSpan
                                     andListData:_priseModel.videos
                                   withTotalData:blockSelf->_totalArray];
                                 [self.collectionView reloadData];
                                blockSelf.hasNextPage = [_priseModel.videos count] > 0?YES:NO;
                            }
                            //MARK:评论
                            else if([self->_strLayouType isEqualToString:@"评论"]){
                                CommontsListModel *model = [CommontsListModel mj_objectWithKeyValues:_responseData];
                                
                                [Utils mergeData:model.advertisements
                                     AndInterval:model.advertisementSpan
                                     andListData:model.data
                                   withTotalData:blockSelf->_totalArray];
                                
                                blockSelf.hasNextPage = [model.data count] > 0?YES:NO;
                            }
                            //[weakSelf getPicSize];
                            ZWWLog(@"撒互信变革")
                            //[self.collectionView reloadData];
                        }
                        else{
                            [YJProgressHUD showInfo:@"请求失败"];
                        }
                        [weakSelf stoploadingAnimationForMore:!refresh];
                    } AndFailureBack:^(NSString *_strError) {
                        ZWWLog(@"关注列表请求异常！详见：%@",_strError);
                        [YJProgressHUD showError:_strError];
                        
                        [weakSelf.collectionView reloadData];
                        [weakSelf stoploadingAnimationForMore:!refresh];
                    } WithisLoading:animation];
}

-(NSString *)getUrlString{
    //关注
    NSString *strUrl = [NSString stringWithFormat:@"%@VideoFollowed",K_APP_HOST];
    
    if ([_strLayouType isEqualToString:@"喜欢"]) {
        strUrl = [NSString stringWithFormat:@"%@ThumbsUpVideos",K_APP_HOST];
    }
    else if([_strLayouType isEqualToString:@"评论"]){
        strUrl = [NSString stringWithFormat:@"%@MyComments",K_APP_HOST];
    }
    
    return strUrl;
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
//MARK: - WaterfallLayoutDelegate
- (CGFloat)waterfallLayout:(WaterfallLayout *)waterfallLayout itemHeightForWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath{
    
    id cellData;
    CGFloat h = 165;
    CGFloat _h = 165;
    CGFloat _w = (K_APP_WIDTH - 3 * cell_margin) * 0.5;
    
    if (self.totalArray && [self.totalArray count] > indexPath.row) {
        
        Videos *videoModel;
        Advertisements *adModel;
        MovieDetailModel *DetialModel;
        cellData = [_totalArray objectAtIndex:indexPath.row];
        if ([cellData isKindOfClass:[Advertisements class]]){
            adModel = (Advertisements *)cellData;
            _w = adModel.ItemWidth;
            _h = adModel.ItemHeight;
        }else if ([cellData isKindOfClass:[MovieDetailModel class]]){
            DetialModel = (MovieDetailModel *)cellData;
            _w = DetialModel.ItemWidth;
            _h = DetialModel.ItemHeight;
        }else{
            videoModel = (Videos *)cellData;
            _w = videoModel.ItemWidth;
            _h = videoModel.ItemHeight;
        }
        
        h = _h;
    }
    
    return h > 0 ? h : 165;
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
//MARK:列
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (self.totalArray && [self.totalArray count] > 0) {
        [self.emptyView setHidden:YES];
        return [self.totalArray count];
    }
    
    [self.emptyView setHidden:NO];
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cover;
    ZWMainVideosCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:newsCellIdentifier forIndexPath:indexPath];
    if (self.totalArray && [self.totalArray count] > indexPath.row) {
        id cellData;
        Videos *videoModel;
        Advertisements *adModel;
        MovieDetailModel *DetialModel;
        //MARK:广告
        cellData = [_totalArray objectAtIndex:indexPath.row];
        if ([cellData isKindOfClass:[Advertisements class]]){
            adModel = (Advertisements *)cellData;
            VideosAdCell *adCell = [collectionView dequeueReusableCellWithReuseIdentifier:newsAdCellIdentifier forIndexPath:indexPath];
            
            cover = adModel.cover;
            if([Utils checkTextEmpty:cover]){
                if ([cover hasSuffix:@"gif"]) {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        [Utils loadGIFImage:cover AndFLAnimatedImageView:adCell.flaADImageView];
                    });
                }
                else{
                    [adCell.flaADImageView sd_setImageWithURL:[cover mj_url]
                                             placeholderImage:K_APP_DEFAULT_USER_IMAGE];
                }
            }
            else{
                [adCell.flaADImageView setImage:K_APP_DEFAULT_USER_IMAGE];
            }
            
            adCell.labTitle.text = adModel.title;
            
            return adCell;
        }else if ([cellData isKindOfClass:[MovieDetailModel class]]){
            DetialModel = (MovieDetailModel *)cellData;
            cover = [DetialModel.cover stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
            if (DetialModel.IsVerticalScreen) {
                [cell.BgImageView sd_setImageWithURL:[cover mj_url] placeholderImage:K_APP_DEFAULT_IMAGE_BIG];
            }else{
                [cell.BgImageView sd_setImageWithURL:[cover mj_url] placeholderImage:K_APP_DEFAULT_IMAGE_SMALL];
            }
            [cell.UserImageView sd_setImageWithURL:[DetialModel.userPhoto mj_url] placeholderImage:K_APP_DEFAULT_USER_IMAGE];
            [cell.UserImageView wyh_autoSetImageCornerRedius:14 ConrnerType:UIRectCornerAllCorners];
            cell.NameLB.text = DetialModel.userName;
            cell.heardLB.text = [NSString stringWithFormat:@"%ld",(long)DetialModel.favoriteCount];
            cell.DesLb.text = DetialModel.title;
        }else{
            videoModel = (Videos *)cellData;
            NSString *strUserPic;
            NSString *strUserName;
            NSString *strHeart;
            
            if ([cellData isKindOfClass:[CommontData class]]) {
                CommontData *comm = (CommontData *)videoModel;
                cover = comm.videoCover;
                cell.DesLb.text = comm.title;
                strUserName = comm.userName;
                strHeart = [NSString stringWithFormat:@"%lD",(long)comm.heartCount];
                
                cell.DesLb.text = comm.context;
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
            
            //收藏图片
            //cell.HeardImageView.image = videoModel.isHeart ? ims(@"collect2"):ims(@"videoheart");
            
            cover = [cover stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
            if (videoModel.IsVerticalScreen) {
                [cell.BgImageView sd_setImageWithURL:[cover mj_url] placeholderImage:K_APP_DEFAULT_IMAGE_BIG];
            }else{
                [cell.BgImageView sd_setImageWithURL:[cover mj_url] placeholderImage:K_APP_DEFAULT_IMAGE_SMALL];
            }
//            [cell.BgImageView sd_setImageWithURL:[cover mj_url] placeholderImage:K_APP_DEFAULT_IMAGE_SMALL];

            [cell.UserImageView sd_setImageWithURL:[strUserPic mj_url] placeholderImage:K_APP_DEFAULT_USER_IMAGE];
            [cell.UserImageView wyh_autoSetImageCornerRedius:14 ConrnerType:UIRectCornerAllCorners];
            
            cell.NameLB.text = strUserName;
            cell.heardLB.text = strHeart;
            
            return cell;
        }
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{//将这一步,放在详情界面,进行加载.没有登录.仍然可以播放.进行详细操作时候,再强制登录
    if (self.totalArray && [self.totalArray count] > indexPath.row) {
        id cellData;
        Videos *videoModel;
        Advertisements *adModel;
        //MARK:广告
        cellData = [_totalArray objectAtIndex:indexPath.row];
        if ([cellData isKindOfClass:[Advertisements class]]){
            adModel = (Advertisements *)cellData;
            NSString *strUrl = adModel.url;
            if ([[UIApplication sharedApplication] canOpenURL:[strUrl mj_url]]) {
                [[UIApplication sharedApplication] openURL:[strUrl mj_url] options:@{} completionHandler:nil];
            }
            else{
                ZWWLog(@"广告地址：%@",strUrl);
                [YJProgressHUD showInfo:@"确认地址是否正确"];
            }
        }else if ([cellData isKindOfClass:[MovieDetailModel class]]){
            NSString *strVid;
            MovieDetailModel *mm = (MovieDetailModel *)cellData;
            strVid = mm.movieid;
            //IsVerticalScreen = mm.IsVerticalScreen;
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
//                                            _movieModel.videoWidth = videoModel.width;
//                                            _movieModel.videoHeight = videoModel.height;
                                            _movieModel.IsVerticalScreen = _movieModel.IsVerticalScreen;
                                            vc.IsVerticalScreen = _movieModel.IsVerticalScreen;
                                            //添加观看历史记录
                                            [[FMDBUtils shareInstance] addHistoryMoves:_movieModel];
                                        }

                                        [[AppDelegate shareInstance].navigation pushViewController:vc animated:YES];
                                    } andisLoading:YES];



        }else{
            videoModel = (Videos *)cellData;
            BOOL IsVerticalScreen;
            NSString *strVid;
            CGFloat width;
            CGFloat height;
            if ([videoModel isKindOfClass:[PriseData class]]) {
                PriseData *pm = (PriseData *)videoModel;
                strVid = [NSString stringWithFormat:@"%lD",(long)pm.priseId];
                IsVerticalScreen = pm.IsVerticalScreen;
                width = pm.width;
                height = pm.height;
            }
            else if([videoModel isKindOfClass:[CommontData class]]){
                CommontData *cm = (CommontData *)videoModel;
                strVid = [NSString stringWithFormat:@"%lD",(long)cm.commontId];
                IsVerticalScreen = cm.IsVerticalScreen;
                width = cm.width;
                height = cm.height;
            }
            else{
                strVid = [NSString stringWithFormat:@"%lD",(long)videoModel.videoId];
                IsVerticalScreen = videoModel.IsVerticalScreen;
                width = videoModel.width;
                height = videoModel.height;
            }
            
            __weak typeof(self) weakSelf = self;
            [Utils loadMoviesDetailsDataWithVId:strVid
                                    abdCallback:^(id  _Nullable responseData, NSString * _Nullable strMsg) {
                                        
                                        ZWMoviseDetailsVC *vc = [[ZWMoviseDetailsVC alloc] init];
                                        vc.videoId = strVid.integerValue;
                                        vc.indexPath = indexPath;
                                        vc.delegate = (id<MoviesDetailsVCDelegate>)weakSelf;
                                        //vc.IsVerticalScreen = IsVerticalScreen;
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
    }
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

@end
