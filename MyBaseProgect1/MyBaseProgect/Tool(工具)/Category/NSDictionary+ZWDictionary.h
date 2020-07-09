//
//  NSDictionary+ZWDictionary.h
//  共享蜂
//
//  Created by 张威威 on 2017/12/17.
//  Copyright © 2017年 张威威. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (ZWDictionary)
//获得一般模型属性
-(void)wh_createProperty;

//获得网络模型属性
-(void)wh_createNetProperty;

/** 合并两个NSDictionary */
+ (NSDictionary *)dictionaryByMerging:(NSDictionary *)dict1 with:(NSDictionary *)dict2;

/** 并入一个NSDictionary */
- (NSDictionary *)dictionaryByMergingWith:(NSDictionary *)dict;

- (NSDictionary *)dictionaryByAddingEntriesFromDictionary:(NSDictionary *)dictionary;

- (NSDictionary *)dictionaryByRemovingEntriesWithKeys:(NSSet *)keys;
@end
