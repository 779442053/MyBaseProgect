//
//  WHNetwork.h
//  WHNetwork
//
//  Created by 吴浩 on 2017/5/17.
//  Copyright © 2017年 wuhao. All rights reserved.
//  https://github.com/remember17/WHNetwork

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"

/** 网络状态 */
typedef NS_ENUM(NSUInteger, WHNetworkStatus) {
    WHNetworkStatusUnknown,             // 未知
    WHNetworkStatusNotReachable,        // 无网络
    WHNetworkStatusWWAN,                // 手机网络
    WHNetworkStatusWiFi                 // WIFI
};

/** 请求类型 */
typedef NS_ENUM(NSUInteger, WHRequestSerializer) {
    WHRequestSerializerJSON,  // 请求JSON
    WHRequestSerializerHTTP,  // 请求二进制
};

/** 响应类型 */
typedef NS_ENUM(NSUInteger, WHResponseSerializer) {
    WHResponseSerializerJSON,  // 响应JSON
    WHResponseSerializerHTTP,  // 响应二进制
};

/** 上传文件类型 */
typedef NS_ENUM(NSUInteger, WHUploadFileType) {
    WHUploadFileTyApeapplicationJSON,   // application/json
    WHUploadFileTypeTextHtml,           // text/html
    WHUploadFileTypeTextJSON,           // text/json
    WHUploadFileTypeTextPlain,          // text/plain
    WHUploadFileTypeTextJavascript,     // text/javascript
    WHUploadFileTypeTextXML             // text/xml
};

typedef void(^NetworkStatus)(WHNetworkStatus status, NSString *statusString);
typedef void(^Success)(id responseObject);
typedef void(^Failure)(NSError *error);
typedef void(^Progress)(NSProgress *progress);

@interface WHNetwork : NSObject

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
                                   fileType:(WHUploadFileType)fileType
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
+ (void)setRequestSerializer:(WHRequestSerializer)requestSerializer;

/** 设置响应数据格式，默认JSON */
+ (void)setResponseSerializer:(WHResponseSerializer)responseSerializer;

/** 超时时间，默认30秒 */
+ (void)setRequestTimeoutInterval:(NSTimeInterval)time;

/** 设置请求头 */
+ (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;

/** 是否打开菊花，默认打开 */
+ (void)openNetworkActivityIndicator:(BOOL)open;

@end
