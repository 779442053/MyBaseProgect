//
//  ZWUserHistoryListVC.h
//  KuaiZhu
//
//  Created by step_zhang on 2019/11/21.
//  Copyright © 2019 su. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyUserCollectionVC.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZWUserHistoryListVC : UITableViewController
@property(nonatomic,copy,nonnull) NSString *typeName;
@property(nonatomic, weak) MyUserCollectionVC *delegateVC;
@end

NS_ASSUME_NONNULL_END
