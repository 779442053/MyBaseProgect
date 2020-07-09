//
//  ZWAlterViewControl.m
//  Bracelet
//
//  Created by 张威威 on 2017/10/25.
//  Copyright © 2017年 ShYangMiStepZhang. All rights reserved.
//

#import "ZWAlterViewControl.h"
//判断手机系统
#define iOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define iOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
@interface ZWAlterViewControl()
{
    AlertViewSselectBlock _alertViewBlock;
}
@end
@implementation ZWAlterViewControl

- (void)showAlertViewMessage:(NSString *)msg Title:(NSString *)title cancleItem:(NSString *)cancle andOtherItem:(NSString *)other viewController:(UIViewController *)controller onBlock:(void (^)(AlertViewBtnIndex))alertViewBlock{
    if (iOS8) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
        if (cancle != nil) {
            [alert addAction:[UIAlertAction actionWithTitle:cancle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                alertViewBlock(CANCLEBTN);
            }]];
        }
        if (other != nil) {
            [alert addAction:[UIAlertAction actionWithTitle:other style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                alertViewBlock(ENTERBTN);
                
            }]];
        }
        
        
        [controller presentViewController:alert animated:YES completion:nil];
        
    }
    
}


@end
