

#import <Foundation/Foundation.h>

@class FansData;

@interface FansModel : NSObject

@property (nonatomic,  copy) NSString *errorMessage;

@property (nonatomic,assign) NSInteger resultCode;

@property (nonatomic,  copy) NSArray <FansData *> *data;

@end

@interface FansData : NSObject

@property (nonatomic,assign) NSInteger fansId;

@property (nonatomic,  copy) NSString *name;

@property (nonatomic,  copy) NSString *photo;

//0 未关注该用户， 大于 0 关注数据的ID
@property (nonatomic,assign) NSInteger followid;

@property (nonatomic,assign) NSInteger fansCount;

@property (nonatomic,assign) NSInteger isFollowed;

@end
