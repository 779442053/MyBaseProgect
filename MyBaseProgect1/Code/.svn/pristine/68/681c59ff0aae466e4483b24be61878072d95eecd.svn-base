//
//  KZMyOtherCell.m
//  KZhu
//
//  Created by momo on 2019/9/27.
//  Copyright © 2019 Looker. All rights reserved.
//

#import "KZMyOtherCell.h"

@interface KZMyOtherCell ()

@property (nonatomic, strong) UIView *lineView;

@end

@implementation KZMyOtherCell

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
    [self.contentView addSubview:self.contentSubView];
    [self.contentSubView addSubview:self.imageHeader];
    [self.contentSubView addSubview:self.titleLable];
    [self.contentSubView addSubview:self.identImageView];
    [self.contentSubView addSubview:self.lineView];
}

- (void)layoutSubviews
{

    [super layoutSubviews];
    
    [self.imageHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentSubView.mas_left).offset(22);
        make.centerY.mas_equalTo(self.contentSubView.mas_centerY);
    }];
    
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageHeader.mas_right).offset(15);
        make.centerY.mas_equalTo(self.contentSubView.mas_centerY);
        make.height.mas_equalTo(30);
    }];
    
    [self.identImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentSubView.mas_right).offset(-18);
        make.centerY.mas_equalTo(self.contentSubView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(14, 16));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageHeader.mas_left);
        make.right.mas_equalTo(self.identImageView.mas_right);
        make.bottom.mas_equalTo(self.contentSubView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
        
}

/// 绘制圆角
- (void)drawCorners:(UIRectCorner)rect
{
    //绘制圆角 要设置的圆角 使用“|”来组合
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.contentSubView.bounds byRoundingCorners:rect cornerRadii:CGSizeMake(13, 13)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    //设置大小
    maskLayer.frame = self.contentSubView.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    self.contentSubView.layer.mask = maskLayer;
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    
    UIRectCorner rect;
    switch (_indexPath.row) {
        case 0:
        {
            rect = UIRectCornerTopLeft | UIRectCornerTopRight;
            [self drawCorners:rect];
            self.lineView.hidden = NO;
        }
            break;
        case 4:
        {
            rect = UIRectCornerBottomLeft | UIRectCornerBottomRight;
            [self drawCorners:rect];
            self.lineView.hidden = YES;
        }
            break;
        default:
            self.lineView.hidden = NO;
            break;
    }

}

#pragma mark - Getter

- (UIView *)contentSubView
{
    if (!_contentSubView) {
        _contentSubView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, K_APP_WIDTH - 2*15, 50)];
        [_contentSubView setBackgroundColor:[UIColor whiteColor]];
    }
    return _contentSubView;
}

- (UIImageView *)imageHeader
{
    if (!_imageHeader) {
        _imageHeader = [[UIImageView alloc] init];
        [_imageHeader setContentMode:UIViewContentModeScaleAspectFill];
    }
    return _imageHeader;
}

- (UILabel *)titleLable
{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] init];
        _titleLable.font = [UIFont boldSystemFontOfSize:15];
        
    }
    return _titleLable;
}

- (UIImageView *)identImageView
{
    if (!_identImageView) {
        _identImageView = [[UIImageView alloc] init];
        [_identImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_identImageView setImage:KZImage(@"right_arrow")];
    }
    return _identImageView;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        [_lineView setBackgroundColor:RGBCOLOR(206, 218, 249)];
    }
    return _lineView;
}


@end
