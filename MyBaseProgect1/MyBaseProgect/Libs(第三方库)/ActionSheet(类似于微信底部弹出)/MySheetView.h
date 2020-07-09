//
//  MySheetView.h
//  EnjoyTransport
//
//  Created by 张威威 on 2018/4/26.
//  Copyright © 2018年 com.liangla. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^selectBlock)(UIButton *selectButton,NSString *title);
@interface MySheetView : UIView
-(void)show:(UIViewController *)vc;
@property(nonatomic,strong)NSArray *buttonNameArray;
@property(nonatomic,copy)selectBlock myBlock;
-(void)handleMyBlock:(selectBlock)block;
@end
