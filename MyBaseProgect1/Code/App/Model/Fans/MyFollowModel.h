//


#import <Foundation/Foundation.h>

@class FollowArr;
@interface MyFollowModel : NSObject

@property (nonatomic,   copy) NSString *errorMessage;

@property (nonatomic, assign) NSInteger resultCode;

@property (nonatomic,   copy) NSArray <FollowArr *> *data;

@end

@interface FollowArr : NSObject

@property (nonatomic, assign) NSInteger followid;

@property (nonatomic, assign) NSInteger userId;

@property (nonatomic,   copy) NSString *name;

@property (nonatomic,   copy) NSString *photo;

@property (nonatomic, assign) NSInteger fansCount;


@end
