

#import "Utils.h"
#import "InfosModel.h"
#import <Photos/Photos.h>

@implementation Utils

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
+(void)setViewShadowStyle:(UIView *)uView
           AndShadowColor:(UIColor *)sColor
         AndShadowOpacity:(CGFloat)sOpacity
          AndShadowRadius:(CGFloat)sRadius
         WithShadowOffset:(CGSize)sOffset{
    
    //shadowColor阴影颜色
    uView.layer.shadowColor = [sColor CGColor];
    
    //阴影透明度
    uView.layer.shadowOpacity = sOpacity;
    
    //阴影半径，默认3
    uView.layer.shadowRadius = sRadius;
    
    //shadowOffset阴影偏移,
    //x向右偏移(正值)，y向下偏移(正值)，默认(0, -3),这个跟shadowRadius配合使用
    uView.layer.shadowOffset = sOffset;
    
    //设置阴影此属性要设置为 false
    uView.layer.masksToBounds = NO;
}

/**! 视图抖动动画 */
+(void)shakeAnimationForView:(UIView *)view{
    // 获取到当前的View
    CALayer *viewLayer = view.layer;
    
    // 获取当前View的位置
    CGPoint position = viewLayer.position;
    
    // 移动的两个终点位置
    CGPoint x = CGPointMake(position.x + 10, position.y);
    CGPoint y = CGPointMake(position.x - 10, position.y);
    
    // 设置动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    
    // 设置运动形式
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    
    // 设置开始位置
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    
    // 设置结束位置
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    
    // 设置自动反转
    [animation setAutoreverses:YES];
    
    // 设置时间
    [animation setDuration:.06];
    
    // 设置次数
    [animation setRepeatCount:3];
    
    // 添加上动画
    [viewLayer addAnimation:animation forKey:nil];
}


//MARK: - 相关动画设置
/**! tabbar侧滑动画  */
+(void)tabBarChangeAnimation:(UITabBarController *)tabBarController WithDirection:(NSInteger)direction{
    
    CATransition *transition = [[CATransition alloc] init];
    transition.duration = 0.2;
    transition.type =  kCATransitionMoveIn;//kCATransitionReveal
    
    if(direction == 0) {
        transition.subtype = kCATransitionFromLeft;
    }
    else{
        transition.subtype = kCATransitionFromRight;
    }
    
    //transition.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
    transition.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionDefault];
    
    [[[tabBarController view] layer] addAnimation:transition forKey:@"reveal"];//switchView
}


//MARK: - Tabbar相关设置
/**!
 * 设置tabBar的尺寸
 * 调用方法：自定义View 继承自 UITabBarController，在 viewWillLayoutSubviews 中使用：
 * [Utils setTabbarHeight:self.tabBar];
 */
+(void)setTabbarHeight:(UITabBar *)tabBar{
    CGRect rectTabbar = tabBar.frame;
    
    if (rectTabbar.size.height >= 49) {
        rectTabbar.size.height = K_APP_TABBAR_HEIGHT;
        
        CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
        CGFloat statusBarHeight = statusBarFrame.size.height;
        if (statusBarHeight > 20.0) {
            rectTabbar.origin.y = K_APP_HEIGHT - K_APP_TABBAR_HEIGHT - 20;
        }
        else{
            rectTabbar.origin.y = K_APP_HEIGHT - K_APP_TABBAR_HEIGHT;
        }
        
        tabBar.frame = rectTabbar;
    }
}

/**!
 * 设置tabBar的尺寸 顶部边框线
 */
+(void)setTopLine:(UITabBar *)tabBar{
    // [S] 顶部边框线
    NSData *topLineData = [[NSUserDefaults standardUserDefaults] dataForKey:K_APP_TABBAR_TOP_LINE];
    if (topLineData == nil || [topLineData length] <= 0) {
        CGRect rect = CGRectMake(0, 0, K_APP_WIDTH, 0.1);
        UIGraphicsBeginImageContext(rect.size);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetRGBFillColor(context, 223.0, 223.0, 223.0, 1.0);
        CGContextFillRect(context, rect);
        
        UIImage *imgTemp = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        topLineData = UIImagePNGRepresentation(imgTemp);
        [[NSUserDefaults standardUserDefaults] setObject:topLineData forKey:K_APP_TABBAR_TOP_LINE];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    tabBar.shadowImage = [UIImage imageWithData:topLineData];
    // [E] 顶部边框线
}

/**!
 * 清除tabbar顶部边线
 */
+(void)clearnTabBarTopLine:(UITabBar *)tabBar{
    
    NSData *clearnLineData = [[NSUserDefaults standardUserDefaults] dataForKey:K_APP_TABBAR_CLEARN_IMAGE];
    
    if (clearnLineData == nil || [clearnLineData length] <= 0) {
        CGRect rect = CGRectMake(0, 0, 1, 1);
        UIGraphicsBeginImageContext(rect.size);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 0.0);
        CGContextFillRect(context, rect);
        
        UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        clearnLineData = UIImagePNGRepresentation(theImage);
        [[NSUserDefaults standardUserDefaults] setObject:clearnLineData forKey:K_APP_TABBAR_CLEARN_IMAGE];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    tabBar.backgroundImage = [UIImage imageWithData:clearnLineData];
    tabBar.shadowImage = [UIImage imageWithData:clearnLineData];
}


//MARK: - 图片相关处理
/**! 图片不变形处理 */
+(void)imgNoTransformation:(UIImageView *)img{
    img.contentMode = UIViewContentModeScaleAspectFill;
    img.clipsToBounds = YES; //是否剪切掉超出 UIImageView 范围的图片
    img.contentScaleFactor = [UIScreen mainScreen].scale;
}

/** 图片压缩处理 */
+(NSData *)zipNSDataWithImage:(UIImage *)sourceImage{
    //进行图像尺寸的压缩
    CGSize imageSize = sourceImage.size;//取出要压缩的image尺寸
    CGFloat width = imageSize.width;    //图片宽度
    CGFloat height = imageSize.height;  //图片高度
    //1.宽高大于1280(宽高比不按照2来算，按照1来算)
    if (width>1280||height>1280) {
        if (width>height) {
            CGFloat scale = height/width;
            width = 1280;
            height = width*scale;
        }else{
            CGFloat scale = width/height;
            height = 1280;
            width = height*scale;
        }
    }
    //2.宽大于1280高小于1280
    else if(width>1280||height<1280){
        CGFloat scale = height/width;
        width = 1280;
        height = width*scale;
    }
    //3.宽小于1280高大于1280
    else if(width<1280||height>1280){
        CGFloat scale = width/height;
        height = 1280;
        width = height*scale;
        
    }
    //4.宽高都小于1280
    else{
        
    }
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [sourceImage drawInRect:CGRectMake(0,0,width,height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //进行图像的画面质量压缩
    NSData *data=UIImageJPEGRepresentation(newImage, 1.0);
    if (data.length>100*1024) {
        if (data.length>1024*1024) {//1M以及以上
            data=UIImageJPEGRepresentation(newImage, 0.7);
        }else if (data.length>512*1024) {//0.5M-1M
            data=UIImageJPEGRepresentation(newImage, 0.8);
        }else if (data.length>200*1024) {
            //0.25M-0.5M
            data=UIImageJPEGRepresentation(newImage, 0.9);
        }
    }
    return data;
}

/** 生成二维码 */
+(UIImage *_Nonnull)getCodeImage:(NSString * _Nonnull)url
                     andDrawLogo:(BOOL)isDrawLogo{
    //生成二维码
    // 1. 创建一个二维码滤镜实例(CIFilter)
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 滤镜恢复默认设置
    [filter setDefaults];
    
    // 2. 给滤镜添加数据
    NSString *string = url;
    
    //加入二维码url
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    // 3. 生成高清二维码
    CIImage *image = [filter outputImage];
    CGAffineTransform transform = CGAffineTransformMakeScale(5.0f, 5.0f);
    CIImage *output = [image imageByApplyingTransform: transform];
    UIImage *newImage = [UIImage imageWithCIImage:output scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    
    //绘制logo
    if (isDrawLogo) {
        CGSize size = newImage.size;
        
        // 开启绘图, 获取图片 上下文<图片大小>
        UIGraphicsBeginImageContextWithOptions(size, NO, 5.0f);
        
        // 将二维码图片画上去
        [newImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        
        //见logo画上去
        UIImage *imgLogo = [UIImage imageNamed:@"AppIcon"];
        
        CGRect rect = CGRectMake((size.width - imgLogo.size.width) * 0.5,
                                 (size.height - imgLogo.size.height) * 0.5,
                                 imgLogo.size.width,
                                 imgLogo.size.height);
        [imgLogo drawInRect:rect];
        
        // 获取最终的图片
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        
        // 关闭上下文
        UIGraphicsEndImageContext();
    }
    
    return newImage;
}

/** 截图 */
+(UIImage * _Nonnull)screenShotForView:(UIView * _Nonnull)screensViwe{
    
    UIGraphicsBeginImageContextWithOptions(screensViwe.size,NO, 0.0);
    
    [screensViwe.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *screenShotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return screenShotImage;
}

/** 创建自定义相册 */
+(void)isExistFolder:(NSString * _Nonnull)folderName
       andBackaction:(void(^ _Nullable)(PHAssetCollection * _Nullable assetCollection))backAction{
    
    __block BOOL isExists = NO;
    
    //首先获取用户手动创建相册的集合
    PHFetchResult *collectonResuts = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    
    //对获取到集合进行遍历
    [collectonResuts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PHAssetCollection *assetCollection = obj;
        //folderName是我们写入照片的相册
        if ([assetCollection.localizedTitle isEqualToString:folderName])  {
            isExists = YES;
            
            if (backAction) backAction(assetCollection);
        }
    }];
    
    if (!isExists) {
        if (backAction) backAction(nil);
    }
}

+(void)createFolder:(NSString *_Nonnull)folderName
      andBackaction:(void(^ _Nullable)(PHAssetCollection *_Nullable assetCollection))backAction {
    
    [Utils isExistFolder:folderName
           andBackaction:^(PHAssetCollection * _Nullable assetCollection) {
               //存在
               if (assetCollection) {
                   if (backAction) backAction(assetCollection);
               }
               //不存在
               else{
                   [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                       //添加HUD文件夹
                       [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:folderName];
                       
                   } completionHandler:^(BOOL success, NSError * _Nullable error) {
                       if (success) {
                           ZWWLog(@"创建相册文件夹成功!");
                           
                           [Utils isExistFolder:folderName
                                  andBackaction:^(PHAssetCollection * _Nullable assetCollection) {
                                      if (backAction) backAction(assetCollection);
                                  }];
                       } else {
                           ZWWLog(@"创建相册文件夹失败:%@", error);
                           if (backAction) backAction(nil);
                       }
                   }];
               }
           }];
}


//MARK: - 信息验证
/**!
 * 验证手机号
 * @return true 通过验证
 */
+(BOOL)checkPhoneNo:(NSString *)strPhoneNo {
    
    if (!strPhoneNo || [strPhoneNo isEqualToString:@""]) {
        return NO;
    }
    
    NSString *strRegex = @"^1[34578]([0-9]{9})$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",strRegex];
    
    return [predicate evaluateWithObject:strPhoneNo];
}

/**!
 * 验证邮箱
 * @return true 通过验证
 */
+(BOOL)checkEmail:(NSString *)strEmail {
    
    if (!strEmail || [strEmail isEqualToString:@""]) {
        return NO;
    }
    
    NSString *strRegex = @"^([a-zA-Z0-9_\\.-]){2,}+@([a-zA-Z0-9-]){2,}+(\\.[a-zA-Z0-9-]+)*\\.[a-zA-Z0-9]{2,6}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",strRegex];
    
    return [predicate evaluateWithObject:strEmail];
}


/**!
 * 验证密码(密码为6~20位的数字字母)
 * @return true 通过验证
 */
+(BOOL)checkPassword:(NSString *)strPwd {
    
    if (!strPwd || [strPwd isEqualToString:@""]) {
        return NO;
    }
    
    //长度限制
    NSUInteger length = strPwd.length;
    if (length < 6 || length > 20) {
        return NO;
    }
    
    //是否含有Emoji 表情
    if ([Utils stringContainsEmoji:strPwd]) {
        return NO;
    }
    
    NSString *strRegex = @"^[A-Za-z0-9]{6,20}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",strRegex];
    return [predicate evaluateWithObject:strPwd];
}

/**!
 * 验证验证码(长度6位的数字字母)
 * @return true 通过验证
 */
+(BOOL)checkPhoneCode:(NSString *)strCode {
    
    if (!strCode || [strCode isEqualToString:@""]) {
        return NO;
    }
    
    //长度限制
    NSUInteger length = strCode.length;
    if (length > 6) {
        return NO;
    }
    
    NSString *strRegex = @"^[0-9a-zA-Z]{4,6}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",strRegex];
    return [predicate evaluateWithObject:strCode];
}

/**!
 * 验证姓名(字母或中文)
 * @params strName NSString
 * @params len     NSInteger 长度
 * @return true 通过验证
 */
+(BOOL)checkName:(NSString *)strName AndLength:(NSInteger)len {
    
    if (!strName || [strName isEqualToString:@""]) {
        return NO;
    }
    
    //长度限制
    NSUInteger length = strName.length;
    if (length > len) {
        return NO;
    }
    
    NSString *strRegex = [NSString stringWithFormat:@"^[A-Za-z\\u4e00-\\u9fa5]{2,%ld}$",(long)len];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",strRegex];
    return [predicate evaluateWithObject:strName];
}

/**!
 * 验证中文
 * @params strName NSString
 * @params len     NSInteger 长度
 * @return true 通过验证
 */
+(BOOL)checkChinese:(NSString *)strName AndLength:(NSInteger)len {
    
    if (!strName || [strName isEqualToString:@""]) {
        return NO;
    }
    
    //长度限制
    NSUInteger length = strName.length;
    if (length > len) {
        return NO;
    }
    
    NSString *strRegex = [NSString stringWithFormat:@"^[\\u4e00-\\u9fa5]{2,%lD}$",(long)len];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",strRegex];
    return [predicate evaluateWithObject:strName];
}

/**!
 * 验证身份证(15/18位)
 * @params value NSString
 * @return true 通过验证
 */
+(BOOL)checkIDCardNumber:(NSString *)value {
    
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSInteger length = 0;
    if (!value) return NO;
    else {
        length = value.length;
        //不满足15位和18位，即身份证错误
        if (length != 15 && length != 18) return NO;
    }
    
    // 省份代码
    NSArray *areasArray = @[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    // 检测省份身份行政区代码
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag = NO; //标识省份代码是否正确
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag = YES;
            break;
        }
    }
    
    if (!areaFlag) return NO;
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    int year = 0;
    
    //分为15位、18位身份证进行校验
    switch (length) {
        case 15:
            //获取年份对应的数字
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                //创建正则表达式 NSRegularExpressionCaseInsensitive：不区分字母大小写的模式
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }
            else{
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }
            //使用正则表达式匹配字符串 NSMatchingReportProgress:找到最长的匹配字符串后调用block回调
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            if(numberofMatch >0) return YES;
            else return NO;
        case 18:
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^((1[1-5])|(2[1-3])|(3[1-7])|(4[1-6])|(5[0-4])|(6[1-5])|71|(8[12])|91)\\d{4}(((19|20)\\d{2}(0[13-9]|1[012])(0[1-9]|[12]\\d|30))|((19|20)\\d{2}(0[13578]|1[02])31)|((19|20)\\d{2}02(0[1-9]|1\\d|2[0-8]))|((19|20)([13579][26]|[2468][048]|0[048])0229))\\d{3}(\\d|X|x)?$"
                                                                        options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
                
            }
            else{
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^((1[1-5])|(2[1-3])|(3[1-7])|(4[1-6])|(5[0-4])|(6[1-5])|71|(8[12])|91)\\d{4}(((19|20)\\d{2}(0[13-9]|1[012])(0[1-9]|[12]\\d|30))|((19|20)\\d{2}(0[13578]|1[02])31)|((19|20)\\d{2}02(0[1-9]|1\\d|2[0-8]))|((19|20)([13579][26]|[2468][048]|0[048])0229))\\d{3}(\\d|X|x)?$"
                                                                        options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }
            
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            if(numberofMatch >0) {
                //1：校验码的计算方法 身份证号码17位数分别乘以不同的系数。从第一位到第十七位的系数分别为：7－9－10－5－8－4－2－1－6－3－7－9－10－5－8－4－2。将这17位数字和系数相乘的结果相加。
                int S = [value substringWithRange:NSMakeRange(0,1)].intValue*7 + [value substringWithRange:NSMakeRange(10,1)].intValue *7 + [value substringWithRange:NSMakeRange(1,1)].intValue*9 + [value substringWithRange:NSMakeRange(11,1)].intValue *9 + [value substringWithRange:NSMakeRange(2,1)].intValue*10 + [value substringWithRange:NSMakeRange(12,1)].intValue *10 + [value substringWithRange:NSMakeRange(3,1)].intValue*5 + [value substringWithRange:NSMakeRange(13,1)].intValue *5 + [value substringWithRange:NSMakeRange(4,1)].intValue*8 + [value substringWithRange:NSMakeRange(14,1)].intValue *8 + [value substringWithRange:NSMakeRange(5,1)].intValue*4 + [value substringWithRange:NSMakeRange(15,1)].intValue *4 + [value substringWithRange:NSMakeRange(6,1)].intValue*2 + [value substringWithRange:NSMakeRange(16,1)].intValue *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                
                //2：用加出来和除以11，看余数是多少？余数只可能有0－1－2－3－4－5－6－7－8－9－10这11个数字
                int Y = S %11;
                NSString *M =@"F";
                NSString *JYM =@"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];
                
                // 3：获取校验位
                NSString *lastStr = [value substringWithRange:NSMakeRange(17,1)];
                ZWWLog(@"%@",M);
                ZWWLog(@"%@",[value substringWithRange:NSMakeRange(17,1)]);
                
                //4：检测ID的校验位
                if ([lastStr isEqualToString:@"x"]) {
                    if ([M isEqualToString:@"X"]) return YES;
                    else return NO;
                }
                else{
                    if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) return YES;
                    else return NO;
                }
            }
            else return NO;
        default:
            return NO;
    }
}

/**!
 * 验证文本是否为空
 * @params strTxt NSString
 * @return true 通过验证
 */
+(BOOL)checkTextEmpty:(NSString *)strTxt{
    
    if (strTxt == nil) return NO;
    if ([strTxt isEqualToString:@"(null)"]) return NO;
    if ([strTxt isEqualToString:@""]) return NO;
    if ([strTxt length] <= 0) return NO;
    if ([[strTxt stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceCharacterSet] length] <= 0) return NO;
    
    return YES;
}

//MARK: - 相关App是否有安装检测
//https://www.zhihu.com/question/19907735
/**! 是否有安装QQ */
+(BOOL)isInstallForQQ{
    //QQ mqq:// 或 mqqiapi://
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqqiapi://"]]) {
            return NO;
        }
    }
    
    return YES;
}

/**! 是否有安装微信 */
+(BOOL)isInstallForWechat {
    //微信 weixin:// 或 wechat://
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
        if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wechat://"]]) {
            return NO;
        }
    }
    
    return YES;
}

/**! 是否有安装新浪微博 */
+(BOOL)isInstallForSina {
    //新浪微博 weibo:// 或 sinaweibo://
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weibo://"]]) {
        if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sinaweibo://"]]) {
            return NO;
        }
    }
    
    return YES;
}

/**! 是否有安装支付宝 */
+(BOOL)isInstallForAliPay {
    //支付宝 alipay://
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay://"]]) {
        return NO;
    }
    
    return YES;
}

/**! 开启设置权限 */
+(void)openSetting{
    
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}


//MARK: - 缓存相关设置
/**! 获取系统缓存 */
+(NSString *)getAppCacheSize{
    
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSString *strResult = @"0M";
    BOOL isDirectory = NO;
    
    //是否存在
    if ([fileManage fileExistsAtPath:K_APPLICATION_CACHE_PATH isDirectory:&isDirectory]) {
        
        @try {
            float fsize = 0.0;
            NSDictionary *attributDic;
            
            //文件夹
            if(isDirectory) {
                
                NSString *tempPath;
                
                //获取该目录下所有文件
                for (NSString *strItem in [fileManage subpathsAtPath:K_APPLICATION_CACHE_PATH]) {
                    tempPath = [NSString stringWithFormat:@"%@/%@",K_APPLICATION_CACHE_PATH,strItem];
                    
                    //存在，且为文件
                    if ([fileManage fileExistsAtPath:tempPath isDirectory:&isDirectory] && isDirectory == NO) {
                        attributDic = [fileManage attributesOfItemAtPath:tempPath error:nil];
                        fsize = fsize + [[attributDic valueForKey:NSFileSize] floatValue];
                    }
                }
            }
            else{
                attributDic = [fileManage attributesOfItemAtPath:K_APPLICATION_CACHE_PATH error:nil];
                fsize = [[attributDic valueForKey:NSFileSize] floatValue];
            }
            
            //计算缓存大小
            fsize = fsize / (1024.0 * 1024.0);
            if (fsize > 0.0) {
                strResult = [NSString stringWithFormat:@"%.2fM",fsize];
            }
        } @catch (NSException *exception) {
            ZWWLog(@"获取缓存异常:%@",exception);
        }
    }
    
    return strResult;
}

/**!
 * 清理系统缓存
 */
+(BOOL)clearnAppCache{
    
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSString *tempPath;
    BOOL isDic = NO;
    BOOL isOk = NO;
    
    //路径存在，且为文件夹
    if ([fileManage fileExistsAtPath:K_APPLICATION_CACHE_PATH isDirectory:&isDic] && isDic) {
        
        @try {
            for (NSString *strItem in [fileManage subpathsAtPath:K_APPLICATION_CACHE_PATH]) {
                tempPath = [NSString stringWithFormat:@"%@/%@",K_APPLICATION_CACHE_PATH,strItem];
                
                //移除
                if ([fileManage fileExistsAtPath:tempPath]) {
                    [fileManage removeItemAtPath:tempPath error:nil];
                }
            }
            
            isOk = YES;
        } @catch (NSException *exception) {
            ZWWLog(@"清理缓存异常:%@",exception);
        }
    }
    
    return isOk;
}


//MARK: - 获取设备信息
/**!
 * 获取当前设备的UUID
 */
+(NSString *)getCurrentDeviceUUID {
    NSUUID *uuid = [[UIDevice currentDevice] identifierForVendor];
    return [uuid UUIDString];
}

+ (NSString *)dy_getIDFV{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)]) {
        NSString *string = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        string = [string stringByReplacingOccurrencesOfString:@"-" withString:@""];
        return string;
    }
    return @"";
}


//MARK: - Emoji表情检测
/**!
 * 是否含有Emoji 表情(true 含有)
 */
+(BOOL)stringContainsEmoji:(NSString *)string{
    
    __block BOOL returnValue = FALSE;
    [string enumerateSubstringsInRange:NSMakeRange(0, string.length)
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
                                
                                unichar hs = [substring characterAtIndex:0];
                                // surrogate pair
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        unichar ls =[substring characterAtIndex:1];
                                        
                                        NSInteger uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f){
                                            returnValue = YES;
                                        }
                                    }
                                }
                                else if (substring.length > 1) {
                                    unichar ls =[substring characterAtIndex:1];
                                    if (ls == 0x20e3){
                                        returnValue = YES;
                                    }
                                }
                                else {
                                    // non surrogate
                                    if (0x2100 <= hs && hs <= 0x27ff){
                                        returnValue = YES;
                                    }
                                    else if (0x2B05 <= hs && hs <= 0x2b07){
                                        returnValue = YES;
                                    }
                                    else if (0x2934 <= hs && hs <= 0x2935){
                                        returnValue = YES;
                                    }
                                    else if (0x3297 <= hs && hs <= 0x3299){
                                        returnValue = YES;
                                    }
                                    else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50){
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}


//MARK: - 时间处理
/** 将Linux时间转换为字符串时间 */
+(NSString *)formatDateToString:(NSTimeInterval)linuxTime WithFormat:(NSString *)format{
    
    long long _timeInterval = linuxTime;
    NSString *_temp = [NSString stringWithFormat:@"%.0f",linuxTime];
    if (_temp.length > 10) {
        _temp = [_temp substringToIndex:10];
        
        _timeInterval = [_temp longLongValue];
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_timeInterval];
    NSDateFormatter *fomatter = [[NSDateFormatter alloc] init];
    [fomatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC+8"]];
    [fomatter setDateFormat:format];
    
    NSString *_strInfo = [fomatter stringFromDate:date];
    return _strInfo;
}

/** 获取当前时间 */
+(NSString *)getCurrentDateToString:(NSString *)format{
    NSDate *date = [NSDate date];
    
    NSDateFormatter *fomatter = [[NSDateFormatter alloc] init];
    [fomatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC+8"]];
    [fomatter setDateFormat:format];
    
    NSString *_strInfo = [fomatter stringFromDate:date];
    return _strInfo;
}

+(long long)getCurrentLinuxTime{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    return [[NSNumber numberWithDouble:time] longLongValue];
}


//MARK: - 获取文本的宽度
/**!
 * 获取文本的宽度
 */
+(CGFloat)getWidthForString:(NSString *)value andFontSize:(UIFont *)font andHeight:(CGFloat)height{
    CGSize sizeToFit = [value sizeWithFont:font constrainedToSize:CGSizeMake(CGFLOAT_MAX, height) lineBreakMode:NSLineBreakByWordWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    
    return sizeToFit.width;
}

/** 获取文本的高度 */
+(CGFloat)getHeightForString:(NSString *)value andFontSize:(UIFont *)font andWidth:(CGFloat)width{
    CGSize sizeToFit = [value sizeWithFont:font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    
    return sizeToFit.height;
}

/**!
 * 获取文本框的高度
 */
+(CGFloat)getTextViewHeight:(UITextView *)textView AndFixedWidth:(CGFloat)width {
    
    CGFloat fw = 0.0;
    
    CGSize size = CGSizeMake(width, CGFLOAT_MAX);
    CGSize constraint = [textView sizeThatFits:size];
    fw = constraint.height + 10.0;
    
    return fw;
}


//MARK: - 设置富文本
/**! 设置富文本 */
+(NSAttributedString *)setAttributeStringText:(NSString *)strFullText
                              andFullTextFont:(UIFont *)textFont
                             andFullTextColor:(UIColor *)textColor
                               withChangeText:(NSString *)changeText
                               withChangeFont:(UIFont *)changFont
                              withChangeColor:(UIColor *)changeColor isLineThrough:(BOOL)lineThrough{
    
    NSDictionary<NSAttributedStringKey,id> *dicAttr;
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:strFullText];
    
    //需要改变的文本
    NSRange range = [strFullText rangeOfString:changeText];
    
    dicAttr = @{
                NSFontAttributeName:changFont,
                NSForegroundColorAttributeName:changeColor
                };
    
    if (lineThrough) {
        [dicAttr setValue:[[NSNumber alloc] initWithInt:1] forKey:NSStrikethroughStyleAttributeName];
    }
    [attributeString addAttributes:dicAttr range:range];
    
    //不需要改变的文本
    NSString *oldText = [strFullText stringByReplacingOccurrencesOfString:changeText withString:@""];
    range = [strFullText rangeOfString:oldText];
    
    dicAttr = @{
                NSFontAttributeName:textFont,
                NSForegroundColorAttributeName:textColor
                };
    [attributeString addAttributes:dicAttr range:range];
    
    return attributeString;
}

/** 设置导航标题字体样式 */
+(NSAttributedString *_Nullable)setNavAttributeStringText:(NSString *_Nullable)strtext
                                              AndFontSize:(CGFloat)fSize
                                             AndTextColor:(UIColor *_Nonnull)txtColor{
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowBlurRadius = 3;
    shadow.shadowColor = [UIColor colorWithRed:39/255.0 green:30/255.0 blue:29/255.0 alpha:0.16];
    shadow.shadowOffset = CGSizeMake(0,2);
    
    NSString *_txt = strtext != nil ? strtext : @"";
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:_txt attributes:@{
        NSFontAttributeName: ADOBE_FONT(fSize),
        NSForegroundColorAttributeName: txtColor,
        NSShadowAttributeName: shadow}];
    
    return string;
}

+(NSAttributedString *_Nullable)updateNavAttribute:(NSAttributedString *_Nullable)attributedString
                                          AndColor:(UIColor *_Nullable)txtColor
                                       AndFontSize:(CGFloat)fSize{
    
    if(attributedString == nil){
        return nil;
    }
    
    NSRange range = [attributedString.string rangeOfString:attributedString.string];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithAttributedString:attributedString];
    
    if(txtColor != nil){
        //[string setAttributes:@{NSForegroundColorAttributeName: txtColor} range:range];
        [string addAttribute:NSForegroundColorAttributeName value:txtColor range:range];
    }
    
    if(fSize > 0){
        //[string setAttributes:@{NSFontAttributeName: ADOBE_FONT(fSize)} range:range];
        [string addAttribute:NSFontAttributeName value:ADOBE_FONT(fSize) range:range];
    }
    
    return string;
}

+(NSAttributedString *)setPlaceholderAttributeString:(NSString *_Nullable)changeText
                                      withChangeFont:(UIFont *_Nullable)changFont
                                     withChangeColor:(UIColor *_Nullable)changeColor
                                       isLineThrough:(BOOL)lineThrough{
    
    if (changFont == nil && changeColor == nil) {
        return nil;
    }
    
    
    NSString *strtext = changeText == nil? @"":changeText;
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:strtext];
    NSMutableDictionary<NSAttributedStringKey,id> *dicAttr = [NSMutableDictionary<NSAttributedStringKey,id> dictionary];
    
    //需要改变的文本
    NSRange range = [strtext rangeOfString:strtext];
    
    if (changFont) {
        [dicAttr setValue:changFont forKey:NSFontAttributeName];
    }
    
    if (changeColor) {
        [dicAttr setValue:changeColor forKey:NSForegroundColorAttributeName];
    }
    
    if (lineThrough) {
        [dicAttr setValue:[[NSNumber alloc] initWithInt:1] forKey:NSStrikethroughStyleAttributeName];
    }
    [attributeString addAttributes:dicAttr range:range];
    
    return attributeString;
}


//MARK: - Json 与 字典、数组类型转换
/**!
 * 数组转换为NString
 * @returns: NString
 */
+(NSString *)getJSONStringFromData:(id)idData{
    
    if (![NSJSONSerialization isValidJSONObject:idData]) {
        ZWWLog(@"无法解析出JSONString");
        return @"";
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:idData
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];
    NSString *strReturn = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return strReturn;
}


//MARK: - 网络请求方法
/**!
 * post 接口请求
 * @para strUrl   String 请求地址
 * @para paras    [String:Any] 请求参数
 * @para successBack  成功回调
 * @para failureBack  失败回调
 */
+(void)postRequestForServerData:(NSString *)strUrl
                 withParameters:(NSDictionary *)paras
             AndHTTPHeaderField:(void(^)(AFHTTPRequestSerializer *_requestSerializer))headerField AndSuccessBack:(void(^)(id _responseData))successBack
                 AndFailureBack:(void(^)(NSString *_strError))failureBack
                  WithisLoading:(BOOL)isLoading{
    
    ZWWLog(@"请求地址：%@,参数：%@",strUrl,paras);
    
    if (![K_APP_REACHABILITY isReachable]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [YJProgressHUD showError:K_APP_NO_NETWORK_INFO];
        });
        
        ZWWLog(@"网络连接异常");
        return;
    }
    if (isLoading) {
        [YJProgressHUD showLoading:@"loading..."];
    }
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    [sessionManager.requestSerializer setValue:LOGIN_COOKIE forHTTPHeaderField:LOGIN_COOKIE_KEY];
    
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain", nil];
    
    //设置HTTPHeaderField
    if (headerField) {
        headerField(sessionManager.requestSerializer);
    }
    
    //提交请求
    [sessionManager POST:strUrl
              parameters:paras
                progress:nil
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     
                     if (isLoading) {
                         [YJProgressHUD hideHUD];
                     }
                     
                     ZWWLog(@"请求结果：%@",responseObject);
                     
                     NSDictionary *jsonData = responseObject;
                     NSInteger resultCode = [[jsonData valueForKey:K_APP_REQUEST_CODE] integerValue];
                     NSString *strMessage = [jsonData valueForKey:K_APP_REQUEST_MSG];
                     
                     //成功
                     if (kRequestOK(resultCode)) {
                         if (successBack != nil) {
                             if ([[jsonData allKeys] containsObject:K_APP_REQUEST_DATA]) {
                                 successBack([jsonData valueForKey:K_APP_REQUEST_DATA]);
                             }
                             else{
                                 successBack(jsonData);
                             }
                         }
                     }
                     else{
                         [YJProgressHUD showError:strMessage];
                     }
                 }
                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     if (isLoading) {
                         [YJProgressHUD hideHUD];
                     }
                     if (failureBack != nil) {
                         failureBack([error localizedDescription]);
                     }
                     ZWWLog(@"请求异常：%@",[error localizedDescription]);
                 }];
}


/**!
 * get 接口请求
 * @para strUrl   String 请求地址
 * @para paras    [String:Any] 请求参数
 * @para successBack  成功回调
 * @para failureBack  失败回调
 */
+(void)getRequestForServerData:(NSString *)strUrl
                withParameters:(NSDictionary *)paras
            AndHTTPHeaderField:(void(^)(AFHTTPRequestSerializer *_requestSerializer))headerField AndSuccessBack:(void(^)(id _responseData))successBack
                AndFailureBack:(void(^)(NSString *_strError))failureBack
                 WithisLoading:(BOOL)isLoading{
    
    ZWWLog(@"请求地址：%@,参数：%@",strUrl,paras);
    
    if (![K_APP_REACHABILITY isReachable]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [YJProgressHUD showError:K_APP_NO_NETWORK_INFO];
        });
        
        ZWWLog(@"网络连接异常");
        return;
    }

    if (isLoading) {
        [YJProgressHUD showLoading:@"loading..."];
    }
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    [sessionManager.requestSerializer setValue:LOGIN_COOKIE forHTTPHeaderField:LOGIN_COOKIE_KEY];
    sessionManager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain", nil];
    
    //设置HTTPHeaderField
    if (headerField) {
        headerField(sessionManager.requestSerializer);
    }
    
    //提交请求
    [[sessionManager GET:strUrl
              parameters:paras
                progress:nil
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     
                     if (isLoading) {
                         [YJProgressHUD hideHUD];
                     }
                     
                     ZWWLog(@"请求结果：%@",responseObject);
                     
                     NSDictionary *jsonData = responseObject;
                     NSInteger resultCode = [[jsonData valueForKey:K_APP_REQUEST_CODE] integerValue];
                     NSString *strMessage = [jsonData valueForKey:K_APP_REQUEST_MSG];
                     
                     //成功
                     if (kRequestOK(resultCode)) {
                         if (successBack != nil) {
                             if ([jsonData.allKeys containsObject:K_APP_REQUEST_DATA]) {
                                 successBack([jsonData valueForKey:K_APP_REQUEST_DATA]);
                             }
                             else{
                                 successBack(jsonData);
                             }
                         }
                     }
                     else{
                         [YJProgressHUD showError:strMessage];
                     }
                 }
                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     if (isLoading) {
                         [YJProgressHUD hideHUD];
                     }
                     
                     if (failureBack != nil) {
                         failureBack([error localizedDescription]);
                     }
                     
                     ZWWLog(@"请求异常：%@",[error localizedDescription]);
                 }] resume];
}

/**
 *  异步POST请求:以body方式,支持数组
 *
 *  @param url     请求的url
 *  @param body    body数据
 *  @param success 成功回调
 *  @param failure 失败回调
 *  @param isLoading BOOL
 */
+(void)postWithUrl:(NSString *)url body:(NSData *)body
       WithSuccess:(void(^_Nullable)(id _Nullable response,NSString * _Nullable strMsg))success
       WithFailure:(void(^_Nullable)(NSString * _Nullable error))failure
     WithisLoading:(BOOL)isLoading{
    ZWWLog(@"请求地址：%@",url);
    
    if (![K_APP_REACHABILITY isReachable]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [YJProgressHUD showError:K_APP_NO_NETWORK_INFO];
        });
        ZWWLog(@"网络连接异常");
        return;
    }
    if (isLoading) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            _view = [[AppDelegate shareInstance] window].rootViewController.view;
//            if (_view) {
//                BOOL exists = NO;
//                for (UIView *object in _view.subviews) {
//                    if ([object isMemberOfClass:[MBProgressHUD class]]) {
//                        exists = YES;
//                        break;
//                    }
//                }
//
//                if (!exists) {
//                    [MBProgressHUD showMessage:@"" toView:_view];
//                }
//            }
//            else {
//                [MBProgressHUD showMessage:@""];
//            }
//        });
        [YJProgressHUD showLoading:@"loading..."];
    }
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:LOGIN_COOKIE forHTTPHeaderField:LOGIN_COOKIE_KEY];
    
    //设置body
    [request setHTTPBody:body];
    
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                 @"text/html",
                                                 @"text/json",
                                                 @"text/javascript",
                                                 @"text/plain",
                                                 nil];
    manager.responseSerializer = responseSerializer;
    
    [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        ZWWLog(@"请求结果：%@",responseObject);
        
        if (isLoading) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (_view != nil)
//                    [MBProgressHUD hideHUDForView:_view];
//                else
//                    [MBProgressHUD hideHUD];
//            });
            [YJProgressHUD hideHUD];
        }

        if (error == nil) {
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:[responseObject mj_JSONData]
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:nil];
            
            ZWWLog(@"请求结果2：%@",responseObject);
            NSInteger resultCode = [[jsonData valueForKey:K_APP_REQUEST_CODE] integerValue];
            NSString *strMessage = [jsonData valueForKey:K_APP_REQUEST_MSG];
            
            //成功
            if (kRequestOK(resultCode)) {
                if (success) {
                    if ([jsonData.allKeys containsObject:K_APP_REQUEST_DATA]) {
                        success([jsonData valueForKey:K_APP_REQUEST_DATA],strMessage);
                    }
                    else{
                        success(jsonData,strMessage);
                    }
                }
            }
            else{
                if (failure != nil) {
                    if (strMessage && ![strMessage isEqualToString:@""]) {
                        failure(strMessage);
                    }
                    else{
                        failure([error localizedDescription]);
                    }
                }
            }
        }
        else {
            if (failure != nil) {
                failure([error localizedDescription]);
            }
        }
    }] resume];
}

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
                 WithisLoading:(BOOL)isLoading{
    
    ZWWLog(@"请求地址：%@",strUrl);
    
    if (![K_APP_REACHABILITY isReachable]) {
        [YJProgressHUD showError:K_APP_NO_NETWORK_INFO];
        ZWWLog(@"网络连接异常");
        return;
    }
    
    //__block UIView *_view;
    if (isLoading) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            _view = [[AppDelegate shareInstance] window].rootViewController.view;
//            if (_view) {
//                BOOL exists = NO;
//                for (UIView *object in _view.subviews) {
//                    if ([object isMemberOfClass:[MBProgressHUD class]]) {
//                        exists = YES;
//                        break;
//                    }
//                }
//
//                if (!exists) {
//                    [YJProgressHUD showMessage:@"" toView:_view];
//                }
//            }
//            else {
//                [YJProgressHUD showMessage:@""];
//            }
//        });
        [YJProgressHUD showLoading:@"上传中..."];
    }
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:LOGIN_COOKIE forHTTPHeaderField:LOGIN_COOKIE_KEY];
    
    //设置HTTPHeaderField
    if (headerField) {
        headerField(request);
    }
    
    //设置body
    [request setHTTPBody:body];
    
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                 @"text/html",
                                                 @"text/json",
                                                 @"text/javascript",
                                                 @"text/plain",
                                                 nil];
    manager.responseSerializer = responseSerializer;
    
    [[manager uploadTaskWithRequest:request
                           fromData:body
                           progress:^(NSProgress * _Nonnull uploadProgress) {
                               if (progressBack) {
                                   progressBack(uploadProgress);
                               }
                           } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                               ZWWLog(@"请求结果：%@，error:%@",responseObject,error);
                               
                               if (isLoading) {
//                                   dispatch_async(dispatch_get_main_queue(), ^{
//                                       if (_view != nil)
//                                           [YJProgressHUD hideHUDForView:_view];
//                                       else
//                                           [YJProgressHUD hideHUD];
//                                   });
                                   [YJProgressHUD hideHUD];
                               }
                               
                               if (error == nil) {
                                   NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:[responseObject mj_JSONData]
                                                                                            options:NSJSONReadingMutableContainers
                                                                                              error:nil];
                                   
                                   NSInteger resultCode = [[jsonData valueForKey:K_APP_REQUEST_CODE] integerValue];
                                   NSString *strMessage = [jsonData valueForKey:K_APP_REQUEST_MSG];
                                   
                                   //成功
                                   if (kRequestOK(resultCode)) {
                                       if (successBack) {
                                           if ([jsonData.allKeys containsObject:K_APP_REQUEST_DATA]) {
                                               successBack([jsonData valueForKey:K_APP_REQUEST_DATA],strMessage);
                                           }
                                           else{
                                               successBack(jsonData,strMessage);
                                           }
                                       }
                                   }
                                   else{
                                       if (failureBack != nil) {
                                           if (strMessage && ![strMessage isEqualToString:@""]) {
                                               failureBack(strMessage);
                                           }
                                           else{
                                               failureBack([error localizedDescription]);
                                           }
                                       }
                                   }
                               }
                               else {
                                   ZWWLog(@"failureBack:%@",error);
                                   if (failureBack != nil) {
                                       failureBack([error localizedDescription]);
                                       [YJProgressHUD hideHUD];
                                   }
                               }
                           }] resume];
}

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
                AndFailureBack:(void(^_Nullable)(NSString * _Nullable _strError))failureBack WithisLoading:(BOOL)isLoading{
    
    ZWWLog(@"请求地址：%@",strUrl)
    if (![K_APP_REACHABILITY isReachable]) {
        [YJProgressHUD showError:K_APP_NO_NETWORK_INFO];
        ZWWLog(@"网络连接异常");
        return;
    }
    if (isLoading) {
        [YJProgressHUD showLoading:@"上传中..."];
    }
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    [sessionManager.requestSerializer setValue:LOGIN_COOKIE forHTTPHeaderField:LOGIN_COOKIE_KEY];
    
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain", nil];
    sessionManager.responseSerializer = responseSerializer;
    
    //设置HTTPHeaderField
    if (headerField) {
        headerField(sessionManager.requestSerializer);
    }
    
    [sessionManager POST:strUrl
              parameters:nil
constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
    //指定参数
    if (formDataBack) {
        formDataBack(formData);
    }
}
                progress:nil
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     
                     ZWWLog(@"请求结果：%@",responseObject);
                     
                     if (isLoading) {
                         [YJProgressHUD hideHUD];
                     }
                     NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                     NSInteger resultCode = [[jsonData valueForKey:K_APP_REQUEST_CODE] integerValue];
                     NSString *strMessage = [jsonData valueForKey:K_APP_REQUEST_MSG];
                     //成功
                     if (kRequestOK(resultCode)) {
                         if (successBack) {
                             if ([[jsonData allKeys] containsObject:K_APP_REQUEST_DATA]) {
                                 successBack([jsonData valueForKey:K_APP_REQUEST_DATA],strMessage);
                             }
                             else{
                                 successBack(jsonData,strMessage);
                             }
                         }
                     }
                     else{
                         [YJProgressHUD showError:strMessage];
                     }
                 }
                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     if (isLoading) {
                         [YJProgressHUD hideHUD];
                     }
                     if (failureBack != nil) {
                         failureBack([error localizedDescription]);
                     }
                     ZWWLog(@"请求结果：%@",[error localizedDescription]);
                 }];
}
+(void)postFileUploadToServer:(NSString *_Nullable)strUrl
        AndUploadformDataBack:(void(^_Nullable)(id<AFMultipartFormData> _Nullable formData))formDataBack
           AndHTTPHeaderField:(void(^_Nullable)(AFHTTPRequestSerializer * _Nullable _requestSerializer))headerField
               AndSuccessBack:(void(^_Nullable)(NSDictionary * _Nullable _responseData, NSString * _Nullable _strMsg))successBack
               AndFailureBack:(void(^_Nullable)(NSString * _Nullable _strError))failureBack WithisLoading:(BOOL)isLoading{

    ZWWLog(@"请求地址：%@",strUrl)
    if (![K_APP_REACHABILITY isReachable]) {
        [YJProgressHUD showError:K_APP_NO_NETWORK_INFO];
        ZWWLog(@"网络连接异常");
        return;
    }
    if (isLoading) {
        [YJProgressHUD showLoading:@"上传中..."];
    }

    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    [sessionManager.requestSerializer setValue:LOGIN_COOKIE forHTTPHeaderField:LOGIN_COOKIE_KEY];

    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain", nil];
    sessionManager.responseSerializer = responseSerializer;

    //设置HTTPHeaderField
    if (headerField) {
        headerField(sessionManager.requestSerializer);
    }

    [sessionManager POST:strUrl
              parameters:nil
constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
    //指定参数
    if (formDataBack) {
        formDataBack(formData);
    }
}
                progress:nil
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

                     ZWWLog(@"请求结果：%@",responseObject);

                     if (isLoading) {
                         [YJProgressHUD hideHUD];
                     }
                     NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                     NSInteger resultCode = [[jsonData valueForKey:K_APP_REQUEST_CODE] integerValue];
                     NSString *strMessage = [jsonData valueForKey:K_APP_REQUEST_MSG];
                     //成功
                     if (kRequestOK(resultCode)) {
                         if (successBack) {
                             if ([[jsonData allKeys] containsObject:K_APP_REQUEST_DATA]) {
                                 successBack([jsonData valueForKey:K_APP_REQUEST_DATA],strMessage);
                             }
                             else{
                                 successBack(jsonData,strMessage);
                             }
                         }
                     }
                     else{
                         [YJProgressHUD showError:strMessage];
                     }
                 }
                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     if (isLoading) {
                         [YJProgressHUD hideHUD];
                     }
                     if (failureBack != nil) {
                         failureBack([error localizedDescription]);
                     }
                     ZWWLog(@"请求结果：%@",[error localizedDescription]);
                 }];

}

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
                 WithisLoading:(BOOL)isLoading{
    
    ZWWLog(@"请求地址：%@,参数：%@",strUrl,paras);
    
    if (![K_APP_REACHABILITY isReachable]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [YJProgressHUD showError:K_APP_NO_NETWORK_INFO];
        });
        
        ZWWLog(@"网络连接异常");
        return;
    }
    
    //__block UIView *_view;
    if (isLoading) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            _view = [[AppDelegate shareInstance] window].rootViewController.view;
//            if (_view) {
//                [YJProgressHUD showMessage:@"" toView:_view];
//            }
//            else {
//                [YJProgressHUD showMessage:@""];
//            }
//        });
        [YJProgressHUD showLoading:@"loading..."];
    }
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
    [request setHTTPMethod:@"PUT"];
    [request addValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:LOGIN_COOKIE forHTTPHeaderField:LOGIN_COOKIE_KEY];
    [request setHTTPBody:[paras mj_JSONData]];
    
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                 @"text/html",
                                                 @"text/json",
                                                 @"text/javascript",
                                                 @"text/plain",
                                                 nil];
    manager.responseSerializer = responseSerializer;
    
    [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        ZWWLog(@"请求结果：%@",responseObject);
        
        if (isLoading) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (_view != nil)
//                    [YJProgressHUD hideHUDForView:_view];
//                else
//                    [YJProgressHUD hideHUD];
//            });
            [YJProgressHUD hideHUD];
        }
        
        if (error == nil) {
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:[responseObject mj_JSONData]
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:nil];
            
            ZWWLog(@"请求结果2：%@",responseObject);
            NSInteger resultCode = [[jsonData valueForKey:K_APP_REQUEST_CODE] integerValue];
            NSString *strMessage = [jsonData valueForKey:K_APP_REQUEST_MSG];
            
            //成功
            if (kRequestOK(resultCode)) {
                if (successBack) {
                    if ([jsonData.allKeys containsObject:K_APP_REQUEST_DATA]) {
                        successBack([jsonData valueForKey:K_APP_REQUEST_DATA],strMessage);
                    }
                    else{
                        successBack(jsonData,strMessage);
                    }
                }
            }
            else{
                if (failureBack != nil) {
                    if (strMessage && ![strMessage isEqualToString:@""]) {
                        failureBack(strMessage);
                    }
                    else{
                        failureBack([error localizedDescription]);
                    }
                }
            }
        }
        else {
            if (failureBack != nil) {
                failureBack([error localizedDescription]);
            }
        }
    }] resume];
}

//文件下载
+(void)downloadRequestDataForUrl:(NSString *_Nonnull)strUrl
              AndHTTPHeaderField:(void(^_Nullable)(NSMutableURLRequest * _Nullable _request))headerField AndFinishBack:(void(^ _Nullable)(id _Nullable responseData,NSString * _Nullable strMsg))finishBack
                     andProgress:(void(^ _Nullable)(NSProgress * _Nonnull progress))progressBack
                      AndLoaging:(BOOL)isLoading{
    
    ZWWLog(@"请求地址：%@",strUrl);
    
    if (![K_APP_REACHABILITY isReachable]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [YJProgressHUD showError:K_APP_NO_NETWORK_INFO];
        });
        
        ZWWLog(@"网络连接异常");
        return;
    }
    
    //__block UIView *_view;
    if (isLoading) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            _view = [[AppDelegate shareInstance] window].rootViewController.view;
//            if (_view) {
//                [MBProgressHUD showMessage:@"" toView:_view];
//            }
//            else {
//                [MBProgressHUD showMessage:@""];
//            }
//        });
        [YJProgressHUD showLoading:@"下载中..."];
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
    [request addValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:LOGIN_COOKIE forHTTPHeaderField:LOGIN_COOKIE_KEY];
    
    //设置HTTPHeaderField
    if (headerField) {
        headerField(request);
    }
    
    NSString *strFileName = [strUrl lastPathComponent];
    if (![[NSFileManager defaultManager] fileExistsAtPath:K_APP_VIDEO_DOWNLOAD_PATH]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:K_APP_VIDEO_DOWNLOAD_PATH withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *tempPath = [NSString stringWithFormat:@"%@%@", K_APP_VIDEO_DOWNLOAD_PATH,strFileName];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [[manager downloadTaskWithRequest:request
                             progress:^(NSProgress * _Nonnull downloadProgress) {
                                 if (progressBack) {
                                     progressBack(downloadProgress);
                                 }
                             }
                          destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                                return [NSURL fileURLWithPath:tempPath];
                            }
                   completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                       ZWWLog(@"文件下载完成！详见：%@,error:%@",filePath.path,error.localizedDescription);
                       
                       if (finishBack) {
                           finishBack(filePath,error.localizedDescription);
                       }
                       
                       if (isLoading) {
//                           dispatch_async(dispatch_get_main_queue(), ^{
//                               if (_view != nil)
//                                   [MBProgressHUD hideHUDForView:_view];
//                               else
//                                   [MBProgressHUD hideHUD];
//                           });
                           [YJProgressHUD hideHUD];
                       }
                   }] resume];
}


//MARK: - 加载Gif
+ (void)loadGIFImage:(NSString *)imagePath AndFLAnimatedImageView:(FLAnimatedImageView *)gifImgView{
    
    //查询缓存图片
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[[SDWebImageManager sharedManager] imageCache]
         queryImageForKey:imagePath
                  options:0
                  context:nil
              completion:^(UIImage * _Nullable image, NSData * _Nullable data, SDImageCacheType cacheType) {
                  if (data) {
                      [self animatedImageView:gifImgView
                                         data:data];
                  }
                  else{
                      @weakify(self);
                      NSURL *url = [NSURL URLWithString:imagePath];
                      [[SDWebImageDownloader sharedDownloader]
                       downloadImageWithURL:url
                                    options:0
                                   progress:nil
                                  completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                      if (finished) {
                                          
                                          @strongify(self);
                                          [[[SDWebImageManager sharedManager] imageCache] storeImage:image
                                                                                           imageData:data
                                                                                              forKey:imagePath
                                                                                           cacheType:SDImageCacheTypeNone
                                                                                          completion:nil];
                                          
                                          if (data != nil) {
                                              [self animatedImageView:gifImgView data:data];
                                          }
                                      }
                                  }];
                  }
              }];
    });
    
}

+ (void)animatedImageView:(FLAnimatedImageView *)imageView data:(NSData *)data {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        FLAnimatedImage *gifImage = [FLAnimatedImage animatedImageWithGIFData:data];
        imageView.animatedImage   = gifImage;
    });
}


//MARK: - 公共请求方法
/** 加载视频详情数据 */
+(void)loadMoviesDetailsDataWithVId:(NSString * _Nullable)strVId
                        abdCallback:(void(^_Nullable)(id _Nullable responseData,NSString *_Nullable  strMsg))callBackMethod
                       andisLoading:(BOOL)loading{
    
    if (!strVId || [strVId isEqualToString:@""]) {
        ZWWLog(@"参数不存在");
        return;
    }
    
    NSString *strUrl = [NSString stringWithFormat:@"%@Video",K_APP_HOST];
    NSDictionary *dicParams = @{
                                @"id":strVId,
                                @"d":[Utils dy_getIDFV]
                               };
    
    [Utils getRequestForServerData:strUrl
                    withParameters:dicParams AndHTTPHeaderField:^(AFHTTPRequestSerializer * _Nullable _requestSerializer) {
                        [_requestSerializer setValue:LOGIN_COOKIE forHTTPHeaderField:LOGIN_COOKIE_KEY];
                    } AndSuccessBack:^(id  _Nullable _responseData) {
                        ZWWLog(@"视频详情请求成功！详见：%@",_responseData);
                        
                        if (callBackMethod) {
                            callBackMethod(_responseData,@"视频详情数据请求成功");
                        }
                    } AndFailureBack:^(NSString * _Nullable _strError) {
                        ZWWLog(@"视频详情请求失败！详见：%@",_strError);
                        
                        if (callBackMethod) {
                            callBackMethod(nil,_strError);
                        }
                    } WithisLoading:loading];
}

/** 用户推广数据 */
+(void)loadTuiGuangDataWithParams:(NSDictionary * _Nullable)dicParams
                    andFinishBack:(void(^_Nullable)(id _Nullable responseData,NSString *_Nullable  strMsg))finishBack
                       AndisLogin:(BOOL)loading{
    
    NSString *strUrl = [NSString stringWithFormat:@"%@Promotion",K_APP_HOST];
    
    [Utils getRequestForServerData:strUrl
                    withParameters:dicParams
                AndHTTPHeaderField:^(AFHTTPRequestSerializer *_requestSerializer) {
                    [_requestSerializer setValue:LOGIN_COOKIE forHTTPHeaderField:LOGIN_COOKIE_KEY];
                }
                    AndSuccessBack:^(id _responseData) {
                        
                        if (finishBack) {
                            finishBack(_responseData,@"加载成功");
                        }
                    } AndFailureBack:^(NSString *_strError) {
                        ZWWLog(@"推广任务数据,加载异常！详见:%@",_strError);
                        
                        if (finishBack) {
                            finishBack(nil,_strError);
                        }
                    }
                     WithisLoading:loading];
}


+ (void)getInfosModelForUserId:(NSInteger)userId
                    andLoading:(BOOL)loading
                 andFinishback:(void(^_Nullable)(InfosModel  * _Nullable model))finishback {
    
    NSString *strUrl = [NSString stringWithFormat:@"%@User",K_APP_HOST];
    NSDictionary *dicParams = @{
                                @"id":[NSString stringWithFormat:@"%lD",(long)userId]
                                };
    
    [Utils getRequestForServerData:strUrl
                    withParameters:dicParams AndHTTPHeaderField:^(AFHTTPRequestSerializer *_requestSerializer) {
                        [_requestSerializer setValue:LOGIN_COOKIE forHTTPHeaderField:LOGIN_COOKIE_KEY];
                    }
                    AndSuccessBack:^(id _responseData) {
                        if (_responseData) {
                            InfosModel *_model = [InfosModel mj_objectWithKeyValues:_responseData];
                            
                            if (finishback) finishback(_model);
                        }
                        else{
                            if (finishback) finishback(nil);
                        }
                    } AndFailureBack:^(NSString *_strError) {
                        ZWWLog(@"获取用户信息失败!详见:%@",_strError);
                        if (finishback) finishback(nil);
                    } WithisLoading:loading];
}

+(void)collectionUserOrNoWithId:(NSString * _Nonnull)strUserId
                        AndFlow:(BOOL)isFlow
                     AndLoading:(BOOL)loading
                 withFinishback:(void(^_Nullable)(BOOL isSuccess))finishback{
    NSString *strUtl = [NSString stringWithFormat:@"%@Follow",K_APP_HOST];
    
    NSDictionary *dicParams = @{
                                @"userID":strUserId,
                                @"isFollow":isFlow?@"true":@"false"
                                };
    
    [Utils putRequestForServerData:strUtl
                    withParameters:dicParams
                    AndSuccessBack:^(id  _Nullable _responseData, NSString * _Nullable strMsg) {
                        
                        [YJProgressHUD showSuccess:@"操作成功"];
                        if (finishback) {
                            finishback(YES);
                        }
                        
                    } AndFailureBack:^(NSString * _Nullable _strError) {
                        ZWWLog(@"关注、取消关注失败！详见：%@",_strError);
                        [YJProgressHUD showError:_strError];
                        
                        if (finishback) {
                            finishback(NO);
                        }
                    }
                     WithisLoading:loading];
}

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
   withTotalData:(NSMutableArray * _Nullable)totalArray{
    
    //广告展示间隔
    if (interval <= 0) interval = 5;
    
    NSMutableArray *_tempArr = [NSMutableArray array];
    if (listArr)
        _tempArr = [NSMutableArray arrayWithArray:listArr];
    
    if (adData && [adData count] > 0 && _tempArr) {
        for (NSUInteger i = 0,j = interval,len = [adData count]; i < len; i++,j += interval) {
            if ([_tempArr count] <= j)
                [_tempArr addObject:adData[i]];
            else{
                [_tempArr insertObject:adData[i] atIndex:j];
                j++;
            }
        }
    }
    
    if (totalArray)
        [totalArray addObjectsFromArray:[_tempArr copy]];
    else
        totalArray = [NSMutableArray arrayWithArray:_tempArr];
}


+ (void)wxExtensionShareURL:(NSString * _Nonnull)urlStr
                    AndBack:(void(^ _Nullable)(UIActivityViewController * _Nonnull activityVC))shareBack{
    
    NSString *shareText = [NSString stringWithFormat:@"%@邀你来看视频了.",K_APP_NAME];
    NSString *shareTitle = shareText;
    UIImage *shareImage = [UIImage imageNamed:@"AppIcon"];
    NSURL *shareUrl = [NSURL URLWithString:urlStr];
    NSArray *activityItemsArray = @[shareTitle,shareText,shareImage,shareUrl];
    
    UIActivityViewController *_activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItemsArray applicationActivities:nil];
    if (@available(iOS 11.0, *)) {//UIActivityTypeMarkupAsPDF是在iOS 11.0 之后才有的
        _activityViewController.excludedActivityTypes = @[ UIActivityTypeAirDrop,
                                                           UIActivityTypeCopyToPasteboard,
                                                           UIActivityTypeAssignToContact,
                                                           UIActivityTypePrint,
                                                           UIActivityTypeMail,
                                                           UIActivityTypePostToTencentWeibo,
                                                           UIActivityTypeSaveToCameraRoll,
                                                           UIActivityTypeMessage,
                                                           UIActivityTypePostToTwitter,
                                                           UIActivityTypeMarkupAsPDF];
    } else if (@available(iOS 9.0, *)) {//UIActivityTypeOpenInIBooks是在iOS 9.0 之后才有的
        _activityViewController.excludedActivityTypes = @[UIActivityTypeAirDrop,
                                                          UIActivityTypeCopyToPasteboard,
                                                          UIActivityTypeAssignToContact,
                                                          UIActivityTypePrint,
                                                          UIActivityTypeMail,
                                                          UIActivityTypePostToTencentWeibo,
                                                          UIActivityTypeSaveToCameraRoll,
                                                          UIActivityTypeMessage,
                                            UIActivityTypePostToTwitter,UIActivityTypeOpenInIBooks];
    }else {
        //隐藏的类型
        NSArray *excludedActivityTypes =  @[UIActivityTypeAirDrop,
                                            UIActivityTypeCopyToPasteboard,
                                            UIActivityTypeAssignToContact,
                                            UIActivityTypePrint,
                                            UIActivityTypeMail,
                                            UIActivityTypePostToTencentWeibo,
                                            UIActivityTypeSaveToCameraRoll,
                                            UIActivityTypeMessage,
                                            UIActivityTypePostToTwitter];
        _activityViewController.excludedActivityTypes = excludedActivityTypes;
    }
    UIActivityViewControllerCompletionWithItemsHandler myBlock = ^(UIActivityType activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
        ZWWLog(@"===%@",activityType);
        if (completed) {
            ZWWLog(@"分享成功");
            [YJProgressHUD showSuccess:@"分享成功"];
        } else {
            ZWWLog(@"分享失败====%@",activityError);
            [YJProgressHUD showError:@"分享失败"];
        }
        [_activityViewController dismissViewControllerAnimated:YES completion:nil];
    };
    
    _activityViewController.completionWithItemsHandler = myBlock;
    
    if (shareBack) {
        shareBack(_activityViewController);
    }
}

@end
