//
//  MainListCollectionViewController.h
//  KuaiZhu
//
//  Created by Ghy on 2019/5/10.
//  Copyright © 2019年 su. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
@class Advertisements;

/** 首页列表 */
@interface MainListCollectionViewController : UICollectionViewController

/** 自定义有参构造 */
-(instancetype)initWithType:(NSString *)strType;
@property(nonatomic, weak) MainViewController *delegateVC;
@end
