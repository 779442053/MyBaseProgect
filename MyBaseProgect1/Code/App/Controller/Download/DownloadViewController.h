//
//  DownloadViewController.h
//  KuaiZhu
//
//  Created by apple on 2019/5/21.
//  Copyright © 2019 su. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MovieDetailModel;

NS_ASSUME_NONNULL_BEGIN

@protocol DownloadTableViewControllerDelegate<NSObject>

//下载进度
@optional
-(void)downloadListProgress:(double)progressValue andMovieId:(NSInteger)movieId;

@end

/**
 * 我的下载
 */
@interface DownloadViewController : BaseViewController

//信息列表
@property(nonatomic,strong) MLMSegmentScroll *segScroll;

@property (nonatomic,strong) MovieDetailModel *movieModel;
@property (nonatomic,  weak) id<DownloadTableViewControllerDelegate> delegate;

-(void)downloadMovie;

@end

NS_ASSUME_NONNULL_END
