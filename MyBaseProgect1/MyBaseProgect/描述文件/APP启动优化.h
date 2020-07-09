//
//  APP启动优化.h
//  MyBaseProgect
//
//  Created by 张威威 on 2018/5/9.
//  Copyright © 2018年 张威威. All rights reserved.
//

/*
 优化思路是
 
 1. 移除不需要用到的动态库
 
 2. 移除不需要用到的类
 
 3. 合并功能类似的类和扩展
 
 4. 尽量避免在+load方法里执行的操作，可以推迟到+initialize方法中。
 
 日志、统计等必须在 APP 一起动就最先配置的事件
 项目配置、环境配置、用户信息的初始化 、推送、IM等事件
 其他 SDK 和配置事件
 

 * 注意: 这个类负责所有的 didFinishLaunchingWithOptions 延迟事件的加载.
 * 以后引入第三方需要在 didFinishLaunchingWithOptions 里初始化或者我们自己的类需要在 didFinishLaunchingWithOptions 初始化的时候,
 * 要考虑尽量少的启动时间带来好的用户体验, 所以应该根据需要减少 didFinishLaunchingWithOptions 里耗时的操作.
 * 第一类: 比如日志 / 统计等需要第一时间启动的, 仍然放在 didFinishLaunchingWithOptions 中.
 * 第二类: 比如用户数据需要在广告显示完成以后使用, 所以需要伴随广告页启动, 只需要将启动代码放到 startupEventsOnADTimeWithAppDelegate 方法里.
 * 第三类: 比如直播和分享等业务, 肯定是用户能看到真正的主界面以后才需要启动, 所以推迟到主界面加载完成以后启动, 只需要将代码放到 startupEventsOnDidAppearAppContent 方法里.
 
 使用 +initialize 来替代 +load
 不要使用 __atribute__((constructor)) 将方法显式标记为初始化器，而是让初始化方法调用时才执行。比如使用dispatch_once(),pthread_once() 或 std::once()。也就是在第一次使用时才初始化，推迟了一部分工作耗时。
 
 
 
 
 在 Xcode 中 Edit scheme -> Run -> Auguments 将环境变量DYLD_PRINT_STATISTICS 设为 1
 http://www.cocoachina.com/ios/20170816/20267.html
 
 
 */
