

#import "CommentsCell.h"

@implementation CommentsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(id)xibWithTableView{
    return [[[NSBundle mainBundle] loadNibNamed:@"CommentsCell" owner:nil options:nil] lastObject];
}
@end