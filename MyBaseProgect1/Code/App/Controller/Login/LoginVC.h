//
//  LoginViewController.h
//  KuaiZhu
//
//  Created by Ghy on 2019/5/13.
//  Copyright © 2019年 su. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
NS_ASSUME_NONNULL_BEGIN

/**
 * 登录
 */
@interface LoginVC : BaseViewController
@property(nonatomic, weak) LoginViewController *delegateVC;
@end

NS_ASSUME_NONNULL_END
