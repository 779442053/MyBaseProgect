//
//  UploadModel.m
//  KuaiZhu
//
//  Created by apple on 2019/5/22.
//  Copyright © 2019 su. All rights reserved.
//

#import "UploadModel.h"

@implementation UploadModel
-(BOOL)IsVerticalScreen{
    //加载慢.问题出在我需要计算 t视频封面尺寸.在这里,强制h竖屏得啦
    // 如果强制需要知道横竖屏.需要应用缓存策略.开辟分线程.进行计算
//    CGSize size = [self GetImageSizeWithURL:self.cover];
//    if (size.width > size.height) {
//        return NO;
//    }
    return YES;

}
- (CGFloat)height
{
    CGFloat CurrentWith = (K_APP_WIDTH - 30)/2;
//    if (self.IsVerticalScreen) {
//        //竖屏,展示长方形
//        return CurrentWith*2 - 30;
//    }else{
//        //展示正方形
//        return CurrentWith - 10 *0.5 - 30 * 0.5;
//    }
    if (self.IsVerticalScreen) {
        //竖屏,展示长方形
        //return CurrentWith*2 - cell_margin *2;
        return kRealValueHeight_S(CurrentWith);
    }else{
        //展示正方形
        //return CurrentWith - cell_margin *2 *0.5 - cell_margin *2 * 0.5;
        return kRealValueHeight_H(CurrentWith);
    }

}
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
-(CGFloat)width{
    CGFloat CurrentWith = (K_APP_WIDTH - 30)/2;
    _width = CurrentWith;
    return _width;
}

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