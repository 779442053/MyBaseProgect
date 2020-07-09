

#import "ZWMessageViewModel.h"
#import "ZWMessageModel.h"
#import "FansModel.h"
#import "MyFollowModel.h"

//聊天模型
#import "WZMChatMessageModel.h"


#import "ZWUploadManager.h"

@interface ZWMessageViewModel()
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger currentPageed;
@property (nonatomic, copy) NSString * currentMessagePageed;
@property (nonatomic, copy) NSString * lastPage;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *name;
@end
@implementation ZWMessageViewModel
-(void)zw_initialize{
    NSString *uploadUrl = [[NSUserDefaults standardUserDefaults]objectForKey:AppUrlUploadFile];
    if ( !uploadUrl || uploadUrl.length == 0) {
        [YJProgressHUD showError:@"没有获取到上传路径"];
    }
    @weakify(self)
    //先获取当前聊天的客服.之后,再去获取当前客服所聊天的内容.为了判断某一条消息  是别人的还是自己的 GetCurrentConstUserCommand
    self.GetCurrentConstUserCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSDictionary* input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            //@strongify(self)
            NSMutableDictionary *parma = [[NSMutableDictionary alloc]init];
            NSString *strUrl = [NSString stringWithFormat:@"%@CustomerServiceAllocation",K_APP_HOST];
            [Utils getRequestForServerData:strUrl
                            withParameters:parma
                        AndHTTPHeaderField:^(AFHTTPRequestSerializer * _Nullable _requestSerializer) {
                            [_requestSerializer setValue:LOGIN_COOKIE forHTTPHeaderField:LOGIN_COOKIE_KEY];
                        }
                            AndSuccessBack:^(id  _Nullable _responseData) {
                                [YJProgressHUD hideHUD];
                                if (_responseData) {
                                    ZWWLog(@"当前客服=%@",_responseData)
                                    self.userID = _responseData[@"userID"];
                                    self.name = _responseData[@"name"];
                                    [[NSUserDefaults standardUserDefaults] setObject:self.name forKey:@"name"];
                                    [[NSUserDefaults standardUserDefaults] setObject:self.userID forKey:@"userID"];
                                    [[NSUserDefaults standardUserDefaults] synchronize];
                                    [subscriber sendNext:@{@"code":@"0"}];
                                }else{
                                    [subscriber sendNext:@{@"code":@"1"}];
                                }
                                [subscriber sendCompleted];
                            }
                            AndFailureBack:^(NSString * _Nullable _strError) {
                                ZWWLog(@"加载数据异常！详见：%@",_strError);
                                [YJProgressHUD showError:_strError];
                                [subscriber sendError:nil];
                                [subscriber sendCompleted];
                            }
                             WithisLoading:NO];

            return [RACDisposable disposableWithBlock:^{
                ZWWLog(@"信号消失")
            }];
        }];
    }];


    
    //我的粉丝
    self.RefreshDataCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSDictionary* input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self)
            [YJProgressHUD showLoading:@"加载中..."];
            self.currentPage = 0;
            NSMutableDictionary *parma = [[NSMutableDictionary alloc]init];
            NSString *strUrl = [NSString stringWithFormat:@"%@Fans?%lld",K_APP_HOST,[Utils getCurrentLinuxTime]];
            [Utils getRequestForServerData:strUrl
                            withParameters:parma
                        AndHTTPHeaderField:^(AFHTTPRequestSerializer * _Nullable _requestSerializer) {
                            [_requestSerializer setValue:LOGIN_COOKIE forHTTPHeaderField:LOGIN_COOKIE_KEY];
                        }
                            AndSuccessBack:^(id  _Nullable _responseData) {
                                [YJProgressHUD hideHUD];
                                if (_responseData) {
                                    ZWWLog(@"粉丝=%@",_responseData)
                                    FansModel *model = [FansModel mj_objectWithKeyValues:_responseData];
                                    NSMutableArray *dataARR = [NSMutableArray arrayWithArray:model.data];
                                    [subscriber sendNext:@{@"code":@"0",@"res":dataARR}];
                                }else{
                                    [subscriber sendNext:@{@"code":@"1"}];
                                }
                                [subscriber sendCompleted];
                            }
                            AndFailureBack:^(NSString * _Nullable _strError) {
                                ZWWLog(@"加载数据异常！详见：%@",_strError);
                                [YJProgressHUD showError:_strError];
                                [subscriber sendError:nil];
                                [subscriber sendCompleted];
                            }
                             WithisLoading:NO];

            return [RACDisposable disposableWithBlock:^{
                ZWWLog(@"信号消失")
            }];
        }];
    }];

    //加载更多
    self.LoadMoreDataCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSDictionary* input) {
        [YJProgressHUD showLoading:@"加载中..."];
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            self.currentPage ++;
            //NSMutableDictionary *parma = [NSMutableDictionary dictionary];
            [subscriber sendNext:@{@"code":@"1"}];
            [subscriber sendCompleted];
            [YJProgressHUD hideHUD];

            return [RACDisposable disposableWithBlock:^{

            }];
        }];
    }];

    //我的关注
    self.RefreshDataCommand2 = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSDictionary* input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self)
            [YJProgressHUD showLoading:@"加载中..."];
            self.currentPage = 0;
            NSMutableDictionary *parma = [NSMutableDictionary dictionary];
            parma[@"uid"] = [NSString stringWithFormat:@"%ld",(long)[UserModel shareInstance].id];
            parma[@"id"] = @"0";
            NSString *strUrl = [NSString stringWithFormat:@"%@follow",K_APP_HOST];
            [Utils getRequestForServerData:strUrl
                            withParameters:parma
                        AndHTTPHeaderField:^(AFHTTPRequestSerializer * _Nullable _requestSerializer) {
                            [_requestSerializer setValue:LOGIN_COOKIE forHTTPHeaderField:LOGIN_COOKIE_KEY];
                        }
                            AndSuccessBack:^(id  _Nullable _responseData) {
                                [YJProgressHUD hideHUD];
                                if (_responseData) {
                                    ZWWLog(@"我的关注=%@",_responseData)
                                    MyFollowModel *model = [MyFollowModel mj_objectWithKeyValues:_responseData];
                                    NSMutableArray *dataARR = [NSMutableArray arrayWithArray:model.data];
                                    [subscriber sendNext:@{@"code":@"0",@"res":dataARR}];
                                }else{
                                    [subscriber sendNext:@{@"code":@"1"}];
                                }
                                [subscriber sendCompleted];
                            }
                            AndFailureBack:^(NSString * _Nullable _strError) {
                                ZWWLog(@"加载数据异常！详见：%@",_strError);
                                [YJProgressHUD showError:_strError];
                                [subscriber sendError:nil];
                                [subscriber sendCompleted];
                            }
                             WithisLoading:NO];

            return [RACDisposable disposableWithBlock:^{
                ZWWLog(@"信号消失")
            }];
        }];
    }];

    self.LoadMoreDataCommand2 = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSDictionary* input) {
        [YJProgressHUD showLoading:@"加载中..."];
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            self.currentPage ++;
            //NSMutableDictionary *parma = [NSMutableDictionary dictionary];
            [subscriber sendNext:@{@"code":@"1"}];
            [subscriber sendCompleted];
            [YJProgressHUD hideHUD];

            return [RACDisposable disposableWithBlock:^{

            }];
        }];
    }];

    //获取我的私信
    self.RefreshDataCommand3 = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSDictionary* input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self)
            [YJProgressHUD showLoading:@"加载中..."];
            self.currentMessagePageed = 0;
            NSString *urlStr = [NSString stringWithFormat:@"%@Messages",K_APP_HOST];
            NSDictionary *param = @{
                                    @"id":@"0",
                                    };
            ZWWLog(@"url= %@",urlStr)
            [Utils getRequestForServerData:urlStr
                            withParameters:param
                        AndHTTPHeaderField:^(AFHTTPRequestSerializer * _Nullable _requestSerializer) {
                            [_requestSerializer setValue:LOGIN_COOKIE forHTTPHeaderField:LOGIN_COOKIE_KEY];
                        }
                            AndSuccessBack:^(id  _Nullable _responseData) {
                                [YJProgressHUD hideHUD];
                                if (_responseData) {
                                    ZWWLog(@"我的消息=%@",_responseData)
                                    NSArray *dataarr = _responseData[@"data"];
                                    NSArray *modelARR = [ZWMessageModel mj_objectArrayWithKeyValuesArray:dataarr];
                                    //处理数据
                                    [subscriber sendNext:@{@"code":@"0",@"res":modelARR}];
                                }else{
                                    [subscriber sendNext:@{@"code":@"1"}];
                                }
                                [subscriber sendCompleted];
                            }
                            AndFailureBack:^(NSString * _Nullable _strError) {
                                ZWWLog(@"加载数据异常！详见：%@",_strError);
                                [YJProgressHUD showError:_strError];
                                [subscriber sendError:nil];
                                [subscriber sendCompleted];
                            }
                             WithisLoading:NO];

            return [RACDisposable disposableWithBlock:^{
                ZWWLog(@"信号消失")
            }];
        }];
    }];

    self.LoadMoreDataCommand3 = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSDictionary* input) {
        [YJProgressHUD showLoading:@"加载中..."];
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            //@strongify(self);
            //self.currentPage ++;
            [subscriber sendNext:@{@"code":@"1"}];
            [subscriber sendCompleted];
            [YJProgressHUD hideHUD];
            return [RACDisposable disposableWithBlock:^{

            }];
        }];
    }];

    self.FollowCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSDictionary* input) {
        [YJProgressHUD showLoading:@"加载中..."];
        NSString *userid;
        NSString * isFlow ;
        if ([input[@"code"] intValue] == 0) {
            FansData *Model = input[@"Model"];
            userid = [NSString stringWithFormat:@"%ld",Model.fansId];
            if (Model.isFollowed) {
                isFlow = @"false";
            }else{
                isFlow = @"true";
            }
            ZWWLog(@"我的粉丝将要关注或者b取消关注操作=%@  userid= %@",isFlow,userid)
        }else{
            FollowArr *Model = input[@"Model"];
            userid = [NSString stringWithFormat:@"%ld",Model.userId];
            if (Model.followid) {//0 标识我没有关注  1  我关注啦
                isFlow = @"false";
            }else{
                isFlow = @"true";
            }
            ZWWLog(@"我的关注的人将要关注或者b取消关注操作=%@  userid= %@",isFlow,userid)
        }
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSString *strUtl = [NSString stringWithFormat:@"%@Follow",K_APP_HOST];
            NSDictionary *dicParams = @{
                                        @"userID":userid,
                                        @"isFollow":isFlow
                                        };
            [Utils putRequestForServerData:strUtl
                            withParameters:dicParams
                            AndSuccessBack:^(id  _Nullable _responseData, NSString * _Nullable strMsg) {
                                [YJProgressHUD showSuccess:@"操作成功"];
                                [subscriber sendNext:@{@"code":@"0"}];
                                [subscriber sendCompleted];
                            } AndFailureBack:^(NSString * _Nullable _strError) {
                                ZWWLog(@"关注、取消关注失败！详见：%@",_strError);
                                [YJProgressHUD showError:_strError];
                                [subscriber sendCompleted];
                            }
                             WithisLoading:NO];
            return [RACDisposable disposableWithBlock:^{

            }];
        }];
    }];

    //获取客服消息
    self.CustomerServiceMessages = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSDictionary* input) {
        [YJProgressHUD showLoading:@"加载中..."];
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            self.currentMessagePageed = @"0";
            NSString *urlStr = [NSString stringWithFormat:@"%@CustomerServiceMessages",K_APP_HOST];
            NSDictionary *param = @{
                                    @"id":self.currentMessagePageed,
                                    };
            [Utils getRequestForServerData:urlStr withParameters:param AndHTTPHeaderField:^(AFHTTPRequestSerializer * _Nullable _requestSerializer) {
                [_requestSerializer setValue:LOGIN_COOKIE forHTTPHeaderField:LOGIN_COOKIE_KEY];
            } AndSuccessBack:^(id  _Nullable _responseData) {
                [YJProgressHUD hideHUD];
                if (_responseData) {
                    ZWWLog(@"获取的客服消息 = %@",_responseData)
                    NSArray *MessageARR = [WZMChatMessageModel mj_objectArrayWithKeyValuesArray:_responseData[@"data"]];
                    WZMChatMessageModel * lastmodel = MessageARR.lastObject;
                    self.currentMessagePageed = lastmodel.ID;
                    ZWWLog(@"最后的id = %@",self.currentMessagePageed)//为了获取聊天记录
                    //=============需要自己封装聊天信息
                    NSMutableArray *temp = [NSMutableArray arrayWithArray:MessageARR];
                    temp = (NSMutableArray *)[[temp reverseObjectEnumerator] allObjects];
                    WZMChatMessageModel * fastModel = temp.lastObject;
                    self.lastPage = fastModel.ID;
                    ZWWLog(@"最新的聊天id = %@",self.lastPage)//为了获取最新的聊天-定时器
                    NSMutableArray *messageARRlast = [[NSMutableArray alloc]init];
                    for (int i = 0; i < temp.count; i++) {
                        WZMChatMessageModel *Model = temp[i];
                        Model.sendType = WZMMessageSendTypeSuccess;
                        if ([Model.recID intValue] == 0) {
                            Model.sender = YES;
                            Model.showName = NO;
                        }else{
                            Model.sender = NO;
                             Model.showName = YES;
                        }
                        if ([Model.content containsString:@"img"]) {
                            Model.msgType = WZMMessageTypeImage;
                            NSRange startRange = [Model.content rangeOfString:@"src=\""];
                            NSRange endRange = [Model.content rangeOfString:@"\"/>"];
                            NSRange endRange1 = [Model.content rangeOfString:@"\" />"];
                            NSString *result;
                            if (startRange.length && (endRange.length || endRange1.length)) {
                                NSRange endRange2;
                                if (endRange.length) {
                                    endRange2 = endRange;
                                }else{
                                    endRange2 = endRange1;
                                }
                                NSRange range = NSMakeRange(startRange.location + startRange.length, endRange2.location - startRange.location - startRange.length);
                                result = [Model.content substringWithRange:range];
                            }else{
                                result = Model.content;
                            }
                            Model.original = result;
                        }else if ([Model.content containsString:@"audio"]){
                            Model.msgType = WZMMessageTypeVoice;
                            NSRange startRange = [Model.content rangeOfString:@"src=\""];
                            NSRange endRange = [Model.content rangeOfString:@"\"/>"];
                            NSString *result;
                            if (startRange.length && endRange.length) {
                                NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
                                result = [Model.content substringWithRange:range];
                            }else{
                                result = Model.content;
                            }
                            Model.voiceUrl = result;
                            Model.duration = 3;
                        }else{
                            Model.msgType = WZMMessageTypeText;
                            Model.content = Model.content;
                        }
                        [messageARRlast addObject:Model];
                    }

                    [subscriber sendNext:@{@"code":@"0",@"res":messageARRlast}];
                    [subscriber sendCompleted];
                }
            } AndFailureBack:^(NSString * _Nullable _strError) {
                [YJProgressHUD showError:_strError];
                [subscriber sendCompleted];
            } WithisLoading:NO];
            return [RACDisposable disposableWithBlock:^{

            }];
        }];
    }];

    //获取更多的客服消息  CustomerMoreServiceMessages
    //获取客服消息
    self.CustomerMoreServiceMessages = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSDictionary* input) {
        [YJProgressHUD showLoading:@"加载中..."];
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            //@strongify(self);
            NSString *urlStr = [NSString stringWithFormat:@"%@CustomerServiceMessagesByIDAsc",K_APP_HOST];
            NSDictionary *param = @{
                                    @"id":self.currentMessagePageed,
                                    };
            [Utils getRequestForServerData:urlStr withParameters:param AndHTTPHeaderField:^(AFHTTPRequestSerializer * _Nullable _requestSerializer) {
                [_requestSerializer setValue:LOGIN_COOKIE forHTTPHeaderField:LOGIN_COOKIE_KEY];
            } AndSuccessBack:^(id  _Nullable _responseData) {
                [YJProgressHUD hideHUD];
                if (_responseData) {
                    ZWWLog(@"获取的更多的消息 = %@",_responseData)
                    NSArray *MessageARR = [WZMChatMessageModel mj_objectArrayWithKeyValuesArray:_responseData[@"data"]];
                    if (MessageARR.count) {
                        WZMChatMessageModel * lastmodel = MessageARR.lastObject;
                        self.currentMessagePageed = lastmodel.ID;
                        ZWWLog(@"最后的id = %@",self.currentMessagePageed)
                    }else{
                        self.currentMessagePageed = self.currentMessagePageed;
                    }
                    //数组倒序排列
                    NSMutableArray *temp = [NSMutableArray arrayWithArray:MessageARR];
                    temp = (NSMutableArray *)[[temp reverseObjectEnumerator] allObjects];
                    ZWWLog(@"获取的更多的客服消息 = %@",temp)
                    if (temp.count) {
                        NSMutableArray *messageARRlast = [[NSMutableArray alloc]init];
                        for (int i = 0; i < temp.count; i++) {
                            WZMChatMessageModel *Model = temp[i];
                            Model.sendType = WZMMessageSendTypeSuccess;
                            if ([Model.recID intValue] == 0) {
                                Model.sender = YES;
                                Model.showName = NO;
                            }else{
                                Model.sender = NO;
                                Model.showName = YES;
                            }
                            if ([Model.content containsString:@"img"]) {
                                Model.msgType = WZMMessageTypeImage;
                                NSRange startRange = [Model.content rangeOfString:@"src=\""];
                                NSRange endRange = [Model.content rangeOfString:@"\"/>"];
                                NSRange endRange1 = [Model.content rangeOfString:@"\" />"];
                                NSString *result;
                                if (startRange.length && (endRange.length || endRange1.length)) {
                                    NSRange endRange2;
                                    if (endRange.length) {
                                        endRange2 = endRange;
                                    }else{
                                        endRange2 = endRange1;
                                    }
                                    NSRange range = NSMakeRange(startRange.location + startRange.length, endRange2.location - startRange.location - startRange.length);
                                    result = [Model.content substringWithRange:range];
                                }else{
                                    result = Model.content;
                                }
                                Model.original = result;
                            }else if ([Model.content containsString:@"audio"]){
                                Model.msgType = WZMMessageTypeVoice;
                                NSRange startRange = [Model.content rangeOfString:@"src=\""];
                                NSRange endRange = [Model.content rangeOfString:@"\"/>"];
                                NSString *result;
                                if (startRange.length && endRange.length) {
                                    NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
                                    result = [Model.content substringWithRange:range];
                                }else{
                                    result = Model.content;
                                }
                                Model.voiceUrl = result;
                                Model.duration = 3;
                            }else{
                                Model.msgType = WZMMessageTypeText;
                                Model.content = Model.content;
                            }
                            [messageARRlast addObject:Model];
                        }
                        [subscriber sendNext:@{@"code":@"0",@"res":messageARRlast}];
                    }else{
                        [YJProgressHUD showSuccess:@"没有更多记录啦"];
                        [subscriber sendNext:@{@"code":@"1"}];
                    }

                    [subscriber sendCompleted];
                }
            } AndFailureBack:^(NSString * _Nullable _strError) {
                [YJProgressHUD showError:_strError];
                [subscriber sendCompleted];
            } WithisLoading:NO];
            return [RACDisposable disposableWithBlock:^{

            }];
        }];
    }];


//发送消息
    self.SendCustomerServiceMessages = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSDictionary* input) {
        [YJProgressHUD showLoading:@"发送中..."];
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            //@strongify(self);
            NSString *urlStr = [NSString stringWithFormat:@"%@CustomerServiceMessages",K_APP_HOST];
            NSDictionary *param = @{
                                    @"content":input[@"text"],
                                    };
            [Utils postRequestForServerData:urlStr withParameters:param AndHTTPHeaderField:^(AFHTTPRequestSerializer * _Nullable _requestSerializer) {
                [_requestSerializer setValue:LOGIN_COOKIE forHTTPHeaderField:LOGIN_COOKIE_KEY];
            } AndSuccessBack:^(id  _Nullable _responseData) {
                [YJProgressHUD hideHUD];
                if (_responseData) {
                    [subscriber sendNext:@{@"code":@"0"}];
                    [subscriber sendCompleted];
                }
            } AndFailureBack:^(NSString * _Nullable _strError) {
                [YJProgressHUD showError:_strError];
                [subscriber sendCompleted];
            } WithisLoading:NO];
            return [RACDisposable disposableWithBlock:^{

            }];
        }];
    }];

    self.UploadFileCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSString* input) {
        [YJProgressHUD showLoading:@"上传中..."];
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//            //@strongify(self);n
            //NSString *urlStr = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"AppUrlUploadFile"];
             NSString *urlStr = uploadUrl;
            [Utils postFileUploadToServer:urlStr AndUploadformDataBack:^(id<AFMultipartFormData>  _Nullable formData) {
                NSData *data = [NSData dataWithContentsOfFile:input];
                NSString *name = @"file";
                NSString *formKey = @"file";
                NSString *type = @"audio/wav";
                [formData appendPartWithFileData:data name:formKey fileName:name mimeType:type];
            } AndHTTPHeaderField:^(AFHTTPRequestSerializer * _Nullable _requestSerializer) {
                [_requestSerializer setValue:LOGIN_COOKIE forHTTPHeaderField:LOGIN_COOKIE_KEY];
            } AndSuccessBack:^(NSDictionary * _Nullable _responseData, NSString * _Nullable _strMsg) {
                [YJProgressHUD hideHUD];
                if (_responseData) {
                    ZWWLog(@"上传录音=%@",_responseData)
                    [subscriber sendNext:@{@"code":@"0",@"res":_responseData[@"fileUrl"]}];
                }
                [subscriber sendCompleted];
            } AndFailureBack:^(NSString * _Nullable _strError) {
                [YJProgressHUD hideHUD];
                [YJProgressHUD showError:_strError];
                [subscriber sendCompleted];
            } WithisLoading:NO];
            return [RACDisposable disposableWithBlock:^{

            }];
        }];
    }];

  //上传照片
    self.UploadImageCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(UIImage* input) {
        [YJProgressHUD showLoading:@"上传中..."];
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            //@strongify(self);
//            NSString *urlStr = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"AppUrlUploadFile"];
            NSString *urlStr = uploadUrl;
            [Utils postImageUploadToServer:urlStr AndUploadformDataBack:^(id<AFMultipartFormData>  _Nullable formData) {
                NSData *data = UIImageJPEGRepresentation(input, 1.0);
                NSString *name = @"image.png";
                NSString *formKey = @"file";
                NSString *type = @"image/png";
                [formData appendPartWithFileData:data name:formKey fileName:name mimeType:type];
            }
                        AndHTTPHeaderField:^(AFHTTPRequestSerializer *_requestSerializer) {
                            [_requestSerializer setValue:LOGIN_COOKIE forHTTPHeaderField:LOGIN_COOKIE_KEY];
                        }
                            AndSuccessBack:^(NSObject *_responseData, NSString *_strMsg) {
                                if (_responseData) {
                                    [YJProgressHUD hideHUD];
                                    ZWWLog(@"上传图片====%@",_responseData)
                                    NSDictionary *dict = (NSDictionary *)_responseData;
                                    [subscriber sendNext:@{@"code":@"0",@"res":dict[@"fileUrl"]}];
                                }
                                else{
                                    [YJProgressHUD showError:(![_strMsg isKindOfClass:[NSNull class]] && _strMsg)?_strMsg:@"上传失败,请稍后再试"];
                                }
                                [subscriber sendCompleted];
                            }
                            AndFailureBack:^(NSString *_strError) {
                                ZWWLog(@"图像上传异常！详见：%@",_strError);
                                [YJProgressHUD hideHUD];
                                [YJProgressHUD showError:_strError];
                                [subscriber sendCompleted];
                            } WithisLoading:NO];
            return [RACDisposable disposableWithBlock:^{

            }];
        }];
    }];




}
@end
