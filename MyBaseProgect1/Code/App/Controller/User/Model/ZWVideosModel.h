

#import <Foundation/Foundation.h>
@class ZWVideos, ZWAdvertisements;
NS_ASSUME_NONNULL_BEGIN

@interface ZWVideosModel : NSObject
@property (nonatomic, assign) NSInteger resultCode;

@property (nonatomic,   copy) NSString *errorMessage;
/** 广告间隔 */
@property (nonatomic, assign) NSInteger advertisementSpan;

@property (nonatomic, strong) NSArray <ZWVideos *> *videos;

@property (nonatomic, strong) NSArray <ZWAdvertisements *> *advertisements;

@end


@interface ZWVideos : NSObject

@property (nonatomic, assign) NSInteger videoId;

@property (nonatomic,   copy) NSString *title;
/** 视频封面 */
@property (nonatomic,   copy) NSString *cover;
/** 视频被收藏次数 */
@property (nonatomic, assign) NSInteger favoriteCount;
/** 视频被点赞次数 */
@property (nonatomic, assign) NSInteger heartCount;
/** 视频被查看次数 */
@property (nonatomic, assign) NSInteger viewCount;
/** 视频被评论次数 */
@property (nonatomic, assign) NSInteger commentCount;

@property (nonatomic, assign) NSInteger userID;

@property (nonatomic,   copy) NSString *userPhoto;

@property (nonatomic,   copy) NSString *createTime;

@property (nonatomic,   copy) NSString *userName;

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat ItemWidth;
@property (nonatomic, assign) CGFloat ItemHeight;
@property (nonatomic, assign) BOOL IsVerticalScreen;

@end

@interface ZWAdvertisements : NSObject

@property (nonatomic, assign) NSInteger advId;

@property (nonatomic,   copy) NSString *title;

@property (nonatomic,   copy) NSString *cover;

@property (nonatomic,   copy) NSString *url;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGFloat width;
@end

NS_ASSUME_NONNULL_END
