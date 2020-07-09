//
//  UIAlertController+ZWAlert.m
//  共享蜂
//
//  Created by 张威威 on 2017/12/17.
//  Copyright © 2017年 张威威. All rights reserved.
//

#import "UIAlertController+ZWAlert.h"

@implementation UIAlertController (ZWAlert)
+ (UIAlertController *)wh_alertControllerWithTitle:(NSString *)title message:(NSString *)message optionStyle:(OptionStyle)optionStyle OkTitle:(NSString *)okTitle cancelTitle:(NSString *)cancelTitle okBlock:(dispatch_block_t)okBlock cancelBlock:(dispatch_block_t)cancelBlock{
    
    UIAlertController* alert=[UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    if (optionStyle == OptionStyleStyleOnlyOK) {
        UIAlertAction* OK=[UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (okBlock) {
                okBlock();
            }
        }];
        [alert addAction:OK];
    } else {
        UIAlertAction* cancel=[UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (cancelBlock) {
                cancelBlock();
            }
        }];
        UIAlertAction* OK=[UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (okBlock) {
                okBlock();
            }
        }];
        [alert addAction:cancel];
        [alert addAction:OK];
    }
    return alert;
}


+ (UIAlertController *)wh_sheetAlertControllerWithTitle:(NSString *)title message:(NSString *)message optionStyle:(OptionStyle)optionStyle OkTitle:(NSString *)okTitle cancelTitle:(NSString *)cancelTitle okBlock:(dispatch_block_t)okBlock cancelBlock:(dispatch_block_t)cancelBlock {
    
    UIAlertController* alert=[UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    if (optionStyle == OptionStyleStyleOnlyOK) {
        UIAlertAction* OK=[UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (okBlock) {
                okBlock();
            }
        }];
        [alert addAction:OK];
    } else {
        UIAlertAction* cancel=[UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (cancelBlock) {
                cancelBlock();
            }
        }];
        UIAlertAction* OK=[UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (okBlock) {
                okBlock();
            }
        }];
        [alert addAction:cancel];
        [alert addAction:OK];
    }
    return alert;
}
@end
