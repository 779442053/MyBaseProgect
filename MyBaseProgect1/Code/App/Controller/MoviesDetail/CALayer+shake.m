//
//  CALayer+shake.m
//  KuaiZhu
//
//  Created by step_zhang on 2019/11/7.
//  Copyright © 2019 su. All rights reserved.
//

#import "CALayer+shake.h"

@implementation CALayer (shake)
-(void)shake{
//    CGPoint position = self.position;
//    CGPoint x = CGPointMake(position.x + 1, position.y);
//    CGPoint y = CGPointMake(position.x - 1, position.y);
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
//    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
//    [animation setFromValue:[NSValue valueWithCGPoint:x]];
//    [animation setToValue:[NSValue valueWithCGPoint:y]];
//    [animation setAutoreverses:YES];
//    [animation setDuration:.06];
//    [animation setRepeatCount:3];
//    [self addAnimation:animation forKey:nil];

    CAKeyframeAnimation *shakeAnim = [CAKeyframeAnimation animation];
    shakeAnim.keyPath = @"transform.translation.x";
    shakeAnim.duration = 0.15;
    CGFloat delta = 10;
    shakeAnim.values = @[@(0) , @(-delta), @(delta), @(0)];
    shakeAnim.repeatCount = 2;
    [self addAnimation:shakeAnim forKey:nil];
}
@end
