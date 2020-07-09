//
//  MineHeaderView.h
//  快猪
//
//  Created by 魏冰杰 on 2019/1/11.
//  Copyright © 2019年 时磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfosModel.h"

@protocol MineHeaderViewDelegate <NSObject>

@optional
- (void)clickModulesBtnEventWithTag:(NSInteger)tag;

- (void)clickLoginEvent;

- (void)jumpUserInfoVc;

- (void)joinCertification;

@end

@interface MineHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *accountIcon;
@property (weak, nonatomic) IBOutlet UILabel *userNameLable;
@property (weak, nonatomic) IBOutlet UILabel *worksLable;
@property (weak, nonatomic) IBOutlet UILabel *forceLable;
@property (weak, nonatomic) IBOutlet UILabel *fansLable;
@property (weak, nonatomic) IBOutlet UILabel *likeLable;
@property (weak, nonatomic) IBOutlet UIButton *approveBtn;
@property (weak, nonatomic) IBOutlet UIButton *LoginBtn;
@property (weak, nonatomic) IBOutlet UILabel *loginLable;

+ (instancetype)createMineHeaderViewInit;

@property (nonatomic, weak) id <MineHeaderViewDelegate> delegate;

- (void)refreshUIWithModel:(InfosModel *)model;

@end
