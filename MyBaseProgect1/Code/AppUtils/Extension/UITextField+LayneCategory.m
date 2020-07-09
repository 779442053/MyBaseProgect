

#import "UITextField+LayneCategory.h"

@implementation UITextField (LayneCategory)

//这句代码要在设置了Placeholder之后调用才会有效
- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    if (@available(iOS 13.0,*)) {
        self.attributedPlaceholder = [Utils setPlaceholderAttributeString:self.placeholder
                                                           withChangeFont:nil
                                                          withChangeColor:placeholderColor isLineThrough:NO];
    }
    else{
        [self setValue:placeholderColor forKeyPath:FieldPlaceholderColorKeyPath];
    }
}

- (void)setLeftSpace:(CGFloat )leftSpace{
  UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, leftSpace, 1)];
  self.leftView = leftView;
  self.leftViewMode = UITextFieldViewModeAlways;
}

- (void)setLeftTitle:(NSString *)leftText{
  [self setLeftTitle:leftText withFont:FONT(14) textColor:[UIColor grayColor]];
}

- (void)setLeftTitle:(NSString *)leftText withFont:(UIFont *)font textColor:(UIColor *)textColor{
  UILabel *leftLabel = [UILabel new];
  leftLabel.text = leftText;
  leftLabel.font = font;
  leftLabel.textColor = textColor;
  [leftLabel sizeToFit];
  self.leftView = leftLabel;
  self.leftViewMode = UITextFieldViewModeAlways;
}

- (void)setRightTitle:(NSString *)rightTitle{
  [self setRightTitle:rightTitle withFont:FONT(14) textColor:[UIColor grayColor]];
}

- (void)setRightTitle:(NSString *)rightText withFont:(UIFont *)font textColor:(UIColor *)textColor{
  ZWWLog(@"%@",rightText);
  UILabel *rightLabel = [UILabel new];
  rightLabel.text = rightText;
  rightLabel.font = font;
  rightLabel.textColor = textColor;
  [rightLabel sizeToFit];
  self.rightView = rightLabel;
  self.rightViewMode = UITextFieldViewModeAlways;
}

- (void)setDefaultBottomLine{
  [self setBottomLineWithColor:hsb(192, 2, 95) height:1.0];
}

- (void)setBottomLineWithColor:(UIColor *)lineColor height:(CGFloat)height{
  UIView *line = [UIView new];
  [self addSubview:line];
  line.backgroundColor = lineColor;
  [line mas_makeConstraints:^(MASConstraintMaker *make) {
    make.bottom.mas_equalTo(0);
    make.right.left.mas_equalTo(0);
    make.height.mas_equalTo(height);
  }];
}

- (void)setLeftIcon:(NSString *)iconName iamgeSize:(CGSize )imageSize leftViewMode:(UITextFieldViewMode )viewModel{
  UIImageView *leftIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, imageSize.width, imageSize.height)];
  leftIcon.image = ims(iconName);
  leftIcon.contentMode = UIViewContentModeScaleAspectFit;
  self.leftView = leftIcon;
  self.leftViewMode = viewModel;
}



@end
