//
//  RegisterViewController.m
//  KuaiZhu
//
//  Created by Ghy on 2019/5/13.
//  Copyright © 2019年 su. All rights reserved.
//

#import "RegisterViewController.h"
#import "NLSliderSwitchProtocol.h"

#define k_margin 22.5
#define k_view_height 50
#define k_top_margin ([[UIDevice currentDevice] isSmallDevice]?0:10)
#define TextColor [[UIColor alloc] colorFromHexInt:0x999999 AndAlpha:1.0]

@interface RegisterViewController ()<UITextFieldDelegate,NLSliderSwitchProtocol>

@property (nonatomic, strong) UIView            *contentView;   //内容视图
@property (nonatomic, strong) ANCustomTextField *txtEmail;      //手机号
@property (nonatomic, strong) ANCustomTextField *txtPwd;        //密码
@property (nonatomic, strong) ANCustomTextField *txtCPwd;       //确认密码
@property (nonatomic, strong) ANCustomTextField *txtNickname;   //昵称
@property (nonatomic, strong) ANCustomTextField *txtCode;       //邀请码
@property (nonatomic, strong) UIButton          *btnRegister;   //注册
@property(nonatomic,assign)NSInteger time;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self initView];
}
-(void)viewDidScrollToVisiableArea{
    NSLog(@"当前滑动到了‘’页面");
}

//MARK: - initView
-(void)initView{
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8F7"];
    //MARK:主视图
    [self.view addSubview:self.contentView];
    //MARK:邮箱==手机号
    [self.contentView addSubview:self.txtEmail];
    //MARK:密码
    [self.contentView addSubview:self.txtPwd];
    //MARK:确认密码
    [self.contentView addSubview:self.txtCPwd];
    //MARK:昵称
    [self.contentView addSubview:self.txtNickname];
    
    //MARK:邀请码
    [self.contentView addSubview:self.txtCode];
    
    //MARK:注册
    [self.view addSubview:self.btnRegister];
}


//MARK: - lazy load
-(UIView *)contentView {
    if (!_contentView) {
        CGFloat x = 0;
        CGFloat w = K_APP_WIDTH - 2 * x;
        _contentView = [BaseUIView createView:CGRectMake(x, 0, w, k_view_height *5)
                           AndBackgroundColor:UIColor.whiteColor
                                  AndisRadius:NO
                                    AndRadiuc:0
                               AndBorderWidth:0
                               AndBorderColor:UIColor.whiteColor];
    }
    return _contentView;
}

-(ANCustomTextField *)txtEmail{
    if (!_txtEmail) {
        CGFloat y = 0;
        CGRect rect = CGRectMake(k_margin,y , K_APP_WIDTH - 2 * k_margin - 30, k_view_height);
        _txtEmail = [[ANCustomTextField alloc] initWithFrame:rect];
        _txtEmail.keyboardType = UIKeyboardTypeEmailAddress;
        _txtEmail.returnKeyType = UIReturnKeyNext;
        
        _txtEmail.delegate = self;
        _txtEmail.hasBorder = NO;
        _txtEmail.hasBottomBorder = YES;
        _txtEmail.borderStyle = UITextBorderStyleNone;
        _txtEmail.bottomLine.backgroundColor = [UIColor colorWithHexString:@"#F7F8F7"];
        
        //显示清除按钮
        _txtEmail.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        _txtEmail.placeholder = @"请输入邮箱";
        _txtEmail.textColor = TextColor;
        _txtEmail.font = FONTOFPX(28);
    }
    return _txtEmail;
}

-(ANCustomTextField *)txtPwd{
    if (!_txtPwd) {
        CGRect rect = self.txtEmail.frame;
        CGRect rectTWO = self.txtEmail.frame;
        rect.origin.y += rect.size.height + 0;
        rect.size.width = rectTWO.size.width;
        _txtPwd = [[ANCustomTextField alloc] initWithFrame:rect];
        _txtPwd.placeholder = @"请输入密码";
        
        _txtPwd.delegate = self;
        _txtPwd.hasBorder = NO;
        _txtPwd.hasBottomBorder = YES;
        _txtPwd.borderStyle = UITextBorderStyleNone;
        _txtPwd.bottomLine.backgroundColor = [UIColor colorWithHexString:@"#F7F8F7"];;
        
        //密码框
        _txtPwd.secureTextEntry = YES;
        
        //显示清除按钮
        _txtPwd.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        _txtPwd.keyboardType = UIKeyboardTypeDefault;
        _txtPwd.returnKeyType = UIReturnKeyNext;
    }
    return _txtPwd;
}

-(ANCustomTextField *)txtCPwd{
    if (!_txtCPwd) {
        CGRect rect = self.txtPwd.frame;

        rect.origin.y += rect.size.height + 0;
        
        _txtCPwd = [[ANCustomTextField alloc] initWithFrame:rect];
        _txtCPwd.placeholder = @"确认密码";
        
        _txtCPwd.hasBorder = NO;
        _txtCPwd.hasBottomBorder = YES;
        _txtCPwd.borderStyle = UITextBorderStyleNone;
        _txtCPwd.bottomLine.backgroundColor = [UIColor colorWithHexString:@"#F7F8F7"];;
        _txtCPwd.delegate = self;
        
        //密码框
        _txtCPwd.secureTextEntry = YES;
        
        //显示清除按钮
        _txtCPwd.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        _txtCPwd.keyboardType = UIKeyboardTypeDefault;
        _txtCPwd.returnKeyType = UIReturnKeyJoin;
    }
    return _txtCPwd;
}

-(ANCustomTextField *)txtNickname{
    if (!_txtNickname) {
        CGRect rect = self.txtCPwd.frame;
        rect.origin.y += rect.size.height + 0;
        _txtNickname = [[ANCustomTextField alloc] initWithFrame:rect];
        _txtNickname.keyboardType = UIKeyboardTypeNamePhonePad;
        _txtNickname.returnKeyType = UIReturnKeyNext;
//         [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:_txtNickname];
        _txtNickname.delegate = self;
        _txtNickname.hasBorder = NO;
        _txtNickname.hasBottomBorder = YES;
        _txtNickname.borderStyle = UITextBorderStyleNone;
        _txtNickname.bottomLine.backgroundColor = [UIColor colorWithHexString:@"#F7F8F7"];;
        
        //显示清除按钮
        _txtNickname.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        _txtNickname.placeholder = @"输入昵称";
        _txtNickname.textColor = TextColor;
        _txtNickname.font = FONTOFPX(28);
    }
    return _txtNickname;
}

-(ANCustomTextField *)txtCode{
    if (!_txtCode) {
        CGRect rect = self.txtNickname.frame;
        rect.origin.y += rect.size.height + 0;
        _txtCode = [[ANCustomTextField alloc] initWithFrame:rect];
        _txtCode.keyboardType = UIKeyboardTypeNamePhonePad;
        _txtCode.returnKeyType = UIReturnKeyJoin;
        
        _txtCode.delegate = self;
        _txtCode.hasBorder = NO;
        _txtCode.hasBottomBorder = YES;
        _txtCode.borderStyle = UITextBorderStyleNone;
        _txtCode.bottomLine.backgroundColor = [UIColor colorWithHexString:@"#F7F8F7"];;
        
        //显示清除按钮
        _txtCode.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        _txtCode.placeholder = @"输入邀请码(邀请码可不填)";
        _txtCode.textColor = TextColor;
        _txtCode.font = FONTOFPX(28);
    }
    return _txtCode;
}

-(UIButton *)btnRegister{
    if (!_btnRegister) {
        CGFloat w = K_APP_WIDTH - 60;
        CGFloat h = 46;
        CGFloat x = (K_APP_WIDTH - w) * 0.5;
        CGFloat y = self.contentView.origin.y + self.contentView.size.height + 25;
        _btnRegister = [BaseUIView createBtn:CGRectMake(x, y, w, h)
                                 AndTitle:@"注册"
                            AndTitleColor:[UIColor colorWithHexString:@"#FFFFFF"]
                               AndTxtFont:[UIFont systemFontOfSize:14]
                                 AndImage:nil
                       AndbackgroundColor:[UIColor colorWithHexString:@"#66C0FF"]
                           AndBorderColor:nil
                          AndCornerRadius:h*0.5
                             WithIsRadius:YES
                      WithBackgroundImage:nil
                          WithBorderWidth:0.0];
        
        [_btnRegister addTarget:self
                         action:@selector(btnRegisterAction:)
               forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnRegister;
}


//MARK: - 注册
-(IBAction)btnRegisterAction:(UIButton *)sender{
    //用户名
    NSString *strUserName = [self.txtEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (![Utils checkTextEmpty:strUserName]) {
        [YJProgressHUD showError:@"请输入邮箱"];
        return;
    }
    else if(![Utils checkEmail:strUserName]){
        [YJProgressHUD showError:@"邮箱格式有误"];
        return;
    }
    //账号密码登录
    NSString *strPassword = [self.txtPwd.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (![Utils checkTextEmpty:strPassword]) {
        [YJProgressHUD showError:@"请输入密码"];
        return;
    }
    else if([Utils stringContainsEmoji:strPassword]){
        [YJProgressHUD showError:@"密码不能含有Emoji表情符号"];
        return;
    }
    else if(![Utils checkPassword:strPassword]){
        [YJProgressHUD showError:@"密码长度为6-20位字母或数字组成"];
        return;
    }
    
    //确认码
    NSString *strCPassword = [self.txtCPwd.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (![strPassword isEqualToString:strCPassword]) {
        [YJProgressHUD showError:@"两者密码不匹配"];
        return;
    }
    
    //昵称
    NSString *strNickname = [self.txtNickname.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (![Utils checkTextEmpty:strNickname]) {
        [YJProgressHUD showError:@"请输入昵称"];
        return;
    }
    //邀请码
    NSString *strCode = [self.txtCode.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([strCode length] > 0 &&[strCode length] < 6){
        [YJProgressHUD showError:@"邀请码至少6位"];
        return;
    }
    if ([strCode length] > 0 && ![Utils checkPassword:strCode]) {
        [YJProgressHUD showError:@"请输入数字和字母组成的邀请码"];
        return;
    }
    
    NSString *strUrl = [NSString stringWithFormat:@"%@Register",K_APP_HOST];
    NSDictionary *dicData = @{
                              @"name":strNickname,
                              @"email":strUserName,
                              @"password":strPassword,
                              @"deviceID":[Utils dy_getIDFV],
                              @"invCode":strCode
                              };
    
    [Utils postRequestForServerData:strUrl
                     withParameters:dicData
                 AndHTTPHeaderField:nil
                     AndSuccessBack:^(id _responseData) {
                     //注册成功
                     if (_responseData) {
                         [YJProgressHUD showSuccess:@"注册成功"];
                         ZWWLog(@"====%@",_responseData);
                         //登录
                         [[LoginViewController shareInstance] logininApp:dicData];
                     }
                     else{
                         [YJProgressHUD showInfo: @"注册失败"];
                     }
                 }
                     AndFailureBack:^(NSString *_strError) {
                         ZWWLog(@"注册失败！详见：%@",_strError);
                         [YJProgressHUD showError:_strError];
                     }
                      WithisLoading:YES];
}


//MARK: - UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    // [S] 禁止用户切换键盘为Emoji表情
    if (textField.isFirstResponder) {
        if ([textField.textInputMode.primaryLanguage isEqual:@"emoji"] || textField.textInputMode.primaryLanguage == nil) {
            return NO;
        }
    }
    // [E] 禁止用户切换键盘为Emoji表情
    
    NSUInteger length = textField.text.length;
    NSUInteger strLength = string.length;
    
    //MARK:密码长度限制
    if(strLength != 0 && textField == self.txtPwd && length >= 20){
        return NO;
    }
    
    //MARK:邮箱长度
    else if(strLength != 0 && textField == self.txtEmail && length >= 35){
        return NO;
    }
    
    //MARK:昵称长度
    else if(strLength != 0 && textField == self.txtNickname && length >= kChineseLen){
        return NO;
    }
    
    //MARK:邀请码长度
    else if(strLength != 0 && textField == self.txtCode && length >= 20){
        return NO;
    }
    
    //回车注册
    if ([string isEqualToString:@"\n"]) {
        [self btnRegisterAction:nil];
    }
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self setHighLightStyle:textField];
}

-(void)setHighLightStyle:(UITextField *)txtCurrent{
    
    ANCustomTextField *_txtField;
    for (UIView *_view in [self.view subviews]) {
        if ([_view isKindOfClass:[ANCustomTextField classForCoder]]) {
            _txtField = (ANCustomTextField *)_view;
            
            //当前编辑文本宽，底部线高亮
            if (_txtField == txtCurrent) {
                [_txtField.bottomLine setBackgroundColor:K_HEAD_MENU_LINE_COLOR];
            }
            else{
                [_txtField.bottomLine setBackgroundColor:K_APP_SPLIT_LINE_COLOR];
            }
        }
        else{ continue; }
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.txtNickname) {
        return YES;
    }else{
        return YES;
    }
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
