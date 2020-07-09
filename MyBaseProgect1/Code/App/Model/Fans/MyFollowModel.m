//

#import "MyFollowModel.h"

@implementation MyFollowModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"data" : [FollowArr class]
             };
}

@end

@implementation FollowArr

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"userId" : @"id"};
}

@end
