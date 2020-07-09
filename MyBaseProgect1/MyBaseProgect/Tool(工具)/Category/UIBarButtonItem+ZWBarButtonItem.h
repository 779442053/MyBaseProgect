//
//  UIBarButtonItem+ZWBarButtonItem.h
//  共享蜂
//
//  Created by 张威威 on 2017/12/17.
//  Copyright © 2017年 张威威. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (ZWBarButtonItem)

//快速创建导航栏按钮
+(instancetype _Nullable )wh_barButtonItemWithTitle:(NSString *_Nullable)title imageName:(NSString *_Nullable)imageName target:(nullable id)target action:(nonnull SEL)action fontSize:(CGFloat)fontSize titleNormalColor:(UIColor *_Nullable)normalColor titleHighlightedColor:(UIColor *_Nullable)highlightedColor;

+ (instancetype)barButtonLeftItemWithImageName:(NSString *)imageName
                                        target:(id)target
                                        action:(SEL)action;
+ (instancetype)barButtonRightItemWithImageName:(NSString *)imageName
                                         target:(id)target
                                         action:(SEL)action;
+ (instancetype)barButtonItemWithImageName:(NSString *)imageName
                           imageEdgeInsets:(UIEdgeInsets)imageEdgeInsets
                                    target:(id)target
                                    action:(SEL)action;


+ (instancetype)barButtonItemWithTitle:(NSString *)title
                                target:(id)target
                                action:(SEL)action;
+ (instancetype)barButtonItemWithTitle:(NSString *)title
                         selectedTitle:(NSString *)selTitle
                                target:(id)target
                                action:(SEL)action;
@end
