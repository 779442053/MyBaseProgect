//
//  ZWConseKey.m
//  Bracelet
//
//  Created by 张威威 on 2017/9/28.
//  Copyright © 2017年 ShYangMiStepZhang. All rights reserved.
//

#import "ZWConseKey.h"

@implementation ZWConseKey

/********** 网络请求地址    =====   所有的网络请求都在这里获取***********/

// 服务地址
NSString *const  HTURL = @"http://www.gongxiangxf.com:8081/crm/api/v1";
NSString *const  HTURL_Test = @"http://192.168.1.180:8080/crm/api/v1";

//登录
NSString *const  LOGIN = @"/login/login";

///获取商户今日流水
/*
 token---用户令牌
 time---时间---日报、周报（传参格式为：yyyy-MM-dd）月报（传参格式为：yyyy-MM）
 type---类型---日报（传day）周报（传week）月报（传month）
 */
NSString *const  GetTodyMoney = @"/order/selectmoney";
//
NSString *const  GetTixian = @"/order/totixian";
///获取订单GetOrderList
NSString *const  GetOrderList = @"/order/tomerchantwater";

NSString *const  FEEDMYIdea = @"/merchantfeedback/addfeedback";
NSString *const  GetMarchanInfore = @"/login/getuserinfo";
//提现
NSString *const  Tixian = @"/order/tixian";
//提现列表
NSString *const  TixianLIST = @"/order/tixianlist";
//订单详情
NSString *const  OrderDetail = @"/order/orderdetail";
//修改商户信息
NSString *const  updatecom = @"/merinfo/updatecom";
NSString *const  GETCode_POST = @"/register/sms";
//手机号注册  如果先前用户没有注册，则进行注册操作并返回token；如果先前用户已注册，则直接返回token
NSString *const  REGISTER_POST = @"/register/register";
NSString *const  REGPSW_POST = @"/reset/password";
//找回支付密码
NSString *const  FINDPAY_POST = @"/reset/findpaypassword";
//更换手机号
NSString *const  RESETPHONE_POST = @"/reset/phone";
///获取服务列表
NSString *const  GETSEVERLIST_POST = @"/serve/queryserves";

NSString *const  GETPROLIST_POST = @"/pro/querypros";
NSString *const  GETPRODetail_POST = @"/pro/queryproId";
NSString *const  GETTanCanList_POST = @"/prodetail/queryprodetails";
NSString *const  GETtaocandetailLiatList_POST = @"/prodetail/queryprodetails";
NSString *const  ADDDingGOU_POST = @"/merchantbuy/addmerchantbuy";

NSString *const  ADDGOOD_POST = @"/goods/addgoods";
NSString *const  GetGoodsTAG_POST = @"/goods/selecttag";
NSString *const  GetGoodsFromTag_POST = @"/goods/selectgoods";
NSString *const  UpdateGoods_POST = @"/goods/updategoods";
NSString *const  DeletegGoods_POST = @"/goods/deletegoods";
NSString *const  GETSHOPTYPE_POST = @"/add/gettypes";
NSString *const  MAKESHOPTYPEFirst_POST = @"/add/addmerchant";
NSString *const  MAKESHOPTYPETwo_POST = @"/add/upmerchantinfo";
//消息推送（仅供测试）/gym/gyms_search/
NSString *const  PUSH_MESSAGE_GET = @"/appmsg/getmsg";
NSString *const  PUSH_MESSAGE_TWO = @"/notice/getnotice";
NSString *const  DELETE_MESSAGE = @"/appmsg/delmsg";
//请求流水折线图
NSString *const  GETLINEDATA_POST = @"/order2/getmoneyandorder";


//获取分享链接
NSString *const  GETSHAREURL_POST = @"/share/getmyshare";
NSString *const  GETSHOPCODERIMAGEURL_POST = @"/merinfo/getqrcode";
NSString *const  UPLODSHOPHEADERIMAGE = @"/merinfo/updateimg";
NSString *const  GET_OTHER_SHOP_DETEGAIL = @"/order/getstores";

//获取分店
NSString *const  GETDATA_OTHERSHOP_POST = @"/order/getstores";


@end
