//
//  AppDelegate+ZWWAppDelegate.h
//  MyBaseProgect
//
//  Created by 张威威 on 2018/4/27.
//  Copyright © 2018年 张威威. All rights reserved.
//

#import "AppDelegate.h"
#import "Reachability.h"
@interface AppDelegate (ZWWAppDelegate)
//初始化服务
-(void)initService;

//初始化 window
-(void)initWindow;

//初始化 UMeng
-(void)initUMeng;

//初始化用户系统
-(void)initUserManager;
//键盘事件
- (void)zw_setKeyBord;

//监听网络状态
- (void)monitorNetworkStatus:(NetworkStatus )status;

//单例
+ (AppDelegate *)shareAppDelegate;

/**
 当前顶层控制器
 */
-(UIViewController*) getCurrentVC;

-(UIViewController*) getCurrentUIVC;
@end
