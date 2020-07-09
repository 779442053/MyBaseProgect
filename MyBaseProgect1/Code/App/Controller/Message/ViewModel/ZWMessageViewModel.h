

#import "ZWBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZWMessageViewModel : ZWBaseViewModel
//刷新的事件
@property (nonatomic, strong) RACCommand *RefreshDataCommand;
////加载更多的事件
@property (nonatomic, strong) RACCommand *LoadMoreDataCommand;
//刷新的事件2
@property (nonatomic, strong) RACCommand *RefreshDataCommand2;
////加载更多的事件2
@property (nonatomic, strong) RACCommand *LoadMoreDataCommand2;

//刷新的事件3
@property (nonatomic, strong) RACCommand *RefreshDataCommand3;
////加载更多的事件3
@property (nonatomic, strong) RACCommand *LoadMoreDataCommand3;

//关注
@property (nonatomic, strong) RACCommand *FollowCommand;
@property (nonatomic, strong) RACCommand *UnFollowCommand;


//获取客服消息列表
@property (nonatomic, strong) RACCommand *CustomerServiceMessages;
//获取客服消息列表
@property (nonatomic, strong) RACCommand *CustomerMoreServiceMessages;
// 定时器 聊天
@property (nonatomic, strong) RACCommand *TimerServiceMessagesCommand;
//发送客服消息
@property (nonatomic, strong) RACCommand *SendCustomerServiceMessages;
//获取当前客服
@property (nonatomic, strong) RACCommand *GetCurrentConstUserCommand;

//上传文件
@property (nonatomic, strong) RACCommand *UploadFileCommand;

@property (nonatomic, strong) RACCommand *UploadImageCommand;
@end

NS_ASSUME_NONNULL_END
