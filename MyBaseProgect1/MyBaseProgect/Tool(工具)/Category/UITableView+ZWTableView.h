//
//  UITableView+ZWTableView.h
//  共享蜂
//
//  Created by 张威威 on 2017/12/17.
//  Copyright © 2017年 张威威. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (ZWTableView)
///刷新
- (void)updateWithBlock:(void (^)(UITableView *tableView))block;

//滚动到某处
- (void)scrollToRow:(NSUInteger)row inSection:(NSUInteger)section atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated;

//插入某一行
- (void)insertRow:(NSUInteger)row inSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;

//刷新某一行
- (void)reloadRow:(NSUInteger)row inSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;

//删除某一行
- (void)deleteRow:(NSUInteger)row inSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;

//插入带有动画
- (void)insertRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation;

//刷新带有动画
- (void)reloadRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation;

//删除带有动画
- (void)deleteRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation;

//插入某一区
- (void)insertSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;

//删除某一区
- (void)deleteSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;


- (void)reloadSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;

//饭选择
- (void)clearSelectedRowsAnimated:(BOOL)animated;
@end
