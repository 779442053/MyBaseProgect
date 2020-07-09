//
//  MyUserCollectionListVC.h
//  KuaiZhu
//
//  Created by step_zhang on 2019/11/21.
//  Copyright © 2019 su. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyUserCollectionVC.h"
NS_ASSUME_NONNULL_BEGIN

@interface MyUserCollectionListVC : UICollectionViewController
-(instancetype)initWithType:(NSString *)strType;
@property(nonatomic, weak) MyUserCollectionVC *delegateVC;
@end

NS_ASSUME_NONNULL_END
