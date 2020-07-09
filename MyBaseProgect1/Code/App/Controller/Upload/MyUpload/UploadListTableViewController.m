//
//  UploadListTableViewController.m
//  KuaiZhu
//
//  Created by apple on 2019/5/21.
//  Copyright © 2019 su. All rights reserved.
//

#import "UploadListTableViewController.h"
#import "WaterfallLayout.h"
#import "UploadVideosCollectionCell.h"//我的作品
#import "UploadModel.h"
#import "ZWMoviseDetailsVC.h"
#import "MovieDetailModel.h"
#import "NLSliderSwitchProtocol.h"
#import "MyUploadViewController.h"
@interface UploadListTableViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,WaterfallLayoutDelegate,UploadListTableViewControllerDelegate,NLSliderSwitchProtocol>

@property(nonatomic,strong) UIView *emptyView;
@property(nonatomic, strong) WaterfallLayout *wlayout;

@end
static NSString * const newsCellIdentifier = @"UploadVideosCollectionCell";
static CGFloat const cell_margin = 3;
@implementation UploadListTableViewController
- (instancetype)initWithType:(NSString *)strType{
    _strType = strType;
    if(self = [super initWithCollectionViewLayout:self.wlayout]){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshListData:) name:K_APP_VIDEO_UPLOAD_REFRESH object:nil];
    }
    return self;
}
-(void)viewDidScrollToVisiableArea{
    NSLog(@"当前滑动到了‘’页面");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //加载数据
    [self loadListData];
    [self.collectionView registerNib:[UINib nibWithNibName:@"UploadVideosCollectionCell" bundle:nil] forCellWithReuseIdentifier:newsCellIdentifier];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView addSubview:self.emptyView];
    self.view.backgroundColor = [UIColor clearColor];

    __weak typeof(self) weakSelf = self;
    //MARK:下拉刷新
    weakSelf.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
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
//MARK: - update
-(void)refreshListData:(id)sender{
    ZWWLog(@"收到监听，正在刷新处理");
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.strType isEqualToString:@"上传中"]) {
            self.arrListData = nil;
        }
        if (self.collectionView.mj_header) {
            [self.collectionView.mj_header beginRefreshing];
        }
    });
    
    //移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self name:K_APP_VIDEO_UPLOAD_REFRESH object:nil];
}


//MARK: - loadListData
-(void)loadListData{
    if ([self.strType isEqualToString:@"上传中"]) {
        [self stopAnimation];
        return;
    }
    [YJProgressHUD showLoading:@"加载中..."];
    NSString *strUrl = [NSString stringWithFormat:@"%@Files",K_APP_HOST];
    NSString *stype = @"passed";//已审核
    if ([self.strType isEqualToString:@"审核中"])
        stype = @"auditing";
    else if([self.strType isEqualToString:@"被拒绝"])
        stype = @"refused";
    NSDictionary *dicParams = @{
                                @"id":@"0",
                                @"type":stype
                                };
    
    __block typeof(self) blockSelf = self;
    __weak typeof(self) weakSelf = self;
    [Utils getRequestForServerData:strUrl
                    withParameters:dicParams AndHTTPHeaderField:^(AFHTTPRequestSerializer * _Nullable _requestSerializer) {
                        [_requestSerializer setValue:LOGIN_COOKIE forHTTPHeaderField:LOGIN_COOKIE_KEY];
                    }
                    AndSuccessBack:^(id  _Nullable _responseData) {
                        [YJProgressHUD hideHUD];
                        if (_responseData && [[_responseData allKeys] containsObject:@"data"]) {
                            blockSelf.arrListData = [UploadModel mj_objectArrayWithKeyValuesArray:[_responseData objectForKey:@"data"] context:nil];
                        }
                        
                        [weakSelf stopAnimation];
                    } AndFailureBack:^(NSString * _Nullable _strError) {
                        [YJProgressHUD hideHUD];
                        ZWWLog(@"%@加载失败！详见：%@",self.strType,_strError);
                        [YJProgressHUD showError:_strError];
                        [weakSelf stopAnimation];
                    } WithisLoading:YES];
}

-(void)stopAnimation{
    [self.collectionView reloadData];
    if (self.collectionView.mj_header) {
        [self.collectionView.mj_header endRefreshing];
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
     UploadVideosCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:newsCellIdentifier forIndexPath:indexPath];
    if (self.arrListData && [self.arrListData count] > indexPath.row) {
        UploadModel *model;
        id cellData = self.arrListData[indexPath.row];
        if ([cellData isKindOfClass:[UploadModel class]])
            model = cellData;
        else
            model = [UploadModel mj_objectWithKeyValues:cellData];

        if ([self.strType isEqualToString:@"上传中"] && [MyUploadViewController alloc].imgLocalTemp) {//拿到上传的图片和title
            [cell cellBindForImg:[MyUploadViewController alloc].imgLocalTemp
                        andTitle:model.title
                      withFinish:NO];
        }
        else{
            [cell cellBindForImgurl:model.cover
                           andTitle:model.title
                         withFinish:NO];
        }
    }

    return cell;

}
//MARK: - UploadListTableViewControllerDelegate
-(void)uploadListProgress:(double)progressValue andMovieId:(NSInteger)movieId{
    ZWWLog(@"我收到进度加载了，v:%f",progressValue);
    __weak typeof(self) weakSelf = self;
    if (self.arrListData && [self.strType isEqualToString:@"上传中"]) {
        NSIndexPath *indexPatch;
        for (NSUInteger i = 0,len = [self.arrListData count]; i < len; i++) {
            if (self.arrListData[i].id == movieId) {
                indexPatch = [NSIndexPath indexPathForRow:i inSection:0];
                dispatch_async(dispatch_get_main_queue(), ^{
                    UploadVideosCollectionCell *cell = [weakSelf.collectionView cellForItemAtIndexPath:indexPatch];
                    if (cell) {
                        cell.progressV.hidden = (progressValue <= 1)?NO:YES;
                        cell.progressV.progress = progressValue;
                    }
                });
            }
        }
    }
}
- (CGFloat)waterfallLayout:(WaterfallLayout *)waterfallLayout itemHeightForWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath{
    id cellData;
    CGFloat h = 165;
    CGFloat _h = 165;
    CGFloat _w = (K_APP_WIDTH - 3 * cell_margin) * 0.5;
    if (self.arrListData && [self.arrListData count] > indexPath.row) {
        UploadModel *videoModel;
        cellData = [_arrListData objectAtIndex:indexPath.row];
        videoModel = (UploadModel *)cellData;
        _w = videoModel.width;
        _h = videoModel.height;
        h = _h * (K_APP_WIDTH - 3 * cell_margin) * 0.5 / _w;
    }
    return h > 0 ? h : 165;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.arrListData && [self.arrListData count] > 0) {
        [self.emptyView setHidden:YES];
        return [self.arrListData count];
    }
    [self.emptyView setHidden:NO];
    return 0;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (self.arrListData && [self.arrListData count] > indexPath.row) {
        //已审核,才可以点击进入正常播放界面
        if ([self.strType isEqualToString:@"已审核"]) {
            UploadModel *model;
            id cellData = self.arrListData[indexPath.row];
            if ([cellData isKindOfClass:[UploadModel class]])
                model = cellData;
            else
                model = [UploadModel mj_objectWithKeyValues:cellData];
            __weak typeof(self) weakSelf = self;
            [Utils loadMoviesDetailsDataWithVId:[NSString stringWithFormat:@"%lD",(long)model.id]
                                    abdCallback:^(id  _Nullable responseData, NSString * _Nullable strMsg) {
                                        
                                        ZWMoviseDetailsVC *vc = [[ZWMoviseDetailsVC alloc] init];
                                        vc.videoId = model.id;
                                        vc.IsVerticalScreen = model.IsVerticalScreen;
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
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //添加监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshListData:) name:K_APP_VIDEO_UPLOAD_REFRESH object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self name:K_APP_VIDEO_UPLOAD_REFRESH object:nil];
}
@end
