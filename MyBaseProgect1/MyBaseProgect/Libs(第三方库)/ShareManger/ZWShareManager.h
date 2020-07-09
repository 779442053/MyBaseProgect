//
//  ZWShareManager.h
//  Bracelet
//
//  Created by 张威威 on 2017/11/8.
//  Copyright © 2017年 ShYangMiStepZhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZWShareManager : NSObject
/**
 *  @author 张威威
 *
 *  单例管理
 */
+ (instancetype)shareManager;
/**
 展示分享页面
 */
-(void)showShareView;
@end
