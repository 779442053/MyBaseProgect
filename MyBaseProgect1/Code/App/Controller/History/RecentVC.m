//

#import "RecentVC.h"
#import "MovieDetailModel.h"
#import "MyCollecCell.h"
#import "ZWMainVideosCell.h"
#import "WaterfallLayout.h"

#import "MovieDetailModel.h"
#import "ZWMoviseDetailsVC.h"
static CGFloat const cell_margin = 3;
#define cycleScrollViewHeight ((K_APP_WIDTH - 2 * cell_margin) * 0.5)
static NSString *const newsCellIdentifier = @"ZWMainVideosCell";

@interface RecentVC () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,WaterfallLayoutDelegate,MoviesDetailsVCDelegate>

@property (nonatomic,  copy) NSArray *dataArr;

@property (nonatomic,strong) MovieDetailModel *model;

@property(nonatomic, strong) WaterfallLayout *wlayout; 

@property (nonatomic,strong) UICollectionView *collectView;

@property (nonatomic,strong) UIButton *btnClear;

@property (nonatomic,strong) UIView *emptyView;
@end

@implementation RecentVC
-(WaterfallLayout *)wlayout{
    if (!_wlayout) {
        _wlayout = [WaterfallLayout waterFallLayoutWithColumnCount:2];
        [_wlayout setColumnSpacing:cell_margin
                        rowSpacing:cell_margin
                      sectionInset:UIEdgeInsetsMake(0, cell_margin, cell_margin, cell_margin)];
        _wlayout.delegate = self;
    }
    return _wlayout;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self initView];
   
    [self getData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//MARK: - initView
-(void)initView{
    //MARK:导航
    [self initNavgationBar:K_APP_NAVIGATION_BACKGROUND_COLOR
          AndHasBottomLine:NO
              AndHasShadow:YES
             WithHasOffset:0.0];
    
    //MARK:返回
    [self initNavigationBack:K_APP_BLACK_BACK];
    
    //MARK:标题
    [self initViewControllerTitle:@"近期收看"
                     AndFontColor:K_APP_VIEWCONTROLLER_TITLE_COLOR
                       AndHasBold:NO
                      AndFontSize:K_APP_VIEWCONTROLLER_TITLE_FONT];
    
    [self.view addSubview:self.collectView];
    [self.collectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(K_APP_NAVIGATION_BAR_HEIGHT);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(K_APP_WIDTH);
        make.bottom.mas_equalTo(0);
    }];
    
    //item
    [self.collectView registerNib:[UINib nibWithNibName:@"ZWMainVideosCell" bundle:nil] forCellWithReuseIdentifier:newsCellIdentifier];
    
    [self.collectView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"reusableView"];
    _dataArr = [NSArray array];
    
    //MARK:清空
    [self.navView addSubview:self.btnClear];
    
    [self.view sendSubviewToBack:self.collectView];
}

-(UIButton *)btnClear{
    if (!_btnClear) {
        CGFloat w = 35;
        CGFloat h = 35;
        CGFloat x = K_APP_WIDTH - w - 20;
        CGFloat y = ([[UIDevice currentDevice] isiPhoneX]?K_APP_IPHONX_TOP:20) + (44 - h) * 0.5;
        _btnClear =[BaseUIView createBtn:CGRectMake(x, y, w, h)
                                  AndTitle:@"清除"
                             AndTitleColor:K_APP_TINT_COLOR
                                AndTxtFont:[UIFont systemFontOfSize:14]
                                  AndImage:nil
                        AndbackgroundColor:nil
                            AndBorderColor:nil
                           AndCornerRadius:0
                              WithIsRadius:NO
                       WithBackgroundImage:nil
                           WithBorderWidth:0];
        
        [_btnClear addTarget:self action:@selector(deleteAll:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnClear;
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


//MARK: - 清除
-(IBAction)deleteAll:(UIButton *)sender{

    //删除所有历史信息
    if (!self.dataArr || [self.dataArr count] <= 0) {
        [MBProgressHUD showInfo:@"没有数据,无需清理"];
        return;
    }
    
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"清除所有?"
                                                                       message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定"
                                                 style:UIAlertActionStyleDestructive
                                               handler:^(UIAlertAction * _Nonnull action) {
                                                   
                                                  BOOL isOK = [[FMDBUtils shareInstance] removeAllDataForTableName:K_FMDB_MOVIES_HISTORY_INFO];
                                                   if (isOK) {
                                                       [YJProgressHUD showSuccess:@"数据已清除"];
                                                   }
                                                   else{
                                                       [YJProgressHUD showError:@"删除失败,请稍后再试"];
                                                   }
                                               }];
    
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消"
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];
    [alertView addAction:ok];
    [alertView addAction:cancle];
    [self presentViewController:alertView animated:YES completion:nil];
}


//MARK: -  UICollectionView
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(K_APP_WIDTH / 2 - 1, kWidth(140));
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (self.dataArr && [self.dataArr count] > 0) {
        [self.emptyView setHidden:YES];
        return [self.dataArr count];
    }
    
    [self.emptyView setHidden:NO];
    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ZWMainVideosCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:newsCellIdentifier forIndexPath:indexPath];
    if (self.dataArr && [self.dataArr count] > indexPath.row) {
        MovieDetailModel *model;
        id cellData = self.dataArr[indexPath.row];
        if (![cellData isKindOfClass:[MovieDetailModel class]]) {
            model = [MovieDetailModel mj_objectWithKeyValues:cellData];
        }
        else{
            model = cellData;
        }

        cell.DesLb.text = model.title;
        NSString *cover = model.cover;
        cover = [cover stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
        if (model.IsVerticalScreen) {
            [cell.BgImageView sd_setImageWithURL:[cover mj_url] placeholderImage:K_APP_DEFAULT_IMAGE_BIG];
        }else{
            [cell.BgImageView sd_setImageWithURL:[cover mj_url] placeholderImage:K_APP_DEFAULT_IMAGE_SMALL];
        }
        
        [cell.UserImageView sd_setImageWithURL:[model.userPhoto mj_url] placeholderImage:K_APP_DEFAULT_USER_IMAGE];
        [cell.UserImageView wyh_autoSetImageCornerRedius:14 ConrnerType:UIRectCornerAllCorners];
        cell.NameLB.text = model.userName;
        cell.heardLB.hidden = YES;
        cell.HeardImageView.hidden = YES;

    }
    
    return cell;
}
//MARK: - request data
- (void)getData{
    self.dataArr = [[FMDBUtils shareInstance] getAllValuesFromTable:K_FMDB_MOVIES_HISTORY_INFO
                                                           AndWhere:nil
                                                        WithOrderBy:@" ORDER BY mid DESC"];
    [self.collectView reloadData];
    ZWWLog(@"arr = %@,数量:%lu",_dataArr,(unsigned long)_dataArr.count);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(K_APP_WIDTH - 2 * cell_margin, cycleScrollViewHeight);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeZero;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArr && [self.dataArr count] > indexPath.row){
        NSString *strVid;
        NSDictionary * cellData = self.dataArr[indexPath.row];
        if ([cellData containsObjectForKey:@"id"]) {
            strVid = cellData[@"id"];
        }else{
            [YJProgressHUD showError:@"视频编号有误"];
            return;
        }
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
    
}
- (UICollectionView *)collectView{
    if (!_collectView) {
        _collectView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.wlayout];
        _collectView.backgroundColor = [UIColor whiteColor];
        _collectView.dataSource = self;
        _collectView.delegate = self;
        [_collectView addSubview:self.emptyView];
    }
    return _collectView;
}
//MARK: - WaterfallLayoutDelegate
- (CGFloat)waterfallLayout:(WaterfallLayout *)waterfallLayout itemHeightForWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath{
    CGFloat _h = 165;
    CGFloat _w = (K_APP_WIDTH - 3 * cell_margin) * 0.5;//宽度不变
    if (self.dataArr && [self.dataArr count] > indexPath.row) {
        MovieDetailModel *model;
        //Advertisements *adModel;
        id cellData = self.dataArr[indexPath.row];
        if (![cellData isKindOfClass:[MovieDetailModel class]]) {
            model = [MovieDetailModel mj_objectWithKeyValues:cellData];
        }
        else{
            model = cellData;
        }
        _w = model.ItemWidth;
        _h = model.ItemHeight;
        //ZWWLog(@"视频的高度==\n\n=%f",videoModel.height)
    }

    return _h ;
}
//MARK: - MoviesDetailsVCDelegate
-(void)moviesDetailsHeartUpdateActionForValue:(NSInteger)_cvalue AndIndexPath:(NSIndexPath *)_indexPath{
    if (self.dataArr && [self.dataArr count] > _indexPath.row) {
        MovieDetailModel *videoModel = (MovieDetailModel *)self.dataArr[_indexPath.row];
        videoModel.heartCount = _cvalue;
        [self.collectView reloadItemsAtIndexPaths:@[_indexPath]];
    }
}
@end

