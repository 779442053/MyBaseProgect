//
//  AdvertisementsModel.h
//  KuaiZhu
//
//  Created by apple on 2019/6/4.
//  Copyright © 2019 su. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * 广告模型
 */
@interface Advertisements : NSObject

@property (nonatomic, assign) NSInteger advId;

@property (nonatomic,   copy) NSString *title;

@property (nonatomic,   copy) NSString *cover;

@property (nonatomic,   copy) NSString *url;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat ItemWidth;
@property (nonatomic, assign) CGFloat ItemHeight;
@end

//MARK: - Advs
@interface Advs : NSObject

@property (nonatomic, assign) NSInteger advId;

@property (nonatomic,   copy) NSString *title;

@property (nonatomic,   copy) NSString *cover;

@property (nonatomic,   copy) NSString *url;

@end

NS_ASSUME_NONNULL_END
