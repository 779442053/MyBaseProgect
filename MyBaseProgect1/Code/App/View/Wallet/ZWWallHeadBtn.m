

#import "ZWWallHeadBtn.h"

@implementation ZWWallHeadBtn

- (nonnull instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setTitleColor:[UIColor colorWithHexString:@"#A7A7A8"] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithHexString:@"#000000"] forState:UIControlStateDisabled];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return self;
}

@end
