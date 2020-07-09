//
//  NSMutableString+ZWMutableStr.h
//  共享蜂
//
//  Created by 张威威 on 2017/12/17.
//  Copyright © 2017年 张威威. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableString (ZWMutableStr)

- (void)replaceString:(NSString *)searchString withString:(NSString *)newString;
- (void)removeSpace;
- (void)removeNilAndNull;
@end
