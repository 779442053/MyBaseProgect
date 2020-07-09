//
//  ZWMethods.h
//  共享蜂
//
//  Created by 张威威 on 2017/12/17.
//  Copyright © 2017年 张威威. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZWMethods : UIViewController
//更改iOS状态栏的颜色
+ (void)wh_setStatusBarBackgroundColor:(UIColor *)color;

//为控制器添加背景图片
+ (void)wh_addBackgroundImageWithImageName:(NSString *)imageName forViewController:(UIViewController *)viewController;

//最大,最小,和,平均
+ (CGFloat) wh_maxNumberFromArray:(NSArray *)array;
+ (CGFloat) wh_minNumberFromArray:(NSArray *)array;
+ (CGFloat) wh_sumNumberFromArray:(NSArray *)array;
+ (CGFloat) wh_averageNumberFromArray:(NSArray *)array;

//可用硬件容量
+ (CGFloat) wh_usableHardDriveCapacity;
//硬件总容量
+ (CGFloat) wh_allHardDriveCapacity;
@end
