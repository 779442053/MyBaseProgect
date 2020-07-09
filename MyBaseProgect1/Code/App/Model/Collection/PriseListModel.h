

#import <Foundation/Foundation.h>

@class PriseData,Advertisements;

/**
 * 喜欢模型
 */
@interface PriseListModel : NSObject

@property (nonatomic,  copy) NSString *errorMessage;

@property (nonatomic,assign) NSString *resultCode;

@property (nonatomic,  copy) NSArray <PriseData *> *videos;

@property (nonatomic, assign) NSInteger advertisementSpan;

@property (nonatomic, strong) NSArray <Advertisements *> *advertisements;

@end

@interface PriseData : NSObject

@property (nonatomic,assign) NSInteger priseId;

@property (nonatomic,assign) NSInteger favoriteID;

@property (nonatomic,  copy) NSString *title;

@property (nonatomic,  copy) NSString *cover;

@property (nonatomic,assign) NSInteger favoriteCount;

@property (nonatomic,assign) NSInteger userID;

@property (nonatomic,assign) NSInteger commentCount;

@property (nonatomic,assign) NSInteger heartCount;

@property (nonatomic,  copy) NSString *userName;

@property (nonatomic,  copy) NSString *userPhoto;

@property (nonatomic,assign) NSInteger viewCount;

@property (nonatomic,  copy) NSString *auditTime;

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat ItemWidth;
@property (nonatomic, assign) CGFloat ItemHeight;
@property (nonatomic, assign) BOOL IsVerticalScreen;

@end