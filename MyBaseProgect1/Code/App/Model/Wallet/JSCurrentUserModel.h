//
//  JSCurrentUserModel.h

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSCurrentUserModel : NSObject

@property (nonatomic,  copy) NSString *errorMessage;
@property (nonatomic,assign) NSInteger favoriteCount;
@property (nonatomic,assign) NSInteger followCount;
@property (nonatomic,assign) NSInteger videoCount;
@property (nonatomic,assign) NSInteger heartCount;
@property (nonatomic,assign) NSInteger fansCount;
@property (nonatomic,assign) NSInteger userId;
@property (nonatomic,  copy) NSString *isFollowed;
@property (nonatomic,  copy) NSString *name;
@property (nonatomic,  copy) NSString *photo;
@property (nonatomic,assign) NSInteger resultCode;

@property (nonatomic,copy) NSString *alipayAccount;
@property (nonatomic,copy) NSString *alipayUser;
@property (nonatomic,copy) NSString *weChatAccount;
@property (nonatomic,copy) NSString *weChatUser;
@property (nonatomic,copy) NSString *bankAccount;
@property (nonatomic,copy) NSString *bank;
@property (nonatomic,copy) NSString *bankAddress;
@property (nonatomic,copy) NSString *bankBindPhone;
@property (nonatomic,copy) NSString *bankBranch;
@property (nonatomic,copy) NSString *email;
@property (nonatomic,copy) NSString *idCardNum;

@property (nonatomic,  copy) NSString *realName;
@property (nonatomic,assign) float balance; //当前零钱
@property (nonatomic,assign) float profit;  //累计收益
@property (nonatomic,assign) float frozen;  //审核中的现金
@property (nonatomic,  copy) NSString *isDownload;
@end

NS_ASSUME_NONNULL_END
