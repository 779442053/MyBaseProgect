//


#import "UpLoadViewController.h"
#import "RefreshTableViewController.h"

#import "UpVideoCell.h"
#import "UploadInfoCell.h"

#import <MediaPlayer/MediaPlayer.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

#import "MyUploadViewController.h"
#import "UploadModel.h"



@interface UpLoadViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIVideoEditorControllerDelegate,UITableViewDelegate,UITableViewDataSource,AVCaptureFileOutputRecordingDelegate>

@property(nonatomic,strong) UIButton *btnRelease;

@end

@implementation UpLoadViewController {
  
  UIImage *_videoImage;
  UIImage *_coverImage;
  BOOL _upSuccess;
  BOOL _upCoverSucces;
  NSString *_infoStr;
  NSString *_coverName;    //封面图片名称
  NSString *_videoName;    //视频名称
  NSString *_realFileUrl;
  NSURL *_exportMP4Path;
  NSURL *_videoPath;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _exportMP4Path = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"video_rc_tmp.mp4"]];
//    _videoPath = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"video_rc_tmp.mov"]];
    [self initUI];
}
-(NSData *)readDataWithChunk:(NSInteger)chunk file:(NSString*)file{
    int offset = 1024*1024;//（每一片的大小是1M）
    //将文件分片，读取每一片的数据：
    NSData* data;
    NSFileHandle *readHandle = [NSFileHandle fileHandleForReadingAtPath:file];
    [readHandle seekToFileOffset:offset * chunk];
    data = [readHandle readDataOfLength:offset];
    return data;
}
//选择视频
- (void)selectMovie{
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"选择视频" preferredStyle:UIAlertControllerStyleActionSheet];
  [alert addAction:[UIAlertAction actionWithTitle:@"拍摄视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    [self openCamera];
  }]];
    
  [alert addAction:[UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    [self selectVideos];
  }]];
    
  [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
    
  }]];
  [self presentViewController:alert animated:YES completion:nil];
}

//视频
- (void)openCamera{
    UIImagePickerController *picker = [UIImagePickerController new];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    //录制视频，默认10s  限制60分钟
    picker.videoMaximumDuration = 180 * 20 *1000000;
    //相机类型（拍照、录像...）这里表示我们打开相机支持的是相机和录像两个功能。
    picker.mediaTypes = @[(NSString *)kUTTypeMovie];
    picker.delegate = self;
    picker.videoQuality = UIImagePickerControllerQualityTypeHigh;
    //设置摄像头模式（拍照，录制视频）为相机模式
    //    UIImagePickerControllerCameraCaptureModeVideo  这个是设置为视频模式
    picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
    
    [self presentViewController:picker animated:YES completion:nil];
}
-  (void)selectVideos{
  UIImagePickerController *picker = [[UIImagePickerController alloc] init];
  picker.delegate = self;
  picker.allowsEditing = NO;
  picker.videoQuality = UIImagePickerControllerQualityTypeMedium;
  picker.mediaTypes = [NSArray arrayWithObjects:@"public.movie", nil];
  picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  [self presentViewController:picker animated:YES completion:nil];
}
//选择封面
- (void)selectCover{
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"选择封面" preferredStyle:UIAlertControllerStyleActionSheet];
  [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    [self chooseImageBy:UIImagePickerControllerSourceTypeCamera];
  }]];
  [alert addAction:[UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    [self chooseImageBy:UIImagePickerControllerSourceTypePhotoLibrary];
  }]];
  [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
    
  }]];
  [self presentViewController:alert animated:YES completion:nil];
}

//选择照片
- (void)chooseImageBy:(UIImagePickerControllerSourceType)sourceType{
  if (![UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]
      && sourceType == UIImagePickerControllerSourceTypeCamera) {
    [YJProgressHUD showError:@"摄像头不可用"];
    return;
  }
  UIImagePickerController *imagePickController = [[UIImagePickerController alloc] init];
  imagePickController.sourceType = sourceType;
  imagePickController.delegate = self;
  [imagePickController.navigationBar setTranslucent:YES];
  [self presentViewController:imagePickController animated:YES completion:nil];
}


//MARK: - UINavigationControllerDelegate
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([UIDevice currentDevice].systemVersion.floatValue < 11) return;
    if ([viewController isKindOfClass:NSClassFromString(@"PUPhotoPickerHostViewController")]) {
        [viewController.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.frame.size.width < 42) {
                [viewController.view sendSubviewToBack:obj];
                *stop = YES;
            }
        }];
    }//
    //ZWWLog(@"当我使用相机\n进行拍照的时候,\n弹出的导航控制器\n就是z会走\n这个方法")
}
//MARK: - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    ZWWLog(@"开始获取视频的资源=%@   picker = %@",info,picker)
  __weak typeof(self) weakSelf = self;
  __block typeof(self) blockSelf = self;
  [picker dismissViewControllerAnimated:YES completion:^{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.movie"]){
      //如果是视频
      NSURL *url = info[UIImagePickerControllerMediaURL];//获得视频的URL
        ZWWLog(@"获得视频的URL === %@",url)
        NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                                       forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
        AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:opts];
                     float second = 0;
                    second = urlAsset.duration.value / urlAsset.duration.timescale;
        if (second > 60) {
            [YJProgressHUD showMessage:@"视频上传,不得少于1分钟"];
            blockSelf->_videoImage = [UIImage imageNamed:@"add_gray"];
            blockSelf->_coverImage = [UIImage imageNamed:@"add_gray"];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                ZWWLog(@"将要转换的路径===%@",url.path)//需要在公共区域 导出视频到我自定义的文件夹下满
                    AVURLAsset *asset = [AVURLAsset assetWithURL:url];
                    [weakSelf startExportVideoWithVideoAsset:asset completion:^(NSString *outputPath) {
                   ZWWLog(@"===成功\n成功\n成功\n成功\n==outputPath=%@",outputPath)
                    }];
                
            });
            UIImage *thumbnail = [self getScreenShotImageFromVideoPath:url];
            thumbnail = [UIImage imageWithData:[Utils zipNSDataWithImage:thumbnail]];
            //x压缩图片
            blockSelf->_videoImage = thumbnail;
            blockSelf->_coverImage = thumbnail;
            blockSelf->_upSuccess = YES;
            blockSelf->_upCoverSucces = YES;
            [weakSelf.refreshTableView reloadData];
        }
    }
    else if ([mediaType isEqualToString:@"public.image"]) {
        ZWWLog(@"==== 选择的是图片 .选择的封面图")
      UIImage *image = info[UIImagePickerControllerOriginalImage];
      image = [UIImage imageWithData:[Utils zipNSDataWithImage:image]];
      blockSelf->_coverImage = image;
      blockSelf->_upCoverSucces = YES;
      [weakSelf.refreshTableView reloadData];
    }
  }];
}
- (void)startExportVideoWithVideoAsset:(AVURLAsset *)videoAsset completion:(void (^)(NSString *outputPath))completion
{
    NSArray *presets = [AVAssetExportSession exportPresetsCompatibleWithAsset:videoAsset];
    NSString *pre = nil;
    if ([presets containsObject:AVAssetExportPreset3840x2160])
    {
        pre = AVAssetExportPreset3840x2160;
    }
    else if([presets containsObject:AVAssetExportPreset1920x1080])
    {
        pre = AVAssetExportPreset1920x1080;
    }
    else if([presets containsObject:AVAssetExportPreset1280x720])
    {
        pre = AVAssetExportPreset1280x720;
    }
    else if([presets containsObject:AVAssetExportPreset960x540])
    {
        pre = AVAssetExportPreset1280x720;
    }
    else
    {
        pre = AVAssetExportPreset640x480;
    }
    if ([presets containsObject:AVAssetExportPreset640x480]) {
        AVAssetExportSession *session = [[AVAssetExportSession alloc]initWithAsset:videoAsset presetName:AVAssetExportPreset640x480];
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yy-MM-dd-HH:mm:ss"];
        NSString *outputPath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", [[formater stringFromDate:[NSDate date]] stringByAppendingString:@".mp4"]];
        NSLog(@"video outputPath = %@",outputPath);
        //删除原来的 防止重复选
        if ([[NSFileManager defaultManager] removeItemAtPath:_exportMP4Path.absoluteString error:nil]) {
            ZWWLog(@"删除之前的公共区域视频成功")
        }
        _exportMP4Path =[NSURL fileURLWithPath:outputPath];
        session.outputURL = [NSURL fileURLWithPath:outputPath];
        session.shouldOptimizeForNetworkUse = YES;
        NSArray *supportedTypeArray = session.supportedFileTypes;
        if ([supportedTypeArray containsObject:AVFileTypeMPEG4]) {
            session.outputFileType = AVFileTypeMPEG4;
        } else if (supportedTypeArray.count == 0) {
            NSLog(@"No supported file types 视频类型暂不支持导出");
            return;
        } else {
            ZWWLog(@"该视频不支持转成MP4 格式,该视频不支持转成MP4 格式该视频不支持转成MP4 格式")
            session.outputFileType = [supportedTypeArray objectAtIndex:0];
        }
        if (![[NSFileManager defaultManager] fileExistsAtPath:[NSHomeDirectory() stringByAppendingFormat:@"/Documents"]]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:[NSHomeDirectory() stringByAppendingFormat:@"/Documents"] withIntermediateDirectories:YES attributes:nil error:nil];
        }
        if ([[NSFileManager defaultManager] fileExistsAtPath:_realFileUrl]) {
            [[NSFileManager defaultManager] removeItemAtPath:_realFileUrl error:nil];
        }
        [session exportAsynchronouslyWithCompletionHandler:^(void) {
            switch (session.status) {
                case AVAssetExportSessionStatusUnknown:
                    NSLog(@"AVAssetExportSessionStatusUnknown"); break;
                case AVAssetExportSessionStatusWaiting:
                    NSLog(@"AVAssetExportSessionStatusWaiting"); break;
                case AVAssetExportSessionStatusExporting:
                    NSLog(@"AVAssetExportSessionStatusExporting"); break;
                case AVAssetExportSessionStatusCompleted: {
                    NSLog(@"AVAssetExportSessionStatusCompleted");
        ZWWLog(@"导出视频成功导出视频成功AVAssetExportSessionStatusCompleted导出视频成功导出视频成功");
                //当上传成功之后,为了用户体验.需要经本地的数据删除.除非用户手动保存在了相册里面
                    self->_realFileUrl = session.outputURL.path;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (completion) {
                            completion(outputPath);
                        }
                    });
                }  break;
                case AVAssetExportSessionStatusFailed:
                    NSLog(@"AVAssetExportSessionStatusFailed"); break;
                default: break;
            }
        }];
    }
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (UIImage *)getScreenShotImageFromVideoPath:(NSURL *)fileURL{
    UIImage *shotImage;
    //视频路径URL
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:fileURL options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    shotImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return shotImage;
}
//MARK: -  视频编辑回调
//编辑成功后的Video被保存在沙盒的临时目录中
- (void)videoEditorController:(UIVideoEditorController *)editor didSaveEditedVideoToPath:(NSString *)editedVideoPath{
   //[self coverMovToMP4:editedVideoPath];
    ZWWLog(@"编辑成功后的Video被保存在沙盒的临时目录中editedVideoPath = %@",editedVideoPath)
   [editor dismissViewControllerAnimated:YES completion:nil];
    ZWWLog(@"编辑保存成功后调用的方法");
}
// 编辑失败后调用的方法
- (void)videoEditorController:(UIVideoEditorController *)editor didFailWithError:(NSError *)error {
    ZWWLog(@"%@",error.description);
    [YJProgressHUD showError:error.description];
}
//编辑取消后调用的方法
- (void)videoEditorControllerDidCancel:(UIVideoEditorController *)editor {
    ZWWLog(@"编辑取消后调用的方法");
    [editor dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//MARK: - initUI
- (void)initUI{
    //MARK:导航
    [self initNavgationBar:K_APP_NAVIGATION_BACKGROUND_COLOR
          AndHasBottomLine:NO
              AndHasShadow:YES
             WithHasOffset:0.0];
    //MARK:返回
    [self initNavigationBack:K_APP_BLACK_BACK];
    //MARK:标题
    [self initViewControllerTitle:@"上传"
                     AndFontColor:K_APP_VIEWCONTROLLER_TITLE_COLOR
                       AndHasBold:NO
                      AndFontSize:K_APP_VIEWCONTROLLER_TITLE_FONT];
    //MARK:发布
    [self.navView addSubview:self.btnRelease];
    _upSuccess = NO;
    _upCoverSucces = NO;
    CGFloat h = K_APP_HEIGHT - K_APP_NAVIGATION_BAR_HEIGHT;
    if ([[UIDevice currentDevice] isiPhoneX]) {
        h -= K_APP_IPHONX_BUTTOM;
    }
    self.refreshTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, K_APP_NAVIGATION_BAR_HEIGHT, K_APP_WIDTH, h) style:UITableViewStyleGrouped];
    self.refreshTableView.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    [self.view addSubview:self.refreshTableView];
    self.refreshTableView.delegate = self;
    self.refreshTableView.dataSource = self;
    self.refreshTableView.estimatedRowHeight = 0;
    self.refreshTableView.estimatedSectionHeaderHeight = 0;
    self.refreshTableView.estimatedSectionFooterHeight = 0;
    self.refreshTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
-(UIButton *)btnRelease{
    if (!_btnRelease) {
        __weak typeof(self) weakSelf = self;
        CGRect rect = weakSelf.btnNavigationBack.frame;
        rect.origin.x = K_APP_WIDTH - 20 - rect.size.width;
        _btnRelease = [BaseUIView createBtn:rect
                                   AndTitle:@"发布"
                              AndTitleColor:K_APP_TINT_COLOR
                                 AndTxtFont:[UIFont systemFontOfSize:15]
                                   AndImage:nil
                         AndbackgroundColor:nil
                             AndBorderColor:nil
                            AndCornerRadius:0.0
                               WithIsRadius:NO
                        WithBackgroundImage:nil
                            WithBorderWidth:0];

        [_btnRelease addTarget:weakSelf
                        action:@selector(upMovies:)
              forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnRelease;
}
//MARK: -  UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, K_APP_WIDTH, kWidth(40))];
    headView.backgroundColor = [UIColor clearColor];
    UILabel *label = [UILabel new];
    label.font = FONTOFPX(30);
    label.textColor = [UIColor blackColor];
    [headView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView.mas_left).offset(kWidth(15));
        make.centerY.equalTo(headView);
    }];
    if (section == 0) {
        label.text = @"请选择上传视频";
    } else if (section == 1) {
        label.text = @"请选择视频封面";
    } else {
        label.text = @"视频说明";
    }

    return headView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 2) {
        UploadInfoCell *cell = [UploadInfoCell cellWithTableView:tableView];
        cell.backgroundColor = [UIColor whiteColor];
        cell.GetTextView = ^(NSString *infos) {
            self->_infoStr = infos;
        };
        return cell;
    }
    else {
        UpVideoCell *cell = [UpVideoCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.section == 0) {
            if (_upSuccess) {
                cell.uploadImageView.image = _videoImage;
            }
        } else {
            if (_upCoverSucces) {
                cell.uploadImageView.image = _coverImage;
            }
        }

        cell.uploadBtn.tag = indexPath.section;
        [cell.uploadBtn addTarget:self action:@selector(btnCellAction:) forControlEvents:UIControlEventTouchUpInside];

        return cell;
    }
    return nil;
}


//MARK: - Action
-(IBAction)btnCellAction:(UIButton *)sender{
    NSInteger index = sender.tag;
    if (index == 0) {
        [self selectMovie];
    } else {
        [self selectCover];
    }
}

- (IBAction)upMovies:(UIButton *)sender{

    if (![UserModel userIsLogin]) {
        [self userToLogin:nil];
        return;
    }

    if (_videoImage == nil){
        [YJProgressHUD showError:@"请上传视频文件"];
        return;
    }

    if (_coverImage  == nil) {
        [YJProgressHUD showError:@"请上传视频封面"];
        return;
    }

    ZWWLog(@"视频说明:%@",_infoStr);
    if (_infoStr == nil
        || _infoStr.length == 0) {
        [YJProgressHUD showError:@"请填写视频说明"];
        return;
    }

    //以当前上传的时间戳命名文件名和视频名
    NSString *str = [Utils getCurrentDateToString:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strUrl = [NSString stringWithFormat:@"%@VideoUpload",K_APP_HOST];
    NSDictionary *dicParam = @{
                               @"title":_infoStr,
                               @"cover":[str stringByAppendingString:@".jpg"],
                               @"video":[str stringByAppendingString:@".mp4"]
                               };

    __block typeof(self) blockSelf = self;
    __weak typeof(self) weakSelf = self;
    [Utils postWithUrl:strUrl
                  body:[dicParam mj_JSONData]
           WithSuccess:^(id  _Nullable response, NSString * _Nullable strMsg) {
               ZWWLog(@"上传返回参数获取如下:%@",response);
               //MARK:跳转到正在上传视图
               if (response) {
                   MyUploadViewController *myUploadVC = [[MyUploadViewController alloc] init];

                   UploadModel *model = [[UploadModel alloc] init];
                   model.id = [response[@"id"] integerValue];
                   model.cover = [NSString stringWithFormat:@"%@",response[@"cover"]];
                   model.title = blockSelf->_infoStr;
                   model.viewCount = 0;
                   myUploadVC.uploadModel = model;

                   [myUploadVC uploadMovieData:response
                                andRealFileUrl:blockSelf->_realFileUrl
                                        andStr:str
                                 andCoverImage:blockSelf->_coverImage];

                   [weakSelf.navigationController pushViewController:myUploadVC animated:YES];
               }
               else{
                   [YJProgressHUD showError:@"视频发布失败"];
               }
           } WithFailure:^(NSString * _Nullable error) {
               ZWWLog(@"视频上传失败！详见：%@",error);
               [YJProgressHUD showError:error];
           }
         WithisLoading:YES];
}

@end


