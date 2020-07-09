

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWMessageModel : NSObject
@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *userID;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *photo;
@property(nonatomic,copy)NSString *sendTime;
@end

NS_ASSUME_NONNULL_END
