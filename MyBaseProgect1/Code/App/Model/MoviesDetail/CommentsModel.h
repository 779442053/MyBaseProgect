//


#import <Foundation/Foundation.h>

@class CommentsData,SubComments;

@interface CommentsModel : NSObject

@property (nonatomic,   copy) NSString *resultCode;

@property (nonatomic,   copy) NSString *errorMessage;

@property (nonatomic, assign) NSInteger dataCount;       //评论总数

@property (nonatomic,   copy) NSArray <CommentsData *> *data;

@end

@interface CommentsData : NSObject

@property (nonatomic, assign) NSInteger commentId;       // 评论数据ID

@property (nonatomic,   copy) NSString *context;

@property (nonatomic,   copy) NSString *sendTime;

@property (nonatomic,   copy) NSString *floor;

@property (nonatomic,   copy) NSString *userName;

@property (nonatomic, assign) NSInteger userID;

@property (nonatomic,   copy) NSString *photo;

@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat width;

@property (nonatomic,   copy) NSArray <SubComments *> *subComments;

@end

@interface SubComments : NSObject

@property (nonatomic, assign) NSInteger subCommentsId;

@property (nonatomic,   copy) NSString *context;

@property (nonatomic,   copy) NSString *sendTime;

@property (nonatomic,   copy) NSString *floor;

@property (nonatomic,   copy) NSString *userName;

@property (nonatomic,   copy) NSString *photo;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat width;

@end
