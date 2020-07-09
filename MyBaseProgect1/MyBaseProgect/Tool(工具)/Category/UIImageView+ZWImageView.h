//
//  UIImageView+ZWImageView.h
//  共享蜂
//
//  Created by 张威威 on 2017/12/17.
//  Copyright © 2017年 张威威. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (ZWImageView)
//快速创建imageView
+(instancetype)wh_imageViewWithPNGImage:(NSString *)imageName frame:(CGRect)frame;

- (void)setHeaderWithURL:(NSURL *)url;

- (UIImageView *)CreateImageViewWithFrame:(CGRect)rect
                            andBackground:(CGColorRef)color
                                andRadius:(CGFloat)radius;
@end
