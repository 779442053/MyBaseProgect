//
//  ZWLoading.h
//  Bracelet
//
//  Created by 张威威 on 2017/9/28.
//  Copyright © 2017年 ShYangMiStepZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZWLoading : UIView

/** loading信息 */
@property (nonatomic, copy) NSString *loadingInfo;

/** loading图单例 */
+ (instancetype)sharedInstance;
@end
