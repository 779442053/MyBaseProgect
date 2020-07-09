//
//  InformationViewController.h
//  KuaiZhu
//
//  Created by apple on 2019/10/5.
//  Copyright © 2019 su. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/**
 * 消息
 */
@interface InformationViewController : BaseViewController
//信息列表
@property(nonatomic,strong) MLMSegmentScroll *segScroll;

//-(void)setBtnSelectStyle:(NSInteger)selectIndex;

+(instancetype)shareInstance;

@end

NS_ASSUME_NONNULL_END
