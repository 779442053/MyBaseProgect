//
//  ZWWNSUserDefault.m
//  MyBaseProgect
//
//  Created by 张威威 on 2018/4/27.
//  Copyright © 2018年 张威威. All rights reserved.
//

#import "ZWWNSUserDefault.h"

@implementation ZWWNSUserDefault
+ (id)objectForKey:(NSString *)defaultName{
    return  [[NSUserDefaults standardUserDefaults] objectForKey:defaultName];
}

+ (void)setObject:(id)value forKey:(NSString *)defaultName
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:defaultName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setBool:(BOOL)value forKey:(NSString *)defaultName{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:defaultName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
