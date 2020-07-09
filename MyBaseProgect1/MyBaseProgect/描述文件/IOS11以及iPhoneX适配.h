//
//  IOS11以及iPhoneX适配.h
//  MyBaseProgect
//
//  Created by 张威威 on 2018/5/9.
//  Copyright © 2018年 张威威. All rights reserved.
//
/*
 
 ios11 以后Right/Left CustomView和屏幕边缘的间距进行了调整，11上为16point，10为8point。导致在两种版本上的边距显示不正确
 - (void)layoutSubviews {
 [super layoutSubviews];
 
 if (@available(iOS 11, *)) {
 self.layoutMargins = UIEdgeInsetsZero;
 
 for (UIView *subview in self.subviews) {
 if ([NSStringFromClass([subview class]) containsString:@"ContentView"]) {
 UIEdgeInsets oEdges = subview.layoutMargins;
 subview.layoutMargins = UIEdgeInsetsMake(0, 0, 0, oEdges.right);
 }
 }
 }
 }
 
   https://www.jianshu.com/p/45ad9fa3f47f   修改基类里面的控制性
 
 
 导航栏高度的变化
 iOS11之前导航栏默认高度为64pt(这里高度指statusBar + NavigationBar)，iOS11之后如果设置了prefersLargeTitles = YES则为96pt，默认情况下还是64pt，但在iPhoneX上由于刘海的出现statusBar由以前的20pt变成了44pt，所以iPhoneX上高度变为88pt，如果项目里隐藏了导航栏加了自定义按钮之类的，这里需要注意适配一下
 
 
 
 大家在iOS11设备上运行出现最多问题应该就是tableview莫名奇妙的偏移20pt或者64pt了。。原因是iOS11弃用了automaticallyAdjustsScrollViewInsets属性，取而代之的是UIScrollView新增了contentInsetAdjustmentBehavior属性，这一切的罪魁祸首都是新引入的safeArea，关于safeArea适配这篇文章iOS 11 安全区域适配总结讲的很详细，感兴趣的可以看下，我直接贴适配代码，因为低版本直接用contentInsetAdjustmentBehavior会报警告，所有定义了如下的宏
 
 #define  adjustsScrollViewInsets(scrollView)\
 do {\
 _Pragma("clang diagnostic push")\
 _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")\
 if ([scrollView respondsToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
 NSMethodSignature *signature = [UIScrollView instanceMethodSignatureForSelector:@selector(setContentInsetAdjustmentBehavior:)];\
 NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];\
 NSInteger argument = 2;\
 invocation.target = scrollView;\
 invocation.selector = @selector(setContentInsetAdjustmentBehavior:);\
 [invocation setArgument:&argument atIndex:2];\
 [invocation retainArguments];\
 [invocation invoke];\
 }\
 _Pragma("clang diagnostic pop")\
 } while (0)
 
 
 全局适配
 // AppDelegate 进行全局设置
 if (@available(iOS 11.0, *)){
 [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
 }
 
 解决高度跳动不稳定问题
 self.tableView.estimatedRowHeight = 0;
 self.tableView.estimatedSectionHeaderHeight = 0;
 self.tableView.estimatedSectionFooterHeight = 0;
 
 
 https://www.jianshu.com/p/26fc39135c34
 
 */
