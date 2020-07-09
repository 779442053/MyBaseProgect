//
//  UIScrollView+ZWScrollview.h
//  共享蜂
//
//  Created by 张威威 on 2017/12/17.
//  Copyright © 2017年 张威威. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (ZWScrollview)

/**
 滚动到顶部
 */
- (void)scrollToTop;


/**
 滚动到底部
 */
- (void)scrollToBottom;


/**
 滚动到左边
 */
- (void)scrollToLeft;


- (void)scrollToRight;


- (void)scrollToTopAnimated:(BOOL)animated;


- (void)scrollToBottomAnimated:(BOOL)animated;


- (void)scrollToLeftAnimated:(BOOL)animated;


- (void)scrollToRightAnimated:(BOOL)animated;
@end
