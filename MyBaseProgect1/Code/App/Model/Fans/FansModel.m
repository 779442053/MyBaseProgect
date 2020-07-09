//

#import "FansModel.h"

@implementation FansModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"data" : [FansData class]
             };
}

@end

@implementation FansData

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"fansId" : @"id"
             };
}

@end
