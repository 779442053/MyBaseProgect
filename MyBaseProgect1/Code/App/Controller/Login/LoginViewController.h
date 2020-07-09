//
//  LoginViewController.h
//  KuaiZhu
//
//  Created by Ghy on 2019/5/13.
//  Copyright © 2019年 su. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoginVC;
@class RegisterViewController;
@class LoginViewControllerDelegate;

NS_ASSUME_NONNULL_BEGIN

/** LoginViewControllerDelegate */
@protocol LoginViewControllerDelegate<NSObject>
@optional -(void)loginFinishBack;
@end

/**
 * 登录
 */
@interface LoginViewController : BaseViewController

/** 登录完成回调 */
@property(nonatomic, weak, nullable) id<LoginViewControllerDelegate> delegate;

+(instancetype)shareInstance;

-(void)logininApp:(NSDictionary *)dicParas;
-(void)getCode:(NSDictionary *)dicParas;
//当前选中的索引
@property(nonatomic,assign) NSInteger selectIndex;
@end

NS_ASSUME_NONNULL_END