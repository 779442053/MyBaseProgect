//
//  FansTableViewController.h
//  KuaiZhu
//
//  Created by apple on 2019/5/27.
//  Copyright © 2019 su. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FansViewController.h"
NS_ASSUME_NONNULL_BEGIN
/**
 * 粉丝列表
 */
@interface FansTableViewController : UITableViewController

@property(nonatomic,  copy, nonnull) NSString  *strType;
@property(nonatomic, weak) FansViewController *delegateVC;
@end

NS_ASSUME_NONNULL_END
