

#import "ZWBaseViewModel.h"

@implementation ZWBaseViewModel
+ (instancetype)allocWithZone:(struct _NSZone *)zone {

    ZWBaseViewModel *viewModel = [super allocWithZone:zone];

    if (viewModel) {

        [viewModel zw_initialize];
    }
    return viewModel;
}

- (instancetype)initWithModel:(id)model {

    self = [super init];
    if (self) {
    }
    return self;
}
- (void)zw_initialize {

}
@end
