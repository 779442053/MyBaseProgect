//
//  ZWWDelayStartupTool.h
//  MyBaseProgect
//
//  Created by 张威威 on 2018/5/9.
//  Copyright © 2018年 张威威. All rights reserved.
//
/**
 * 注意: 这个类负责所有的 didFinishLaunchingWithOptions 延迟事件的加载.
 * 以后引入第三方需要在 didFinishLaunchingWithOptions 里初始化或者我们自己的类需要在 didFinishLaunchingWithOptions 初始化的时候,
 * 要考虑尽量少的启动时间带来好的用户体验, 所以应该根据需要减少 didFinishLaunchingWithOptions 里耗时的操作.
 * 第一类: 比如日志 / 统计等需要第一时间启动的, 仍然放在 didFinishLaunchingWithOptions 中.
 * 第二类: 比如用户数据需要在广告显示完成以后使用, 所以需要伴随广告页启动, 只需要将启动代码放到 startupEventsOnADTimeWithAppDelegate 方法里.
 * 第三类: 比如直播和分享等业务, 肯定是用户能看到真正的主界面以后才需要启动, 所以推迟到主界面加载完成以后启动, 只需要将代码放到 startupEventsOnDidAppearAppContent 方法里.
 */

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface ZWWDelayStartupTool : NSObject
/**
 * 启动伴随 didFinishLaunchingWithOptions 启动的事件.
 * 启动类型为:日志 / 统计等需要第一时间启动的.
 */
+ (void)startupEventsOnAppDidFinishLaunchingWithOptions;
/**
 * 启动可以在展示广告的时候初始化的事件.
 * 启动类型为: 用户数据需要在广告显示完成以后使用, 所以需要伴随广告页启动.
 */
+ (void)startupEventsOnADTime;
/**
 * 启动在第一个界面显示完(用户已经进入主界面)以后可以加载的事件.
 * 启动类型为: 比如直播和分享等业务, 肯定是用户能看到真正的主界面以后才需要启动, 所以推迟到主界面加载完成以后启动.
 */
+ (void)startupEventsOnDidAppearAppContent;
@end
NS_ASSUME_NONNULL_END
