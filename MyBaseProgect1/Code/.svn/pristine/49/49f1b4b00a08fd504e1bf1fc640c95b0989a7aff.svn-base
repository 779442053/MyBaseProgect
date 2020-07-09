

#import "ZWUserModel.h"
#import <objc/runtime.h>
#define userTag @"user"
@implementation ZWUserModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"ID" : @"id"};
}
+ (instancetype)currentUser
{
    static ZWUserModel *user = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        user = [[ZWUserModel alloc]init];
        user.ID = @"";
        user.name = @"";
        user.phone = @"";
        user.photo = @"";
        user.email = @"";
        user.videoCount = @"";
        user.isFollowed=@"0";
        user.followCount = @"0";
        user.balance = @"0.00";
        user.fansCount = @"0";
        user.favoriteCount = @"0";
        user.heartCount = @"0";
        user.alipayAccount = @"0";
        user.alipayUser = @"";
        user.weChatAccount = @"";
        user.weChatUser = @"";
        user.bankAccount = @"";
        user.bank = @"";
        user.realName = @"";
        user.profit = @"0.00";
        user.frozen = @"0.00";
        user.auditMoney = @"0.00";
        user.isDownload = @"0";
    });
    return user;
}
- (NSString *)description
{
    return [NSString stringWithFormat:@"name = %@ ,token = %@ realName = %@",self.name,self.ID,self.realName];
}



//实现归档解档
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    unsigned int count = 0;
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);

    for (int i = 0 ; i < count; i++)
    {
        objc_property_t pro = propertyList[i];
        const char *name = property_getName(pro);
        NSString *key = [NSString stringWithUTF8String:name];
        if ([aDecoder decodeObjectForKey:key])
        {
            [self setValue:[aDecoder decodeObjectForKey:key] forKey:key];
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    unsigned int count = 0;
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    for (int i = 0 ; i < count; i ++)
    {
        objc_property_t pro = propertyList[i];
        const char *name = property_getName(pro);
        NSString *key  = [NSString stringWithUTF8String:name];
        [aCoder encodeObject:[self valueForKey:key] forKey:key];
    }
}
@end
