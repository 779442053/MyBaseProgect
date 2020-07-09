//
//  UploadModel.h
//  KuaiZhu
//
//  Created by apple on 2019/5/22.
//  Copyright © 2019 su. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 * 视频上传模型
 */
@interface UploadModel : NSObject
@property(nonatomic,assign) NSInteger id;
@property(nonatomic,  copy) NSString *cover;
@property(nonatomic,  copy) NSString *title;
@property(nonatomic,assign) NSInteger viewCount;

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) BOOL IsVerticalScreen;
@end

NS_ASSUME_NONNULL_END
