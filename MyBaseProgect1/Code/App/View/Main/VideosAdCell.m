//
//  VideosAdCell.m
//  KuaiZhu
//
//  Created by apple on 2019/5/28.
//  Copyright © 2019 su. All rights reserved.
//

#import "VideosAdCell.h"

@implementation VideosAdCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backgroundColor = UIColor.clearColor;
    
//    //圆角
//    self.layer.cornerRadius = 13;
//    self.layer.masksToBounds = YES;
    
    //阴影
//    [Utils setViewShadowStyle:self.contentView
//               AndShadowColor:UIColor.lightGrayColor
//             AndShadowOpacity:1
//              AndShadowRadius:7
//             WithShadowOffset:CGSizeMake(0,1)];
}

@end
