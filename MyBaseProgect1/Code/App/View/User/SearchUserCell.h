//
//  SearchUserCell.h
//  KuaiZhu
//
//  Created by step_zhang on 2019/11/12.
//  Copyright © 2019 su. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FansModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SearchUserCell : UITableViewCell
@property(nonatomic,strong) RACSubject *Subject;
@property(nonatomic,strong)FansData *FansModel;
@end

NS_ASSUME_NONNULL_END
