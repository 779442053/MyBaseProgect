//
//  ZWShareManager.m
//  Bracelet
//
//  Created by 张威威 on 2017/11/8.
//  Copyright © 2017年 ShYangMiStepZhang. All rights reserved.
//
/*
 分享配置===在需要分享的地方直接调用即可
 -(void)share{
 [[ShareManager sharedShareManager] showShareView];
 }
 */

#import "ZWShareManager.h"
//#import <UShareUI/UShareUI.h>

@implementation ZWShareManager

+ (instancetype)shareManager{
    static ZWShareManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
-(void)showShareView{
//    //显示分享面板
//    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
//        // 根据获取的platformType确定所选平台进行下一步操作
//        [self shareWebPageToPlatformType:platformType];
//    }];
}

//- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
//{
//    //创建分享消息对象
//    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
//
//    //创建网页内容对象
//
//    //NSString* thumbURL =  @"https://mobile.umeng.com/images/pic/home/social/img-1.png";
//    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"识己-致最懂健身的你" descr:@"欢迎使用【识己】,我们旨在带给您不一样的的健身体验！" thumImage:[UIImage imageNamed:@"ICON"]];
//    //设置网页地址
//    shareObject.webpageUrl = @"https://itunes.apple.com/us/app/%e8%af%86%e5%b7%b1-%e8%87%b4%e6%9c%80%e6%87%82%e9%94%bb%e7%82%bc%e7%9a%84%e4%bd%a0/id1299600823?l=zh&ls=1&mt=8";
//
//    //分享消息对象设置分享内容对象
//    messageObject.shareObject = shareObject;
//
//    //调用分享接口
//    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
//        if (error) {
//            UMSocialLogInfo(@"************Share fail with error %@*********",error);
//        }else{
//            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
//                UMSocialShareResponse *resp = data;
//                //分享结果消息
//                UMSocialLogInfo(@"response message is %@",resp.message);
//                [YJProgressHUD showSuccess:resp.message];
//                //第三方原始返回的数据
//                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
//
//            }else{
//                UMSocialLogInfo(@"response data is %@",data);
//            }
//        }
//        [self alertWithError:error];
//    }];
//}

- (void)alertWithError:(NSError *)error
{
    NSString *result = nil;
    if (!error) {
        result = [NSString stringWithFormat:@"Share succeed"];
    }
    else{
        NSMutableString *str = [NSMutableString string];
        if (error.userInfo) {
            for (NSString *key in error.userInfo) {
                [str appendFormat:@"%@ = %@\n", key, error.userInfo[key]];
            }
        }
        if (error) {
            result = [NSString stringWithFormat:@"Share fail with error code: %d\n%@",(int)error.code, str];
        }
        else{
            result = [NSString stringWithFormat:@"Share fail"];
        }
    }
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"share"
//                                                    message:result
//                                                   delegate:nil
//                                          cancelButtonTitle:NSLocalizedString(@"sure", @"确定")
//                                          otherButtonTitles:nil];
//
//    [alert show];
    //[YJProgressHUD showError:result];
}

@end
