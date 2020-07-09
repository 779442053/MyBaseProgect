

#import <UIKit/UIKit.h>
#import "InfosModel.h"

@protocol UserInfoViewDelegate <NSObject>

@optional

- (void)clickBtnEventWithTag:(NSInteger)tag;

- (void)clickForceBtnEvent:(BOOL)isSel AndSender:(UIButton *)sender;

@end

@interface UserInfoView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *accountIcon;
@property (weak, nonatomic) IBOutlet UILabel *worksLable;
@property (weak, nonatomic) IBOutlet UILabel *forceLable;
@property (weak, nonatomic) IBOutlet UILabel *fansLable;
@property (weak, nonatomic) IBOutlet UILabel *likeLable;
@property (weak, nonatomic) IBOutlet UIButton *letterBtn;
@property (weak, nonatomic) IBOutlet UIButton *forceBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic, weak) id <UserInfoViewDelegate> delegate;

@property (nonatomic, strong) InfosModel *infoModel;

+ (instancetype)createUserInfoViewInit;

@end
