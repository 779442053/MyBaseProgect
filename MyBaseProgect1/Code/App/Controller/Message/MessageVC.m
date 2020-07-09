//


#import "MessageVC.h"

static const NSInteger maxFontNum = 100;//最大输入限制

@interface MessageVC () <UITextViewDelegate>

@property (nonatomic,strong) UITextView *feedBackView;

@property (nonatomic,strong) UILabel *wordNumLabel; //字符数

@property (nonatomic,strong) UIButton *btnOk;
@property(nonatomic,strong) UIImageView *backImg;
@property(nonatomic,strong)UILabel *plachHolderLabel;
@property(nonatomic,strong) UIButton *btnSearch;
@end

@implementation MessageVC
-(void)BackBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(UIButton *)btnSearch{
    if (!_btnSearch) {
        CGFloat w = 35;
        CGFloat x = [[UIDevice currentDevice] isSmallDevice]?15:25;
        CGFloat h = 35;
        CGFloat y = ([[UIDevice currentDevice] isiPhoneX]?K_APP_IPHONX_TOP:20) + (44 - h) * 0.5;
        _btnSearch =[BaseUIView createBtn:CGRectMake(x, y, w, h)
                                 AndTitle:nil
                            AndTitleColor:nil
                               AndTxtFont:nil
                                 AndImage:[UIImage imageNamed:@"backBtnBlack"]
                       AndbackgroundColor:nil
                           AndBorderColor:nil
                          AndCornerRadius:0
                             WithIsRadius:NO
                      WithBackgroundImage:nil
                          WithBorderWidth:0];

        [_btnSearch addTarget:self action:@selector(BackBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnSearch;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}
-(UIImageView *)backImg{
    if (!_backImg) {
        _backImg = [BaseUIView createImage:UIScreen.mainScreen.bounds
                                  AndImage:[UIImage imageNamed:@"我的信息"]
                        AndBackgroundColor:nil
                              WithisRadius:NO];
    }
    return _backImg;
}
//MARK: - init
- (void)initUI{
    [self.view addSubview:self.backImg];

    UIImageView *sendMessageView = [[UIImageView alloc]init];
    sendMessageView.image = [UIImage imageNamed:@"sendMessageBGImage"];
    [self.view addSubview:sendMessageView];
    [sendMessageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(K_APP_NAVIGATION_BAR_HEIGHT + 10);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(300);
    }];


    float w = K_APP_WIDTH - 80;
    float h = 21;
    float y = (44 - h) * 0.5 + ([[UIDevice currentDevice] isiPhoneX]?K_APP_IPHONX_TOP:20);
    float x = (K_APP_WIDTH - w) / 2.f;
    UILabel *labPageTitle = [BaseUIView createLable:CGRectMake(x , y , w , h )
                                            AndText:@""
                                       AndTextColor:[UIColor whiteColor]
                                         AndTxtFont:[UIFont systemFontOfSize:24]
                                 AndBackgroundColor:nil];
    labPageTitle.textAlignment = NSTextAlignmentCenter;
    labPageTitle.textColor = [UIColor whiteColor];
    labPageTitle.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:labPageTitle];

    [self.view addSubview:self.btnSearch];
    
    
    //MARK:确定
    [self.view addSubview:self.btnOk];
    
    [self.view addSubview:self.feedBackView];
    [self.feedBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(K_APP_NAVIGATION_BAR_HEIGHT + 20);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(300 - 30);
    }];
    
    [self configTextView];
    
    [self.view addSubview:self.wordNumLabel];
    [self.wordNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.feedBackView.mas_right).offset(-8);
        make.bottom.equalTo(self.feedBackView.mas_bottom).offset(-4);
        make.size.mas_equalTo(CGSizeMake(100, 24));
    }];

    UILabel *desLB  = [[UILabel alloc]init];
    desLB.text = @"(100字之内)";
    desLB.font = FONT(12);
    desLB.textColor = [UIColor blackColor];
    [self.view addSubview:desLB];
    [desLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.feedBackView.mas_left).offset(4);
        make.bottom.equalTo(self.feedBackView.mas_bottom).offset(-4);
        make.size.mas_equalTo(CGSizeMake(100, 12));
    }];
}

-(UIButton *)btnOk{
    if (!_btnOk) {
        CGFloat x = K_APP_WIDTH - 20 - 35;
        CGFloat y = (44 - 21) * 0.5 + ([[UIDevice currentDevice] isiPhoneX]?K_APP_IPHONX_TOP:20);
        CGFloat w = 50;
        CGFloat h = 21;
        _btnOk = [BaseUIView createBtn:CGRectMake(x, y, w, h)
                              AndTitle:@"发送"
                         AndTitleColor:[UIColor whiteColor]
                            AndTxtFont:[UIFont systemFontOfSize:18]
                              AndImage:nil
                    AndbackgroundColor:nil
                        AndBorderColor:nil
                       AndCornerRadius:0.0
                          WithIsRadius:NO
                   WithBackgroundImage:nil
                       WithBorderWidth:0];
        
        [_btnOk addTarget:self
                   action:@selector(btnApplyFeedbackAction:)
         forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnOk;
}

//配置Textview
- (void)configTextView{
    self.plachHolderLabel = [UILabel new];
    self.plachHolderLabel.text = @"请输入五个字以上";
    
    self.plachHolderLabel.numberOfLines = 0;
    self.plachHolderLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    [self.plachHolderLabel sizeToFit];
    [self.feedBackView addSubview:self.plachHolderLabel];
    self.feedBackView.font = FONT(13);
    self.plachHolderLabel.font = FONT(13);
    
    if (@available(iOS 13.0,*)) {
       //...
    }
    else{
        [self.feedBackView setValue:self.plachHolderLabel forKey:@"_placeholderLabel"];
    }
}

//MARK: - Action
- (IBAction)btnApplyFeedbackAction:(UIButton *)sender{
    
    if (self.feedBackView.text.length < 5
        || self.feedBackView.text == nil) {
        [YJProgressHUD showError:@"至少要输入五个字"];
    }
    else {
        __weak typeof(self) weakSelf = self;
        NSString *strURL = [NSString stringWithFormat:@"%@Message",K_APP_HOST];
        NSDictionary *dicParams = @{
                                    @"content":self.feedBackView.text,
                                    @"userID":self.userId
                                    };
        [Utils postWithUrl:strURL
                      body:[dicParams mj_JSONData]
               WithSuccess:^(id  _Nullable response, NSString * _Nullable strMsg) {
                   if (response) {
                       [YJProgressHUD showSuccess:@"发送成功"];
                       
                       //关闭
                       [weakSelf.navigationController popViewControllerAnimated:YES];
                   }
                   else{
                       ZWWLog(@"发送私信失败！详见：%@",weakSelf);
                       [MBProgressHUD showError:strMsg?strMsg:@"请稍后再试"];
                   }
               }
               WithFailure:^(NSString * _Nullable error) {
                   ZWWLog(@"发送私信异常！详见：%@",error);
                   [MBProgressHUD showError:error];
               }
             WithisLoading:YES];

    }
}


//MARK: -  UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    
    NSString *toBeString = textView.text;
    
    // 获取键盘输入模式
    NSString *lang = [[UIApplication sharedApplication] textInputMode].primaryLanguage;
    
    if ([lang isEqualToString:@"zh-Hans"]) {
        // zh-Hans代表简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            
            if (toBeString.length > maxFontNum) {
                textView.text = [toBeString substringToIndex:maxFontNum];//超出限制则截取最大限制的文本
                self.wordNumLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)maxFontNum,(long)maxFontNum];
            }
            else {
                self.wordNumLabel.text = [NSString stringWithFormat:@"%lu/%ld",(unsigned long)toBeString.length,(long)maxFontNum];
            }
        }
        
    } else {// 中文输入法以外的直接统计
        
        if (toBeString.length > maxFontNum) {
            
            textView.text = [toBeString substringToIndex:maxFontNum];
            
            self.wordNumLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)maxFontNum,(long)maxFontNum];
            
        } else {
            self.wordNumLabel.text = [NSString stringWithFormat:@"%lu/%ld",(unsigned long)toBeString.length,(long)maxFontNum];
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    
    NSUInteger length = textView.text.length;
    NSUInteger strLength = text.length;
    
    //MARK:长度限制
    if(strLength != 0 && length >= maxFontNum){
        return NO;
    }
    if (text.length == 0 && textView.text.length == 1)
    {
        self.plachHolderLabel.hidden = NO;

    }
    if (text.length == 0 && textView.text.length == 0)
    {
        self.plachHolderLabel.hidden = NO;

    }
    self.plachHolderLabel.hidden = YES;

    
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{

    return YES;
}

//MARK: -  lazyload
- (UITextView *)feedBackView{
    if (!_feedBackView) {
        _feedBackView = [UITextView new];
        _feedBackView.textColor = [UIColor colorWithHexString:@"#999999"];
        _feedBackView.delegate = self;
        _feedBackView.font = FONTOFPX(32);
        _feedBackView.backgroundColor = [UIColor whiteColor];
    }
    return _feedBackView;
}

- (UILabel *)wordNumLabel{
    if (_wordNumLabel == nil) {
        _wordNumLabel = [UILabel new];
        _wordNumLabel.textColor = [UIColor colorWithHexString:@"#619BF1"];
        _wordNumLabel.text = @"0/100";
        _wordNumLabel.font = FONT(12);
        _wordNumLabel.textAlignment = NSTextAlignmentRight;
    }
    return _wordNumLabel;
}


@end

