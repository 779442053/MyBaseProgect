//
//  CollectionListViewController.h
//  KuaiZhu
//
//  Created by apple on 2019/10/5.
//  Copyright © 2019 su. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/**
 * 关注(收藏)列表
 */
@interface CollectionListViewController : UICollectionViewController

/** 自定义有参构造 */
-(instancetype)initWithType:(NSString *)strType;

@end

NS_ASSUME_NONNULL_END
