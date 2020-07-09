//
//  NSArray+ZWARR.h
//  共享蜂
//
//  Created by 张威威 on 2017/12/17.
//  Copyright © 2017年 张威威. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (ZWARR)
//放置越界
- (id)safeObjectAtIndex:(NSUInteger)index;

/*
 
 判断是否相等
 
 default is YES
 
 **/
- (BOOL)isEqualToAnotherArray:(NSArray *)array;
@end
