
/*

 音频播放.播放本地或者网络返url形式的t音频

 */
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWAudioPlayer : NSObject
/**
 单例

 @return YHAudioPlayer
 */
+ (instancetype)shareInstanced;

/**
 播放音频

 @param url 路径字符串
 @param progress 进度（0-1）1:代表播放完成
 */
- (void)playWithUrlString:(NSString *)url progress:(void(^)(float progress))progress;
@end

NS_ASSUME_NONNULL_END
