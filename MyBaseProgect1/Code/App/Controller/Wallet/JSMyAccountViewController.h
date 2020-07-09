//
//  JSMyAccountViewController.h

#import <UIKit/UIKit.h>
#import "JSCurrentUserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSMyAccountViewController : BaseViewController
@property (nonatomic, strong) JSCurrentUserModel *currentUserModel;
@end

NS_ASSUME_NONNULL_END
