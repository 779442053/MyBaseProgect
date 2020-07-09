//
//  ZWWNetWork.h
//  MyBaseProgect
//
//  Created by 张威威 on 2018/5/16.
//  Copyright © 2018年 张威威. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"

/** 网络状态 */
typedef NS_ENUM(NSUInteger, ZWNetworkStatus) {
    ZWNetworkStatusUnknown,             // 未知
    ZWNetworkStatusNotReachable,        // 无网络
    ZWNetworkStatusWWAN,                // 手机网络
    ZWNetworkStatusWiFi                 // WIFI
};

/** 请求类型 */
typedef NS_ENUM(NSUInteger, ZWRequestSerializer) {
    ZWRequestSerializerJSON,  // 请求JSON
    ZWRequestSerializerHTTP,  // 请求二进制
};

/** 响应类型 */
typedef NS_ENUM(NSUInteger, ZWResponseSerializer) {
    ZWResponseSerializerJSON,  // 响应JSON
    ZWResponseSerializerHTTP,  // 响应二进制
};

/** 上传文件类型 */
typedef NS_ENUM(NSUInteger, ZWUploadFileType) {
    ZWUploadFileTyApeapplicationJSON,   // application/json
    ZWUploadFileTypeTextHtml,           // text/html
    ZWUploadFileTypeTextJSON,           // text/json
    ZWUploadFileTypeTextPlain,          // text/plain
    ZWUploadFileTypeTextJavascript,     // text/javascript
    ZWUploadFileTypeTextXML             // text/xml
};

typedef void(^NetworkStatus)(ZWNetworkStatus status, NSString *statusString);
typedef void(^Success)(id responseObject);
typedef void(^Failure)(NSError *error);
typedef void(^Progress)(NSProgress *progress);
@interface ZWWNetWork : NSObject

+ (BOOL)isNetwork;      //是否有网络
+ (BOOL)isWWAN;         //是否为WWAN网络
+ (BOOL)isWiFi;         //是否为Wifi网络
+ (void)networkStatus:(NetworkStatus)networkStatus; //监听网络状态

/** GET请求 */
+ (NSURLSessionTask *)GET:(NSString *)URL   //地址
               parameters:(id)parameters    //参数
                  success:(Success)success  //成功回调
                  failure:(Failure)failure; //失败回调

/** POST请求 */
+ (NSURLSessionTask *)POST:(NSString *)URL      //地址
                parameters:(id)parameters       //参数
                   success:(Success)success     //成功回调
                   failure:(Failure)failure;    //失败回调

/**
 下载文件
 @param URL 地址
 @param localFilePath 下载到的路径，默认在Document目录的Download中
 @param progress 进度
 @param success 成功回调，参数为存储路径
 @param failure 失败回调
 @return NSURLSessionDownloadTask，暂停suspend，重新开始resume
 */
+ (NSURLSessionTask *)downloadWithURL:(NSString *)URL
                        localFilePath:(NSString *)localFilePath
                             progress:(Progress)progress
                              success:(void(^)(NSString *downloadedFilePath))success
                              failure:(Failure)failure;


/**
 上传文件
 @param URL 地址
 @param parameters 参数
 @param name 对应服务器上的字段
 @param localFilePath 要上传文件的本地路径
 @param seriverFileName 上传到服务器后的文件名
 @param fileType 文件类型
 @param progress 进度
 @param success 成功回调
 @param failure 失败回调
 @return 可用cancel方法取消请求
 */
+ (NSURLSessionTask *)uploadFileWithURL:(NSString *)URL
                             parameters:(id)parameters
                                   name:(NSString *)name
                          localFilePath:(NSString *)localFilePath
                        seriverFileName:(NSString *)seriverFileName
                               fileType:(ZWUploadFileType)fileType
                               progress:(Progress)progress
                                success:(Success)success
                                failure:(Failure)failure;


/**
 上传图片
 @param URL 地址
 @param parameters 参数
 @param name 对应服务器上的字段
 @param localImages 要上传的图片数组
 @param serverImageNames 上传之后的图片名数组，默认为上传的时间"yyyyMMddHHmmss"
 @param imageScale 压缩比例 0.1f - 1.f
 @param imageType 图片类型png/jpg...
 @param progress 进度
 @param success 成功回调
 @param failure 失败回调
 @return 可用cancel方法取消请求
 */
+ (NSURLSessionTask *)uploadImagesWithURL:(NSString *)URL
                               parameters:(id)parameters
                                     name:(NSString *)name
                              localImages:(NSArray<UIImage *> *)localImages
                         serverImageNames:(NSArray<NSString *> *)serverImageNames
                               imageScale:(CGFloat)imageScale
                                imageType:(NSString *)imageType
                                 progress:(Progress)progress
                                  success:(Success)success
                                  failure:(Failure)failure;

/** 取消所有HTTP请求 */
+ (void)cancelAllRequest;

/** 取消指定URL的HTTP请求 */
+ (void)cancelRequestWithURL:(NSString *)URL;

/** 设置网络请求参数格式，默认二进制 */
+ (void)setRequestSerializer:(ZWRequestSerializer)requestSerializer;

/** 设置响应数据格式，默认JSON */
+ (void)setResponseSerializer:(ZWResponseSerializer)responseSerializer;

/** 超时时间，默认30秒 */
+ (void)setRequestTimeoutInterval:(NSTimeInterval)time;

/** 设置请求头 */
+ (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;

/** 是否打开菊花，默认打开 */
+ (void)openNetworkActivityIndicator:(BOOL)open;
















@end
