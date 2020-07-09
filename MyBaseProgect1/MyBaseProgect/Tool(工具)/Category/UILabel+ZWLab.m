//
//  UILabel+ZWLab.m
//  共享蜂
//
//  Created by 张威威 on 2017/12/17.
//  Copyright © 2017年 张威威. All rights reserved.
//

#import "UILabel+ZWLab.h"
#import <CoreText/CoreText.h>
@implementation UILabel (ZWLab)

+(instancetype)wh_labelWithText:(NSString *)text textFont:(int)font textColor:(UIColor *)color frame:(CGRect)frame{
    UILabel *label = [UILabel new];
    label.text = text;
    label.font = [UIFont systemFontOfSize:font];
    label.textColor = color;
    label.textAlignment=YES;
    label.frame=frame;
    return label;
}

- (void)setColumnSpace:(CGFloat)columnSpace
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    //调整间距
    [attributedString addAttribute:(__bridge NSString *)kCTKernAttributeName value:@(columnSpace) range:NSMakeRange(0, [attributedString length])];
    self.attributedText = attributedString;
}

- (void)setRowSpace:(CGFloat)rowSpace
{
    self.numberOfLines = 0;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    //调整行距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = rowSpace;
    paragraphStyle.baseWritingDirection = NSWritingDirectionLeftToRight;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.text length])];
    self.attributedText = attributedString;
}
-(void) setText:(NSString *)text Font:(UIFont *)font withColor:(UIColor *)color Range:(NSRange)range
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
    [str addAttribute:NSForegroundColorAttributeName value:color range:range];
    [str addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, text.length)];
    self.attributedText = str;
}

-(void) setText:(NSString *)text Font:(UIFont *)font withColor:(UIColor *)color Range:(NSRange)range withColor:(UIColor *)color1 Range:(NSRange)range1
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
    [str addAttribute:NSForegroundColorAttributeName value:color range:range];
    [str addAttribute:NSForegroundColorAttributeName value:color1 range:range1];
    [str addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, text.length)];
    self.attributedText = str;
}
@end
