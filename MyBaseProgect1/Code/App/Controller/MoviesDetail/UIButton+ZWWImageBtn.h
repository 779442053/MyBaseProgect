//
//  UIButton+ZWWImageBtn.h
//  KuaiZhu
//
//  Created by step_zhang on 2019/11/7.
//  Copyright © 2019 su. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    ButtonImgViewStyleTop,
    ButtonImgViewStyleLeft,
    ButtonImgViewStyleBottom,
    ButtonImgViewStyleRight,
} ButtonImgViewStyle;
NS_ASSUME_NONNULL_BEGIN

@interface UIButton (ZWWImageBtn)
/**
 设置 按钮 图片所在的位置
 @param style   图片位置类型（上、左、下、右）
 @param size    图片的大小
 @param space 图片跟文字间的间距
 */
- (void)setImgViewStyle:(ButtonImgViewStyle)style imageSize:(CGSize)size space:(CGFloat)space;

@end

NS_ASSUME_NONNULL_END
