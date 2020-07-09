//
//  KZMyOtherCell.h
//  KZhu
//
//  Created by momo on 2019/9/27.
//  Copyright © 2019 Looker. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KZMyOtherCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imageHeader;
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UIImageView *identImageView;
@property (nonatomic, strong) UIView *contentSubView;

@property (nonatomic, strong) NSIndexPath *indexPath;

@end

NS_ASSUME_NONNULL_END
