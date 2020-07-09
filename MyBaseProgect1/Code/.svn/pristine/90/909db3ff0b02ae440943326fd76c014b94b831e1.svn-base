//
//  UserModel.m
//  KuaiZhu
//
//  Created by Ghy on 2019/5/9.
//  Copyright © 2019年 su. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel


/////////////////////////////////////////////////////////
//MARK: -
/////////////////////////////////////////////////////////
/** 当前登录的用户信息 */
+(nullable UserModel *)shareInstance{
    
    //登录成功
    NSDictionary *objUserData = [[NSUserDefaults standardUserDefaults] dictionaryForKey:K_APP_LOGIN_DATA_KEY];
    if(objUserData){
        //字典转换为模型
        UserModel *_shareInstance = [UserModel mj_objectWithKeyValues:objUserData];
        
        return _shareInstance;
    }
    return nil;
}

/** 用户是否登录 */
+(BOOL)userIsLogin{
    BOOL _isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:K_APP_LOGIN_SET_KEY];
    if (_isLogin){
        NSDictionary *objUserData = [[NSUserDefaults standardUserDefaults] dictionaryForKey:K_APP_LOGIN_DATA_KEY];
        
        if(objUserData) return YES;
    }
    
    return NO;
}

/** 存储当前登录用户信息 */
+(void)setUserData:(NSDictionary *)dicData{
    
    if(dicData && [dicData allKeys] > 0){
        NSMutableDictionary *_dicTemp = [NSMutableDictionary dictionaryWithDictionary:dicData];
        
        //移除模型中没有值的对象，否则存储到沙盒会崩溃
        id objValue;
        NSString *strKey;
        NSArray *arrKeys = [_dicTemp allKeys];
        
        for (NSUInteger i = 0,len = [arrKeys count]; i < len; i++) {
            strKey = [NSString stringWithFormat:@"%@",arrKeys[i]];
            objValue = [_dicTemp valueForKey:strKey];
            
            if ([objValue isKindOfClass:[NSNull class]] || objValue == NULL || objValue == nil) {
                
                //置为空字符串
                [_dicTemp setValue:@"" forKey:strKey];
            }
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:_dicTemp forKey:K_APP_LOGIN_DATA_KEY];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:K_APP_LOGIN_SET_KEY];
    }
    else{
        //退出登录
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:K_APP_LOGIN_SET_KEY];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/** 退出登录，移除用户信息 */
+(void)removeUserData{
    //退出登录
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:K_APP_LOGIN_DATA_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:K_APP_LOGIN_SET_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



@end

