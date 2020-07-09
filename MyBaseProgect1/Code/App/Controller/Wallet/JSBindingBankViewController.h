//
//  JSBindingBankViewController.h

#import <UIKit/UIKit.h>
#import "JSCurrentUserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSBindingBankViewController : BaseViewController

@property (nonatomic, strong) JSCurrentUserModel *currentUserModel;
@property (nonatomic, assign) NSInteger dismissType;
@end

NS_ASSUME_NONNULL_END
