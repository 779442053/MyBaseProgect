//


#import "HelpsModel.h"

@implementation HelpsModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"data" : [HelpsData class]
             };
}

@end

@implementation HelpsData

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"helpsid" : @"id"};
}

@end
