//
//  NSMutableString+ZWMutableStr.m
//  共享蜂
//
//  Created by 张威威 on 2017/12/17.
//  Copyright © 2017年 张威威. All rights reserved.
//

#import "NSMutableString+ZWMutableStr.h"

@implementation NSMutableString (ZWMutableStr)

/**
 *  替换字符串
 *
 *  @param searchString 将要被替换的字符串
 *  @param newString    替换后的字符串
 */
- (void)replaceString:(NSString *)searchString withString:(NSString *)newString {
    NSRange range = [self rangeOfString:searchString];
    [self replaceCharactersInRange:range withString:newString];
}

/**
 *  去除空格
 */
- (void)removeSpace {
    [self replaceString:@" " withString:@""];
}

- (void)removeNilAndNull {
    
    if ([self isEqual:[NSNull null]]| (self == nil)) {
        
        [self setString:@""];
    }
}
@end
