

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWDownLoadManager : NSObject
+ (ZWDownLoadManager *)sharedInstance;

/*
 *  下载聊天语音 (文件方式保存)  若下载过,会从加载缓存
 *  @param requestUrl       后台返回的Url
 *  @param progress         下载进度
 *  @param complete         成功失败回调
 */
- (void)downLoadAudioWithRequestUrl:(NSString *)requestUrl complete:(void (^)(BOOL success,id obj))complete progress:(void(^)(int64_t bytesWritten, int64_t totalBytesWritten))progress;
@end

NS_ASSUME_NONNULL_END
