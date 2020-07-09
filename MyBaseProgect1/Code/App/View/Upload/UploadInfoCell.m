

#import "UploadInfoCell.h"


@interface UploadInfoCell () <UITextViewDelegate>
@property(nonatomic,strong) UILabel *plachHolderLbel;
@end

@implementation UploadInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(instancetype)cellWithTableView:(UITableView *)tableView{
  static NSString *cellId = @"UploadInfoCell";
  UploadInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
  if (cell == nil) {
    cell = [[UploadInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    cell.backgroundColor = [UIColor whiteColor];
  }
  return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
  
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    UITextView *textView = [UITextView new];
    textView.textColor = [UIColor colorWithHexString:@"#999999"];
    textView.backgroundColor = [UIColor clearColor];
    textView.delegate = self;
    [self addSubview:textView];
    self.infoTextView = textView;
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.mas_equalTo(kWidth(15));
       make.right.mas_equalTo(kWidth(15));
       make.height.equalTo(self.mas_height);
    }];
    
    CGRect rect = CGRectMake(5, 5, K_APP_WIDTH - 2 * 5, 42);
    _plachHolderLbel = [BaseUIView createLable:rect
                                       AndText:@"说点什么..(禁止上传违法、有害、儿童等视频,发现封号)"
                                  AndTextColor:[UIColor grayColor]
                                    AndTxtFont:FONT(14)
                            AndBackgroundColor:nil];
    _plachHolderLbel.lineBreakMode = NSLineBreakByWordWrapping;
    _plachHolderLbel.numberOfLines = 2;
    [_plachHolderLbel alignTop];
    
    [textView addSubview:_plachHolderLbel];
    textView.font = FONT(14);
  }
  return self;
}


//MARK: - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
  ZWWLog(@"即将开始编辑");
  if (self.GetTextView) {
    self.GetTextView(textView.text);
  }
  return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
  ZWWLog(@"即将结束编辑");
  if (self.GetTextView) {
    self.GetTextView(textView.text);
  }
  return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
  // 已经开始编辑
  if (self.GetTextView) {
    self.GetTextView(textView.text);
  }
  ZWWLog(@"已经开始编辑");
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
  if (self.GetTextView) {
    self.GetTextView(textView.text);
  }
  // 已经结束编辑
  ZWWLog(@"已经结束编辑");
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    // [S] 禁止用户切换键盘为Emoji表情
    if (textView.isFirstResponder) {
        if ([textView.textInputMode.primaryLanguage isEqual:@"emoji"] || textView.textInputMode.primaryLanguage == nil) {
            return NO;
        }
    }
    // [E] 禁止用户切换键盘为Emoji表情
    
    NSUInteger length = textView.text.length;
    NSUInteger strLength = text.length;
    
    //MARK:提示文本
    if (strLength > 0 && ![text isEqualToString:@"\n"] && ![text isEqualToString:@" "]) {
        [self.plachHolderLbel setHidden:YES];
    }
    else if (strLength <= 0 && range.location <= 0) {
        [self.plachHolderLbel setHidden:NO];
    }
    
    //MARK:长度限制
    if(strLength != 0 && length >= 20){
        return NO;
    }
    
  if (self.GetTextView) {
      self.GetTextView(textView.text);
  }
    
  return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
  if (self.GetTextView) {
    self.GetTextView(textView.text);
  }
}



@end
