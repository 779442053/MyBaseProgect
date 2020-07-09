//


#import <Foundation/Foundation.h>

@class SearchData;
@interface SearchModel : NSObject

@property (nonatomic,  assign) NSInteger resultCode;

@property (nonatomic,    copy) NSString *errorMessage;

@property (nonatomic,    copy) NSArray <SearchData *> *videos;

@end

@interface SearchData : NSObject

@property (nonatomic,assign) NSInteger videoId;

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