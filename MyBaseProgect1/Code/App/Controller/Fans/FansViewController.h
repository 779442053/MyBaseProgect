//
//  FansViewController.h
//  KuaiZhu
//
//  Created by apple on 2019/5/27.
//  Copyright © 2019 su. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** Ta的粉丝、关注 */
@interface FansViewController : BaseViewController

-(instancetype)initWithUser:(NSString *)strUser AndTitle:(NSString *)strTitle;
-(void)updateControllerWithUser:(NSString *)strUser AndTitle:(NSString *)strTitle;

-(NSString *)getUserId;

+(instancetype)shareInstance;
//当前选中的索引
@property(nonatomic,assign) NSInteger selectIndex;
@end

NS_ASSUME_NONNULL_END
