

#import "ZWMyBillsModel.h"

@implementation ZWMyBillsModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"data" : [MyBillsData class]
             };
}
@end
@implementation MyBillsData

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"infoList" : [InfoData class]
             };
}

@end

@implementation InfoData

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"infoId" : @"id"};
}

@end
