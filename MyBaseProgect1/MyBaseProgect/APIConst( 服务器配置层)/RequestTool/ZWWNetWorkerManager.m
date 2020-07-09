//
//  ZWWNetWorkerManager.m
//  MyBaseProgect
//
//  Created by 张威威 on 2018/5/9.
//  Copyright © 2018年 张威威. All rights reserved.
//

#import "ZWWNetWorkerManager.h"
#import "ZWRequest.h"

@implementation ZWWNetWorkerManager
static ZWWNetWorkerManager *manager = nil;
+ (instancetype)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[ZWWNetWorkerManager alloc] init];
    });
    
    return manager;
}
- (RACSignal *)requestWithMethod:(RequestType)requestType withTargetUrl:(NSString *)url andParameters:(id)parameters
{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        ZWRequest *requset = [ZWRequest request];
        if (requestType == RequestTypeGet) {
            //get请求
            
            [requset GET:url parameters:parameters success:^(ZWRequest *request, NSDictionary *responseObject) {
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
            } failure:^(ZWRequest *request, NSError *error) {
                [subscriber sendError:error];
                [subscriber sendCompleted];
            }];
//            [[AFHTTPSessionManager manager] GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//                [subscriber sendNext:responseObject];
//                [subscriber sendCompleted];
//
//            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//                [subscriber sendError:error];
//            }];
            
        }else{
            [requset POST:url parameters:parameters success:^(ZWRequest *request, NSDictionary *responseString) {
                [subscriber sendNext:responseString];
                [subscriber sendCompleted];
            } failure:^(ZWRequest *request, NSError *error) {
                [subscriber sendError:error];
                [subscriber sendCompleted];
            }];
//            [[AFHTTPSessionManager manager] POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//                [subscriber sendNext:responseObject];
//                [subscriber sendCompleted];
//            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//                [subscriber sendError:error];
//            }];
        }
        
        return [RACDisposable disposableWithBlock:^{
            
            NSLog(@"清理");
        }];
        
    }];
    
}


@end
