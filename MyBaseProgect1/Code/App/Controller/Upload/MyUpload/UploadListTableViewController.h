//
//  UploadListTableViewController.h
//  KuaiZhu
//
//  Created by apple on 2019/5/21.
//  Copyright © 2019 su. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyUploadViewController.h"
@class UploadModel;

NS_ASSUME_NONNULL_BEGIN

@protocol UploadListTableViewControllerDelegate<NSObject>

//上传进度
@optional
-(void)uploadListProgress:(double)progressValue andMovieId:(NSInteger)movieId;

@end
/**
 * 上传列表
 */
@interface UploadListTableViewController : UICollectionViewController
@property(nonatomic,copy, nonnull) NSString               *strType;
@property(nonatomic,copy,nullable) NSArray<UploadModel *> *arrListData;

@property(nonatomic,weak,nullable) id<UploadListTableViewControllerDelegate> delegate;
-(instancetype)initWithType:(NSString *)strType;
@property(nonatomic, weak) MyUploadViewController *delegateVC;
@end

NS_ASSUME_NONNULL_END
