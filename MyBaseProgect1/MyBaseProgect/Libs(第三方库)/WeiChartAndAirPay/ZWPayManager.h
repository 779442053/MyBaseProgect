////
////  ZWPayManager.h
////  Bracelet
////简书 http://www.jianshu.com/users/fe5700cfb223/latest_articles
////  Created by 张威威 on 2017/9/29.
////  Copyright © 2017年 ShYangMiStepZhang. All rights reserved.
////
//
//#import <Foundation/Foundation.h>
//#import "WXApi.h"
//#import <AlipaySDK/AlipaySDK.h>
///**
// *  @author gitKong
// *
// *  此处必须保证在Info.plist 中的 URL Types 的 Identifier 对应一致
// */
//#define ZWWECHATURLNAME @"weixin"
//#define ZWALIPAYURLNAME @"zhifubao"
//
//#define ZWPAYMANAGER [ZWPayManager shareManager]
///**
// *  @author gitKong
// *
// *  回调状态码
// */
//typedef NS_ENUM(NSInteger,ZWErrCode){
//    ZWErrCodeSuccess,// 成功
//    ZWErrCodeFailure,// 失败
//    ZWErrCodeCancel// 取消
//};
//
//typedef void(^ZWCompleteCallBack)(ZWErrCode errCode,NSString *errStr);
//
//@interface ZWPayManager : NSObject
//
///**
// *  @author gitKong
// *
// *  单例管理
// */
//+ (instancetype)shareManager;
///**
// *  @author gitKong
// *
// *  处理跳转url，回到应用，需要在delegate中实现
// */
//- (BOOL)ZW_handleUrl:(NSURL *)url;
///**
// *  @author gitKong
// *
// *  注册App，需要在 didFinishLaunchingWithOptions 中调用
// */
//- (void)ZW_registerApp;
//
///**
// *  @author gitKong
// *
// *  发起支付
// *
// * @param orderMessage 传入订单信息,如果是字符串，则对应是跳转支付宝支付；如果传入PayReq 对象，这跳转微信支付,注意，不能传入空字符串或者nil
// * @param callBack     回调，有返回状态信息
// */
//- (void)ZW_payWithOrderMessage:(id)orderMessage callBack:(ZWCompleteCallBack)callBack;
//
//@end

