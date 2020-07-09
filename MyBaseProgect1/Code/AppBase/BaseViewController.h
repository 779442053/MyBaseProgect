//
//  BaseViewController.h
//  券拍拍
//
//  Created by XXP on 18/12/11.
//  Copyright (c) 2018年 XianXinTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LoginViewControllerDelegate;

@interface BaseViewController : UIViewController

//MARK: - proterty
@property(nonatomic,assign) CGFloat x;
@property(nonatomic,assign) CGFloat y;
@property(nonatomic,assign) CGFloat w;
@property(nonatomic,assign) CGFloat h;
@property(nonatomic,strong) UIView   * _Nullable navView;
@property(nonatomic,strong) UILabel  * _Nullable labPageTitle;
@property(nonatomic,strong) UIButton * _Nullable btnNavigationBack;

//MARK: -  初始化导航
/** initNavgationBar 设置导航栏 */
-(void)initNavgationBar:(UIColor *_Nullable)backgroundColor
       AndHasBottomLine:(BOOL)line
           AndHasShadow:(BOOL)shadow
          WithHasOffset:(CGFloat)offset;

//MARK: - 初始化视图标题
/** 视图标题 */
-(void)initViewControllerTitle:(NSString *_Nullable)strTitle
                  AndFontColor:(UIColor *_Nullable)fColor
                    AndHasBold:(BOOL) hasBold
                   AndFontSize:(CGFloat)fSize;

/** 设置渐变背景 */
-(void)setBackgroundColor;

//MARK: - 初始化导航返回
/** 设置返回按钮 */
-(void)initNavigationBack:(NSString *_Nullable)strBackImagName;
-(IBAction)btnNavigationBackAction:(UIButton *_Nullable)sender;

//MARK: - 手势
//-(IBAction)swipeHandelAction:(UISwipeGestureRecognizer *_Nullable)sender;

//MARK: - 登录
-(void)userToLogin:(__weak LoginViewControllerDelegate * _Nullable)delegate;

//MARK: - 右边按钮
- (void)addRightBtnWithTitle:(NSString *_Nonnull)title
                    andImage:(UIImage *_Nonnull)image;
- (void)rightAction;

@end
