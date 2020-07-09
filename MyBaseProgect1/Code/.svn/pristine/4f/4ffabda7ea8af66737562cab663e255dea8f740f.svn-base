//
//  Setting.h
//  QuanPaiPai
//
//  Created by XianXin on 2018/12/14.
//  Copyright © 2018 XianXin. All rights reserved.
//

#ifndef Setting_h
#define Setting_h

//////////////////////////////////////////////////////////////
//MARK: - 接口信息配置
//////////////////////////////////////////////////////////////
/** 服务器地址(静态化) */
#define K_APP_STATIC_HOST [NSString stringWithFormat:@"%@Staticize/",K_APP_HOST]

/** 服务器地址 */
#define K_APP_CONFIG_KEY @"app_config_key"
#define AppUrlUploadFile @"AppUrlUploadFile"
#define K_APP_HOST ([[NSUserDefaults standardUserDefaults] stringForKey:K_APP_CONFIG_KEY]?[[NSUserDefaults standardUserDefaults] stringForKey:K_APP_CONFIG_KEY]:[[[NSBundle mainBundle] infoDictionary] valueForKey:@"AppConfigUrl"])

/** Http请求返回码 */
#define K_APP_REQUEST_CODE @"resultCode"

/** 请求返回信息  */
#define K_APP_REQUEST_MSG @"errorMessage"

/** 请求返回结果  */
#define K_APP_REQUEST_DATA @"result"

//请求超时时间(单位：秒)
#define K_APP_REQUEST_TIMEOUT 15

//请求结果(>= 0 成功)
#define kRequestOK(rs)((rs)>=0)

#endif /* Setting_h */
