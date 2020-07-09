//
//  ZWConseKey.h
//  Bracelet
//
//  Created by 张威威 on 2017/9/28.
//  Copyright © 2017年 ShYangMiStepZhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZWConseKey : NSObject
#pragma ===========这里是全部的API接口 =============

/**
 苹果官方建议使用const关键词.
 当我们想全局共用一些数据时，可以用宏、变量、常量
 只是在预处理器里进行文本替换，没有类型，不做任何类型检查，编译器可以对相同的字符串进行优化。只保存一份到 .rodata 段。甚至有相同后缀的字符串也可以优化，你可以用GCC 编译测试，"Hello world" 与 "world" 两个字符串，只存储前面一个。取的时候只需要给前面和中间的地址，如果是整形、浮点型会有多份拷贝，但这些数写在指令中。占的只是代码段而已，大量用宏会导致二进制文件变大
 
 共享一块内存空间，就算项目中N处用到，也不会分配N块内存空间，可以根据const修饰的位置设定能否修改，在编译阶段会执行类型检查
 */
//1.    所有请求参数的类型都为字符串类型。
//2.    请求参数，比如数字字符串，手机号串，出生年月串都会在服务端进行校验，但是也希望能在移动端先进行校验。
//所有接口，响应都是json数据。
//json数据，格式如下：
//当有附加数据时：
//{
//    "code": code,  //错误码
//    "message": message,  //出错信息
//    "data": data        //附加数据，为json格式，具体格式后文会根据具体的请求加以说明。
//}
//当没有数据，仅包含执行结果信息时：
//{
//    "code": code,  //错误码
//    "message": message   //出错信息
//}
//1.    所有异常返回的信息都是不会包含data字段（附加数据），仅包含code（错误码）和message（出错信息）！！
//1.    所有接口均通过http://tool.chinaz.com/Tools/httptest.aspx 测试。



/*********** 网络请求地址 ************/
// 服务地址
FOUNDATION_EXTERN NSString *const HTURL;
FOUNDATION_EXTERN NSString *const HTURL_Test;

FOUNDATION_EXTERN NSString *const LOGIN;
FOUNDATION_EXTERN NSString *const GetTodyMoney;
FOUNDATION_EXTERN NSString *const GetTixian;
FOUNDATION_EXTERN NSString *const GetOrderList;



FOUNDATION_EXTERN NSString *const GetMonthMoney;
FOUNDATION_EXTERN NSString *const FEEDMYIdea;
FOUNDATION_EXTERN NSString *const GetMarchanInfore;
FOUNDATION_EXTERN NSString *const Tixian;
FOUNDATION_EXTERN NSString *const TixianLIST;
FOUNDATION_EXTERN NSString *const OrderDetail;
FOUNDATION_EXTERN NSString *const updatecom;
FOUNDATION_EXTERN NSString *const GETCode_POST;
////手机号注册  如果先前用户没有注册，则进行注册操作并返回token；如果先前用户已注册，则直接返回token
FOUNDATION_EXTERN NSString *const REGISTER_POST;
FOUNDATION_EXTERN NSString *const REGPSW_POST;
FOUNDATION_EXTERN NSString *const FINDPAY_POST;
FOUNDATION_EXTERN NSString *const RESETPHONE_POST;
FOUNDATION_EXTERN NSString *const GETSEVERLIST_POST;
FOUNDATION_EXTERN NSString *const GETPROLIST_POST;
FOUNDATION_EXTERN NSString *const GETPRODetail_POST;
FOUNDATION_EXTERN NSString *const GETTanCanList_POST;
FOUNDATION_EXTERN NSString *const GETtaocandetailLiatList_POST;
FOUNDATION_EXTERN NSString *const ADDDingGOU_POST;
FOUNDATION_EXTERN NSString *const ADDGOOD_POST;
FOUNDATION_EXTERN NSString *const GetGoodsTAG_POST;
FOUNDATION_EXTERN NSString *const GetGoodsFromTag_POST;
FOUNDATION_EXTERN NSString *const UpdateGoods_POST;
FOUNDATION_EXTERN NSString *const DeletegGoods_POST;

FOUNDATION_EXTERN NSString *const GETSHOPTYPE_POST;
FOUNDATION_EXTERN NSString *const MAKESHOPTYPEFirst_POST;
FOUNDATION_EXTERN NSString *const MAKESHOPTYPETwo_POST;
//消息推送（仅供测试）
FOUNDATION_EXTERN NSString *const PUSH_MESSAGE_GET;
FOUNDATION_EXTERN NSString *const PUSH_MESSAGE_TWO;
FOUNDATION_EXTERN NSString *const DELETE_MESSAGE;
FOUNDATION_EXTERN NSString *const GETLINEDATA_POST;
FOUNDATION_EXTERN NSString *const GETSHAREURL_POST;
FOUNDATION_EXTERN NSString *const GETSHOPCODERIMAGEURL_POST;
FOUNDATION_EXTERN NSString *const UPLODSHOPHEADERIMAGE;

FOUNDATION_EXTERN NSString *const GET_OTHER_SHOP_DETEGAIL;
FOUNDATION_EXTERN NSString *const GETDATA_OTHERSHOP_POST;


@end
