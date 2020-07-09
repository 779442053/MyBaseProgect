

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AFNetworking/AFURLRequestSerialization.h>

@class FLAnimatedImageView;
@class InfosModel;
@class PHAssetCollection;

/**
 * 常用工具类
 */
@interface Utils : NSObject

//MARK: - 视图设置
/**!
 * 设置视图阴影
 *
 * @para uView        UIView  目标视图
 * @para shadowColor  UIColor 阴影颜色
 * @para shadowOpacity Float  阴影透明度(0.0 ~ 1.0,默认0.5)
 * @para shadowRadius CGFloat 阴影半径(默认3)
 * @para shadowOffset CGSize  阴影偏移，x向右偏移，y向下偏移，默认(0, -3)
 */
+(void)setViewShadowStyle:(UIView *_Nullable)uView
           AndShadowColor:(UIColor *_Nullable)sColor
         AndShadowOpacity:(CGFloat)sOpacity
          AndShadowRadius:(CGFloat)sRadius
         WithShadowOffset:(CGSize)sOffset;

/**! 视图抖动动画 */
+(void)shakeAnimationForView:(UIView *_Nullable)view;


//MARK: - 相关动画设置
/**! tabbar侧滑动画  */
+(void)tabBarChangeAnimation:(UITabBarController *_Nullable)tabBarController
               WithDirection:(NSInteger)direction;


//MARK: - Tabbar相关设置
/**!
 * 设置tabBar的尺寸
 * 调用方法：自定义View 继承自 UITabBarController，在 viewWillLayoutSubviews 中使用：
 * [Utils setTabbarHeight:self.tabBar];
 */
+(void)setTabbarHeight:(UITabBar *_Nullable)tabBar;

/**!
 * 设置tabBar的尺寸 顶部边框线
 */
+(void)setTopLine:(UITabBar *_Nullable)tabBar;

/**!
 * 清除tabbar顶部边线
 */
+(void)clearnTabBarTopLine:(UITabBar *_Nullable)tabBar;


//MARK: - 图片相关处理
/**! 图片不变形处理 */
+(void)imgNoTransformation:(UIImageView *_Nullable)img;

/** 图片压缩处理 */
+(NSData *_Nonnull)zipNSDataWithImage:(UIImage *_Nonnull)sourceImage;

/** 生成二维码 */
+(UIImage *_Nonnull)getCodeImage:(NSString * _Nonnull)url
                     andDrawLogo:(BOOL)isDrawLogo;

/** 截图 */
+(UIImage * _Nonnull)screenShotForView:(UIView * _Nonnull)screensViwe;

/** 创建自定义相册 */
+(void)createFolder:(NSString *_Nonnull)folderName
      andBackaction:(void(^ _Nullable)(PHAssetCollection *_Nullable assetCollection))backAction;



//MARK: - 信息验证
/**!
 * 验证手机号
 * @return true 通过验证
 */
+(BOOL)checkPhoneNo:(NSString *_Nullable)strPhoneNo;

/**!
 * 验证邮箱
 * @return true 通过验证
 */
+(BOOL)checkEmail:(NSString *_Nullable)strEmail;


/**!
 * 验证密码(密码为6~20位的数字字母)
 * @return true 通过验证
 */
+(BOOL)checkPassword:(NSString *_Nullable)strPwd;

/**!
 * 验证验证码(长度6位的数字字母)
 * @return true 通过验证
 */
+(BOOL)checkPhoneCode:(NSString *_Nullable)strCode;

/**!
 * 验证姓名(字母或中文)
 * @params strName NSString
 * @params len     NSInteger 长度
 * @return true 通过验证
 */
+(BOOL)checkName:(NSString *_Nullable)strName
       AndLength:(NSInteger)len;

/**!
 * 验证中文
 * @params strName NSString
 * @params len     NSInteger 长度
 * @return true 通过验证
 */
+(BOOL)checkChinese:(NSString *_Nullable)strName
          AndLength:(NSInteger)len;

/**!
 * 验证身份证(15/18位)
 * @params value NSString
 * @return true 通过验证
 */
+(BOOL)checkIDCardNumber:(NSString *_Nullable)value;

/**!
 * 验证文本是否为空
 * @params strTxt NSString
 * @return true 通过验证
 */
+(BOOL)checkTextEmpty:(NSString *_Nullable)strTxt;


//MARK: - 相关App是否有安装检测
//https://www.zhihu.com/question/19907735
/**! 是否有安装QQ */
+(BOOL)isInstallForQQ;

/**! 是否有安装微信 */
+(BOOL)isInstallForWechat;

/**! 是否有安装新浪微博 */
+(BOOL)isInstallForSina;

/**! 是否有安装支付宝 */
+(BOOL)isInstallForAliPay;

/**! 开启设置权限 */
+(void)openSetting;


//MARK: - 缓存相关设置
/**! 获取系统缓存 */
+(NSString *_Nonnull)getAppCacheSize;

/**!
 * 清理系统缓存
 */
+(BOOL)clearnAppCache;


//MARK: - 获取设备信息
/**!
 * 获取当前设备的UUID
 */
+(NSString *_Nullable)getCurrentDeviceUUID;

+ (NSString *_Nullable)dy_getIDFV;

//MARK: - Emoji表情检测
/**!
 * 是否含有Emoji 表情(true 含有)
 */
+(BOOL)stringContainsEmoji:(NSString *_Nullable)string;


//MARK: - 时间处理
/** 将Linux时间装换为字符串时间 */
+(NSString *_Nullable)formatDateToString:(NSTimeInterval)linuxTime
                              WithFormat:(NSString *_Nullable)format;

/** 获取当前时间 */
+(NSString *_Nullable)getCurrentDateToString:(NSString *_Nullable)format;

/** 获取Linux时间戳 */
+(long long)getCurrentLinuxTime;


//MARK: - 获取文本的宽度
/**!
 * 获取文本的宽度
 */
+(CGFloat)getWidthForString:(NSString *_Nullable)value
                andFontSize:(UIFont *_Nullable)font
                  andHeight:(CGFloat)height;

/** 获取文本的高度 */
+(CGFloat)getHeightForString:(NSString *_Nullable)value
                 andFontSize:(UIFont *_Nullable)font
                    andWidth:(CGFloat)width;

/**!
 * 获取文本框的高度
 */
+(CGFloat)getTextViewHeight:(UITextView *_Nullable)textView
              AndFixedWidth:(CGFloat)width;


//MARK: - 设置富文本
/**! 设置富文本 */
+(NSAttributedString *_Nullable)setAttributeStringText:(NSString *_Nullable)strFullText
                                       andFullTextFont:(UIFont *_Nullable)textFont
                                      andFullTextColor:(UIColor *_Nullable)textColor
                                        withChangeText:(NSString *_Nullable)changeText
                                        withChangeFont:(UIFont *_Nullable)changFont
                                       withChangeColor:(UIColor *_Nullable)changeColor
                                         isLineThrough:(BOOL)lineThrough;

/** 设置导航标题字体样式 */
+(NSAttributedString *_Nullable)setNavAttributeStringText:(NSString *_Nullable)strtext
                                     AndFontSize:(CGFloat)fSize
                                    AndTextColor:(UIColor *_Nonnull)txtColor;

+(NSAttributedString *_Nullable)updateNavAttribute:(NSAttributedString *_Nullable)attributedString
                                          AndColor:(UIColor *_Nullable)txtColor
                                       AndFontSize:(CGFloat)fSize;

/** placeHold 设置 */
+(NSAttributedString *_Nullable)setPlaceholderAttributeString:(NSString *_Nullable)changeText
                                      withChangeFont:(UIFont *_Nullable)changFont
                                     withChangeColor:(UIColor *_Nullable)changeColor
                                       isLineThrough:(BOOL)lineThrough;


//MARK: - Json 与 字典、数组类型转换
/**!
 * 数组转换为NString
 * @returns: NString
 */
+(NSString *_Nullable)getJSONStringFromData:(id _Nullable)idData;


//MARK: - 网络请求方法
/**!
 * post 接口请求
 * @para strUrl   String 请求地址
 * @para paras    [String:Any] 请求参数
 * @para successBack  成功回调
 * @para failureBack  失败回调
 */
+(void)postRequestForServerData:(NSString *_Nullable)strUrl
                 withParameters:(NSDictionary *_Nullable)paras
             AndHTTPHeaderField:(void(^ _Nullable)(AFHTTPRequestSerializer *_Nullable _requestSerializer))headerField AndSuccessBack:(void(^_Nullable)(id _Nullable _responseData))successBack
                 AndFailureBack:(void(^_Nullable)(NSString *_Nullable _strError))failureBack
                  WithisLoading:(BOOL)isLoading;


/**!
 * get 接口请求
 * @para strUrl   String 请求地址
 * @para paras    [String:Any] 请求参数
 * @para successBack  成功回调
 * @para failureBack  失败回调
 */
+(void)getRequestForServerData:(NSString *_Nullable)strUrl
                withParameters:(NSDictionary *_Nullable)paras
            AndHTTPHeaderField:(void(^_Nullable)(AFHTTPRequestSerializer *_Nullable _requestSerializer))headerField AndSuccessBack:(void(^_Nullable)(id _Nullable _responseData))successBack
                AndFailureBack:(void(^_Nullable)(NSString *_Nullable _strError))failureBack
                 WithisLoading:(BOOL)isLoading;

/**
 *  异步POST请求:以body方式,支持数组
 *
 *  @param url     请求的url
 *  @param body    body数据
 *  @param success 成功回调
 *  @param failure 失败回调
 *  @param isLoading BOOL
 */
+(void)postWithUrl:(NSString *_Nullable)url
              body:(NSData *_Nullable)body
       WithSuccess:(void(^_Nullable)(id _Nullable response,NSString * _Nullable strMsg))success
       WithFailure:(void(^_Nullable)(NSString * _Nullable error))failure
     WithisLoading:(BOOL)isLoading;

/**!
 * 文件或图片上传
 * @para strUrl String 上传地址
 * @para headerField  请求参数
 * @para successBack  成功回调
 * @para failureBack  失败回调
 * @para progressBack 进度
 */
+(void)postImageUploadToServer:(NSString *_Nullable)strUrl
                       AndBody:(NSData *_Nullable)body
            AndHTTPHeaderField:(void(^_Nullable)(NSMutableURLRequest * _Nullable _request))headerField
                AndSuccessBack:(void(^_Nullable)(NSObject * _Nullable _responseData, NSString * _Nullable _strMsg))successBack
                AndFailureBack:(void(^_Nullable)(NSString * _Nullable _strError))failureBack
                   andProgress:(void(^ _Nullable)(NSProgress * _Nonnull progress))progressBack
                 WithisLoading:(BOOL)isLoading;

/**!
 * 文件或图片上传
 * @para strUrl String 上传地址
 * @para uploadformDataBack 上传参数设置
 * @para headerField  请求参数
 * @para successBack  成功回调
 * @para failureBack  失败回调
 */
+(void)postImageUploadToServer:(NSString *_Nullable)strUrl
         AndUploadformDataBack:(void(^_Nullable)(id<AFMultipartFormData> _Nullable formData))formDataBack
            AndHTTPHeaderField:(void(^_Nullable)(AFHTTPRequestSerializer * _Nullable _requestSerializer))headerField
                AndSuccessBack:(void(^_Nullable)(NSObject * _Nullable _responseData, NSString * _Nullable _strMsg))successBack
                AndFailureBack:(void(^_Nullable)(NSString * _Nullable _strError))failureBack WithisLoading:(BOOL)isLoading;
+(void)postFileUploadToServer:(NSString *_Nullable)strUrl
        AndUploadformDataBack:(void(^_Nullable)(id<AFMultipartFormData> _Nullable formData))formDataBack
           AndHTTPHeaderField:(void(^_Nullable)(AFHTTPRequestSerializer * _Nullable _requestSerializer))headerField
               AndSuccessBack:(void(^_Nullable)(NSDictionary * _Nullable _responseData, NSString * _Nullable _strMsg))successBack
               AndFailureBack:(void(^_Nullable)(NSString * _Nullable _strError))failureBack WithisLoading:(BOOL)isLoading;

/**!
 *  异步Put请求:以body方式,支持数组
 *
 *  @param strUrl      请求的url
 *  @param paras       NSDictionary
 *  @param successBack 成功回调
 *  @param failureBack 失败回调
 *  @param isLoading   BOOL
 */
+(void)putRequestForServerData:(NSString *_Nullable)strUrl
                withParameters:(NSDictionary *_Nullable)paras
                AndSuccessBack:(void(^_Nullable)(id _Nullable _responseData,NSString * _Nullable strMsg))successBack
                AndFailureBack:(void(^_Nullable)(NSString * _Nullable _strError))failureBack
                 WithisLoading:(BOOL)isLoading;

/**!
 * 异步文件下载
 *
 *  @param strUrl      请求的url
 *  @param finishBack  完成回调
 *  @param isLoading   BOOL 是否加载进度
 */
+(void)downloadRequestDataForUrl:(NSString *_Nonnull)strUrl
              AndHTTPHeaderField:(void(^_Nullable)(NSMutableURLRequest * _Nullable _request))headerField AndFinishBack:(void(^ _Nullable)(id _Nullable responseData,NSString * _Nullable strMsg))finishBack
                     andProgress:(void(^ _Nullable)(NSProgress * _Nonnull progress))progressBack
                      AndLoaging:(BOOL)isLoading;

//MARK: - 加载Gif
+(void)loadGIFImage:(NSString *_Nullable)imagePath
AndFLAnimatedImageView:(FLAnimatedImageView *_Nullable)gifImgView;


//MARK: - 公共请求方法
/** 加载视频详情数据 */
+(void)loadMoviesDetailsDataWithVId:(NSString * _Nullable)strVId
                        abdCallback:(void(^_Nullable)(id _Nullable responseData,NSString *_Nullable  strMsg))callBackMethod
                       andisLoading:(BOOL)loading;

/** 用户推广数据 */
+(void)loadTuiGuangDataWithParams:(NSDictionary * _Nullable)dicParams
                    andFinishBack:(void(^_Nullable)(id _Nullable responseData,NSString *_Nullable  strMsg))finishBack
                       AndisLogin:(BOOL)loading;

/** 加载用户信息 */
+ (void)getInfosModelForUserId:(NSInteger)userId
                    andLoading:(BOOL)loading
                 andFinishback:(void(^_Nullable)(InfosModel  * _Nullable model))finishback;

/**
 * 用户关注、取消关注
 * @param strUserId 关注/取消关注的用户Id
 * @param isFlow Bool YES 添加关注，反之取消关注
 */
+(void)collectionUserOrNoWithId:(NSString * _Nonnull)strUserId
                        AndFlow:(BOOL)isFlow
                     AndLoading:(BOOL)loading
                 withFinishback:(void(^_Nullable)(BOOL isSuccess))finishback;

/**
 * 列表数据处理
 * @param adData     NSArray        返回的广告数据
 * @param interval   NSInteger      广告间隔时间
 * @param listArr    NSArray        当前请求返回的列表数据
 * @param totalArray NSMutableArray 之前已加载的总列表数据
 */
+(void)mergeData:(NSArray * _Nullable)adData
     AndInterval:(NSInteger)interval
     andListData:(NSArray * _Nullable)listArr
   withTotalData:(NSMutableArray * _Nullable)totalArray;

/**
 * 分享
 */
+ (void)wxExtensionShareURL:(NSString * _Nonnull)urlStr
                    AndBack:(void(^ _Nullable)(UIActivityViewController * _Nonnull activityVC))shareBack;

@end
