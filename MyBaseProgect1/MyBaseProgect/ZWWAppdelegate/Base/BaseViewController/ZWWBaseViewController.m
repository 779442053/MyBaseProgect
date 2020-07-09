//
//  ZWWBaseViewController.m
//  MyBaseProgect
//
//  Created by 张威威 on 2018/5/8.
//  Copyright © 2018年 张威威. All rights reserved.
//创建全屏的基类

#import "ZWWBaseViewController.h"

@interface ZWWBaseViewController ()

@end

@implementation ZWWBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];//主题色
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //通过设置此属性，你可以指定view的边（上、下、左、右）延伸到整个屏幕。

    //automaticallyAdjustsScrollViewInsets  默认是yes
//    automaticallyAdjustsScrollViewInsets就能很好地满足需求，设置些属性值为YES（也是默认值），viewController会table顶部添加inset，所以table会出现在navigation bar的底部
    //extendedLayoutIncludesOpaqueBars
    /*
     extendedLayoutIncludesOpaqueBars是前面两个属性的补充。如果status bar是不透明的，view不会被延伸到status bar，除非extendedLayoutIncludesOpaqueBars = YES;

     如果想要让你的view延伸到navigation bar(edgesForExtendedLayout to UIRectEdgeAll)并且设置此属性为NO(默认)。view就不会延伸到不透明的status bar。

     */
    //适配iOS11
    if (@available(ios 11.0,*)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        UITableView.appearance.estimatedRowHeight = 0;
        UITableView.appearance.estimatedSectionFooterHeight = 0;
        UITableView.appearance.estimatedSectionHeaderHeight = 0;
    }else{
        if([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)])
        {
            self.automaticallyAdjustsScrollViewInsets=NO;
        }
    }
  
}

//点击屏幕任一点.键盘消失=
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
