

#import "JSCurrentUserModel.h"

@implementation JSCurrentUserModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"userId" : @"id"};
}
@end
