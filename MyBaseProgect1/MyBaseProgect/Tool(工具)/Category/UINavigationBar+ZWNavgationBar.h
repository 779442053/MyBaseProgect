//
//  UINavigationBar+ZWNavgationBar.h
//  ShareBee
//
//  Created by 张威威 on 2017/12/25.
//  Copyright © 2017年 张威威. All rights reserved.
//
/*
  [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
 - (void)viewWillAppear:(BOOL)animated{
 [super viewWillAppear:animated];
 //    self.navigationController.navigationBarHidden = YES;
 self.tableView.delegate = self;
 //界面从上一界面返回的时候，再次设置为之前的颜色
 [self scrollViewDidScroll:self.tableView];
 [self.navigationController.navigationBar setShadowImage:[UIImage new]];
 }
 - (void)viewWillDisappear:(BOOL)animated{
 [super viewWillDisappear:animated];
 self.tableView.delegate = nil;
 [self.navigationController.navigationBar reset];
 }
 
 - (void)scrollViewDidScroll:(UIScrollView *)scrollView{
 UIColor * color = [UIColor redColor];
 CGFloat offsetY = scrollView.contentOffset.y;
 if (offsetY > NAVBAR_CHANGE_POINT) {
 CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
 [self.navigationController.navigationBar setBackgroundColor:[color colorWithAlphaComponent:alpha]];
 } else {
 [self.navigationController.navigationBar setBackgroundColor:[color colorWithAlphaComponent:0]];
 }
 }
 */

#import <UIKit/UIKit.h>

@interface UINavigationBar (ZWNavgationBar)
//设置背景颜色
- (void)setBackgroundColor:(UIColor *)backgroundColor;
//设置leftItem、rightItem、titleView的alpha
- (void)setElementsAlpha:(CGFloat)alpha;
//重置回原来的样式
- (void)reset;
@end
