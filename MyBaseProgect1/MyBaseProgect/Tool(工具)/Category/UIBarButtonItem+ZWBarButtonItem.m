//
//  UIBarButtonItem+ZWBarButtonItem.m
//  共享蜂
//
//  Created by 张威威 on 2017/12/17.
//  Copyright © 2017年 张威威. All rights reserved.
//

#import "UIBarButtonItem+ZWBarButtonItem.h"

@implementation UIBarButtonItem (ZWBarButtonItem)

+(instancetype _Nullable )wh_barButtonItemWithTitle:(NSString *_Nullable)title imageName:(NSString *_Nullable)imageName target:(nullable id)target action:(nonnull SEL)action fontSize:(CGFloat)fontSize titleNormalColor:(UIColor *_Nullable)normalColor titleHighlightedColor:(UIColor *_Nullable)highlightedColor {
    
    UIButton *button = [UIButton new];
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setTitleColor:normalColor forState:UIControlStateNormal];
    [button setTitleColor:highlightedColor forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (instancetype)barButtonLeftItemWithImageName:(NSString *)imageName
                                        target:(id)target
                                        action:(SEL)action {
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 22)];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8);
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    return barButtonItem;
}

+ (instancetype)barButtonRightItemWithImageName:(NSString *)imageName
                                         target:(id)target
                                         action:(SEL)action {
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 22)];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 28, 0, 0);
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    return barButtonItem;
    
}

+ (instancetype)barButtonItemWithImageName:(NSString *)imageName
                           imageEdgeInsets:(UIEdgeInsets)imageEdgeInsets
                                    target:(id)target
                                    action:(SEL)action {
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 22)];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.imageEdgeInsets = imageEdgeInsets;
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    return barButtonItem;
}

+ (instancetype)barButtonItemWithTitle:(NSString *)title
                                target:(id)target
                                action:(SEL)action {
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
    button.titleLabel.textAlignment = NSTextAlignmentRight;
    //[button setTitleColor:[UIColor colorWith XCFThemeColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    return barButtonItem;
}

+ (instancetype)barButtonItemWithTitle:(NSString *)title
                         selectedTitle:(NSString *)selTitle
                                target:(id)target
                                action:(SEL)action {
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
    //[button setTitleColor:XCFThemeColor forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:selTitle forState:UIControlStateSelected];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    return barButtonItem;
}
@end
