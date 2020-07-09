//
//  ZWAlterViewControl.h
//  Bracelet
//
//  Created by 张威威 on 2017/10/25.
//  Copyright © 2017年 ShYangMiStepZhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger){
    CANCLEBTN = 0,
    ENTERBTN,
    
}AlertViewBtnIndex;

typedef void(^AlertViewSselectBlock)(AlertViewBtnIndex index);
@interface ZWAlterViewControl : NSObject<UIAlertViewDelegate>

@property (nonatomic, copy) AlertViewSselectBlock block;

- (void)showAlertViewMessage:(NSString *)msg Title:(NSString *)title cancleItem:(NSString *)cancle andOtherItem:(NSString *)other viewController:(UIViewController *)controller onBlock:(void (^)(AlertViewBtnIndex))alertViewBlock;

@end
