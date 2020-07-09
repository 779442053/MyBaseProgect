//
//  UserModel.h
//  KuaiZhu
//
//  Created by Ghy on 2019/5/9.
//  Copyright © 2019年 su. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * 用户模型数据
 */
@interface UserModel : NSObject

/////////////////////////////////////////////////////////
//MARK: - proterty
/////////////////////////////////////////////////////////
@property(nonatomic,assign) NSInteger id;
@property(nonatomic,assign) NSInteger resultCode;
@property(nonatomic,  copy) NSString *name;        //用户昵称
@property(nonatomic,  copy) NSString *email;
@property(nonatomic,  copy) NSString *phone;
@property(nonatomic,  copy) NSString *errorMessage;
@property(nonatomic,  copy) NSString *photo;
@property(nonatomic,  copy) NSString *LoginCookie; //cookie

/////////////////////////////////////////////////////////
//MARK: -
/////////////////////////////////////////////////////////

/** 当前登录的用户信息 */
+(nullable UserModel *)shareInstance;

/** 用户是否登录 */
+(BOOL)userIsLogin;

/** 存储当前登录用户信息 */
+(void)setUserData:(NSDictionary *)dicData;

/** 退出登录，移除用户信息 */
+(void)removeUserData;



@end

NS_ASSUME_NONNULL_END

