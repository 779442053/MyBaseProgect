//
//  UserVipVC.h
//  KuaiZhu
//
//  Created by step_zhang on 2019/11/20.
//  Copyright © 2019 su. All rights reserved.
//

#import "BaseViewController.h"
@class InfosModel;
NS_ASSUME_NONNULL_BEGIN

@interface UserVipVC : BaseViewController
@property (nonatomic, strong) NSString   * _Nonnull userId;
@property (nonatomic, strong) NSString   * _Nonnull userName;
@property (nonatomic, strong) InfosModel * _Nullable infoModel;
@end

NS_ASSUME_NONNULL_END
