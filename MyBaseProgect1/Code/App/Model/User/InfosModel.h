

#import <Foundation/Foundation.h>

@interface InfosModel : NSObject

@property (nonatomic,  copy) NSString *errorMessage;

@property (nonatomic,assign) NSInteger favoriteCount;
@property (nonatomic,assign) NSInteger followCount;
@property (nonatomic,assign) NSInteger videoCount;
@property (nonatomic,assign) NSInteger heartCount;
@property (nonatomic,assign) NSInteger fansCount;
@property (nonatomic,assign) NSInteger userId;
@property (nonatomic,  copy) NSString *alipayAccount;
@property (nonatomic,assign) NSInteger balance;
@property (nonatomic,  copy) NSString *bank;
@property (nonatomic,  copy) NSString *bankAccount;
@property (nonatomic,  copy) NSString *realName;
@property (nonatomic,  copy) NSString *weChatAccount;

@property (nonatomic,  copy) NSString *isFollowed;

@property (nonatomic,  copy) NSString *name;
@property (nonatomic,  copy) NSString *photo;
@property (nonatomic,assign) NSInteger resultCode;

@end
