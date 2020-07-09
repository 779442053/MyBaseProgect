//
//  UIColor+Custom.m
//  QuanPaiPai
//
//  Created by XianXin on 2018/12/14.
//  Copyright © 2018 XianXin. All rights reserved.
//

#import "UIColor+Custom.h"

@implementation UIColor (Custom)

/**
 * 获取颜色
 * @parameter hex:十六进制 0xffffff
 * @return UIColor
 */
-(UIColor *)colorFromHexInt:(NSInteger)hex AndAlpha:(CGFloat)alpha{
    return [UIColor colorWithRed:((hex & 0xFF0000) >> 16) / 255.f
                           green:((hex & 0xFF00) >> 8) / 255.f
                            blue:(hex & 0xFF) / 255.f
                           alpha:alpha];
}

/**
 * 获取颜色
 * @para r CGFloat
 * @para g CGFloat
 * @para b CGFloat
 *
 * @return UIColor
 */
-(UIColor *)colorFromHexRGB:(CGFloat)r AndGreen:(CGFloat)g AndBlue:(CGFloat)b WithAlpha:(CGFloat)alpha{
    return [UIColor colorWithRed:r / 255.f
                           green:g / 255.f
                            blue:b / 255.f
                           alpha:alpha];
}

+ (instancetype)colorWithHexString:(NSString *)hexStr {
    CGFloat r, g, b, a;
    if (hexStrToRGBA(hexStr, &r, &g, &b, &a)) {
        return [UIColor colorWithRed:r green:g blue:b alpha:a];
    }
    return nil;
}


//MARK: - 
static inline NSUInteger hexStrToInt(NSString *str) {
    uint32_t result = 0;
    sscanf([str UTF8String], "%X", &result);
    return result;
}

static BOOL hexStrToRGBA(NSString *str,
                         CGFloat *r, CGFloat *g, CGFloat *b, CGFloat *a) {
    //str = [[str stringByTrim] uppercaseString];
    str = [[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([str hasPrefix:@"#"]) {
        str = [str substringFromIndex:1];
    } else if ([str hasPrefix:@"0X"]) {
        str = [str substringFromIndex:2];
    }
    
    NSUInteger length = [str length];
    //         RGB            RGBA          RRGGBB        RRGGBBAA
    if (length != 3 && length != 4 && length != 6 && length != 8) {
        return NO;
    }
    
    //RGB,RGBA,RRGGBB,RRGGBBAA
    if (length < 5) {
        *r = hexStrToInt([str substringWithRange:NSMakeRange(0, 1)]) / 255.0f;
        *g = hexStrToInt([str substringWithRange:NSMakeRange(1, 1)]) / 255.0f;
        *b = hexStrToInt([str substringWithRange:NSMakeRange(2, 1)]) / 255.0f;
        if (length == 4)  *a = hexStrToInt([str substringWithRange:NSMakeRange(3, 1)]) / 255.0f;
        else *a = 1;
    } else {
        *r = hexStrToInt([str substringWithRange:NSMakeRange(0, 2)]) / 255.0f;
        *g = hexStrToInt([str substringWithRange:NSMakeRange(2, 2)]) / 255.0f;
        *b = hexStrToInt([str substringWithRange:NSMakeRange(4, 2)]) / 255.0f;
        if (length == 8) *a = hexStrToInt([str substringWithRange:NSMakeRange(6, 2)]) / 255.0f;
        else *a = 1;
    }
    return YES;
}

@end
