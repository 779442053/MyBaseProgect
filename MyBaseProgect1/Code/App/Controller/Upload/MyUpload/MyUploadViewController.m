//
//  MyUploadViewController.m
//  KuaiZhu
//
//  Created by apple on 2019/5/21.
//  Copyright © 2019 su. All rights reserved.
//

#import "MyUploadViewController.h"
#import "UploadListTableViewController.h"
#import "UploadModel.h"
#import "NLSliderSwitch.h"
static const CGFloat k_top_offset_h = 44;
@interface MyUploadViewController ()<NLSliderSwitchDelegate,UIScrollViewDelegate>{
    NSInteger uploadCount;
}

@property (nonatomic, strong) UIScrollView * backScrollV;
//滑条
@property (nonatomic, strong) NLSliderSwitch *sliderSwitch;
@property(nonatomic,strong) UIButton *btnSearch;


@property(nonatomic,weak) id<UploadListTableViewControllerDelegate> delegate;

@end

@implementation MyUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}
-(void)BackBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

//MARK: - initView
-(void)initView{
    [self setBackgroundColor];
    [self initNavgationBar:[UIColor clearColor]
          AndHasBottomLine:NO
              AndHasShadow:NO
             WithHasOffset:0.0];
    [self initViewControllerTitle:@"我的上传"
                     AndFontColor:K_APP_VIEWCONTROLLER_TITLE_COLOR
                       AndHasBold:YES
                      AndFontSize:K_APP_VIEWCONTROLLER_TITLE_FONT];
    [self.view addSubview:self.btnSearch];
    NSArray *titarr = @[@"上传中",@"已审核",@"审核中",@"被拒绝"];
    CGFloat h = K_APP_HEIGHT - K_APP_NAVIGATION_BAR_HEIGHT - k_top_offset_h;
    if ([[UIDevice currentDevice] isiPhoneX]) {
        h -= K_APP_IPHONX_BUTTOM;
    }
    self.backScrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, K_APP_NAVIGATION_BAR_HEIGHT + k_top_offset_h, K_APP_WIDTH,h)];
    self.backScrollV.pagingEnabled = YES;
    self.backScrollV.delegate = (id)self;
    self.backScrollV.showsVerticalScrollIndicator = NO;
    self.backScrollV.showsHorizontalScrollIndicator = NO;
    self.backScrollV.bounces = NO;
    self.backScrollV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backScrollV];
    self.backScrollV.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * 4, 1);//禁止竖向滚动
    NSMutableArray *viewARR = [[NSMutableArray alloc] init];
    for (int i = 0; i< titarr.count; i++) {
        NSString *type = titarr[i];
        UploadListTableViewController *viewVC = [[UploadListTableViewController alloc]initWithType:type];
        [viewARR addObject:viewVC];
        if (i == 0 && self.uploadModel) {
            viewVC.arrListData = @[self.uploadModel];
            self.delegate = (id<UploadListTableViewControllerDelegate>)viewVC;
        }
        [viewVC.view setFrame:CGRectMake(i*K_APP_WIDTH, 0, K_APP_WIDTH, self.backScrollV.frame.size.height)];
        viewVC.delegateVC = self;
        [viewVC.collectionView.mj_header beginRefreshing];
        [self.backScrollV addSubview:viewVC.view];
        [self addChildViewController:viewVC];
    }
    self.sliderSwitch = [[NLSliderSwitch alloc]initWithFrame:CGRectMake(0, self.navView.frame.size.height - 5, K_APP_WIDTH , 50) buttonSize:CGSizeMake(K_APP_WIDTH*0.25, 30)];
    self.sliderSwitch.titleArray = titarr;
    self.sliderSwitch.normalTitleColor = [UIColor colorWithHexString:@"#666666"];
    self.sliderSwitch.selectedTitleColor = [UIColor colorWithHexString:@"#000000"];
    self.sliderSwitch.selectedButtonColor = [UIColor colorWithHexString:@"#FF1493"];
    self.sliderSwitch.titleFont = [UIFont systemFontOfSize:15];
    self.sliderSwitch.backgroundColor = [UIColor clearColor];
    self.sliderSwitch.delegate = (id)self;
    self.sliderSwitch.viewControllers = viewARR;
    [self.sliderSwitch slideToIndex:self.selectIndex animated:YES];
    [self.view addSubview:self.sliderSwitch];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.backScrollV) {
        float xx = scrollView.contentOffset.x;
        int rate = round(xx/K_APP_WIDTH);
        if (rate != self.sliderSwitch.selectedIndex) {
            [self.sliderSwitch slideToIndex:rate];
        }
    }
}
-(void)sliderSwitch:(NLSliderSwitch *)sliderSwitch didSelectedIndex:(NSInteger)selectedIndex{
    [self.backScrollV scrollRectToVisible:CGRectMake(selectedIndex*K_APP_WIDTH,0, K_APP_WIDTH, 1) animated:YES];
}


//MARK: - 上传
-(void)uploadMovieData:(id)response
        andRealFileUrl:(NSString *)realFileUrl
                andStr:(NSString *)str
         andCoverImage:(UIImage *)coverImage{
    
    uploadCount = 0;
    self.imgLocalTemp = coverImage;
    
    UploadListTableViewController *uploadListVC = self.childViewControllers.firstObject;
    if (uploadListVC && (!uploadListVC.arrListData || uploadListVC.arrListData.count <= 0)) {
        uploadListVC.arrListData = @[self.uploadModel];
        [uploadListVC.collectionView reloadData];
        self.delegate = (id<UploadListTableViewControllerDelegate>)uploadListVC;
    }
    
    NSString *serverUrl = [NSString stringWithFormat:@"%@",response[@"serverUrl"]];
    NSString *strId = [NSString stringWithFormat:@"%@",response[@"id"]];
    NSData *videoData;
    if (realFileUrl) {
        videoData = [NSData dataWithContentsOfURL:URLFilePath(realFileUrl)];
    }else{
        videoData = [NSData dataWithContentsOfURL:URLWithStr(realFileUrl)];
    }
    NSData *coverData = UIImageJPEGRepresentation(coverImage, 0.75);
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    dispatch_group_enter(group);
    [self uploadMovieFile:serverUrl
                  andFileName:str
                   andVideoID:strId
                  andfileType:@"video"
                  andPosition:@"0"
                     andisEOF:@"true"
                  andfileData:videoData
                    withGroup:group];
    
    dispatch_group_enter(group);
    [self uploadMovieFile:serverUrl
                  andFileName:str
                   andVideoID:strId
                  andfileType:@"cover"
                  andPosition:@"0"
                     andisEOF:@"true"
                  andfileData:coverData
                    withGroup:group];
    
    //关闭
    __block typeof(self) blockSelf = self;
    dispatch_group_notify(group, queue, ^{
        ZWWLog(@"全部线程结束");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (blockSelf->uploadCount == 2)
                [YJProgressHUD showSuccess:@"上传成功"];
            else
                [YJProgressHUD showError:@"上传失败"];
            
            [self.backScrollV setContentOffset:CGPointZero animated:NO];
        });
        
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:K_APP_VIDEO_UPLOAD_REFRESH object:nil];
    });
}

- (void)uploadMovieFile:(NSString *)serverUrl
            andFileName:(NSString *)videoName
             andVideoID:(NSString *)videoID
            andfileType:(NSString *)fileType
            andPosition:(NSString *)position
               andisEOF:(NSString *)isEOF
            andfileData:(NSData *)fileData
              withGroup:(dispatch_group_t)group
{
    
    __block typeof(self) blockSelf = self;
    __weak typeof(self) weakSelf = self;
    
    [Utils postImageUploadToServer:serverUrl
                           AndBody:fileData
                AndHTTPHeaderField:^(NSMutableURLRequest *_request) {
                    
                    if ([fileType isEqualToString:@"cover"]) {
                        [_request setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
                    }
                    else{
                        [_request setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
                    }
                    [_request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                    [_request setValue:LOGIN_COOKIE forHTTPHeaderField:LOGIN_COOKIE_KEY];
                    
                    [_request setValue:videoID forHTTPHeaderField:@"__videoID"];
                    [_request setValue:fileType forHTTPHeaderField:@"__fileType"];
                    [_request setValue:position forHTTPHeaderField:@"__position"];
                    [_request setValue:isEOF forHTTPHeaderField:@"__isEOF"];
                }
                    AndSuccessBack:^(NSObject *_responseData, NSString *_strMsg) {
                        ZWWLog(@"%@上传成功:%@",[fileType isEqualToString:@"cover"]?@"视频封面图片":@"视频",_responseData);
                        if (_responseData) {
                            ZWWLog(@"上传成功！详见：%@",(_strMsg && ![_strMsg isKindOfClass:[NSNull class]])?_strMsg:@"上传成功");
                            blockSelf->uploadCount++;
                        }
                        else{
                            ZWWLog(@"上传失败！详见：%@",(_strMsg && ![_strMsg isKindOfClass:[NSNull class]])?_strMsg:@"上传失败");
                            blockSelf->uploadCount--;
                        }
                        
                        dispatch_group_leave(group);
                    } AndFailureBack:^(NSString *_strError) {
                        ZWWLog(@"%@上传失败:%@",[fileType isEqualToString:@"cover"]?@"视频封面图片":@"视频",_strError);
                        blockSelf->uploadCount--;
                        
                        dispatch_group_leave(group);
                    } andProgress:^(NSProgress * _Nonnull progress) {
                        double fv = (double)progress.completedUnitCount/(double)progress.totalUnitCount;
                        ZWWLog(@"progress:%lld / %lld,fv:%f",progress.completedUnitCount,progress.totalUnitCount,fv);
                        
                        //只加载视频进度
                        if (![fileType isEqualToString:@"cover"] && weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(uploadListProgress:andMovieId:)]) {
                            [weakSelf.delegate uploadListProgress:fv
                                                        andMovieId:videoID.integerValue];
                        }
                    }
                     WithisLoading:YES];
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
@end
