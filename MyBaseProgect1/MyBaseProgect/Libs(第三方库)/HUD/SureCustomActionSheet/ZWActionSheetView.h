//
//  ZWActionSheetView.h
//  Bracelet
//
//  Created by 张威威 on 2017/10/26.
//  Copyright © 2017年 ShYangMiStepZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZWActionSheetView : UIView
@property (nonatomic, strong) NSArray *optionsArr;
@property (nonatomic,   copy) NSString *cancelTitle;
- (instancetype)initWithTitleView:(UIView*)titleView
                       optionsArr:(NSArray*)optionsArr
                      cancelTitle:(NSString*)cancelTitle
                    selectedBlock:(void(^)(NSInteger))selectedBlock
                      cancelBlock:(void(^)())cancelBlock;
@end
