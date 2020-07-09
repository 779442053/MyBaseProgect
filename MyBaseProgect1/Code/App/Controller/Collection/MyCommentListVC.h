

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyCommentListVC : UITableViewController
//当前类别名称(需要传值过来)
@property(nonatomic,copy,nonnull) NSString *typeName;
@end

NS_ASSUME_NONNULL_END
