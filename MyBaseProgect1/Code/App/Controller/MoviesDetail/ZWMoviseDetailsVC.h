//
//  ZWMoviseDetailsVC.h
//  KuaiZhu
//
//  Created by step_zhang on 2019/11/7.
//  Copyright © 2019 su. All rights reserved.
//

#import "BaseViewController.h"
@class MovieDetailModel;

/**
 * 视频详情操作委托(和 indexPath 一起使用)，逆向传值更新点击的视频列表信息
 */
@protocol MoviesDetailsVCDelegate <NSObject>

@optional
/** 取消(关注)视频发布者 */
-(void)moviesDetailsCollectionUpdateActionForValue:(NSInteger)_cvalue
                                      AndIndexPath:(NSIndexPath *_Nonnull)_indexPath;

@optional
/** 点赞(取消点赞)视频 */
-(void)moviesDetailsHeartUpdateActionForValue:(NSInteger)_cvalue
                                 AndIndexPath:(NSIndexPath *_Nonnull)_indexPath;

@optional
/** 评论视频 */
-(void)moviesDetailsCommentsUpdateActionForValue:(NSInteger)_cvalue
                                    AndIndexPath:(NSIndexPath *_Nonnull)_indexPath;
@end

@interface ZWMoviseDetailsVC : BaseViewController
/** 视频链接 */
@property (nonatomic,copy,nonnull) NSString *movieUrl;

/** 视频id */
@property (nonatomic,assign) NSInteger videoId;

@property (nonatomic, assign) BOOL IsVerticalScreen;

/** 进入当前视图的数据索引 */
@property (nonatomic,strong,nullable) NSIndexPath *indexPath;

@property (nonatomic,strong,nullable) MovieDetailModel *movieModel;

@property (nonatomic, strong) UITableView * _Nullable refreshTableView;    //列表
/** 逆向传值更新视频点击的列表(可选) */
@property (nonatomic, weak, nullable) id<MoviesDetailsVCDelegate> delegate;
@end


