//
//  ZWWNSUserDefault.h
//  MyBaseProgect
//
//  Created by 张威威 on 2018/4/27.
//  Copyright © 2018年 张威威. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZWWNSUserDefault : NSObject
+ (id)objectForKey:(NSString *)defaultName;

+ (void)setObject:(id)value forKey:(NSString *)defaultName;

+ (void)setBool:(BOOL)value forKey:(NSString *)defaultName;

@end
