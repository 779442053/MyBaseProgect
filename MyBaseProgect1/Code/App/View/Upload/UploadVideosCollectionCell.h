

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UploadVideosCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *videoTitle;
@property(nonatomic, strong) UIProgressView *progressV;
-(void)cellBindForImgurl:(NSString *)strImg
                andTitle:(NSString *)strTitle
              withFinish:(BOOL)finish;

-(void)cellBindForImg:(UIImage *)tmpImg
             andTitle:(NSString *)strTitle
           withFinish:(BOOL)finish;
+(CGFloat)cellHeight;
@end

NS_ASSUME_NONNULL_END
