//
//  UIDevice+Screen.h
//  QuanPaiPai
//
//  Created by XianXin on 2018/12/14.
//  Copyright © 2018 XianXin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (Screen)

/**!
 * 判断是否为iPhoneX(375 x 812)、iPhone XR(414 x 896)、iPhone XS(375 x 812)、iPhone XS Max(414 x 896)
 * 用法：UIDevice.current.isiPhoneX()
 * 参考：https://mobile.zcool.com.cn/article/ZNzc2OTI4.html?from=timeline&isappinstalled=0
 */
-(BOOL)isiPhoneX;

/**!
 * 判断是否为 iPhoneSE、iPhone5、5s、5c(或4英寸 设备)
 * 4英寸设备分辨率：640*1136
 */
-(BOOL)isiPhoneSE;

/**!
 * 判断是否为 iPhone4、4s(或3.5英寸 设备)
 * 3.5英寸设备分辨率：640 * 960
 */
-(BOOL)isiPhone4;

/**!
 * 是否为小尺寸的设备(指屏幕尺寸为4英寸及其以下的设备)
 * 4'   640 * 1136 设备：iPhoneSE、iPhone5、iPhone5c、iPhone5s
 * 3.5' 640 * 960 设备：iPhone4s、iPhone4、iPhone3GS、iPhone3G
 */
-(BOOL)isSmallDevice;
@end

NS_ASSUME_NONNULL_END
