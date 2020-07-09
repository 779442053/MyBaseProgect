

#import "ZWVideosModel.h"
@implementation ZWAdvertisements

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"advId" : @"id"};
}

@end
@implementation ZWVideos

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"videoId" : @"id"};
}
-(BOOL)IsVerticalScreen{
    //    CGSize size = [self GetImageSizeWithURL:self.cover];
    //    ZWWLog(@"===============\n 计算出图片的原始尺寸\n========height=%f width = %f",size.height,size.width)
    //    if (size.width > size.height) {
    //        return NO;
    //    }
    //    return YES;
    if (self.width > self.height) {
        return NO;
    }
    return YES;
}
-(CGFloat)ItemHeight{
    CGFloat CurrentWith = (K_APP_WIDTH - 30)/2;
    if (self.IsVerticalScreen) {
        //竖屏,展示长方形
        return CurrentWith*2 - 30;
    }else{
        //展示正方形
        return CurrentWith - 10 *0.5 - 30 * 0.5;
    }
}
-(CGFloat)ItemWidth{
    CGFloat CurrentWith = (K_APP_WIDTH - 30)/2;
    _ItemWidth = CurrentWith;
    return _ItemWidth;
}
//-(CGFloat)height{
//    //if (_height) return _height;
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:self.cover]) {
//        id height = [[NSUserDefaults standardUserDefaults] objectForKey:self.cover];
//        _height = [height floatValue];
//    }else{
//        CGSize size = [self GetImageSizeWithURL:self.cover];
//        if (size.height < 328.0) {
//            size.height = 328.0 * 0.5;
//        }else if (size.height >= 328.0){
//            size.height = 328.0;
//        }
//        dispatch_group_t group = dispatch_group_create();
//        dispatch_queue_t queue = dispatch_queue_create("dispatchGroupMethod", DISPATCH_QUEUE_CONCURRENT);
//        dispatch_group_async(group, queue, ^{
//            dispatch_async(queue, ^{
//                [[NSUserDefaults standardUserDefaults] setObject:@(size.height) forKey:self.cover];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//            });
//        });
//
//        _height = size.height;
//    }
//    return _height;
//}
-(CGSize)GetImageSizeWithURL:(id)imageURL{

    NSURL* URL = nil;
    if([imageURL isKindOfClass:[NSURL class]]){
        URL = imageURL;
    }
    if([imageURL isKindOfClass:[NSString class]]){
        URL = [NSURL URLWithString:imageURL];
    }
    NSData *data = [NSData dataWithContentsOfURL:URL];
    UIImage *imageOrigin = [UIImage imageWithData:data];

    CGFloat CurrentWith = (K_APP_WIDTH - 30)/2;
    UIImage *image = [self imageCompressForWidth:imageOrigin targetWidth:CurrentWith];

    return CGSizeMake(image.size.width, image.size.height);
}
//-(CGFloat)width{
//    CGFloat CurrentWith = (K_APP_WIDTH - 45)/2;
//    _width = CurrentWith;
//    return _width;
//}

-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(size);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    UIGraphicsEndImageContext();
    return newImage;
}
@end
@implementation ZWVideosModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"videos" : [ZWVideos class],
             @"advertisements" : [ZWAdvertisements class]
             };
}

@end