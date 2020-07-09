//
//  MyUploadViewController.h
//  KuaiZhu
//
//  Created by apple on 2019/5/21.
//  Copyright © 2019 su. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UploadModel;

NS_ASSUME_NONNULL_BEGIN

/**
 * 我的上传
 */
@interface MyUploadViewController : BaseViewController

@property(nonatomic,strong) UploadModel *uploadModel;

@property(nonatomic,strong) UIImage *imgLocalTemp;

//上传
-(void)uploadMovieData:(id)response
        andRealFileUrl:(NSString *)realFileUrl
                andStr:(NSString *)str
         andCoverImage:(UIImage *)coverImage;

//当前选中的索引
@property(nonatomic,assign) NSInteger selectIndex;

@end

NS_ASSUME_NONNULL_END
