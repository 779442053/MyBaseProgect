

#import "ZWWIMViewController.h"
#import "ZWMessageViewModel.h"
#import "ZWImageViewController.h"

#import "WZMChat.h"

//录音相关

#import "ZWAudioRecorder.h"
#import "WZMRecordAnimation.h"


//cell

#import "WZMChatTextMessageCell.h"
#import "WZMChatVoiceMessageCell.h"
#import "WZMChatImageMessageCell.h"

#import "WZMChatMessageModel.h"

#import "ZWPhotoHelper.h"
@interface ZWWIMViewController ()<UITableViewDelegate,UITableViewDataSource,WZMInputViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, assign) ZWWMessageType type;
@property (nonatomic, strong) ZWMessageViewModel *ViewModel;
@property(nonatomic,strong)NSMutableArray< WZMChatMessageModel *> *messageARR;


///自定义表情键盘
@property (nonatomic, strong) WZMInputView *inputView;
@property (nonatomic, assign) CGFloat tableViewY;

@property (nonatomic, weak) id<UIGestureRecognizerDelegate> recognizerDelegate;

@property (nonatomic, assign, getter=isDeferredSystemGestures) BOOL deferredSystemGestures;

@property (nonatomic, strong) WZMRecordAnimation *recordAnimation;

@end

@implementation ZWWIMViewController
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
    self.tableViewY = self.frame.origin.y;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.inputView];
    [self setupRefresh];
    //屏蔽系统底部手势
    self.deferredSystemGestures = YES;
    @weakify(self)
    [[self.ViewModel.CustomerServiceMessages execute:nil] subscribeNext:^(NSMutableDictionary* x) {
        @strongify(self)
        if ([x[@"code"] intValue] == 0) {
            [self.messageARR addObjectsFromArray:x[@"res"]];
            [self.tableView reloadData];
            [self tableViewScrollToBottom:NO duration:0.25];
        }
    }completed:^{

    }];

}
- (void)setupRefresh{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    self.tableView.mj_header.lastUpdatedTimeKey = [NSString stringWithFormat:@"%@--%u", [self class],  self.type];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    //[self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer.hidden = YES;
}
- (void)loadNewTopics{
    //获取消息记录
    @weakify(self)
    [[self.ViewModel.CustomerMoreServiceMessages execute:nil] subscribeNext:^(NSMutableDictionary* x) {
        @strongify(self)
        if ([x[@"code"] intValue] == 0) {
            //放在数组的前面
            NSMutableArray *totalARR = [[NSMutableArray alloc]init];
            NSArray *currentARR = x[@"res"];
            [totalARR addObjectsFromArray:currentARR];
            [totalARR addObjectsFromArray:self.messageARR];
            self.messageARR = totalARR;
            [self.tableView reloadData];
        }else if ([x[@"code"] intValue] == 1){
            
        }
        [self.tableView.mj_header endRefreshing];
    }completed:^{
        [self.tableView.mj_header endRefreshing];
    }];
}
#pragma mark - 发送消息
//文本消息
- (void)inputView:(WZMInputView *)inputView sendMessage:(NSString *)message {
    //清空草稿
  ZWWLog(@"开始发送消息====%@",message)
    [self.inputView chatResignFirstResponder];
    [[self.ViewModel.SendCustomerServiceMessages execute:@{@"text":message}] subscribeNext:^(id  _Nullable x) {
        if ([x[@"code"] intValue] == 0) {
            WZMChatMessageModel *Model = [[WZMChatMessageModel alloc]init];
            Model.sender = YES;
            Model.msgType = WZMMessageTypeText;
            Model.sendType = WZMMessageSendTypeSuccess;
            Model.sendName = [UserModel shareInstance].name;
            Model.sendPhoto = [UserModel shareInstance].photo;
            Model.content = message;
            Model.showName = NO;
            [self.messageARR addObject:Model];
            [self.tableView reloadData];
            [self tableViewScrollToBottom:NO duration:0.25];
        }
    }];

}
//其他自定义消息, 如: 图片、视频、位置等等
- (void)inputView:(WZMInputView *)inputView didSelectMoreType:(WZInputMoreType)type {
    [self.inputView chatResignFirstResponder];
    if (type == WZInputMoreTypeImage) {
        [self.inputView endEditing:YES];
        ZWPhotoConfig *config = [[ZWPhotoConfig alloc] init];
        config.navBarTintColor = [UIColor colorWithHexString:@"FD4772"];
        config.navBarBgColor = [UIColor colorWithHexString:@"FBFAF8"];
        config.navBarTitleColor = [UIColor colorWithHexString:@"FD4772"];
        config.allowsEditing = YES;
        [[ZWPhotoHelper creatWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary config:config] getSourceWithSelectImageBlock:^(id data) {
            if ([data isKindOfClass:[UIImage class]]) { // 图片
                //开始发送给服务器上传文件.返回该图片的的URL  封装消息模型里面.修改界面数据源  刷新界面
                [[self.ViewModel.UploadImageCommand execute:data] subscribeNext:^(id  _Nullable x) {
                    if ([x[@"code"] intValue] == 0) {
                        NSString *photoUrl = x[@"res"];
                        NSString *tex = [NSString stringWithFormat:@"<img src=\"%@\"/>",photoUrl];
                        [[self.ViewModel.SendCustomerServiceMessages execute:@{@"text":tex}] subscribeNext:^(id  _Nullable x) {
                            if ([x[@"code"] intValue] == 0) {
                                WZMChatMessageModel *Model = [[WZMChatMessageModel alloc]init];
                                Model.sender = YES;
                                Model.msgType = WZMMessageTypeImage;
                                Model.sendType = WZMMessageSendTypeSuccess;
                                Model.sendName = [UserModel shareInstance].name;
                                Model.sendPhoto = [UserModel shareInstance].photo;
                                Model.original = photoUrl;
                                Model.showName = NO;
                                [self.messageARR addObject:Model];
                                [self.tableView reloadData];
                                [self tableViewScrollToBottom:NO duration:0.25];
                            }
                        }];
                    }
                }];
            } else {
                [YJProgressHUD showMessage:@"选取的不是图片,请选择图片"];
            }
        }];
    }
    else if (type == WZInputMoreTypeVideo) {
        [self.inputView endEditing:YES];
       [self getSourceWithSourceType:UIImagePickerControllerSourceTypeCamera];
    }

}
- (void)getSourceWithSourceType:(UIImagePickerControllerSourceType)sourceType{
    ZWPhotoConfig *config = [[ZWPhotoConfig alloc] init];
    config.navBarTintColor = [UIColor colorWithHexString:@"FD4772"];
    config.navBarBgColor = [UIColor colorWithHexString:@"FBFAF8"];
    config.navBarTitleColor = [UIColor colorWithHexString:@"FD4772"];
    config.allowsEditing = YES;
    [[ZWPhotoHelper creatWithSourceType:sourceType config:config] getSourceWithSelectImageBlock:^(id data) {
        if ([data isKindOfClass:[UIImage class]]) { // 图片
            [[self.ViewModel.UploadImageCommand execute:data] subscribeNext:^(id  _Nullable x) {
                if ([x[@"code"] intValue] == 0) {
                    NSString *photoUrl = x[@"res"];
                    NSString *tex = [NSString stringWithFormat:@"<img src=\"%@\"/>",photoUrl];
                    [[self.ViewModel.SendCustomerServiceMessages execute:@{@"text":tex}] subscribeNext:^(id  _Nullable x) {
                        if ([x[@"code"] intValue] == 0) {
                            WZMChatMessageModel *Model = [[WZMChatMessageModel alloc]init];
                            Model.sender = YES;
                            Model.msgType = WZMMessageTypeImage;
                            Model.sendType = WZMMessageSendTypeSuccess;
                            Model.sendName = [UserModel shareInstance].name;
                            Model.sendPhoto = [UserModel shareInstance].photo;
                            Model.original = photoUrl;
                            Model.showName = NO;
                            [self.messageARR addObject:Model];
                            [self.tableView reloadData];
                            [self tableViewScrollToBottom:NO duration:0.25];
                        }
                    }];
                }
            }];
        } else {
            [YJProgressHUD showMessage:@"所选内容非图片对象"];
        }
    }];
}

//录音状态变化
- (void)inputView:(WZMInputView *)inputView didChangeRecordType:(WZMRecordType)type {
    ZWWLog(@"录音状态开始发生变化======%ld",(long)type)
    if (type == WZMRecordTypeBegin) {
        //WeakSelf
        [[ZWAudioRecorder shareInstanced] startRecordingWithFileName:[self currentRecordFileName] completion:^(NSError *error) {
            ZWWLog(@"开始录音===%@",error)
            if (error) {
                if (error.code != 122) {

                }
            }
        }power:^(float progress) {
            ZWWLog(@"progress ====\n %f",progress)
            self.recordAnimation.volume = progress;

        }];

    }
    else if (type == WZMRecordTypeFinish) {
        //WeakSelf
        [[ZWAudioRecorder shareInstanced] stopRecordingWithCompletion:^(NSString *recordPath) {
            if ([recordPath isEqualToString:shortRecord]) {
                //录音太短
            }else{
                ZWWLog(@"record finish , file path is :\n%@",recordPath);
                NSString *voiceMsg = [NSString stringWithFormat:@"voice[local://%@]",recordPath];
                ZWWLog(@"录音完成===%@",voiceMsg)
                //上传录音
                [[self.ViewModel.UploadFileCommand execute:recordPath] subscribeNext:^(id  _Nullable x) {
                    if ([x[@"code"] intValue] == 0) {
                        ZWWLog(@"上传完成,返回服务器路径")
                        //发送消息
                        NSString *voiceUrl = x[@"res"];
                        NSString *voicestr = [NSString stringWithFormat:@"<audio controls src=\"%@\"/>",voiceUrl];
                        [[self.ViewModel.SendCustomerServiceMessages execute:@{@"text":voicestr}] subscribeNext:^(id  _Nullable x) {
                            if ([x[@"code"] intValue] == 0) {
                                //本地处理数据.刷新表格
                                WZMChatMessageModel *Model = [[WZMChatMessageModel alloc]init];
                                Model.sender = YES;
                                Model.msgType = WZMMessageTypeVoice;
                                Model.sendType = WZMMessageSendTypeSuccess;
                                Model.sendName = [UserModel shareInstance].name;
                                Model.sendPhoto = [UserModel shareInstance].photo;
                                Model.showName = NO;
                                Model.voiceUrl = voiceUrl;
                                Model.duration = 3;
                                [self.messageARR addObject:Model];
                                [self.tableView reloadData];
                                [self tableViewScrollToBottom:NO duration:0.25];

                            }
                        }];
                    }
                }];


            }
        }];

    }
    else {
        ZWWLog(@"=quxiao取消取消")
        [[ZWAudioRecorder shareInstanced] removeCurrentRecordFile];
    }
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.inputView chatResignFirstResponder];
}
- (WZMInputView *)inputView {
    if (_inputView == nil) {
        _inputView = [[WZMInputView alloc] init];
        _inputView.delegate = self;
    }
    return _inputView;
}

#pragma mark - 录音按钮手势冲突处理
//设置手势代理
- (void)updateRecognizerDelegate:(BOOL)appear {
    if (appear) {
        if (self.recognizerDelegate == nil) {
            self.recognizerDelegate = self.navigationController.interactivePopGestureRecognizer.delegate;
        }
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    else {
        self.navigationController.interactivePopGestureRecognizer.delegate = self.recognizerDelegate;
    }
}

//是否响应触摸事件
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (self.navigationController.viewControllers.count <= 1) return NO;
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint point = [touch locationInView:gestureRecognizer.view];
        if (point.y > CHAT_SCREEN_HEIGHT-self.inputView.toolViewH) {
            return NO;
        }
        if (point.x <= 100) {//设置手势触发区
            return YES;
        }
    }
    return NO;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGFloat tx = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:gestureRecognizer.view].x;
        if (tx < 0) {
            return NO;
        }
    }
    return YES;
}

//是否与其他手势共存，一般使用默认值(默认返回NO：不与任何手势共存)
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    //UIScrollView的滑动冲突
    if ([otherGestureRecognizer.view isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollow = (UIScrollView *)otherGestureRecognizer.view;
        if (scrollow.bounds.size.width >= scrollow.contentSize.width) {
            return NO;
        }
        if (scrollow.contentOffset.x == 0) {
            return YES;
        }
    }
    return NO;
}
//屏蔽屏幕底部的系统手势
- (UIRectEdge)preferredScreenEdgesDeferringSystemGestures {
    if (self.isDeferredSystemGestures) {
        return  UIRectEdgeBottom;
    }
    return UIRectEdgeNone;
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageARR.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.messageARR.count) {
        WZMChatMessageModel *model = _messageARR[indexPath.row];
        if (model.msgType == WZMMessageTypeText) {//文字.包含有表情的文字
           WZMChatTextMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"textCell"];
            if (cell == nil) {
                cell = [[WZMChatTextMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"textCell"];
            }
            [cell setConfig:model isShowName:model.showName];
            return cell;
        }else if (model.msgType == WZMMessageTypeImage){//相册或者相机里面的图片
           WZMChatImageMessageCell* cell = [tableView dequeueReusableCellWithIdentifier:@"imageCell"];
            if (cell == nil) {
                cell = [[WZMChatImageMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"imageCell"];
            }
            [cell setConfig:model isShowName:model.showName];
            return cell;
        }else if (model.msgType == WZMMessageTypeVoice) {//声音
           WZMChatVoiceMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"voiceCell"];
            if (cell == nil) {
                cell = [[WZMChatVoiceMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"voiceCell"];
            }
            [cell setConfig:model isShowName:model.showName];
            return cell;
        }
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noDataCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"noDataCell"];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WZMChatMessageModel *model = self.messageARR[indexPath.row];
    if (model.msgType == WZMMessageTypeImage) {
        ZWImageViewController *imageViewC =[[ZWImageViewController alloc] init];
        NSData * imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.original]];
        //取出存储的高清图片
        imageViewC.imageData = imageData;
        [self.navigationController presentViewController:imageViewC animated:YES completion:nil];

    }
}
//行高,需要处理
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.messageARR.count) {
        WZMChatMessageModel *model = [self.messageARR objectAtIndex:indexPath.row];
        [model cacheModelSize];
        if (model.showName) {
            return model.modelH+45;
        }
        else {
            return model.modelH+32;
        }
    }
    return 44.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        CGRect rect = self.frame;
        rect.origin.y = self.tableViewY;
        rect.size.height -= (self.tableViewY+self.inputView.toolViewH);
        _tableView = [[UITableView alloc] initWithFrame:rect
                                                  style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.mj_header.ignoredScrollViewContentInsetTop =20;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollIndicatorInsets = self.tableView.contentInset;
        [_tableView registerClass:[WZMChatTextMessageCell class] forCellReuseIdentifier:@"textCell"];
        [_tableView registerClass:[WZMChatVoiceMessageCell class] forCellReuseIdentifier:@"voiceCell"];
        [_tableView registerClass:[WZMChatImageMessageCell class] forCellReuseIdentifier:@"imageCell"];
        //这三段代码很重要...草
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
    }
    return _tableView;
}
-(ZWMessageViewModel *)ViewModel{
    if (_ViewModel == nil) {
        _ViewModel = [[ZWMessageViewModel alloc]init];
    }
    return _ViewModel;
}
-(NSMutableArray<WZMChatMessageModel *> *)messageARR{
    if (_messageARR == nil) {
        _messageARR = [[NSMutableArray alloc]init];
    }
    return _messageARR;
}

#pragma mark - Private
- (NSString *)currentRecordFileName
{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    NSString *fileName = [NSString stringWithFormat:@"%ld",(long)timeInterval];
    return fileName;
}

//键盘状态变化
- (void)inputView:(WZMInputView *)inputView willChangeFrameWithDuration:(CGFloat)duration {
    [self tableViewScrollToBottom:YES duration:duration];
}//键盘状态发生变化
- (void)tableViewScrollToBottom:(BOOL)animated duration:(CGFloat)duration {
    if (animated) {
        CGFloat keyboardH = self.inputView.keyboardH;
        CGFloat contentH = self.tableView.contentSize.height;
        CGFloat tableViewH = self.tableView.bounds.size.height;
        CGFloat offsetY = 0;
        if (contentH < tableViewH) {
            offsetY = MAX(contentH+keyboardH-tableViewH, 0);
        }
        else {
            offsetY = keyboardH;
            if (keyboardH < 10) {
                offsetY = keyboardH;
            }else{
                offsetY = keyboardH - 110 - K_APP_STATUS_BAR_HEIGHT - K_APP_TABBAR_HEIGHT;
            }
        }
        CGRect TRect = self.tableView.frame;
        TRect.origin.y = self.tableViewY-offsetY;
        [UIView animateWithDuration:0.25 animations:^{
            self.tableView.frame = TRect;
            if (self.messageARR.count) {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(self.messageARR.count-1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
        }];
    }
    else {
        if (self.messageARR.count) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(self.messageARR.count-1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }
}
- (WZMRecordAnimation *)recordAnimation {
    if (_recordAnimation == nil) {
        _recordAnimation = [[WZMRecordAnimation alloc] init];
    }
    return _recordAnimation;
}

@end
