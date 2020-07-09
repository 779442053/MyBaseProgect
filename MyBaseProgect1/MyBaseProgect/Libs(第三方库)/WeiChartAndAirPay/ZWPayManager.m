////
////  ZWPayManager.m
////  Bracelet
////简书 http://www.jianshu.com/users/fe5700cfb223/latest_articles
////  Created by 张威威 on 2017/9/29.
////  Copyright © 2017年 ShYangMiStepZhang. All rights reserved.
////
//
//#import "ZWPayManager.h"
//// 回调url地址为空
//#define ZWTIP_CALLBACKURL @"url地址不能为空！"
//// 订单信息为空字符串或者nil
//#define ZWTIP_ORDERMESSAGE @"订单信息不能为空！"
//// 没添加 URL Types
//#define ZWTIP_URLTYPE @"请先在Info.plist 添加 URL Type"
//// 添加了 URL Types 但信息不全
//#define ZWTIP_URLTYPE_SCHEME(name) [NSString stringWithFormat:@"请先在Info.plist 的 URL Type 添加 %@ 对应的 URL Scheme",name]
//@interface ZWPayManager ()<WXApiDelegate>
//// 缓存回调
//@property (nonatomic,copy)ZWCompleteCallBack callBack;
//// 缓存appScheme
//@property (nonatomic,strong)NSMutableDictionary *appSchemeDict;
//@end
//@implementation ZWPayManager
//
//+ (instancetype)shareManager{
//    static ZWPayManager *instance;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        instance = [[self alloc] init];
//    });
//    return instance;
//}
//
//- (BOOL)ZW_handleUrl:(NSURL *)url{
//
//    NSAssert(url, ZWTIP_CALLBACKURL);
//    if ([url.host isEqualToString:@"pay"]) {// 微信
//        return [WXApi handleOpenURL:url delegate:self];
//    }
//    else if ([url.host isEqualToString:@"safepay"]) {// 支付宝
//        // 支付跳转支付宝钱包进行支付，处理支付结果(在app被杀模式下，通过这个方法获取支付结果）
//        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            NSString *resultStatus = resultDic[@"resultStatus"];
//            NSString *errStr = resultDic[@"memo"];
//            ZWErrCode errorCode = ZWErrCodeSuccess;
//            switch (resultStatus.integerValue) {
//                case 9000:// 成功
//                    errorCode = ZWErrCodeSuccess;
//                    break;
//                case 6001:// 取消
//                    errorCode = ZWErrCodeCancel;
//                    break;
//                default:
//                    errorCode = ZWErrCodeFailure;
//                    break;
//            }
//            if ([ZWPayManager shareManager].callBack) {
//                [ZWPayManager shareManager].callBack(errorCode,errStr);
//            }
//        }];
//
//        // 授权跳转支付宝钱包进行支付，处理支付结果
//        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
//            NSLog(@"result = %@",resultDic);
//            // 解析 auth code
//            NSString *result = resultDic[@"result"];
//            NSString *authCode = nil;
//            if (result.length>0) {
//                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
//                for (NSString *subResult in resultArr) {
//                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
//                        authCode = [subResult substringFromIndex:10];
//                        break;
//                    }
//                }
//            }
//            NSLog(@"授权结果 authCode = %@", authCode?:@"");
//        }];
//        return YES;
//    }
//    else{
//        return NO;
//    }
//}
//
//- (void)ZW_registerApp{
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
//    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
//    NSArray *urlTypes = dict[@"CFBundleURLTypes"];
//    NSAssert(urlTypes, ZWTIP_URLTYPE);
//    for (NSDictionary *urlTypeDict in urlTypes) {
//        NSString *urlName = urlTypeDict[@"CFBundleURLName"];
//        NSArray *urlSchemes = urlTypeDict[@"CFBundleURLSchemes"];
//        NSAssert(urlSchemes.count, ZWTIP_URLTYPE_SCHEME(urlName));
//        // 一般对应只有一个
//        NSString *urlScheme = urlSchemes.lastObject;
//        if ([urlName isEqualToString:ZWWECHATURLNAME]) {
//            [self.appSchemeDict setValue:urlScheme forKey:ZWWECHATURLNAME];
//            // 注册微信
//            [WXApi registerApp:urlScheme];
//        }
//        else if ([urlName isEqualToString:ZWALIPAYURLNAME]){
//            // 保存支付宝scheme，以便发起支付使用
//            [self.appSchemeDict setValue:urlScheme forKey:ZWALIPAYURLNAME];
//        }
//        else{
//
//        }
//    }
//}
//
//- (void)ZW_payWithOrderMessage:(id)orderMessage callBack:(ZWCompleteCallBack)callBack{
//    NSAssert(orderMessage, ZWTIP_ORDERMESSAGE);
//    // 缓存block
//    self.callBack = callBack;
//    // 发起支付
//    if ([orderMessage isKindOfClass:[PayReq class]]) {
//        // 微信
//        NSAssert(self.appSchemeDict[ZWWECHATURLNAME], ZWTIP_URLTYPE_SCHEME(ZWWECHATURLNAME));
//
//        [WXApi sendReq:(PayReq *)orderMessage];
//    }
//    else if ([orderMessage isKindOfClass:[NSString class]]){
//        // 支付宝
//        NSAssert(![orderMessage isEqualToString:@""], ZWTIP_ORDERMESSAGE);
//        NSAssert(self.appSchemeDict[ZWALIPAYURLNAME], ZWTIP_URLTYPE_SCHEME(ZWALIPAYURLNAME));
//        ZWWLog(@"========%@",self.appSchemeDict[ZWALIPAYURLNAME])
//         ZWWLog(@"========%@",orderMessage)
//        [[AlipaySDK defaultService] payOrder:(NSString *)orderMessage fromScheme:self.appSchemeDict[ZWALIPAYURLNAME] callback:^(NSDictionary *resultDic){
//            ZWWLog(@"========%@",resultDic)
//            NSString *resultStatus = resultDic[@"resultStatus"];
//            NSString *errStr = resultDic[@"memo"];
//            ZWErrCode errorCode = ZWErrCodeSuccess;
//            switch (resultStatus.integerValue) {
//                case 9000:// 成功
//                    errorCode = ZWErrCodeSuccess;
//                    break;
//                case 6001:// 取消
//                    errorCode = ZWErrCodeCancel;
//                    break;
//                default:
//                    errorCode = ZWErrCodeFailure;
//                    break;
//            }
//            if ([ZWPayManager shareManager].callBack) {
//                [ZWPayManager shareManager].callBack(errorCode,errStr);
//            }
//        }];
//    }
//}
//
//#pragma mark - WXApiDelegate
//- (void)onResp:(BaseResp *)resp {
//    // 判断支付类型
//    if([resp isKindOfClass:[PayResp class]]){
//        //支付回调
//        ZWErrCode errorCode = ZWErrCodeSuccess;
//        NSString *errStr = resp.errStr;
//        switch (resp.errCode) {
//            case 0:
//                errorCode = ZWErrCodeSuccess;
//                errStr = @"订单支付成功";
//                break;
//            case -1:
//                errorCode = ZWErrCodeFailure;
//                errStr = resp.errStr;
//                break;
//            case -2:
//                errorCode = ZWErrCodeCancel;
//                errStr = @"用户中途取消";
//                break;
//            default:
//                errorCode = ZWErrCodeFailure;
//                errStr = resp.errStr;
//                break;
//        }
//        if (self.callBack) {
//            self.callBack(errorCode,errStr);
//        }
//    }
//}
//
//#pragma mark -- Setter & Getter
//
//- (NSMutableDictionary *)appSchemeDict{
//    if (_appSchemeDict == nil) {
//        _appSchemeDict = [NSMutableDictionary dictionary];
//    }
//    return _appSchemeDict;
//}
//
//
//@end

