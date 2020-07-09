

#import "UploadVideosCollectionCell.h"

@implementation UploadVideosCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    //MARK:进度
    [self.contentView addSubview:self.progressV];
//    self.bgImageView.layer.cornerRadius = 13;
//    self.bgImageView.layer.masksToBounds = YES;

}

-(UIProgressView *)progressV{
    if (!_progressV) {
        CGFloat h = 2;
        CGFloat y = [UploadVideosCollectionCell cellHeight] - h;
        CGFloat x = 20;
        CGFloat w = K_APP_WIDTH - x;
        _progressV = [[UIProgressView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        _progressV.hidden = YES;
        _progressV.tintColor = [UIColor colorWithHexString:@"#00c66f"];
        _progressV.trackTintColor = K_APP_SPLIT_LINE_COLOR;
    }
    return _progressV;
}

-(void)cellBindForImgurl:(NSString *)strImg andTitle:(NSString *)strTitle withFinish:(BOOL)finish{
    if ([Utils checkTextEmpty:strImg]) {
        [self.bgImageView setImageWithURL:[strImg mj_url]
                 placeholderImage:K_APP_DEFAULT_IMAGE_SMALL];
    }
    else{
        self.bgImageView.image = K_APP_DEFAULT_IMAGE_SMALL;
    }
     //[self.bgImageView wyh_autoSetImageCornerRedius:13 ConrnerType:UIRectCornerAllCorners];

    self.videoTitle.text = strTitle;
    [self.videoTitle alignTop];
}

-(void)cellBindForImg:(UIImage *)tmpImg andTitle:(NSString *)strTitle withFinish:(BOOL)finish{

    self.bgImageView.image = tmpImg;
    self.videoTitle.text = strTitle;
    [self.videoTitle alignTop];
}

+(CGFloat)cellHeight{
    CGFloat CurrentWith = (K_APP_WIDTH - 30)/2;
    return CurrentWith*2 - 50;
}
@end
