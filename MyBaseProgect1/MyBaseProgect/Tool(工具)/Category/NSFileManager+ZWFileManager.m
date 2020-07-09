//
//  NSFileManager+ZWFileManager.m
//  共享蜂
//
//  Created by 张威威 on 2017/12/17.
//  Copyright © 2017年 张威威. All rights reserved.
//

#import "NSFileManager+ZWFileManager.h"

@implementation NSFileManager (ZWFileManager)

+ (NSURL *)URLForDirectory:(NSSearchPathDirectory)directory
{
    return [self.defaultManager URLsForDirectory:directory inDomains:NSUserDomainMask].lastObject;
}

+ (NSString *)pathForDirectory:(NSSearchPathDirectory)directory
{
    return NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES)[0];
}

+ (NSURL *)documentsURL
{
    return [self URLForDirectory:NSDocumentDirectory];
}

+ (NSString *)documentsPath
{
    return [self pathForDirectory:NSDocumentDirectory];
}

+ (NSURL *)libraryURL
{
    return [self URLForDirectory:NSLibraryDirectory];
}

+ (NSString *)libraryPath
{
    return [self pathForDirectory:NSLibraryDirectory];
}

+ (NSURL *)cachesURL
{
    return [self URLForDirectory:NSCachesDirectory];
}

+ (NSString *)cachesPath
{
    return [self pathForDirectory:NSCachesDirectory];
}
@end
