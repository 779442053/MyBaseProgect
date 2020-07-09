//
//  MoveDetialShareView.h
//  KuaiZhu
//
//  Created by step_zhang on 2019/11/25.
//  Copyright © 2019 su. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWMoviseDetailsVC.h"
NS_ASSUME_NONNULL_BEGIN

@interface MoveDetialShareView : UIView
- (void)showAlert;
@property (nonatomic,strong)ZWMoviseDetailsVC *vc;
@property (nonatomic, copy) void(^_Nonnull shareTypeBlock)(NSInteger selectType);
@property (nonatomic,strong)UIImageView *CodeImageView;
@property (nonatomic,strong)UILabel *labTitle;

@end

NS_ASSUME_NONNULL_END
