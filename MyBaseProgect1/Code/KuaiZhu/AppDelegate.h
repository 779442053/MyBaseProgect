//
//  AppDelegate.h
//  KuaiZhu
//
//  Created by Ghy on 2019/5/9.
//  Copyright © 2019年 su. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigation;

+(instancetype)shareInstance;

@end

