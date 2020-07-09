//
//  ZWImageViewController.m
//  KuaiZhu
//
//  Created by step_zhang on 2019/11/1.
//  Copyright © 2019 su. All rights reserved.
//

#import "ZWImageViewController.h"

@interface ZWImageViewController ()

@end

@implementation ZWImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];

    UITapGestureRecognizer *taps = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismisTaps)];

    [self.view addGestureRecognizer:taps];

    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 400)];
    imageV.center = self.view.center;
    imageV.image = [UIImage imageWithData:self.imageData];
    [self.view addSubview:imageV];
}
- (void)dismisTaps{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
