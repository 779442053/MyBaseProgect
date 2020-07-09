//
//  UIImageView+ZWMisaligned.m
//  ShareBee
//
//  Created by 张威威 on 2017/12/25.
//  Copyright © 2017年 张威威. All rights reserved.
//
//运行这段代码，然后在模拟器中点击Debug-->Color Misaligned Color。不出现以外的话会发现图像呈现为谈黄色，这是因为图片在UIImageView上做了拉升，这种拉伸一般都会影响程序的性能。一般的解决方案就是通过CoreGraphic核心绘图这个框架，重新绘制图片，绘制的图片尺寸大小和UIImageView的尺寸大小完全一致，就能达到优化程序的目的。常规做法可能就是封装一个方法，传入图片名、UIImageView的frame，然后返回一张图片。但是这里我并不打算这样做，我的主要目的是：不改写以下代码，只需要简单的拖入一个文件，就连头文件都不用导入，就能达到优化解决图片拉升优化程序的目的。

//导入这个类,即可高性能的渲染imageview的加载.一行代码也不用写

#import "UIImageView+ZWMisaligned.h"
#import <objc/runtime.h>
@implementation UIImageView (ZWMisaligned)

//在类被加载到运行时的时候，就会执行
//+ (void)load{
//    //方法都是定义在类里面，所以获取方法以Class开头
//    //获取类方法  参一：获取那个类的方法  参二：获取方法编号，根据SEL找到类对应的方法
//    Method originalMethod = class_getInstanceMethod([self class], @selector(setImage:));
//    Method swizzledMethod = class_getInstanceMethod([self class], @selector(zw_setImage:));
//    //交换方法的实现
//    method_exchangeImplementations(originalMethod, swizzledMethod);
//}

//自定义的和系统方法交换
- (void)zw_setImage:(UIImage *)image{
    //第三个参数是分辨率  如果设置为0，会根据设备自动设置图片分辨率
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0);
    //绘制图像
    [image drawInRect:self.bounds];
    //获取结果
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    //关闭上下文
    UIGraphicsEndImageContext();
    //调用系统默认的设置图片的方法，即已经交换过自己写的方法
    [self zw_setImage:result];
}
@end
