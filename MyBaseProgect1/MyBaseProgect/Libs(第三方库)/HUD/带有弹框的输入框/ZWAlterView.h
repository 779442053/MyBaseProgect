//
//  ZWAlterView.h
//  Bracelet
//
//  Created by 张威威 on 2017/9/28.
//  Copyright © 2017年 ShYangMiStepZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 弹窗上的按钮
 
 - AlertButtonLeft: 左边的按钮
 - AlertButtonRight: 右边的按钮
 */
typedef NS_ENUM(NSUInteger, AbnormalButton) {
    AlertButtonLeft = 0,
    AlertButtonRight
};
#pragma mark - 协议

@class ZWAlterView;

@protocol ZWAlterViewDelegate <NSObject>

- (void)declareAbnormalAlertView:(ZWAlterView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end


#pragma mark - interface

/** 申报异常弹窗 */
@interface ZWAlterView : UIView

/** 这个弹窗对应的orderID */
@property (nonatomic,copy) NSString *orderID;
/** 用户填写异常情况的textView */
@property (nonatomic,strong) UITextView *textView;

@property (nonatomic,weak) id<ZWAlterViewDelegate> delegate;

/**
 申报异常弹窗的构造方法
 
 @param title 弹窗标题
 @param message 弹窗message
 @param delegate 确定代理方
 @param leftButtonTitle 左边按钮的title
 @param rightButtonTitle 右边按钮的title
 @return 一个申报异常的弹窗
 */
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate leftButtonTitle:(NSString *)leftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle;

/** show出这个弹窗 */
- (void)show;

@end
