

#import <Foundation/Foundation.h>

@class CommontData,Advertisements;

/**
 * 评论模型
 */
@interface CommontsListModel : NSObject

@property (nonatomic,assign) NSInteger resultCode;

@property (nonatomic,  copy) NSString *errorMessage;

@property (nonatomic,assign) NSInteger videoCount;

@property (nonatomic,  copy) NSArray <CommontData *> *data;

@property (nonatomic, assign) NSInteger advertisementSpan;

@property (nonatomic, strong) NSArray <Advertisements *> *advertisements;

@end

@interface CommontData : NSObject

@property (nonatomic,assign) NSInteger commontId;

@property (nonatomic,assign) NSInteger favoriteID;

@property (nonatomic,  copy) NSString *title;

@property (nonatomic,  copy) NSString *cover;

@property (nonatomic,  copy) NSString *videoCover;

@property (nonatomic,assign) NSInteger favoriteCount;

@property (nonatomic,assign) NSInteger userID;

@property (nonatomic,assign) NSInteger commentCount;

@property (nonatomic,assign) NSInteger heartCount;

@property (nonatomic,  copy) NSString *userName;

@property (nonatomic,  copy) NSString *photo;
//被评论的视频被查看的多少次
@property (nonatomic,assign) NSInteger videoViewCount;

@property (nonatomic,  copy) NSString *auditTime;
@property (nonatomic,  copy) NSString *sendTime;
//评论内容 videoUserName
@property (nonatomic,  copy) NSString *context;
@property (nonatomic,  copy) NSString *videoUserName;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat ItemWidth;
@property (nonatomic, assign) CGFloat ItemHeight;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, assign) BOOL IsVerticalScreen;
@end