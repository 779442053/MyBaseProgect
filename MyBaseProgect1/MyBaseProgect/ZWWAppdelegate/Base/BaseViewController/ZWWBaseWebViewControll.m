//
//  ZWWBaseWebViewControll.m
//  MyBaseProgect
//
//  Created by 张威威 on 2018/6/14.
//  Copyright © 2018年 张威威. All rights reserved.
//

#import "ZWWBaseWebViewControll.h"

@interface ZWWBaseWebViewControll ()<WKNavigationDelegate>
@property(nonatomic,strong)WKWebView *webView;
@end

@implementation ZWWBaseWebViewControll
-(WKWebView *)webView{
    if (_webView==nil) {
        _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, ZWNavBarHeight, KScreenWidth, KScreenHeight-ZWNavBarHeight)];
        _webView.navigationDelegate = self;
    }
    return _webView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
