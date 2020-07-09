//
//  ZWWNetWorkerManager.h
//  MyBaseProgect
//
//  Created by 张威威 on 2018/5/9.
//  Copyright © 2018年 张威威. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, RequestType)
{
    RequestTypePost,
    RequestTypeGet
};
@interface ZWWNetWorkerManager : NSObject
+ (instancetype)shareManager;

- (RACSignal *)requestWithMethod:(RequestType)requestType withTargetUrl:(NSString *)url andParameters:(id)parameters;
@end
