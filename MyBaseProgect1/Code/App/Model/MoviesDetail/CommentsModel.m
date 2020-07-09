

#import "CommentsModel.h"

@implementation CommentsModel

+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [CommentsData class]};
}


@end


@implementation CommentsData

+ (NSDictionary *)objectClassInArray{
    return @{@"subComments" : [SubComments class]};
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"commentId" : @"id"
             };
}
-(CGFloat)cellHeight{
    if (_cellHeight) return _cellHeight;
    CGFloat knowHeight = 45.0;
    //label的高度
    CGSize textMaxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 70 - 15, MAXFLOAT);
    CGFloat labelHeight = [self.context boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil].size.height;
    _cellHeight += labelHeight + knowHeight + 13 + 10;
    return _cellHeight;
}


@end

@implementation SubComments

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"subCommentsId" : @"id"
             };
}
-(CGFloat)cellHeight{
   if (_cellHeight) return _cellHeight;
    CGFloat knowHeight = 45.0;
    CGSize textMaxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 70 - 15 - 40, MAXFLOAT);
    CGFloat labelHeight = [self.context boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil].size.height;
    _cellHeight += labelHeight + knowHeight + 13;
    return _cellHeight;
}
@end
