

#import <UIKit/UIKit.h>

@protocol PriseViewDelegate <NSObject>

@optional

- (void)clickOkEvent;

@end


@interface PriseView : UIView
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *desLable;

@property (nonatomic, weak) id <PriseViewDelegate> delegate;


+ (instancetype)createPriseViewInit;

@end
