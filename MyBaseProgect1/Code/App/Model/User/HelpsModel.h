//


#import <Foundation/Foundation.h>

@class HelpsData;
@interface HelpsModel : NSObject

@property (nonatomic,  copy) NSString *errorMessage;

@property (nonatomic, assign) NSInteger resultCode;

@property (nonatomic, copy) NSArray <HelpsData *> *data;

@end

@interface HelpsData : NSObject

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *helpsid;

@property (nonatomic, copy) NSString *title;

@end
