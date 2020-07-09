//
//  UINavigationController+ZWNavigationController.h
//  共享蜂
//
//  Created by 张威威 on 2017/12/17.
//  Copyright © 2017年 张威威. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (ZWNavigationController)

/** 寻找Navigation中的某个viewcontroler */
- (id)findViewController:(Class)className;

/** 判断是否只有一个RootViewController */
- (BOOL)isOnlyContainRootViewController;

/** RootViewController */
- (UIViewController *)rootViewController;

/** 返回指定的viewcontroler */
- (NSArray *)popToViewControllerWithClassName:(Class)className animated:(BOOL)animated;

/** pop回第n层 */
- (NSArray *)popToViewControllerWithLevel:(NSInteger)level animated:(BOOL)animated;

///以某种动画形式push
- (void)pushViewController:(UIViewController *)controller withTransition:(UIViewAnimationTransition)transition;

///以某种动画形式pop
- (UIViewController *)popViewControllerWithTransition:(UIViewAnimationTransition)transition;


@end
