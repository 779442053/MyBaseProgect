//
//  UIView+ZWFram.m
//  Bracelet
//
//  Created by 张威威 on 2017/9/27.
//  Copyright © 2017年 ShYangMiStepZhang. All rights reserved.
//

#import "UIView+ZWFram.h"

@implementation UIView (ZWFram)


- (void)setViewx:(CGFloat)viewx
{
    CGRect frame = self.frame;
    frame.origin.x = viewx;
    self.frame = frame;
}

- (void)setViewy:(CGFloat)viewy
{
    CGRect frame = self.frame;
    frame.origin.y = viewy;
    self.frame = frame;
}

- (CGFloat)viewx
{
    return self.frame.origin.x;
}

- (CGFloat)viewy
{
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)viewwidth
{
    CGRect frame = self.frame;
    frame.size.width = viewwidth;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)viewheight
{
    CGRect frame = self.frame;
    frame.size.height = viewheight;
    self.frame = frame;
}

- (CGFloat)viewheight
{
    return self.frame.size.height;
}

- (CGFloat)viewwidth
{
    return self.frame.size.width;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
    
}
- (CGFloat)centerX
{
    return self.center.x;
}
- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
    
}
- (CGFloat)centerY
{
    return self.center.x;
}

/** 获取最大x */
- (CGFloat)maxX{
    return self.viewx + self.viewwidth;
}
/** 获取最小x */
- (CGFloat)minX{
    return self.x;
}

/** 获取最大y */
- (CGFloat)maxY{
    return self.viewy + self.viewheight;
}
/** 获取最小y */
- (CGFloat)minY{
    return self.y;
}
/** 设置最小x,相当于设置x */
- (void)setMinX:(CGFloat)minX{
    self.x = minX;
}

/** 设置最大x */
- (void)setMaxX:(CGFloat)maxX{
    self.x = maxX - self.viewwidth;
}

/** 设置最小y,相当于设置y */
- (void)setMinY:(CGFloat)minY{
    self.y = minY;
}

/** 设置最大y */
- (void)setMaxY:(CGFloat)maxY{
    self.y = maxY - self.viewheight;
}





@end
