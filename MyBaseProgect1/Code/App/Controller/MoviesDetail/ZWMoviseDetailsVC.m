//
//  ZWMoviseDetailsVC.m
//  KuaiZhu
//
//  Created by step_zhang on 2019/11/7.
//  Copyright © 2019 su. All rights reserved.
//
#define ZWWOBJECT_IS_EMPYT(object) \
({ \
BOOL flag = NO; \
if ([object isKindOfClass:[NSNull class]] || object == nil || object == Nil || object == NULL) \
flag = YES; \
if ([object isKindOfClass:[NSString class]]) \
if ([(NSString *)object length] < 1) \
flag = YES; \
if ([object isKindOfClass:[NSArray class]]) \
if ([(NSArray *)object count] < 1) \
flag = YES; \
if ([object isKindOfClass:[NSDictionary class]]) \
if ([(NSDictionary *)object allKeys].count < 1) \
flag = YES; \
(flag); \
})
#import "ZWMoviseDetailsVC.h"
#import "MovieDetailModel.h"
#import "DownloadViewController.h"
#import "MessageVC.h"
#import "LoginViewController.h"
//评论
#import "CommentsModel.h"
#import "CommentsCell.h"
//分享
#import <CoreImage/CoreImage.h>


//个人中心
#import "ZWUserDetialVC.h"
#import "InfosModel.h"

#import <ZFPlayer/ZFPlayer.h>
#import <ZFPlayer/ZFPlayerControlView.h>
#import <ZFAVPlayerManager.h>
#import <Photos/Photos.h>

//#import "CustomIOS7AlertView.h"
#import "MoveDetialShareView.h"

#import "UIButton+ZWWImageBtn.h"
#import "CALayer+shake.h"

#define TextColor [UIColor colorWithHexString:@"#999999"]
//#define k_video_height 0    //视频底部信息
#define k_nav_view_alpha 0.3

static CGFloat const k_table_section_view_h = 80;
static CGFloat const k_conment_view_height = 40;
static CGFloat const k_buttom_width = 60;
static CGFloat const k_margin = 20;
//K_APP_IPHONX_BUTTOM
#define k_table_head_view_h (K_APP_HEIGHT  + ([[UIDevice currentDevice] isiPhoneX]?-0:0))
#define k_table_head_view_hTwo (K_APP_HEIGHT *0.315)
@interface ZWMoviseDetailsVC ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,LoginViewControllerDelegate>{
    BOOL isSecond;
}
//@property (nonatomic, strong) CustomIOS7AlertView *customAlertView;    //弹出框分享
//@property (nonatomic, strong) MoveDetialShareView *detailsShareView; //分享详情



@property (nonatomic, strong) UIView *navTopView;
//https://www.jianshu.com/p/90e55deb4d51 ZFPlayer 3.0解析
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) ZFAVPlayerManager *playManager;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic, strong) UIView *containerView;//播放容器界面

//////// 播放完璧界面
@property (nonatomic, strong) UIButton *playBtn;        //重新播放
@property (nonatomic, strong) UIButton *btnWXShare;     //微信分享
@property (nonatomic, strong) UIButton *btnQQShare;     //QQ分享
@property (nonatomic, strong) UIButton *btnCopy;        //复制地址
@property (nonatomic, strong) UILabel *labShare;        //分享到
@property (nonatomic, strong) UIButton *btnExceptionalShare;     //打赏
@property (nonatomic, strong) UIView *headView;         //表头部视图


//////评论工具框
@property (nonatomic, strong) UIView *discussView;       //评论
@property (nonatomic, strong) UITextField *commentField; //评论TextField
@property (nonatomic,   copy) NSString *commendId;       //被回复的Id
@property (nonatomic, strong) UIButton *sendBtn;         //发送
@property (nonatomic, strong) UIButton *btnConmment;     //评论展开
@property (nonatomic, assign) CGFloat lastOffSetY;

//==========section == 3  =================
@property (nonatomic, strong) UIButton *followbtn;      //关注
@property (nonatomic, strong) UIButton *btnPeople;      //视频发布人图像
@property (nonatomic, strong) UILabel *nameLabel;       //视频发布人
@property (nonatomic, strong) UILabel *fansLabel;       //粉丝
@property (nonatomic, strong) UIButton *MessageBtn;     //私信
@property (nonatomic, strong) UIButton *likeBtn;     //点赞数量
@property (nonatomic, strong) UIButton *commentBtn;     //评论数量
@property (nonatomic, strong) UILabel *VoidoNameLB;//视频名字
@property (nonatomic, strong) UIButton *CollowBtn;     //收藏,取消收藏

@property (nonatomic, strong) FLAnimatedImageView *flimgCommentAD;//广告.也许有.也许没有
@property (nonatomic, strong) FLAnimatedImageView *flimgPlayAD;   //开始播放广告
@property (nonatomic,strong) NSTimer             *timer;
@property (nonatomic,strong) NSTimer             *Shacktimer;//dou抖动
@property (nonatomic,strong) UIButton            *btnGo;
@property (nonatomic,assign) NSInteger           timerNo;
@end

@implementation ZWMoviseDetailsVC
{
    CommentsModel *_commnetModel;       //评论
}
#pragma - 保存至相册
- (void)saveImageToPhotoAlbum:(UIImage*)savedImage
{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
    if(error != NULL){
       [YJProgressHUD showSuccess:@"保存相册失败"];
    }else{
        [YJProgressHUD showSuccess:@"保存相册成功"];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //加载观影信息
    [self getCodeData];
    //加载评论
    if ([UserModel userIsLogin]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self loadCommentData];
        });
    }
    //增加在线时间
    if ([UserModel userIsLogin]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self addOnlineTime];
        });
    }
    [self setBackgroundColor];
    [self initUI];
}
-(void)ItemBtnClick:(UIButton *)sender{
    if (sender.tag == 0) {
        if (![UserModel userIsLogin]) {
            [self userToLogin:(LoginViewControllerDelegate *)self];
            return;
        }
        BOOL isHeart = NO;
        NSString *foolwStr = @"false";
        //当前未喜欢(0) -> 点击变为已喜欢
        if (self.movieModel.isHeart == 0) {
            foolwStr = @"true";
            isHeart = YES;
        }
        NSString *strUtl = [NSString stringWithFormat:@"%@Heart",K_APP_HOST];
        NSDictionary *dicParams = @{
                                    @"videoID":[NSString stringWithFormat:@"%lD",(long)self.videoId],
                                    @"isHeart":foolwStr
                                    };

        __weak typeof(self) weakSelf = self;
        [Utils putRequestForServerData:strUtl
                        withParameters:dicParams
                        AndSuccessBack:^(id  _Nullable _responseData, NSString * _Nullable strMsg) {
                            [YJProgressHUD showSuccess:@"操作成功"];
                            //数据状态改变
                            weakSelf.movieModel.isHeart = isHeart?1:0;
                            NSInteger heartCount = weakSelf.movieModel.heartCount;
                            heartCount = isHeart?++heartCount:--heartCount;
                            if (heartCount <= 0) {
                                heartCount = 0;
                            }
                            weakSelf.movieModel.heartCount = heartCount;
                            //委托处理
                            if (weakSelf.delegate && weakSelf.indexPath && [weakSelf.delegate respondsToSelector:@selector(moviesDetailsHeartUpdateActionForValue:AndIndexPath:)]) {
                                [weakSelf.delegate moviesDetailsHeartUpdateActionForValue:heartCount AndIndexPath:weakSelf.indexPath];
                            }
                            //UI更新
                            dispatch_async(dispatch_get_main_queue(), ^{
                                sender.selected = !sender.selected;
                                [weakSelf updateUI];
                            });
                        } AndFailureBack:^(NSString * _Nullable _strError) {
                            ZWWLog(@"喜欢、取消喜欢失败！详见：%@",_strError);
                            [YJProgressHUD showError:_strError];
                        }
                         WithisLoading:YES];
    }else if (sender.tag == 1){
        //自定义分享界面  zzz
//        if (![UserModel userIsLogin]) {
//            [self userToLogin:(LoginViewControllerDelegate *)self];
//            return;
//        }
        NSString * string = [NSString stringWithFormat:@"%@?%@",self.movieModel.shareVideoUrl,K_APP_SHARE_INFO];
        CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
        [filter setDefaults];
        NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        [filter setValue:data forKeyPath:@"inputMessage"];
        CIImage *image = [filter outputImage];
        
        MoveDetialShareView *bottomView = [[MoveDetialShareView alloc]init];
        bottomView.frame = CGRectMake(0, 0, K_APP_WIDTH, K_APP_HEIGHT);
        bottomView.CodeImageView.image =[self createNonInterpolatedUIImageFormCIImage:image withSize:227];
        bottomView.labTitle.text = string;
        bottomView.vc = self;
        [bottomView showAlert];
        __block typeof(self) blockSelf = self;
        __weak typeof(self) weakSelf = self;
        bottomView.shareTypeBlock = ^(NSInteger selectType) {
            if(selectType == 3){
                           UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
                           pasteBoard.string = [NSString stringWithFormat:@"%@?%@",blockSelf.movieModel.shareVideoUrl,K_APP_SHARE_INFO];
                           NSLog(@"copy share:%@",pasteBoard.string);
                           [YJProgressHUD showSuccess:@"已经复制，快去分享吧！"];
                       }
                       //MARK:保存相册
                       else if(selectType == 1){
                           UIImage *saveImage = [weakSelf createNonInterpolatedUIImageFormCIImage:image withSize:227];
                           [weakSelf saveImageToPhotoAlbum:saveImage];
                       }
        };

        //[self.customAlertView show];
    }else if (sender.tag == 2){
        NSString *strUrl = [NSString stringWithFormat:@"%@?%@",self.movieModel.shareVideoUrl,K_APP_SHARE_INFO];
        if (strUrl && ![strUrl isEqualToString:@""] && ![strUrl isKindOfClass:[NSNull class]]) {
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:strUrl]]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strUrl] options:@{} completionHandler:nil];
            }
        }
    }else if (sender.tag == 3){
      [YJProgressHUD showMessage:@"即将推出,敬请期待"];
    }

}
//更新关注,喜欢相关标题
-(void)updateUI{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.likeBtn setTitle:[NSString stringWithFormat:@"%ld赞",(long)self->_movieModel.heartCount] forState:UIControlStateNormal];
        [self.commentBtn setTitle:[NSString stringWithFormat:@"%ld评论",(long)self->_commnetModel.dataCount] forState:UIControlStateNormal];

        //0(false) 未关注,反之已关注
        [self.followbtn setSelected:self.movieModel.isFollow == 0?NO:YES];

        //自己不能关注自己
        if ([UserModel shareInstance].id == self.movieModel.userID.integerValue) {
            self.followbtn.hidden = YES;
        }
        //0(flase) 未喜欢,已喜欢
        [self.CollowBtn setSelected:self.movieModel.isHeart == 0?NO:YES];
        self.nameLabel.text = self.movieModel.userName;
        self.fansLabel.text = [NSString stringWithFormat:@"%lD粉丝",(long)self.movieModel.followCount];
        self.VoidoNameLB.text = self.movieModel.title;
        [self.VoidoNameLB sizeToFit];
        //用户图像
        NSString *imgURL = self.movieModel.userPhoto;
        if ([Utils checkTextEmpty:imgURL]) {
            [self.btnPeople setBackgroundImageForState:UIControlStateNormal withURL:[imgURL mj_url]
                                      placeholderImage:K_APP_DEFAULT_USER_IMAGE];
        }
        else{
            [self.btnPeople setBackgroundImage:K_APP_DEFAULT_USER_IMAGE forState:UIControlStateNormal];
        }
    });

    //广告加载
    if (self.movieModel.playAdv) {
        //开启倒计时
        if(!isSecond){
            //广告图片或广告视频地址
            NSString *strInfo = [NSString stringWithFormat:@"%@",[self.movieModel.playAdv objectForKey:@"cover"]];

            //广告文件类型 1 图片 2 视频
            NSInteger resType = [[self.movieModel.playAdv objectForKey:@"resType"] integerValue];

            //MARK:视频播放前的视频广告
            if (resType == 2) {
                self.flimgPlayAD.hidden = YES;

                self.playManager.assetURL = [strInfo mj_url];
                [self.playManager play];

                ZWWLog(@"视频广告地址：%@",strInfo);
            }
            //MARK:视频播放前的图片广告
            else{
                self.flimgPlayAD.hidden = NO;
                if ([strInfo hasPrefix:@"http"]) {
                    if ([strInfo hasSuffix:@"gif"]) {
                        self.flimgPlayAD.image = K_APP_DEFAULT_IMAGE_BIG;

                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            [Utils loadGIFImage:strInfo AndFLAnimatedImageView:self.flimgPlayAD];
                        });
                    }
                    else{
                        [self.flimgPlayAD sd_setImageWithURL:[strInfo mj_url]
                                            placeholderImage:K_APP_DEFAULT_IMAGE_BIG];
                    }
                }
            }
            //MARK:广告倒计时
            self.btnGo.hidden = NO;
            [self performSelector:@selector(startCountDown) withObject:self afterDelay:1];
        }
        isSecond = YES;
    }
    //没有广告
    else{
        self.btnGo.hidden = YES;
        self.flimgPlayAD.hidden = YES;

        if(!isSecond){
            NSString *urlStr;
            if ([self.movieModel.url hasPrefix:@"http"]) {
                urlStr = self.movieModel.url;
            }
            else {
                NSArray *array = [self.movieModel.serverUrl componentsSeparatedByString:@"/API/Upload"];
                urlStr = [NSString stringWithFormat:@"%@/Upload/%@",array.firstObject,self.movieModel.url];
            }
            [self.playManager setAssetURL:[urlStr mj_url]];
            [self.playManager prepareToPlay];
        }
        isSecond = YES;
    }
}
//
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
  //section里面.创建 喜欢itemview  如果有广告.创建广告imageview 个人相关信息
    if (section == 0) {
        return self.headView;
    }else if (section == 1){
        UIView *shareView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, K_APP_WIDTH, 50)];
        shareView.backgroundColor = [UIColor clearColor];
        NSMutableArray *imageARR = [[NSMutableArray alloc] initWithObjects:@"CollectionIconNorme",@"shareIcon",@"WebIcon",@"VIPLinkIcon", nil];
        NSMutableArray *selectedARR = [[NSMutableArray alloc] initWithObjects:@"collect2",@"shareIcon",@"WebIcon",@"VIPLinkIcon", nil];
        NSMutableArray *TitleARR = [[NSMutableArray alloc] initWithObjects:@"喜欢",@"分享",@"网页",@"线路一", nil];
        for (int i = 0; i < imageARR.count ; i++) {
            UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            itemBtn.tag = i;
            itemBtn.frame = CGRectMake(5 + 75*i, 10, 60, 35);
            [itemBtn addTarget:self action:@selector(ItemBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [itemBtn setTitle:TitleARR[i] forState:UIControlStateNormal];
            [itemBtn setImage:[UIImage imageNamed:imageARR[i]] forState:UIControlStateNormal];
            [itemBtn setImage:[UIImage imageNamed:selectedARR[i]] forState:UIControlStateSelected];
            [itemBtn setImgViewStyle:ButtonImgViewStyleLeft imageSize:CGSizeMake(30, 30) space:5];
            itemBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            [itemBtn setTitleColor:[UIColor colorWithHexString:@"#000000"] forState:UIControlStateNormal];
            if (i == 0) {
                self.CollowBtn = itemBtn;
            }
            [shareView addSubview:itemBtn];
        }
        return shareView;
    }else if (section == 2){//广告
        UIView *headView = [[UIView alloc]init];
        headView.backgroundColor = [UIColor clearColor];
        if (self.movieModel && self.movieModel.adv) {
            //添加广告.
            headView.frame = CGRectMake(0, 0, K_APP_WIDTH, 177);
            if (![[headView subviews] containsObject:self.flimgCommentAD]) {
                [headView addSubview:self.flimgCommentAD];
            }
            NSString *strInfo = [NSString stringWithFormat:@"%@",[self.movieModel.adv objectForKey:@"cover"]];
            if ([strInfo hasPrefix:@"http"]) {
                if ([strInfo hasSuffix:@"gif"]) {
                    self.flimgCommentAD.image = K_APP_DEFAULT_IMAGE_BIG;
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        [Utils loadGIFImage:strInfo AndFLAnimatedImageView:self.flimgCommentAD];
                    });
                }
                else{
                    [self.flimgCommentAD sd_setImageWithURL:[strInfo mj_url]
                                           placeholderImage:K_APP_DEFAULT_IMAGE_BIG];
                }
            }
        }else{
            headView.frame = CGRectMake(0, 0, 0.01, 0.001);
        }
        return headView;
    }else if (section == 3){//评论列表和个人信息展示
        UIView *headView = [[UIView alloc]init];
        headView.backgroundColor = [UIColor clearColor];
        headView.frame = CGRectMake(0, 0, K_APP_WIDTH, 140);
        self.btnPeople.frame = CGRectMake(18, 5, 56, 56);
        self.btnPeople.layer.cornerRadius = 28;
        self.btnPeople.layer.masksToBounds = YES;
        [headView addSubview:self.btnPeople];
        self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.btnPeople.frame)+11, 17, 150, 14);
        [headView addSubview:self.nameLabel];
        self.fansLabel.frame = CGRectMake(CGRectGetMaxX(self.btnPeople.frame)+11, CGRectGetMaxY(self.nameLabel.frame) + 10, 150, 12);
        [headView addSubview:self.fansLabel];
        self.MessageBtn.frame = CGRectMake(K_APP_WIDTH - 7 - 99, 17, 99, 27);
        [headView addSubview:self.MessageBtn];
        self.followbtn.frame = CGRectMake(K_APP_WIDTH - 7 - 99, 17 + 8 + 27, 99, 27);
        [headView addSubview:self.followbtn];
        self.VoidoNameLB.frame = CGRectMake(16, CGRectGetMaxY(self.btnPeople.frame) + 20, K_APP_WIDTH - 32, 20);
        [headView addSubview:self.VoidoNameLB];
        self.likeBtn.frame = CGRectMake(16, CGRectGetMaxY(self.VoidoNameLB.frame) + 20, 100, 20);
        [headView addSubview:self.likeBtn];
        self.commentBtn.frame = CGRectMake(CGRectGetMaxX(self.likeBtn.frame), CGRectGetMaxY(self.VoidoNameLB.frame) + 20, 100, 20);
        [headView addSubview:self.commentBtn];
        return headView;
    }else{///section  为4的时候
        UIView *contentView = [[UIView alloc] init];
        contentView.userInteractionEnabled = YES;
        contentView.tag = section;
        //点击回复评论
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startComment:)];
        [contentView addGestureRecognizer:tap];
        contentView.frame = CGRectMake(0, 0, K_APP_WIDTH, 80);
        NSInteger nsection = section - 4;
        if (_commnetModel.data && [_commnetModel.data count] > nsection) {
            //MARK:用户头像
            UIImageView *headImageView = [[UIImageView alloc]init];
            headImageView.userInteractionEnabled = YES;
            headImageView.tag = nsection;
            [contentView addSubview:headImageView];
            [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(15);
                make.centerY.equalTo(contentView);
                make.width.mas_equalTo(40);
                make.height.mas_equalTo(40);
            }];
            [headImageView sd_setImageWithURL:urlWith(_commnetModel.data[nsection].photo) placeholderImage:K_APP_DEFAULT_USER_IMAGE];
            [headImageView wyh_autoSetImageCornerRedius:20 ConrnerType:UIRectCornerAllCorners];
            UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc]init];
            [headImageView addGestureRecognizer:tapGest];
            //6.手势监听方法
            [tapGest addTarget:self action:@selector(btnPeopleClick:)];

            //MARK:用户名称
            UILabel *nickName = [UILabel new];
            [contentView addSubview:nickName];
            nickName.font = FONTOFPX(24);
            nickName.textColor = [UIColor colorWithHexString:@"#000000"];
            [nickName mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(headImageView.mas_right).offset(15);
                make.top.mas_equalTo(15);
            }];
            nickName.text = _commnetModel.data[nsection].userName;
            //MARK:几楼和时间
            UILabel *userFloor = [UILabel new];
            [contentView addSubview:userFloor];
            userFloor.font = FONTOFPX(20);
            userFloor.textColor = [UIColor colorWithHexString:@"#999999"];
            [userFloor mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(headImageView.mas_right).offset(15);
                make.top.equalTo(nickName.mas_bottom).offset(9);
            }];
            userFloor.text = [_commnetModel.data[nsection].floor stringByAppendingString:@"楼"];

            //MARK:发送时间
            UILabel *sendTime = [UILabel new];
            [contentView addSubview:sendTime];

            sendTime.font = FONTOFPX(20);
            sendTime.textColor = [UIColor colorWithHexString:@"#999999"];
            [sendTime mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(userFloor.mas_right).offset(15);
                make.top.equalTo(nickName.mas_bottom).offset(9);
            }];
            sendTime.text = _commnetModel.data[nsection].sendTime;

            //MARK:评论内容
            UILabel *context = [UILabel new];
            context.numberOfLines = 0;
            [contentView addSubview:context];

            context.font = FONTOFPX(26);
            context.textColor = [UIColor colorWithHexString:@"#000000"];
            [context mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(headImageView.mas_right).offset(15);
                make.top.equalTo(nickName.mas_bottom).offset(25);
                make.right.mas_equalTo(contentView.mas_right).with.mas_offset(-15);
            }];
            context.text = _commnetModel.data[nsection].context;

            //MARK:分割线
            UIView *lineView = lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, K_APP_WIDTH, 0.5)];
            [contentView addSubview:lineView];
            lineView.backgroundColor = K_APP_SPLIT_LINE_COLOR;
        }

        return contentView;
        
    }
    return [UIView new];

}
//MARK: - 回复评论
-(void)startComment:(UITapGestureRecognizer *)sender{
    NSInteger index = sender.view.tag - 4;
    ZWWLog(@"点的哪个head:%ld",(long)index);
    if (_commnetModel && _commnetModel.data && [_commnetModel.data count] > index) {
        self.commendId = [NSString stringWithFormat:@"%ld",(long)_commnetModel.data[index].commentId];
        self.commentField.placeholder = [NSString stringWithFormat:@"回复:%@",_commnetModel.data[index].userName];
        [self.commentField becomeFirstResponder];
    }
    else{
        [YJProgressHUD showInfo:@"回复评论编号有误"];
    }
}
//总体 分为4section.一个,展示 分享  一个展示广告 一个展示用户相关信息 顶部是一个 播放器
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger section = 4; //原始  就是4个section
    if (_commnetModel)
    section += _commnetModel.dataCount;
//    if (self.movieModel && self.movieModel.adv)
//    section += 1;
    return section;
}
//MARK:列内容
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 || section == 1 || section == 2 || section == 3) {//播放条.广告
        return 0;
    }else {
        if (_commnetModel && _commnetModel.data && [_commnetModel.data count] > section - 3)
        return _commnetModel.data[section - 4].subComments.count;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //需要提前计算 评论内容的尺寸
    if (indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 2|| indexPath.section == 3) {
        return 0;
    }else{
        NSInteger indexSection = indexPath.section - 4;
        if (_commnetModel && _commnetModel.data && [_commnetModel.data count] > indexSection){
            if (_commnetModel.data[indexSection].subComments && [_commnetModel.data[indexSection].subComments count] > indexPath.row) {
                SubComments *model = _commnetModel.data[indexSection].subComments[indexPath.row];
                return model.cellHeight;
            }
        }
    }
    return 30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentsCell *cell = [CommentsCell xibWithTableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    NSInteger indexSection = indexPath.section - 4;
    if (_commnetModel && _commnetModel.data && [_commnetModel.data count] > indexSection){
        if (_commnetModel.data[indexSection].subComments && [_commnetModel.data[indexSection].subComments count] > indexPath.row) {
            SubComments *model = _commnetModel.data[indexSection].subComments[indexPath.row];
            cell.nickName.text = model.userName;
            cell.subContext.text = model.context;
            [cell.userImageView sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:K_APP_DEFAULT_USER_IMAGE];
            [cell.userImageView wyh_autoSetImageCornerRedius:15 ConrnerType:UIRectCornerAllCorners];
            int floor = [model.floor intValue] + 1;
            cell.desLB.text = [NSString stringWithFormat:@"%d楼 %@",floor,model.sendTime];
        }
    }
    return cell;
}
#pragma 横竖屏的修改这在里进行修改
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    //3个section  高度都已经知道.除非没有广告的视频  0 itemView   1 广告   2 个人信息   3 评论
    if (section == 0) {//这里是播放器
        CGFloat h;
        if (self.IsVerticalScreen) {
            h = k_table_head_view_h;
        }else{
            h = k_table_head_view_hTwo + K_APP_NAVIGATION_BAR_HEIGHT;
        }
        return h;
    }else if (section == 1){
        return 50;
    }else if (self.movieModel && self.movieModel.adv && section == 2){
        return 177;
    }else if (section == 3){//用户信息
        return 140;
    }else if (section == 2 && ZWWOBJECT_IS_EMPYT(self.movieModel.adv)){//没有广告.该section 高度忽略不急
        return 0.01;
    }else{//其余..全部返回 80  最后,需要根据g内容多少,计算section的高度
         NSInteger indexSection = section - 4;
        if (_commnetModel && _commnetModel.data && [_commnetModel.data count] > indexSection){
            CommentsData *model = _commnetModel.data[indexSection];
            return model.cellHeight;
        }else{
            return k_table_section_view_h;
        }
    }
}

//MARK: - 加载推广信息(确认是否有观看、下载次数)==这个版本不再需要啦
- (void)getCodeData {
    [self loadMovieDetailData];
}
//MARK: - 视频详情数据加载
- (void)loadMovieDetailData{
    if (!self.movieModel) {
        __weak typeof(self) weakSelf = self;
        [Utils loadMoviesDetailsDataWithVId:[NSString stringWithFormat:@"%lD",(long)self.videoId]
                                abdCallback:^(id  _Nullable responseData, NSString * _Nullable strMsg) {
                                    if (responseData && [MovieDetailModel mj_objectWithKeyValues:responseData]) {

                                        MovieDetailModel *_movieModel = [MovieDetailModel mj_objectWithKeyValues:responseData];

                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [weakSelf updateUI];
                                        });
                                        _movieModel.videoHeight = _movieModel.videoHeight;
                                        _movieModel.videoWidth = _movieModel.videoWidth;
                                        _movieModel.IsVerticalScreen = _movieModel.IsVerticalScreen;
                                        //添加观看历史记录
                                        [[FMDBUtils shareInstance] addHistoryMoves:_movieModel];
                                    }
                                    else{
                                        [YJProgressHUD showError:strMsg?strMsg:@"视频加载失败"];
                                    }

                                    [weakSelf.refreshTableView reloadData];
                                } andisLoading:YES];
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateUI];
        });
    }
}
//MARK: - 加载评论
-(void)loadCommentData{
    NSString *strUtl = [NSString stringWithFormat:@"%@Comments",K_APP_HOST];
    NSDictionary *dicParam = @{ @"id" : @"0",
                                @"vid" : [NSString stringWithFormat:@"%lD",(long)self.videoId]};
    __weak typeof(self) weakSelf = self;
    __block typeof(self) blockSelf = self;
    [Utils getRequestForServerData:strUtl
                    withParameters:dicParam
                AndHTTPHeaderField:^(AFHTTPRequestSerializer * _Nullable _requestSerializer) {
                    [_requestSerializer setValue:LOGIN_COOKIE forHTTPHeaderField:LOGIN_COOKIE_KEY];
                } AndSuccessBack:^(id  _Nullable _responseData) {
                    ZWWLog(@"视频评论加载成功！详见：%@",_responseData);

                    if (_responseData) {
                        blockSelf->_commnetModel = [CommentsModel mj_objectWithKeyValues:_responseData];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakSelf updateUI];
                        });
                    }
                    [weakSelf.refreshTableView reloadData];
                }
                    AndFailureBack:^(NSString * _Nullable _strError) {
                        ZWWLog(@"视频评论加载失败！详见：%@",_strError);
                    }
                     WithisLoading:NO];
}
//MARK: - 增加在线时间
-(void)addOnlineTime{
    NSString *strUrl = [NSString stringWithFormat:@"%@OnlineTime",K_APP_HOST];
    NSDictionary *dicParams = @{@"time":@"5"};
    [Utils putRequestForServerData:strUrl
                    withParameters:dicParams
                    AndSuccessBack:^(id  _Nullable _responseData, NSString * _Nullable strMsg) {
                        ZWWLog(@"增加在线时间成功");
                    }
                    AndFailureBack:^(NSString * _Nullable _strError) {
                        ZWWLog(@"增加在线时间异常!详见L：%@",_strError);
                    } WithisLoading:NO];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.player.viewControllerDisappear = NO;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.player.isFullScreen) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}
- (BOOL)shouldAutorotate {
    return self.player.shouldAutorotate;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.player.isFullScreen) {
        return UIInterfaceOrientationMaskLandscape;
    }
    return UIInterfaceOrientationMaskPortrait;
}
-(void)backHome:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
/** 顶部导航 */
- (UIView *)navTopView{
    if (!_navTopView) {
        _navTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, K_APP_WIDTH, K_APP_NAVIGATION_BAR_HEIGHT)];
        _navTopView.backgroundColor = [UIColor clearColor];
        //_navTopView.alpha = k_nav_view_alpha;
        //MARK:back
        CGFloat w = 40;
        CGFloat h = 40;
        CGFloat y2 = (44 - h) * 0.5 + ([[UIDevice currentDevice] isiPhoneX]?K_APP_IPHONX_TOP:20);
        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, y2, w, h)];
        [backBtn setImage:ims(@"newback.png") forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backHome:) forControlEvents:UIControlEventTouchUpInside];
        [_navTopView addSubview:backBtn];
    }
    return _navTopView;
}
//MARK: - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.IsVerticalScreen) {
        if (scrollView.contentOffset.y > k_conment_view_height) {
            [UIView animateWithDuration:0.35 animations:^{
                self.discussView.backgroundColor = [UIColor whiteColor];
                [self.btnConmment setBackgroundImage:[UIImage imageNamed:@"talkiconhui"] forState:UIControlStateNormal];
            }];
        }else{
            [UIView animateWithDuration:0.35 animations:^{
                self.discussView.backgroundColor = [UIColor clearColor];
                [self.btnConmment setBackgroundImage:[UIImage imageNamed:@"talkicon"] forState:UIControlStateNormal];
            }];
        }
    }
    //正在向上滑动
    if (scrollView.contentOffset.y - self.lastOffSetY > 0) {
        [UIView animateWithDuration:0.35 animations:^{
            self->_navTopView.alpha = 0;
        }];
    }
    //正在向下滑动
    else {
        [UIView animateWithDuration:0.35 animations:^{
            //self->_navTopView.alpha = k_nav_view_alpha;
            self->_navTopView.alpha = 1;
        }];
    }
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.lastOffSetY = scrollView.contentOffset.y;
    //ZWWLog(@"滑动的最后偏移量====%f",self.lastOffSetY)
}
//MARK: - UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSUInteger length = textField.text.length;
    NSUInteger strLength = string.length;
    //MARK:评论长度限制
    if(strLength != 0 && textField == self.commentField && length >= 20){
        return NO;
    }
    //回车发送
    if ([string isEqualToString:@"\n"]) {
        [self sendComment:nil];
    }
    return YES;
}
-(void)sendComment:(UIButton *)sender{
    if (![UserModel userIsLogin]) {
        [self userToLogin:(LoginViewControllerDelegate *)self];
        return;
    }
    NSString *strComment = [self.commentField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (![Utils checkTextEmpty:strComment]) {
        [YJProgressHUD showError:@"请输入评论内容"];
        return;
    }
    if (self.commendId == nil) {
        self.commendId = @"0";
    }
    NSString *strUrl = [NSString stringWithFormat:@"%@Comment",K_APP_HOST];
    NSDictionary *dicParams = @{
                                @"videoID":[NSString stringWithFormat:@"%ld",(long)self.videoId],
                                @"parentID":self.commendId,
                                @"context":strComment,
                                @"deviceID":[Utils dy_getIDFV]
                                };
    __weak typeof(self) weakSelf = self;
    __block typeof(self) blockSelf = self;
    [Utils postRequestForServerData:strUrl
                     withParameters:dicParams
                 AndHTTPHeaderField:^(AFHTTPRequestSerializer * _Nullable _requestSerializer) {
                     [_requestSerializer setValue:LOGIN_COOKIE forHTTPHeaderField:LOGIN_COOKIE_KEY];
                 }
                     AndSuccessBack:^(id  _Nullable _responseData) {
                         [YJProgressHUD showSuccess:@"评论成功"];
                         blockSelf->_commnetModel.dataCount += 1;
                         dispatch_async(dispatch_get_main_queue(), ^{
                             [weakSelf.commentField setText:@""];
                             [weakSelf.commentField resignFirstResponder];
                             [weakSelf updateUI];
                         });
                         [weakSelf loadCommentData];
                         [weakSelf.refreshTableView reloadData];
                         //委托处理
                         if (weakSelf.delegate && weakSelf.indexPath && [weakSelf.delegate respondsToSelector:@selector(moviesDetailsCommentsUpdateActionForValue:AndIndexPath:)]) {

                             [weakSelf.delegate moviesDetailsCommentsUpdateActionForValue:blockSelf->_commnetModel.dataCount AndIndexPath:weakSelf.indexPath];
                         }
                     }
                     AndFailureBack:^(NSString * _Nullable _strError) {
                         ZWWLog(@"发送评论失败！详见：%@",_strError);
                         [YJProgressHUD showError:_strError];
                     }
                      WithisLoading:NO];
}
//MARK: - initUI
- (void)initUI{
    CGFloat y = 0;
    CGFloat h = K_APP_HEIGHT - y;
    //CGFloat h = K_APP_HEIGHT - y;
    if ([[UIDevice currentDevice] isiPhoneX]) {
        //h -= K_APP_IPHONX_BUTTOM;
    }
    if (@available(iOS 11.0, *)) {
        self.refreshTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.view.safeAreaInsets.top, K_APP_WIDTH, h)
                                                             style:UITableViewStylePlain];
    } else {
        self.refreshTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, K_APP_WIDTH, h)
                                                             style:UITableViewStylePlain];
    }
    if (@available(iOS 11.0, *)) {
        self.refreshTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.refreshTableView.backgroundColor = [UIColor clearColor];
    self.refreshTableView.delegate = self;
    self.refreshTableView.dataSource = self;
    if (@available(iOS 11.0, *)) {
        if (self.IsVerticalScreen) {
            self.headView.frame = CGRectMake(0, self.view.safeAreaInsets.top, K_APP_WIDTH, k_table_head_view_h);
        }else{
            self.headView.frame = CGRectMake(0, self.view.safeAreaInsets.top, K_APP_WIDTH, k_table_head_view_hTwo + K_APP_NAVIGATION_BAR_HEIGHT);
        }
    } else {
        if (self.IsVerticalScreen) {
            self.headView.frame = CGRectMake(0, 0, K_APP_WIDTH, k_table_head_view_h);
        }else{
            self.headView.frame = CGRectMake(0, 0, K_APP_WIDTH, k_table_head_view_hTwo + K_APP_NAVIGATION_BAR_HEIGHT);
        }
    }
    [self.refreshTableView setTableHeaderView:[UIView new]];
    UILabel *line = [BaseUIView createLable:CGRectMake(0, 0, K_APP_WIDTH, k_conment_view_height + 30)
                                    AndText:nil
                               AndTextColor:nil
                                 AndTxtFont:nil
                         AndBackgroundColor:[UIColor clearColor]];
    self.refreshTableView.tableFooterView = line;
    self.refreshTableView.showsVerticalScrollIndicator = NO;
    self.refreshTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.refreshTableView];
    //MARK:navTopView 顶部分享按钮
    [self.view addSubview:self.navTopView];
    [self.view bringSubviewToFront:self.navTopView];
    //MARK:评论视图
    [self.view addSubview:self.discussView];
    [self.view bringSubviewToFront:self.discussView];
}
-(UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc] init];
        _headView.backgroundColor = [UIColor blackColor];
        [_headView addSubview:self.containerView];
        //MARK:播放相关
        @weakify(self)
        self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
            @strongify(self)
            [self setNeedsStatusBarAppearanceUpdate];
        };
        //这里,取消封面
        [self.controlView showTitle:@"" coverURLString:_movieModel.cover fullScreenMode:ZFFullScreenModeLandscape];
    }
    return _headView;
}
//关注
-(void)FollowPeople:(UIButton *)sender{
    if (![UserModel userIsLogin]) {
        [self userToLogin:(LoginViewControllerDelegate *)self];
        return;
    }
    BOOL isFollow = NO;
    //当前未关注(0) -> 点击变为已关注
    if (self.movieModel.isFollow == 0)
    isFollow = YES;
    __weak typeof(self) weakSelf = self;
    __block typeof(self) blockSelf = self;
    [Utils collectionUserOrNoWithId:self.movieModel.userID
                            AndFlow:isFollow
                         AndLoading:YES
                     withFinishback:^(BOOL isSuccess) {
                         if (isSuccess) {
                             //数据状态改变
                             blockSelf.movieModel.isFollow = isFollow?1:0;
                             NSInteger followCount = weakSelf.movieModel.followCount;
                             followCount = isFollow?++followCount:--followCount;
                             if (followCount <= 0) followCount = 0;
                             blockSelf.movieModel.followCount = followCount;
                             //委托处理
                             if (weakSelf.delegate && weakSelf.indexPath && [weakSelf.delegate respondsToSelector:@selector(moviesDetailsCollectionUpdateActionForValue:AndIndexPath:)]) {
                                 [weakSelf.delegate moviesDetailsCollectionUpdateActionForValue:followCount AndIndexPath:weakSelf.indexPath];
                             }
                             //更新UI
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 sender.selected = !sender.selected;
                                 [weakSelf updateUI];
                             });
                         }
                     }];
}
-(void)MessageBtnClick:(UIButton *)sender{
    //关注后才可以发送私信
    if (self.movieModel.isFollow == 0?NO:YES) {
        MessageVC *meesageVC = [[MessageVC alloc]init];
        meesageVC.userId = self.movieModel.userID;
        [self.navigationController pushViewController:meesageVC animated:YES];
    }else{
        [YJProgressHUD showMessage:@"关注后才可以发送私信"];
    }
}
-(void)btnPeopleClick:(UITapGestureRecognizer *)tapGest{
    ZWUserDetialVC *vc;
    UIImageView * sender = (UIImageView *)tapGest.view;
    NSInteger nsection = sender.tag;
    if(_commnetModel.data && [_commnetModel.data count] > nsection){
        vc = [[ZWUserDetialVC alloc] init];
        CommentsData *model = _commnetModel.data[nsection];
        vc.userId = [NSString stringWithFormat:@"%lD",(long)model.userID];
        vc.userName = model.userName;
    }
    if (vc) {
        __weak typeof(self) weakSelf = self;
        [Utils getInfosModelForUserId:[vc.userId integerValue]
                           andLoading:YES
                        andFinishback:^(InfosModel * _Nullable model) {
                            vc.infoModel = model;
                            [weakSelf.navigationController pushViewController:vc animated:YES];
                        }];
    }
    else{
        [YJProgressHUD showInfo:@"数据不存在，请稍后再试"];
    }
}
-(void)btnPeopleClickk:(UIButton *)sender{
    ZWUserDetialVC *vc;
    NSInteger nsection = sender.tag;
    if (sender == self.btnPeople && self.movieModel) {
        vc = [[ZWUserDetialVC alloc] init];
        vc.userId = self.movieModel.userID;
        vc.userName = self.movieModel.userName;
    }
    else if(_commnetModel.data && [_commnetModel.data count] > nsection){
        vc = [[ZWUserDetialVC alloc] init];
        CommentsData *model = _commnetModel.data[nsection];
        vc.userId = [NSString stringWithFormat:@"%lD",(long)model.userID];
        vc.userName = model.userName;
    }
    if (vc) {
        __weak typeof(self) weakSelf = self;
        [Utils getInfosModelForUserId:[vc.userId integerValue]
                           andLoading:YES
                        andFinishback:^(InfosModel * _Nullable model) {
                            vc.infoModel = model;
                            [weakSelf.navigationController pushViewController:vc animated:YES];
                        }];
    }
    else{
        [YJProgressHUD showInfo:@"数据不存在，请稍后再试"];
    }
}
-(UIButton *)followbtn{
    if (_followbtn == nil) {
        _followbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_followbtn setBackgroundImage:[UIImage imageNamed:@"关注"] forState:UIControlStateNormal];
        [_followbtn setBackgroundImage:[UIImage imageNamed:@"取消关注"] forState:UIControlStateSelected];
        [_followbtn addTarget:self action:@selector(FollowPeople:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _followbtn;
}
-(UIButton *)MessageBtn{
    if (_MessageBtn == nil) {
        _MessageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_MessageBtn setBackgroundImage:[UIImage imageNamed:@"sixinIconVideodetial"] forState:UIControlStateNormal];
        [_MessageBtn setTitle:@"私信TA" forState:UIControlStateNormal];
        _MessageBtn.titleLabel.font = [UIFont systemFontOfSize:12.8];
        [_MessageBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        [_MessageBtn addTarget:self action:@selector(MessageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _MessageBtn;
}
-(UIButton *)btnPeople{
    if (_btnPeople == nil) {
        _btnPeople = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnPeople setBackgroundImage:[UIImage imageNamed:@"VoideUserImage"] forState:UIControlStateNormal];
        [_btnPeople addTarget:self action:@selector(btnPeopleClickk:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnPeople;
}
-(UIButton *)likeBtn{
    if (_likeBtn == nil) {
        _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_likeBtn setImage:[UIImage imageNamed:@"likeNumIcon"] forState:UIControlStateNormal];
        [_likeBtn setImgViewStyle:ButtonImgViewStyleLeft imageSize:CGSizeMake(22, 20) space:12];
        _likeBtn.titleLabel.font = [UIFont systemFontOfSize:12.8];
        [_likeBtn setTitleColor:[UIColor colorWithHexString:@"#7AA2ED"] forState:UIControlStateNormal];
    }
    return _likeBtn;
}
-(UIButton *)commentBtn{
    if (_commentBtn == nil) {
        _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentBtn setImage:[UIImage imageNamed:@"commentIconnum"] forState:UIControlStateNormal];
        [_commentBtn setImgViewStyle:ButtonImgViewStyleLeft imageSize:CGSizeMake(22, 20) space:12];
        _commentBtn.titleLabel.font = [UIFont systemFontOfSize:12.8];
        [_commentBtn setTitleColor:[UIColor colorWithHexString:@"#7AA2ED"] forState:UIControlStateNormal];
    }
    return _commentBtn;
}
-(UILabel *)nameLabel{
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = [UIColor colorWithHexString:@"#000000"];
        _nameLabel.font = [UIFont systemFontOfSize:15.36];
    }
    return _nameLabel;
}
-(UILabel *)fansLabel{
    if (_fansLabel == nil) {
        _fansLabel = [[UILabel alloc]init];
        _fansLabel.textColor = [UIColor colorWithHexString:@"#000000"];
        _fansLabel.font = [UIFont systemFontOfSize:13.44];
    }
    return _fansLabel;
}
-(UILabel *)VoidoNameLB{
    if (_VoidoNameLB == nil) {
        _VoidoNameLB = [[UILabel alloc]init];
        _VoidoNameLB.textColor = [UIColor colorWithHexString:@"#000000"];
        _VoidoNameLB.font = [UIFont boldSystemFontOfSize:19.2];
        _VoidoNameLB.numberOfLines = 0;
    }
    return _VoidoNameLB;
}
- (UIView *)discussView{
    if (!_discussView) {
        CGFloat h = k_conment_view_height;
        CGFloat y = K_APP_HEIGHT - h;
        if ([[UIDevice currentDevice] isiPhoneX])
        y -= K_APP_IPHONX_BUTTOM;
        _discussView = [[UIView alloc] initWithFrame:CGRectMake(0, y, K_APP_WIDTH, h)];
        if (self.IsVerticalScreen) {
            _discussView.backgroundColor = [UIColor clearColor];
        }else{
            _discussView.backgroundColor = [UIColor whiteColor];
        }
        //MARK:评论框
        [_discussView addSubview:self.commentField];
        [self.commentField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(60);
            make.centerY.equalTo(self.discussView);
            make.right.mas_equalTo(-50);
            make.height.mas_equalTo(30);
        }];
        //MARK:发送
        [_discussView addSubview:self.sendBtn];
        [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.left.equalTo(self.commentField.mas_right).offset(10);
            make.centerY.equalTo(self.discussView);
        }];
        //MARK:评论展开
        [_discussView addSubview:self.btnConmment];
    }
    return _discussView;
}
- (UITextField *)commentField{
    if (!_commentField) {
        _commentField = [UITextField new];
        _commentField.backgroundColor = [UIColor clearColor];
        _commentField.placeholder = @"说点什么...";
        _commentField.delegate = self;
        _commentField.returnKeyType = UIReturnKeySend;
        _commentField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
        _commentField.leftViewMode = UITextFieldViewModeAlways;
        _commentField.layer.cornerRadius = 15.0;
        [_commentField setPlaceholderColor:TextColor];
    }
    return _commentField;
}
-(UIButton *)sendBtn{
    if (!_sendBtn) {
        _sendBtn = [UIButton new];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        _sendBtn.titleLabel.font = FONTOFPX(24);
        [_sendBtn setTitleColor:[UIColor colorWithHexString:@"#1b9efc"] forState:UIControlStateNormal];
        [_sendBtn addTarget:self action:@selector(sendComment:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}
-(FLAnimatedImageView *)flimgCommentAD{
    if (!_flimgCommentAD) {
        _flimgCommentAD = [[FLAnimatedImageView alloc] initWithFrame:CGRectMake(0, 0, K_APP_WIDTH, 177)];
        _flimgCommentAD.userInteractionEnabled = YES;
        [Utils imgNoTransformation:_flimgCommentAD];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adClickAction:)];
        [_flimgCommentAD addGestureRecognizer:tap];
    }
    return _flimgCommentAD;
}
#pragma 这里需要根据横竖屏来进行适配播放前广告的尺寸
-(FLAnimatedImageView *)flimgPlayAD{
    if (!_flimgPlayAD) {
        CGFloat h = K_APP_WIDTH*9/16;////这里的高度  需要根据横竖屏d来进行适配
        CGFloat y = (self.controlView.frame.size.height - h) * 0.5;
        _flimgPlayAD = [[FLAnimatedImageView alloc] initWithFrame:CGRectMake(0, y, K_APP_WIDTH, h)];
        _flimgPlayAD.userInteractionEnabled = YES;
        _flimgPlayAD.backgroundColor = [UIColor greenColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adClickAction:)];
        [_flimgPlayAD addGestureRecognizer:tap];
    }
    return _flimgPlayAD;
}
//MARK: - 广告点击
-(void)adClickAction:(id)sender{
    NSString *strUrl;
    if([[sender view] isEqual:self.flimgCommentAD]){
        strUrl = [NSString stringWithFormat:@"%@",[self.movieModel.adv objectForKey:@"url"]];
    }
    if (strUrl && ![strUrl isEqualToString:@""] && ![strUrl isKindOfClass:[NSNull class]]) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:strUrl]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strUrl] options:@{} completionHandler:nil];
        }
    }
}
//MARK: - 倒计时
/** 开始倒计时 */
-(void)startCountDown{
    self.timerNo = 0;
    //按钮禁用
    [self.btnGo setEnabled:NO];
    //开启计时
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateUIInfo) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.timer fire];
}
/** 停止计时 */
-(void)stopCountDown{
    //停止
    if (self.timer != nil) {
        [self.timer invalidate];
        self.timer = nil;
    }
    //按钮启用
    self.btnGo.hidden = YES;
    [self.btnGo setTitle: @"" forState:UIControlStateNormal];
    [self hideShareView:YES];
}
-(void)hideShareView:(BOOL)hide{
    [self.playBtn setHidden:hide];
    [self.btnCopy setHidden:hide];
    [self.labShare setHidden:hide];
    [self.btnQQShare setHidden:hide];
    [self.btnWXShare setHidden:hide];
}
-(void)updateUIInfo{
    self.timerNo = self.timerNo + 1;
    NSInteger inteval = [[self.movieModel.playAdv objectForKey:@"playTime"] integerValue];
    if (self.timerNo < inteval) {
        NSString *strInfo = [NSString stringWithFormat:@"%lds",(long)(inteval - self.timerNo)];
        [self.btnGo setTitle:strInfo forState:UIControlStateNormal];
    }
    else{
        //停止计时
        [self stopCountDown];
        self.flimgPlayAD.hidden = YES;
        NSString *urlStr;
        if ([_movieModel.url hasPrefix:@"http"]) {
            urlStr = _movieModel.url;
        } else {
            NSArray *array = [_movieModel.serverUrl componentsSeparatedByString:@"/API/Upload"];
            urlStr = [NSString stringWithFormat:@"%@/Upload/%@",array.firstObject,_movieModel.url];
        }
        ZWWLog(@"播放地址：%@",urlStr);
        self.playManager.assetURL = [urlStr mj_url];
        [self.playManager play];
    }
}
-(UIButton *)btnGo{
    if (!_btnGo) {
        CGFloat w = 30;
        CGFloat h = 30;
        CGFloat x = K_APP_WIDTH - w - 20;
        CGFloat y = (44 - h) * 0.5 + ([[UIDevice currentDevice] isiPhoneX]?K_APP_IPHONX_TOP:20);

        NSInteger interval = 5;
        if (self.movieModel.playAdv) {
            interval = [[self.movieModel.playAdv objectForKey:@"playTime"] integerValue];
        }
        _btnGo = [BaseUIView createBtn:CGRectMake(x, y, w, h)
                              AndTitle:[NSString stringWithFormat:@"%lDs",(long)interval]
                         AndTitleColor:[UIColor whiteColor]
                            AndTxtFont:[UIFont systemFontOfSize:12]
                              AndImage:nil
                    AndbackgroundColor:nil
                        AndBorderColor:nil
                       AndCornerRadius:0
                          WithIsRadius:YES
                   WithBackgroundImage:nil
                       WithBorderWidth:0];
    }
    return _btnGo;
}
-(ZFPlayerController *)player{
    if (!_player) {
        __weak typeof(self) weakSelf = self;
        _player = [ZFPlayerController playerWithPlayerManager:weakSelf.playManager containerView:weakSelf.containerView];
        _player.controlView = weakSelf.controlView;
        //移动网络依然自动播放(默认NO)
        [_player setWWANAutoPlay:NO];
        //自动播放
        [_player setShouldAutoPlay:YES];
        //离开视图自动暂停
        [_player setPauseWhenAppResignActive:YES];
        //禁用哪些手势，默认支持单击、双击、滑动、缩放手势
        [_player setDisableGestureTypes:ZFPlayerDisableGestureTypesPan];
        //播放停止之后重置播放器
        _player.playerDidToEnd = ^(id  _Nonnull asset) {
            //MARK:广告视频重复播放
            if (weakSelf.btnGo.hidden == NO) {
                [weakSelf.playManager replay];
            }
            //MARK:正常视频播放结束
            else{
                [weakSelf.player stopCurrentPlayingCell];
                //显示重播和分享
                [weakSelf hideShareView:NO];
            }
        };
    }
    return _player;
}

-(ZFAVPlayerManager *)playManager{
    if (!_playManager) {
        _playManager = [[ZFAVPlayerManager alloc] init];
    }
    return _playManager;
}
- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
        _controlView.fastViewAnimated = YES;
        _controlView.fullScreenOnly = YES;
        _controlView.effectViewShow = YES;
        _controlView.autoHiddenTimeInterval = 3.5;
        _controlView.autoFadeTimeInterval = 0.5;
        _controlView.prepareShowLoading = YES;
        _controlView.prepareShowControlView = NO;
        _controlView.backgroundColor = [UIColor clearColor];
        //这上面,是播放暂停之后的最上面的界面.在这里,添加分享,和重复播放按钮
        //MARK:分享到
        [_controlView addSubview:self.labShare];

        //MARK:复制地址
        [_controlView addSubview:self.btnCopy];
        [self.btnCopy mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.controlView).offset(-k_buttom_width - k_margin);
            make.centerY.equalTo(self.controlView).offset(k_buttom_width);
            make.width.height.mas_equalTo(k_buttom_width);
        }];

        //MARK:微信
        [_controlView addSubview:self.btnWXShare];
        [self.btnWXShare mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.controlView);
            make.centerY.equalTo(self.controlView).offset(k_buttom_width);
            make.width.height.mas_equalTo(k_buttom_width);
        }];

        //MARK:QQ
        [_controlView addSubview:self.btnQQShare];
        [self.btnQQShare mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.controlView).offset(k_buttom_width + k_margin);
            make.centerY.equalTo(self.controlView).offset(k_buttom_width);
            make.width.height.mas_equalTo(k_buttom_width);
        }];

        //MARK:重新播放
        CGFloat w = 100;
        [_controlView addSubview:self.playBtn];
        [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.controlView);
            make.centerY.equalTo(self.controlView).offset(k_buttom_width + 50);
            make.height.mas_equalTo(21);
            make.width.mas_equalTo(w);
        }];
//        [_controlView addSubview:self.btnExceptionalShare];
//        [self.btnExceptionalShare mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(50, 50));
//            make.right.mas_equalTo(self->_controlView.mas_right).with.mas_offset(-10);
//            make.bottom.mas_equalTo(self->_controlView.mas_centerY).with.mas_offset(-20);
//        }];
    }
    return _controlView;
}
- (UIView *)containerView{
    if (!_containerView) {
        CGFloat x = 0;
        CGFloat y = 0;
        if (!self.IsVerticalScreen) {
            y = K_APP_NAVIGATION_BAR_HEIGHT;
        }
        CGFloat w = K_APP_WIDTH;
        CGFloat h;
        if (self.IsVerticalScreen) {
            h = k_table_head_view_h;
        }else{
            h = k_table_head_view_hTwo;
        }
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        _containerView.backgroundColor = [UIColor blackColor];
    }
    return _containerView;
}
-(UILabel *)labShare{
    if (!_labShare) {
        CGFloat w = 2 * k_margin + 3 * k_buttom_width;
        CGFloat h = 21;
        CGFloat x = (K_APP_WIDTH - w) * 0.5;
        CGFloat y = (self.containerView.size.height - h) * 0.5;
        _labShare = [BaseUIView createLable:CGRectMake(x, y, w, h)
                                    AndText:@"––––––––––––– 分享到 –––––––––––––"
                               AndTextColor:[UIColor whiteColor]
                                 AndTxtFont:FONT(11)
                         AndBackgroundColor:nil];
        _labShare.textAlignment = NSTextAlignmentCenter;
        _labShare.hidden = YES;
    }
    return _labShare;
}
- (UIButton *)btnExceptionalShare{
    if (!_btnExceptionalShare) {
        _btnExceptionalShare = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnExceptionalShare setBackgroundImage:[UIImage imageNamed:@"赏"] forState:UIControlStateNormal];
        [_btnExceptionalShare addTarget:self action:@selector(ShangBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//        self.Shacktimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(shackBtnAction:) userInfo:nil repeats:YES];
//        [[NSRunLoop currentRunLoop] addTimer:self.Shacktimer forMode:NSRunLoopCommonModes];
//        [self.Shacktimer fire];
    }
    return _btnExceptionalShare;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.player.viewControllerDisappear = YES;
}
-(void)shackBtnAction:(UIButton *)sender{
  [self.btnExceptionalShare.layer shake];
}
- (UIButton *)playBtn{
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _playBtn.hidden = YES;
        [_playBtn setImage:ims(@"video_replay") forState:UIControlStateNormal];
        [_playBtn setTitle:@"  重播" forState:UIControlStateNormal];
        [_playBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(btnReplayAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}
- (UIButton *)btnCopy{
    if (!_btnCopy) {
        _btnCopy = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnCopy.hidden = YES;
        [_btnCopy setImage:ims(@"video_copy.png") forState:UIControlStateNormal];
        _btnCopy.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 20, 0);
        CGFloat h = 21;
        CGFloat y = k_buttom_width - h;
        UILabel *lab = [BaseUIView createLable:CGRectMake(0,y, k_buttom_width, h)
                                       AndText:@"复制地址"
                                  AndTextColor:[UIColor whiteColor]
                                    AndTxtFont:FONT(12)
                            AndBackgroundColor:nil];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.adjustsFontSizeToFitWidth = YES;
        [_btnCopy addSubview:lab];
        [_btnCopy addTarget:self action:@selector(btnShareAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnCopy;
}
- (UIButton *)btnWXShare{
    if (!_btnWXShare) {
        _btnWXShare = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnWXShare.hidden = YES;
        [_btnWXShare setImage:ims(@"video_wx.png") forState:UIControlStateNormal];
        _btnWXShare.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 20, 0);
        CGFloat h = 21;
        CGFloat y = k_buttom_width - h;
        UILabel *lab = [BaseUIView createLable:CGRectMake(0, y, k_buttom_width, h)
                                       AndText:@"微信"
                                  AndTextColor:[UIColor whiteColor]
                                    AndTxtFont:FONT(12)
                            AndBackgroundColor:nil];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.adjustsFontSizeToFitWidth = YES;
        [_btnWXShare addSubview:lab];
        [_btnWXShare addTarget:self action:@selector(btnShareAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnWXShare;
}
- (UIButton *)btnQQShare{
    if (!_btnQQShare) {
        _btnQQShare = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnQQShare.hidden = YES;
        [_btnQQShare setImage:ims(@"video_qq.png") forState:UIControlStateNormal];
        _btnQQShare.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 20, 0);
        CGFloat h = 21;
        CGFloat y = k_buttom_width - h;
        UILabel *lab = [BaseUIView createLable:CGRectMake(0, y, k_buttom_width, h)
                                       AndText:@"QQ"
                                  AndTextColor:[UIColor whiteColor]
                                    AndTxtFont:FONT(12)
                            AndBackgroundColor:nil];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.adjustsFontSizeToFitWidth = YES;
        [_btnQQShare addSubview:lab];
        [_btnQQShare addTarget:self action:@selector(btnShareAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnQQShare;
}
-(UIButton *)btnConmment{
    if (!_btnConmment) {
        CGFloat w = 30;
        CGFloat h = 30;
        CGFloat x = 15;
        CGFloat y = (k_conment_view_height - h) * 0.5;
        _btnConmment = [BaseUIView createBtn:CGRectMake(x, y, w, h)
                                    AndTitle:nil
                               AndTitleColor:nil
                                  AndTxtFont:nil
                                    AndImage:nil
                          AndbackgroundColor:nil
                              AndBorderColor:nil
                             AndCornerRadius:0
                                WithIsRadius:NO
                         WithBackgroundImage:[UIImage imageNamed:@"talkicon"]
                             WithBorderWidth:0];
        if (!self.IsVerticalScreen) {
            [_btnConmment setBackgroundImage:[UIImage imageNamed:@"talkiconhui"] forState:UIControlStateNormal];
        }
        _btnConmment.showsTouchWhenHighlighted = YES;
        [_btnConmment addTarget:self
                         action:@selector(btnShowOrHideAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnConmment;
}
-(void)btnShowOrHideAction:(UIButton *)sender{
    //收起
    CGPoint point = [self.refreshTableView contentOffset];
    if (sender.selected || point.y > 0) point = CGPointZero;
    //展开
    else {
        CGFloat h = self.containerView.frame.size.height;
        if ([[UIDevice currentDevice] isiPhoneX]) {
            h -= K_APP_IPHONX_TOP;
        }
        else{
            h -= self.navTopView.frame.size.height;
        }
        point = CGPointMake(0, h);
    }

    [self.refreshTableView setContentOffset:point animated:YES];
    sender.selected = !sender.selected;
}
-(void)ShangBtnAction:(UIButton *)sender{
    [YJProgressHUD showMessage:@"即将推出,敬请期待"];
}
-(void)btnShareAction:(UIButton *)sender{
    if (![UserModel userIsLogin]) {
        [self userToLogin:(LoginViewControllerDelegate *)self];
        return;
    }
    //JSNewShareVC *shareVC;
    NSString * strShareCopyUrl;
    NSString * strShareUrl;
    if(sender == self.btnCopy){
        UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
        pasteBoard.string = [NSString stringWithFormat:@"%@?%@",self.movieModel.shareVideoUrl,K_APP_SHARE_INFO];
        ZWWLog(@"copy share:%@",pasteBoard.string);
        [YJProgressHUD showInfo:@"已经复制，快去分享吧！"];
    }
    else if(sender == self.btnWXShare){
        //shareVC = [[JSNewShareVC alloc] init];
        strShareCopyUrl = self.movieModel.shareVideoUrl;
        strShareUrl = self.movieModel.shareWinXinUrl;
        [self.playManager pause];
    }
    else if(sender == self.btnQQShare){
        //shareVC = [[JSNewShareVC alloc] init];
        strShareCopyUrl = self.movieModel.shareVideoUrl;
        strShareUrl = self.movieModel.shareQQUrl;
        [self.playManager pause];
    }
    else{
        //shareVC = [[JSNewShareVC alloc] init];
        strShareCopyUrl = self.movieModel.shareVideoUrl;
        strShareUrl = self.movieModel.shareVideoUrl;
        //暂停
        [self.playManager pause];
    }
    NSString *itunesAddress = [NSString stringWithFormat:@"%@?%@",strShareUrl,K_APP_SHARE_INFO];;

    if (strShareUrl && ![strShareUrl isEqualToString:@""]){
        itunesAddress = strShareUrl;

        if (![itunesAddress containsString:K_APP_SHARE_INFO]) {
            itunesAddress = [NSString stringWithFormat:@"%@%@%@",strShareUrl,[strShareUrl containsString:@"?"]?@"&":@"?",K_APP_SHARE_INFO];
        }
    }

    __weak typeof(self) weakSelf = self;
    [Utils wxExtensionShareURL:itunesAddress
                       AndBack:^(UIActivityViewController *activityVC) {
                           [weakSelf presentViewController:activityVC
                                                  animated:YES completion:nil];
                       }];

}
//MARK: - 重新播放
-(void)btnReplayAction:(UIButton *)sender{
    [self.playManager replay];
    [sender setHidden:YES];
    [self hideShareView:YES];
}
//代理
-(void)loginFinishBack{
     [self getCodeData];
    if ([UserModel userIsLogin]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self loadCommentData];
        });
    }
    //增加在线时间
    if ([UserModel userIsLogin]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self addOnlineTime];
        });
    }
}

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
    
}

@end
