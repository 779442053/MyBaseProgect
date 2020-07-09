//
//  ZWWNetWork.m
//  MyBaseProgect
//
//  Created by 张威威 on 2018/5/16.
//  Copyright © 2018年 张威威. All rights reserved.
//

#import "ZWWNetWork.h"

@implementation ZWWNetWork

static AFHTTPSessionManager *_sessionManager;
static NSMutableArray *_allSessionTask;
#pragma mark -
#pragma mark - GET请求
+ (NSURLSessionTask *)GET:(NSString *)URL
               parameters:(id)parameters
                  success:(Success)success
                  failure:(Failure)failure {
    
    NSURLSessionTask *sessionTask = [_sessionManager GET:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[self allSessionTask] removeObject:task];
        success ? success(responseObject) : nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[self allSessionTask] removeObject:task];
        failure ? failure(error) : nil;
    }];
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
    return sessionTask;
}

#pragma mark -
#pragma mark - POST请求
+ (NSURLSessionTask *)POST:(NSString *)URL
                parameters:(id)parameters
                   success:(Success)success
                   failure:(Failure)failure {
    NSURLSessionTask *sessionTask = [_sessionManager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[self allSessionTask] removeObject:task];
        success ? success(responseObject) : nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[self allSessionTask] removeObject:task];
        failure ? failure(error) : nil;
    }];
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil;
    return sessionTask;
}

#pragma mark -
#pragma mark - 下载文件
+ (NSURLSessionTask *)downloadWithURL:(NSString *)URL
                        localFilePath:(NSString *)localFilePath
                             progress:(Progress)progress
                              success:(void(^)(NSString *downloadedFilePath))success
                              failure:(Failure)failure {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
    __block NSURLSessionDownloadTask *downloadTask = [_sessionManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            progress ? progress(downloadProgress) : nil;
        });
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *downloadDir = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:localFilePath ? localFilePath : @"Download"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager createDirectoryAtPath:downloadDir withIntermediateDirectories:YES attributes:nil error:nil];
        NSString *filePaht = [downloadDir stringByAppendingPathComponent:response.suggestedFilename];
        return [NSURL fileURLWithPath:filePaht];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        [[self allSessionTask] removeObject:downloadTask];
        if (failure && error) {
            failure(error);
            return;
        }
        success ? success(filePath.absoluteString) : nil;
    }];
    [downloadTask resume];
    downloadTask ? [[self allSessionTask] addObject:downloadTask] : nil;
    return downloadTask;
}

#pragma mark -
#pragma mark - 上传文件
+ (NSURLSessionTask *)uploadFileWithURL:(NSString *)URL parameters:(id)parameters name:(NSString *)name localFilePath:(NSString *)localFilePath seriverFileName:(NSString *)seriverFileName fileType:(ZWUploadFileType)fileType progress:(Progress)progress success:(Success)success failure:(Failure)failure {
    NSURLSessionTask *sessionTask = [_sessionManager POST:URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *fileData = [NSData dataWithContentsOfFile:localFilePath];
        NSString *fileTypeString = @"text/xml";
        switch (fileType) {
            case ZWUploadFileTyApeapplicationJSON:
                fileTypeString = @"application/json";
                break;
            case ZWUploadFileTypeTextHtml:
                fileTypeString = @"text/html";
                break;
            case ZWUploadFileTypeTextJSON:
                fileTypeString = @"text/json";
                break;
            case ZWUploadFileTypeTextPlain:
                fileTypeString = @"text/plain";
                break;
            case ZWUploadFileTypeTextJavascript:
                fileTypeString = @"text/javascript";
                break;
            case ZWUploadFileTypeTextXML:
                fileTypeString = @"text/xml";
                break;
        }
        [formData appendPartWithFileData:fileData name:@"file" fileName:seriverFileName mimeType:fileTypeString];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(uploadProgress) : nil;
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[self allSessionTask] removeObject:task];
        success ? success(responseObject) : nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[self allSessionTask] removeObject:task];
        failure ? failure(error) : nil;
    }];
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
    return sessionTask;
}

#pragma mark -
#pragma mark - 上传图片
+ (NSURLSessionTask *)uploadImagesWithURL:(NSString *)URL
                               parameters:(id)parameters
                                     name:(NSString *)name
                              localImages:(NSArray<UIImage *> *)localImages
                         serverImageNames:(NSArray<NSString *> *)serverImageNames
                               imageScale:(CGFloat)imageScale
                                imageType:(NSString *)imageType
                                 progress:(Progress)progress
                                  success:(Success)success
                                  failure:(Failure)failure {
    NSURLSessionTask *sessionTask = [_sessionManager POST:URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (NSUInteger i = 0; i < localImages.count; i++) {
            NSData *imageData = UIImageJPEGRepresentation(localImages[i], imageScale ? : 1.f);
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *imageFileName = [NSString stringWithFormat:@"%@%ld.%@",str,i,imageType?:@"jpg"];
            NSString *tempFileName = [NSString stringWithFormat:@"%@.%@",serverImageNames[i],imageType?:@"jpg"];
            NSString *tempImageType = [NSString stringWithFormat:@"image/%@",imageType ?: @"jpg"];
            [formData appendPartWithFileData:imageData
                                        name:name
                                    fileName:serverImageNames ? tempFileName : imageFileName
                                    mimeType:tempImageType];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(uploadProgress) : nil;
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[self allSessionTask] removeObject:task];
        success ? success(responseObject) : nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[self allSessionTask] removeObject:task];
        failure ? failure(error) : nil;
    }];
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil;
    return sessionTask;
}

#pragma mark -
#pragma mark - 初始化
/** 监测网络状态 */
+ (void)load {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

+(void)initialize {
    _sessionManager = [AFHTTPSessionManager manager];
    _sessionManager.requestSerializer.timeoutInterval = 30.f;
    _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*",@"multipart/form-data", nil];
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
}

#pragma mark -
#pragma mark - 自定义设置
/** 设置网络请求参数格式，默认二进制 */
+ (void)setRequestSerializer:(ZWRequestSerializer)requestSerializer {
    _sessionManager.requestSerializer = (requestSerializer == ZWRequestSerializerHTTP) ? [AFHTTPRequestSerializer serializer] : [AFJSONRequestSerializer serializer];
}

/** 设置响应数据格式，默认JSON */
+ (void)setResponseSerializer:(ZWResponseSerializer)responseSerializer {
    _sessionManager.responseSerializer = (responseSerializer == ZWResponseSerializerHTTP) ? [AFHTTPResponseSerializer serializer] : [AFJSONResponseSerializer serializer];
}

/** 超时时间，默认30秒 */
+ (void)setRequestTimeoutInterval:(NSTimeInterval)time {
    _sessionManager.requestSerializer.timeoutInterval = time;
}

/** 设置请求头 */
+ (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field {
    [_sessionManager.requestSerializer setValue:value forHTTPHeaderField:field];
}

/** 是否打开菊花 */
+ (void)openNetworkActivityIndicator:(BOOL)open {
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:open];
}

/** 取消所有HTTP请求 */
+ (void)cancelAllRequest {
    // 锁操作
    @synchronized(self) {
        [[self allSessionTask] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            [task cancel];
        }];
        [[self allSessionTask] removeAllObjects];
    }
}

/** 取消指定URL的HTTP请求 */
+ (void)cancelRequestWithURL:(NSString *)URL {
    if (!URL) { return; }
    @synchronized (self) {
        [[self allSessionTask] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task.currentRequest.URL.absoluteString hasPrefix:URL]) {
                [task cancel];
                [[self allSessionTask] removeObject:task];
                *stop = YES;
            }
        }];
    }
}

+ (BOOL)isNetwork {
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

+ (BOOL)isWWAN {
    return [AFNetworkReachabilityManager sharedManager].reachableViaWWAN;
}

+ (BOOL)isWiFi {
    return [AFNetworkReachabilityManager sharedManager].reachableViaWiFi;
}

#pragma mark -
#pragma mark - 网络状态
+ (void)networkStatus:(NetworkStatus)networkStatus {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusUnknown:
                    networkStatus ? networkStatus(ZWNetworkStatusUnknown, @"NetworkStatus Unknow") : nil;
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                    networkStatus ? networkStatus(ZWNetworkStatusNotReachable, @"NetworkStatus NotReachable") : nil;
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    networkStatus ? networkStatus(ZWNetworkStatusWWAN, @"ZWNetworkStatus WWAN") : nil;
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    networkStatus ? networkStatus(ZWNetworkStatusWiFi, @"NetworkStatus WiFi") : nil;
                    break;
            }
        }];
    });
}

/** task数组 */
+ (NSMutableArray *)allSessionTask {
    if (!_allSessionTask) {
        _allSessionTask = [[NSMutableArray alloc] init];
    }
    return _allSessionTask;
}

@end

#pragma mark -
#pragma mark - 打印JSON中文
#ifdef DEBUG
@implementation NSArray (Log)

- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *strM = [NSMutableString stringWithString:@"(\n"];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [strM appendFormat:@"\t%@,\n", obj];
    }];
    
    [strM appendString:@")"];
    
    return strM;
}

@end

@implementation NSDictionary (Log)

- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *strM = [NSMutableString stringWithString:@"{\n"];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [strM appendFormat:@"\t%@ = %@;\n", key, obj];
    }];
    
    [strM appendString:@"}\n"];
    
    return strM;
}


@end
#endif
