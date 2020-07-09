//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWAudioModel : NSObject
@property (nonatomic,copy) NSString *ext;    //后缀格式
@property (nonatomic,assign) float  duration;//时长
@property (nonatomic,copy) NSURL *url;       //音频url
@end

NS_ASSUME_NONNULL_END
