

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (Han)
- (void)cellType;
- (CGSize)labelAutoCalculateRectWith:(NSString *)text Font:(UIFont *)textFont MaxSize:(CGSize)maxSize;
@end

NS_ASSUME_NONNULL_END
