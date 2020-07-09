

#import "JSMyAccountHeadView.h"

@implementation JSMyAccountHeadView

+ (instancetype)myAccountHeadView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"JSMyAccountHeadView" owner:nil options:nil]lastObject];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)addBtnAction:(id)sender {
    if (self.addBtnClickBlock) {
        self.addBtnClickBlock(self.addbtn);
    }
}
@end
