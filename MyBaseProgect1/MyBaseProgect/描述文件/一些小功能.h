//
//  一些小功能.h
//  MyBaseProgect
//
//  Created by 张威威 on 2018/5/8.
//  Copyright © 2018年 张威威. All rights reserved.
//

 /*
  =====截屏分享
  #import "UIView+snapshot.h"
  
  @implementation UIView (UIView_Snapshot)
  
  -(UIImage*)snapshot:(UIView *)shotView {
  UIGraphicsBeginImageContext(shotView.bounds.size);
  UIGraphicsBeginImageContextWithOptions(shotView.bounds.size, NO, [[UIScreen mainScreen] scale]);
  CGContextRef context = UIGraphicsGetCurrentContext();
  [self.layer renderInContext:context];
  UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return screenShot;
  }
  @end
  
  链接：http://www.jianshu.com/p/54ffa243dfdc
  
  
  
  
  开或关 闪光灯
  + (void)changeFlash {
  
  //  获取摄像机单例对象
  AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
  //必须判定是否有闪光灯，否则如果没有闪光灯会崩溃
  if (![device hasFlash]) return;
  
  //修改前必须先锁定
  [device lockForConfiguration:nil];
  
  if (device.flashMode == AVCaptureFlashModeOff) {
  device.flashMode = AVCaptureFlashModeOn;
  device.torchMode = AVCaptureTorchModeOn;
  } else if (device.flashMode == AVCaptureFlashModeOn) {
  device.flashMode = AVCaptureFlashModeOff;
  device.torchMode = AVCaptureTorchModeOff;
  }
  
  [device unlockForConfiguration];
  }
  
  关灯 用于退出时调用
  + (void)closeFlash {
  
  AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
  
  if (![device hasFlash]) return;
  
  if (device.flashMode == AVCaptureFlashModeOn) {
  
  device.flashMode = AVCaptureFlashModeOff;
  device.torchMode = AVCaptureTorchModeOff;
  }
  }
=========类似于支付宝的底部cell的展示
  UILabel *botmView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
  botmView.textAlignment = NSTextAlignmentCenter;
  botmView.text = @"---------我是有底线的---------";
  self.Mytabview.tableFooterView = botmView;
  
  ///类似于QQ弹出菜单视图
  [QQPopMenuView showWithItems:@[@{@"title":@"发起讨论",@"imageName":@"popMenu_createChat"},
  @{@"title":@"扫描名片",@"imageName":@"popMenu_scanCard"},
  @{@"title":@"写日报",@"imageName":@"popMenu_writeReport"},
  @{@"title":@"外勤签到",@"imageName":@"popMenu_signIn"}]
  width:130
  triangleLocation:CGPointMake([UIScreen mainScreen].bounds.size.width-30, 64+5)
  action:^(NSInteger index) {
  NSLog(@"点击了第%ld行",index);
  }];
  
  //分享
  直接调用即可
   [[ZWShareManager shareManager] showShareView];
  
  
  
  // 将字典转为模型
  Person *p = [Person mj_objectWithKeyValues:dict2];
  // 将 plist数据转成模型数组
  NSArrar *models =  [Person mj_objectArrayWithFile:@"xx.plist"];
  // 将字典数组转成模型数组, 最常用
  NSArrar *models =  [Person mj_objectArrayWithKeyValuesArray:dict]
  
  
  统一使用该方法初始化，子类中直接声明对于的'readonly' 的 'viewModel'属性，
  并在@implementation内部加上关键词 '@dynamic viewModel;'
  @dynamic A相当于告诉编译器：“参数A的getter和setter方法并不在此处，
  而在其他地方实现了或者生成了，当你程序运行的时候你就知道了，
  所以别警告我了”这样程序在运行的时候，
  对应参数的getter和setter方法就会在其他地方去寻找，比如父类。
  
  
  综上可以知道：
  1、alloc和allocWithZone都可以用于创建实例（其实是用于创建实例的时候分配内存空间）
  2、alloc会默认调用allocWithZone方法
  3、如果不重写allocWithZone方法，在调用alloc和allocWithZone方法产生的实例可能不是同一个实例，单例未真正实现
   ===========================获取图片,重新绘制图片=============================
  在实际开发中,可能会遇到从手机相册中选择图片的需求,选择图片这个过程是一个消耗性能的过程,取决于手机图片的大小,如果手机像素非常高,图片的尺寸非常大,这个时候就会变得很消耗性能;
  以上两种方法虽然都可能达到压缩图片的需求,但是可能会照成图片的失真;
  下面提供另一种方法:根据图片从新绘制一张出来,不会失真,只是改变图片大小,比如之前是50005000的分辨率,这个时候你压缩后可能就只有500500,不会失真,只会改变大小,建议使用
  
  - (UIimage *)imageWithImage:(UIImage*)image
  scaledToSize:(CGSize)newSize;
  {
  UIGraphicsBeginImageContext(newSize);
  [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
  UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return newImage;
  }
  
  
  iOS开发解决页面滑动返回跟scrollView左右划冲突
  
  -(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
  {
  // 首先判断otherGestureRecognizer是不是系统pop手势
  if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
  // 再判断系统手势的state是began还是fail，同时判断scrollView的位置是不是正好在最左边
  if (otherGestureRecognizer.state == UIGestureRecognizerStateBegan && self.contentOffset.x == 0) {
  return YES;
  }
  }
  return NO;
  }
  
  
  
  =====在某一个界面进制使用返回手势====
  https://blog.csdn.net/j362367731/article/details/51167681
  
 

  
  
  */
