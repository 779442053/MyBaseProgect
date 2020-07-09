//
//  UIView+ZWFram.h
//  Bracelet
//
//  Created by 张威威 on 2017/9/27.
//  Copyright © 2017年 ShYangMiStepZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ZWFram)
@property (nonatomic, assign) CGFloat viewx;
@property (nonatomic, assign) CGFloat viewy;
@property (nonatomic, assign) CGFloat viewwidth;
@property (nonatomic, assign) CGFloat viewheight;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;

@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic, assign) CGFloat maxX;
@property (nonatomic, assign) CGFloat minX;

@property (nonatomic, assign) CGFloat maxY;
@property (nonatomic, assign) CGFloat minY;
@end
