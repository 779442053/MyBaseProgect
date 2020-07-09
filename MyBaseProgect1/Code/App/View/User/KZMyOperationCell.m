
//
//  KZMyOperationCell.m
//  KZhu
//
//  Created by momo on 2019/9/27.
//  Copyright © 2019 Looker. All rights reserved.
//

#import "KZMyOperationCell.h"

@interface KZMyOperationCell ()

@property (nonatomic, strong) UIView *operationView;

@end

@implementation KZMyOperationCell

#define Start_X          26.0f      // 第一个View的X坐标
#define Start_Y          16.0f     // 第一个View的Y坐标
#define View_Height   43    // 高
#define View_Width     43   // 宽

#pragma mark - Init

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = RGBCOLOR(218, 227, 255);
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    
    [self.contentView addSubview:self.operationView];
    
    NSArray *imageArr = @[
        @"myComment",
        @"mycollection",
        @"heart-on",
        @"browse"
    ];
    
    NSArray *titleArr = @[@"我的评论",@"我的关注",@"我的喜欢",@"我的历史"];
    
    CGFloat Width_Space = (self.operationView.width - 2*Start_X - 4*View_Width)/3;
    
    NSInteger count = imageArr.count;
    
    for (int i = 0; i < count; i++) {
        
        NSInteger index = i % count;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        [btn addTarget:self action:@selector(btnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        
        btn.frame = CGRectMake(index * (View_Width + Width_Space) +Start_X,  Start_Y, View_Width, View_Height);
        [btn setImage:KZImage(imageArr[i]) forState:UIControlStateNormal];
        [self.operationView addSubview:btn];
        
        UILabel *btnDesc = [[UILabel alloc] init];
        btnDesc.font = FONT(13);
        btnDesc.text = titleArr[i];
        btnDesc.textColor = K_APP_TINT_COLOR;
        btnDesc.textAlignment = NSTextAlignmentCenter;
        [self.operationView addSubview:btnDesc];
        
        [btnDesc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(btn.mas_centerX);
            make.top.mas_equalTo(btn.mas_bottom).offset(10);
        }];
    }
}

-(void)btnClickAction:(UIButton *)sender{
    if (self.cellClickBlock) {
        self.cellClickBlock(sender.tag);
    }
}

#pragma mark - Getter

- (UIView *)operationView
{
    if (!_operationView) {
        
        CGRect rect = CGRectMake(15, 15, K_APP_WIDTH - 15*2, 92);
        _operationView = [[UIView alloc] initWithFrame:rect];
        [_operationView setBackgroundColor:[UIColor whiteColor]];
        _operationView.layer.masksToBounds = YES;//是否裁剪
        _operationView.layer.cornerRadius = 13;//剪切半径
        
        //添加阴影
        _operationView.layer.shadowColor = RGBCOLOR(39, 30, 29).CGColor;
        _operationView.layer.shadowOffset = CGSizeZero;//投影偏移
        _operationView.layer.shadowRadius = 4;//大小为8px
    }
    return _operationView;
}
@end
