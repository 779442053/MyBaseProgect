//
//  UILabel+ZWLab.h
//  共享蜂
//
//  Created by 张威威 on 2017/12/17.
//  Copyright © 2017年 张威威. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (ZWLab)
// 快速创建标签
+(instancetype)wh_labelWithText:(NSString *)text textFont:(int)font textColor:(UIColor *)color frame:(CGRect)frame;

/**
 *  设置字间距
 */
- (void)setColumnSpace:(CGFloat)columnSpace;

/**
 *  设置行距
 */
- (void)setRowSpace:(CGFloat)rowSpace;
// 设置文字 大小 颜色区间
-(void) setText:(NSString *)text Font:(UIFont *)font withColor:(UIColor *)color Range:(NSRange)range;

-(void) setText:(NSString *)text Font:(UIFont *)font withColor:(UIColor *)color Range:(NSRange)range withColor:(UIColor *)color1 Range:(NSRange)range1;

@end
