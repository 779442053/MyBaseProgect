

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class MyBillsData;
@interface ZWMyBillsModel : NSObject

@property (nonatomic, assign) NSInteger resultCode;
@property (nonatomic, copy) NSString *errorMessage;
@property (nonatomic, strong) NSArray <MyBillsData *> *data;

@end


@class InfoData;
@interface MyBillsData : NSObject

@property (nonatomic, copy) NSString *date;
@property (nonatomic, assign) double income;
@property (nonatomic, assign) double expenditure;
@property (nonatomic, strong) NSArray <InfoData *> *infoList;

@end


@interface InfoData : NSObject

@property (nonatomic, copy) NSString *infoId;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *type;

@end
NS_ASSUME_NONNULL_END
