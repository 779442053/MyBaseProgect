//
//  POP动画库研究.h
//  MyBaseProgect
//
//  Created by 张威威 on 2018/5/14.
//  Copyright © 2018年 张威威. All rights reserved.
//

/*
 动画相关的部分都是基于Core Animation
 POPBasicAnimation
 POPSpringAnimation
 POPDecayAnimation
 POPCustomAnimation //自定义动画
 1.
 POPBasicAnimation *anBasic = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionX];
 anBasic.toValue = @(self.square.center.y+300);
 anBasic.beginTime = CACurrentMediaTime() + 1.0f;
 [self.square pop_addAnimation:anBasic forKey:@"position"];
 定义一个animation对象，并指定对应的动画属性
 设置初始值和默认值(初始值可以不指定，会默认从当前值开始)
 添加到想产生动画的对象上
 
 POPBasicAnimation提供四种timingfunction
 kCAMediaTimingFunctionLinear
 kCAMediaTimingFunctionEaseIn
 kCAMediaTimingFunctionEaseOut
 kCAMediaTimingFunctionEaseInEaseOut
 
 POPSpringAnimation   类似于弹簧的动画....使用最常见!  POPSpringAnimation是没有duration字段的
 POPSpringAnimation *anSpring = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
 anSpring.toValue = @(self.square.center.y+300);
 anSpring.beginTime = CACurrentMediaTime() + 1.0f;
 anSpring.springBounciness = 10.0f;
 [self.square pop_addAnimation:anSpring forKey:@"position"];
 
 springBounciness:4.0    //[0-20] 弹力 越大则震动幅度越大
 springSpeed     :12.0   //[0-20] 速度 越大则动画结束越快
 dynamicsTension :0      //拉力  接下来这三个都跟物理力学模拟相关 数值调整起来也很费时 没事不建议使用哈
 dynamicsFriction:0      //摩擦 同上
 dynamicsMass    :0      //质量 同上
 
 
 POPDecayAnimation提供一个过阻尼效果(其实Spring是一种欠阻尼效果)，可以实现类似UIScrollView的滑动衰减效果(是的 你可以靠它来自己实现一个UIScrollView)
 POPDecayAnimation也是没有duration字段的，其动画持续时间由velocity与deceleration决定
 
 
 POPDecayAnimation *anDecay = [POPDecayAnimation animationWithPropertyNamed:kPOPLayerPositionX];
 anDecay.velocity = @(600);
 anDecay.beginTime = CACurrentMediaTime() + 1.0f;
 [self.square pop_addAnimation:anDecay forKey:@"position"];
 deceleration:0.998  //衰减系数(越小则衰减得越快)
 
 
 
 */
