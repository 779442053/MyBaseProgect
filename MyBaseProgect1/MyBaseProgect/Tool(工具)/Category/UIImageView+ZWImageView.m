//
//  UIImageView+ZWImageView.m
//  共享蜂
//
//  Created by 张威威 on 2017/12/17.
//  Copyright © 2017年 张威威. All rights reserved.
//

#import "UIImageView+ZWImageView.h"
#import "UIImage+ZWImage.h"

@implementation UIImageView (ZWImageView)

+(instancetype)wh_imageViewWithPNGImage:(NSString *)imageName frame:(CGRect)frame {
    UIImageView *imageV=[[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    imageV.frame=frame;
    return imageV;
}

- (void)setHeaderWithURL:(NSURL *)url {
    UIImage *placeholder = [[UIImage imageNamed:@"app_wode_touxing"] circleImage];

    [self sd_setImageWithURL:url
            placeholderImage:placeholder
                   completed:^(UIImage *image,
                               NSError *error,
                               SDImageCacheType cacheType,
                               NSURL *imageURL) {
                       self.image = image ? [image circleImage] : placeholder;
                   }];
    
}

- (UIImageView *)CreateImageViewWithFrame:(CGRect)rect
                            andBackground:(CGColorRef)color
                                andRadius:(CGFloat)radius{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UIGraphicsBeginImageContext(imageView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();   // 设置上下文
    CGContextSetLineWidth(context, 1);                  // 边框大小
    CGContextSetStrokeColorWithColor(context, color);   // 边框颜色
    CGContextSetFillColorWithColor(context, color);     // 填充颜色
    
    CGFloat x = rect.origin.x;
    CGFloat y = rect.origin.y;
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGContextMoveToPoint(context, x+width, y+radius/2);
    CGContextAddArcToPoint(context, x+width, y+height, x+width-radius/2, y+height, radius);
    CGContextAddArcToPoint(context, x, y+height, x, y+height-radius/2, radius);
    CGContextAddArcToPoint(context, x, y, x+radius/2, y, radius);
    CGContextAddArcToPoint(context, x+width, y, x+width, y+radius/2, radius);
    CGContextDrawPath(context, kCGPathFillStroke);
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    return imageView;
}
@end
