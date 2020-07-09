

#import "PriseView.h"

@implementation PriseView
+ (instancetype)createPriseViewInit {
    
    NSArray *nibView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([PriseView class]) owner:self options:nil];
    
    return [nibView objectAtIndex:0];
}

- (IBAction)clickbtnEvent:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickOkEvent)]) {
        [self.delegate clickOkEvent];
    }
    
}


@end
