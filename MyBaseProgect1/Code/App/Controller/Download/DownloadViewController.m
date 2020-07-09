//
//  DownloadViewController.m
//  KuaiZhu
//
//  Created by apple on 2019/5/21.
//  Copyright © 2019 su. All rights reserved.
//

#import "DownloadViewController.h"
#import "DownloadListTableViewController.h"
#import "MovieDetailModel.h"

#import <Photos/Photos.h>

static const CGFloat k_top_offset_h = 44;

//栏目
#define column_type_arr @[@"正在下载",@"已下载"]

@interface DownloadViewController ()

//头部菜单
@property(nonatomic,strong) MLMSegmentHead *segHead;

//当前选中的索引
@property(nonatomic,assign) NSInteger selectIndex;
@property(nonatomic,strong) UIButton *btnSearch;
@property(nonatomic,strong) UIImageView *backImg;

@end

@implementation DownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initView];
}


//MARK: - initView
-(void)initView{
    [self.view addSubview:self.backImg];
    [self.view addSubview:self.btnSearch];
    float w = K_APP_WIDTH - 80;
    float h = 21;
    float y = (44 - h) * 0.5 + ([[UIDevice currentDevice] isiPhoneX]?K_APP_IPHONX_TOP:20);
    float x = (K_APP_WIDTH - w) / 2.f;
    UILabel *labPageTitle = [BaseUIView createLable:CGRectMake(x, y, w, h)
                                            AndText:@"我的下载"
                                       AndTextColor:[UIColor whiteColor]
                                         AndTxtFont:[UIFont systemFontOfSize:24]
                                 AndBackgroundColor:nil];
    labPageTitle.textAlignment = NSTextAlignmentCenter;
    labPageTitle.textColor = [UIColor whiteColor];
    labPageTitle.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:labPageTitle];

    UIView *topView = [[UIView alloc]init];
    topView.backgroundColor = [UIColor colorWithHexString:@"#fcfdff"];
    topView.frame = CGRectMake(0, y+h + 10, K_APP_WIDTH, k_top_offset_h + 10);
    topView.layer.cornerRadius = 13;
    topView.layer.masksToBounds = YES;
    [self.view addSubview:topView];
    
    //MARK:头部菜单
    __weak typeof(self) weakSelf = self;
    [MLMSegmentManager associateHead:weakSelf.segHead
                          withScroll:weakSelf.segScroll
                          completion:^{
                              [topView addSubview:self.segHead];
                              [weakSelf.view addSubview:self.segScroll];
                              
                              [weakSelf.segHead getScrollLineView].layer.cornerRadius = K_HEAD_BOTTOM_LINE_CORNER;
                              [weakSelf.segHead getScrollLineView].layer.masksToBounds = YES;
                          }];
    
//    [self.view sendSubviewToBack:self.segScroll];
}

-(MLMSegmentHead *)segHead{
    if (!_segHead) {
        //__weak typeof(self) weakSelf = self;
        CGRect rect = CGRectMake(0, 0, K_APP_WIDTH, k_top_offset_h);
        _segHead = [[MLMSegmentHead alloc] initWithFrame:rect
                                                  titles:column_type_arr
                                               headStyle:SegmentHeadStyleLine layoutStyle:MLMSegmentLayoutDefault];
        
        _segHead.bottomLineHeight = 0;                      //底部线
        _segHead.headColor = [UIColor whiteColor];          //背景色
        
        _segHead.selectColor = K_HEAD_MENU_SELECT_COLOR;    //选中的颜色
        _segHead.deSelectColor = K_HEAD_MENU_DEFAULT_COLOR; //默认颜色
        
        _segHead.fontSize = K_HEAD_MENU_FONT_SIZE;          //字体大小
        _segHead.fontScale = K_HEAD_MENU_SCALE;             //缩放大小
        
        _segHead.lineColor = K_HEAD_MENU_LINE_COLOR;        //下划线颜色
        _segHead.lineHeight = K_HEAD_BOTTOM_LINE_HEIGHT;    //下划线高度
        _segHead.lineWidth = K_HEAD_BOTTOM_LINE_WIDTH;      //下划线宽度
        _segHead.slideCorner = K_HEAD_BOTTOM_LINE_CORNER;
    }
    return _segHead;
}

-(MLMSegmentScroll *)segScroll{
    if (!_segScroll) {
        __weak typeof(self) weakSelf = self;
        __block typeof(self) blockSelf = self;
        
        CGFloat h = K_APP_HEIGHT - K_APP_NAVIGATION_BAR_HEIGHT - k_top_offset_h;
        if ([[UIDevice currentDevice] isiPhoneX]) {
            h -= K_APP_IPHONX_BUTTOM;
        }
        _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, K_APP_NAVIGATION_BAR_HEIGHT + k_top_offset_h, K_APP_WIDTH, h)
                                                   vcOrViews:[weakSelf collectionViewArr:[column_type_arr count]]];
        _segScroll.loadAll = NO;
        _segScroll.scrollEnd = ^(NSInteger currentIndex) {
            blockSelf.selectIndex = currentIndex;
        };
    }
    return _segScroll;
}

//添加视图
-(NSArray *)collectionViewArr:(NSUInteger)count{
    NSMutableArray *_arr = [NSMutableArray array];
    DownloadListTableViewController *_cv;
    NSString *strType;
    
    for (NSUInteger i = 0; i < count; i++) {
        
        strType = [NSString stringWithFormat:@"%@",[column_type_arr objectAtIndex:i]];
        _cv = [[DownloadListTableViewController alloc] initWithType:strType];
        if ([strType isEqualToString:@"正在下载"]) {
            self.delegate = (id<DownloadTableViewControllerDelegate>)_cv;
        }
        [_arr addObject:_cv];
    }
    return [_arr copy];
}


//MARK: - 下载
-(void)downloadMovie{
    
    __weak typeof(self) weakSelf = self;
    __block typeof(self) blockSelf = self;
    //[MBProgressHUD showInfo:@"已开启视频文件后台下载中"];
    
    NSString *strDownloadUrl;
    NSInteger movieId = [self->_movieModel.movieid integerValue];
    if ([self.movieModel.url hasPrefix:@"http"]) {
        strDownloadUrl = self.movieModel.url;
    } else {
        NSArray *array = [self.movieModel.serverUrl componentsSeparatedByString:@"/API/Upload"];
        strDownloadUrl = [NSString stringWithFormat:@"%@/Upload/%@",array.firstObject,self.movieModel.url];
    }
    
    //下载
    [Utils downloadRequestDataForUrl:strDownloadUrl
                  AndHTTPHeaderField:^(NSMutableURLRequest * _Nullable _request) {
                      [_request setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
                      [_request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                      [_request setValue:LOGIN_COOKIE forHTTPHeaderField:LOGIN_COOKIE_KEY];
                  } AndFinishBack:^(id  _Nullable responseData, NSString * _Nullable strMsg) {
                      
                      NSURL *filePath = (NSURL *)responseData;
                      NSString *strLocalpath = [NSString stringWithFormat:@"%@",filePath.path];
                      NSString *strName = [blockSelf->_movieModel.url lastPathComponent];
                      
                      if (filePath && [[NSFileManager defaultManager] fileExistsAtPath:filePath.path]) {
                          
                          //保存到相册
                          dispatch_async(dispatch_get_main_queue(), ^{
                              //保存
                              [weakSelf saveVideoToAlbum:filePath];
                          });
                          
                          dispatch_async(dispatch_get_global_queue(0, 0), ^{
                              //记录下载数据
                              [[FMDBUtils shareInstance] addDownloadMovesForId:movieId
                                                                        andUrl:blockSelf->_movieModel.url
                                                                    andLocaurl:strLocalpath
                                                                      andTitle:blockSelf->_movieModel.title
                                                                   andMovename:strName
                                                                      andCover:blockSelf->_movieModel.cover
                                                                    withFinish:YES];
                          });
                      }
                      else{
                          ZWWLog(@"视频文件下载失败！详见：%@",strMsg);
                          [YJProgressHUD showError:strMsg?strMsg:@"视频文件下载失败"];
                      }
                  }
                         andProgress:^(NSProgress * _Nonnull progress) {
                             double fv = (double)progress.completedUnitCount/(double)progress.totalUnitCount;
                             ZWWLog(@"progress:%lld / %lld,fv:%f",progress.completedUnitCount,progress.totalUnitCount,fv);
                             
                             if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(downloadListProgress:andMovieId:)]) {
                                 [weakSelf.delegate downloadListProgress:fv
                                                              andMovieId:movieId];
                             }
                         }
                          AndLoaging:NO];

}


//videoPath为视频下载到本地之后的本地路径
- (void)saveVideoToAlbum:(NSURL *)videoPath{
    
    __weak typeof(self) weakSelf = self;
    [Utils createFolder:K_APP_NAME
         andBackaction:^(PHAssetCollection *assetCollection) {
             ZWWLog(@"assetCollection:%@",assetCollection);
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                     //请求创建一个Asset
                     PHAssetChangeRequest *assetRequest = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:videoPath];
                     
                     //请求编辑相册
                     PHAssetCollectionChangeRequest *collectonRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
                     
                     //为Asset创建一个占位符，放到相册编辑请求中
                     PHObjectPlaceholder *placeHolder = [assetRequest placeholderForCreatedAsset];
                     
                     //相册中添加视频
                     [collectonRequest addAssets:@[placeHolder]];
                     
                 } completionHandler:^(BOOL success, NSError *error) {
                     if (success) {
                         ZWWLog(@"保存视频成功!");
                         dispatch_async(dispatch_get_main_queue(), ^{
                             [YJProgressHUD showSuccess:@"视频下载成功，已保存到系统相册"];
                             
                             //刷新
                             if ([weakSelf.childViewControllers count] > weakSelf.selectIndex) {
                                 DownloadListTableViewController *dlVC = weakSelf.childViewControllers[weakSelf.selectIndex];
                                 if (dlVC && dlVC.collectionView && dlVC.collectionView.mj_header) {
                                     [dlVC.collectionView.mj_header beginRefreshing];
                                 }
                             }
                             
                         });
                         
                     } else {
                         ZWWLog(@"保存视频失败:%@", error);
                         dispatch_async(dispatch_get_main_queue(), ^{
                             [YJProgressHUD showError:error.localizedDescription];
                         });
                     }
                 }];
             });
    }];
}
-(UIButton *)btnSearch{
    if (!_btnSearch) {
        CGFloat w = 35;
        CGFloat x = [[UIDevice currentDevice] isSmallDevice]?15:25;
        CGFloat h = 35;
        CGFloat y = ([[UIDevice currentDevice] isiPhoneX]?K_APP_IPHONX_TOP:20) + (44 - h) * 0.5;
        _btnSearch =[BaseUIView createBtn:CGRectMake(x, y, w, h)
                                 AndTitle:nil
                            AndTitleColor:nil
                               AndTxtFont:nil
                                 AndImage:[UIImage imageNamed:@"backBtnBlack"]
                       AndbackgroundColor:nil
                           AndBorderColor:nil
                          AndCornerRadius:0
                             WithIsRadius:NO
                      WithBackgroundImage:nil
                          WithBorderWidth:0];

        [_btnSearch addTarget:self action:@selector(BackBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnSearch;
}
-(UIImageView *)backImg{
    if (!_backImg) {
        _backImg = [BaseUIView createImage:UIScreen.mainScreen.bounds
                                  AndImage:[UIImage imageNamed:@"我的信息"]
                        AndBackgroundColor:nil
                              WithisRadius:NO];
    }
    return _backImg;
}
-(void)BackBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
