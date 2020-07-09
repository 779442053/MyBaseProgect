//
//  NSURLSession了解.h
//  MyBaseProgect
//
//  Created by 张威威 on 2018/5/10.
//  Copyright © 2018年 张威威. All rights reserved.
//

 /*
  NSURLSession是2013年iOS 7发布的用于替代NSURLConnection的
  NSURLSession只提供了异步请求方式而没有提供同步请求方式
  // 创建Request请求
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
  // 配置Request请求
  // 设置请求方法
  [request setHTTPMethod:@"GET"];
  // 设置请求超时 默认超时时间60s
  [request setTimeoutInterval:10.0];
  // 设置头部参数
  [request addValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
  //或者下面这种方式 添加所有请求头信息
  request.allHTTPHeaderFields=@{@"Content-Encoding":@"gzip"};
  //设置缓存策略
  [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
  根据需求添加不用的设置，比如请求方式、超时时间、请求头信息，这里重点介绍下缓存策略：
  
  NSURLRequestUseProtocolCachePolicy = 0 //默认的缓存策略， 如果缓存不存在，直接从服务端获取。如果缓存存在，会根据response中的Cache-Control字段判断下一步操作，如: Cache-Control字段为must-revalidata, 则询问服务端该数据是否有更新，无更新的话直接返回给用户缓存数据，若已更新，则请求服务端.
  NSURLRequestReloadIgnoringLocalCacheData = 1 //忽略本地缓存数据，直接请求服务端.
  NSURLRequestIgnoringLocalAndRemoteCacheData = 4 //忽略本地缓存，代理服务器以及其他中介，直接请求源服务端.
  NSURLRequestReloadIgnoringCacheData = NSURLRequestReloadIgnoringLocalCacheData
  NSURLRequestReturnCacheDataElseLoad = 2 //有缓存就使用，不管其有效性(即忽略Cache-Control字段), 无则请求服务端.
  NSURLRequestReturnCacheDataDontLoad = 3 //只加载本地缓存. 没有就失败. (确定当前无网络时使用)
  NSURLRequestReloadRevalidatingCacheData = 5 //缓存数据必须得得到服务端确认有效才使用
  
  
  
  
  // 采用苹果提供的共享session
  NSURLSession *sharedSession = [NSURLSession sharedSession];
  
  
  
  */
