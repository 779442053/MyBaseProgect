//
//  KZMyAdCell.m
//  KZhu
//
//  Created by momo on 2019/9/27.
//  Copyright © 2019 Looker. All rights reserved.
//

#import "KZMyAdCell.h"

@interface KZMyAdCell ()

@property (nonatomic, strong) UIImageView *adImage;

@end

@implementation KZMyAdCell

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
    [self.contentView addSubview:self.adImage];
}

- (void)layoutSubviews
{
    [self.adImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(10);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
}

#pragma mark - Getter

- (UIImageView *)adImage
{
    if (!_adImage) {
        _adImage = [[UIImageView alloc] init];
        [_adImage setImage:KZImage(@"mine_walletAd_icon")];
    }
    return _adImage;
}

@end
