//
//  MySheetView.m
//  EnjoyTransport
//
//  Created by 张威威 on 2018/4/26.
//  Copyright © 2018年 com.liangla. All rights reserved.
//

#import "MySheetView.h"
@interface MySheetView()
{
    UIView *whiteView;
    UIView *blackView;
    float whiteY;
}
@end
@implementation MySheetView
-(instancetype)initWithFrame:(CGRect)frame{
    UIWindow *window =  [[UIApplication sharedApplication].delegate window];
    if (self = [super initWithFrame:window.bounds]) {
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}
-(void)show:(UIViewController *)vc{
    UIWindow *window =  [[UIApplication sharedApplication].delegate window];
    NSInteger count = self.buttonNameArray.count;
    CGFloat blackHeight = 55;
    blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,KScreenWidth , KScreenHeight)];
    [self addSubview:blackView];
    //上半部分添加轻触事件，取消显示
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelSelect)];
    [blackView addGestureRecognizer:tap];
    whiteY = blackHeight;
    whiteView = [[UIView alloc]initWithFrame:CGRectMake(0,KScreenHeight, KScreenWidth, 194)];
    whiteView.backgroundColor = [UIColor colorWithHexString:@"#DFDFDF"];
    
    //按钮
    for (int i = 0; i < count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor whiteColor];
        [button setTitleColor:[UIColor colorWithHexString:@"#222222"] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:18];
        [button setTitle:_buttonNameArray[count-1-i] forState:UIControlStateNormal];
        button.frame = CGRectMake(0, whiteView.frame.size.height-64-(i+1)*65, KScreenWidth, 64);
        [button addTarget:self action:@selector(privateAction:) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:button];
    }
    //添加一个取消按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor whiteColor];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    button.frame = CGRectMake(0, whiteView.frame.size.height- 64, KScreenWidth, 64);
    [button addTarget:self action:@selector(cancelSelect) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    [whiteView addSubview:button];
    [window addSubview:self];
}
-(void)layoutSubviews{
    
    UIWindow *window =  [[UIApplication sharedApplication].delegate window];
    CGFloat width = window.frame.size.width;
    CGFloat height = window.frame.size.height;
    [super layoutSubviews];
    self.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.5];
        whiteView.frame=CGRectMake(0,height - 192, width, whiteView.frame.size.height);
        [self addSubview:whiteView];
    } completion:^(BOOL finished) {
    }];
}
-(void)dismiss{
    UIWindow *window =  [[UIApplication sharedApplication].delegate window];
    CGFloat width = window.frame.size.width;
    CGFloat height = window.frame.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        whiteView.frame=CGRectMake(0,height, width, whiteView.frame.size.height);
        self.backgroundColor = [UIColor clearColor];
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
-(void)privateAction:(UIButton *)sender{
    if (self.myBlock) {
        self.myBlock(sender,sender.titleLabel.text);
    }
    [self dismiss];
}

-(void)handleMyBlock:(selectBlock)block{
    self.myBlock = block;
}

-(void)cancelSelect{
    [self dismiss];
}

@end
