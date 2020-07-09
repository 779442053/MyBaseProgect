//
//  AppDelegate.h
//  MyBaseProgect
//
//  Created by 张威威 on 2018/4/27.
//  Copyright © 2018年 张威威. All rights reserved.
//

#ifndef UntilMastros_h
#define UntilMastros_h

//获取系统对象
#define kApplication        [UIApplication sharedApplication]
#define kAppWindow          [UIApplication sharedApplication].delegate.window
#define kAppDelegate        [AppDelegate shareAppDelegate]
#define kRootViewController [UIApplication sharedApplication].delegate.window.rootViewController

//获取屏幕宽高
#define KScreenWidth [[UIScreen mainScreen] bounds].size.width
#define KScreenHeight [[UIScreen mainScreen] bounds].size.height
#define kScreen_Bounds [UIScreen mainScreen].bounds]
//屏幕适配
#define Iphone6ScaleWidth(with) (with)*KScreenWidth/375.0
#define Iphone6ScaleHeight(height) (height)*KScreenHeight/667.0
//根据ip6的屏幕来拉伸===
#define kRealValue(with) ((with)*(KScreenWidth/375.0f))
//字体的适配使用runtime交换方法.将系统的字体设置方法换掉
//https://www.jianshu.com/p/446099c6cdad  参考这篇博客
/// iPhone X
#define  ZWiPhoneX ([[UIScreen mainScreen] bounds].size.width == 375.f && [[UIScreen mainScreen] bounds].size.height == 812.f ? YES : NO)
#define ZWStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
/// navigation bar
#define ZWNavBarHeight self.navigationController.navigationBar.frame.size.height
///  Status bar & navigation bar height
#define ZWStatusAndNavHeight (ZWStatusBarHeight + ZWNavBarHeight)

/// Tabbar height.
#define  ZWTabbarHeight (ZWiPhoneX ? (49.f+34.f) : 49.f)
/// Tabbar safe bottom margin.
#define  ZWTabbarSafeBottomMargin (ZWiPhoneX ? 34.f : 0.f)
//强弱引用
#define ZWWWeakSelf(type)  __weak typeof(type) weak##type = type;
#define ZWWStrongSelf(type) __strong typeof(type) type = weak##type;

#define ZW(weakSelf)  __weak __typeof(&*self)weakSelf = self;

//View 圆角和加边框
#define ZWWViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

//property 使用代码块
#define VIEWSAFEAREAINSETS(view) ({UIEdgeInsets i; if(@available(iOS 11.0, *)) {i = view.safeAreaInsets;} else {i = UIEdgeInsetsZero;} i;})
///IOS 版本判断
#define IOSAVAILABLEVERSION(version) ([[UIDevice currentDevice] availableVersion:version] < 0)
// 当前系统版本
#define CurrentSystemVersion [[UIDevice currentDevice].systemVersion doubleValue]
//当前语言K
#define KCurrentLanguage (［NSLocale preferredLanguages] objectAtIndex:0])
//APP版本号
#define KAPP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
////字符串是否为空
//#define ZWWSTRING_IS_EMPTY(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )
////数组是否为空
//#define ZWWARRAY_IS_EMPTY(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
////字典是否为空
//#define ZWWDICT_IS_EMPTY(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)
//是否是空对象
#define ZWWOBJECT_IS_EMPYT(object) \
({ \
BOOL flag = NO; \
if ([object isKindOfClass:[NSNull class]] || object == nil || object == Nil || object == NULL) \
flag = YES; \
if ([object isKindOfClass:[NSString class]]) \
if ([(NSString *)object length] < 1) \
flag = YES; \
if ([object isKindOfClass:[NSArray class]]) \
if ([(NSArray *)object count] < 1) \
flag = YES; \
if ([object isKindOfClass:[NSDictionary class]]) \
if ([(NSDictionary *)object allKeys].count < 1) \
flag = YES; \
(flag); \
})


//-------------------打印日志-------------------------
//DEBUG  模式下打印日志,当前行
#ifdef DEBUG
#define ZWWLog(fmt, ...) NSLog((@"\n[文件名:%s]\n""[函数名:%s]""[行号:%d] \n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define ZWWLog(...)
#endif

//获取一段时间间隔==用来测试代码执行效率
#define kStartTime CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
#define kEndTime  NSLog(@"Time: %f", CFAbsoluteTimeGetCurrent() - start)
//打印当前方法名
#define ZWWFUNCTION() ITTDPRINT(@"%s", __PRETTY_FUNCTION__)

//单例化一个类
#define SINGLETON_FOR_HEADER(className) \
\
+ (className *)shared##className;

#define SINGLETON_FOR_CLASS(className) \
\
+ (className *)shared##className { \
static className *shared##className = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
shared##className = [[self alloc] init]; \
}); \
return shared##className; \
}






#endif /* UntilMastros_h */
