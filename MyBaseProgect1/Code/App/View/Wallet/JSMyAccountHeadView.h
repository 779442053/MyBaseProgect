

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSMyAccountHeadView : UIView

@property (nonatomic, copy) void(^addBtnClickBlock)(UIButton *btn);

+ (instancetype)myAccountHeadView;


@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *addbtn;
- (IBAction)addBtnAction:(id)sender;

@end

NS_ASSUME_NONNULL_END
