//
//  LoginViewController.m
//  KuaiZhu
//
//  Created by Ghy on 2019/5/13.
//  Copyright © 2019年 su. All rights reserved.
//

#import "LoginVC.h"
#import "NLSliderSwitchProtocol.h"

#define k_margin 22.5
#define k_view_height 50
#define k_top_margin ([[UIDevice currentDevice] isSmallDevice]?0:10)
#define TextColor [[UIColor alloc] colorFromHexInt:0x999999 AndAlpha:1.0]

@interface LoginVC ()<UITextFieldDelegate,NLSliderSwitchProtocol>

@property (nonatomic, strong) UIView            *contentView;   //内容视图
@property (nonatomic, strong) ANCustomTextField *txtEmail;      //邮箱
@property (nonatomic, strong) ANCustomTextField *txtPwd;        //密码
@property (nonatomic, strong) UIButton          *btnLogin;      //登录

@end

@implementation LoginVC

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
    //MARK:邮箱
    [self.contentView addSubview:self.txtEmail];
    //MARK:密码
    [self.contentView addSubview:self.txtPwd];
    
    //MARK:登录
    [self.view addSubview:self.btnLogin];

}


//MARK: - lazy load
-(UIView *)contentView {
    if (!_contentView) {
        CGFloat x = 0;
        CGFloat w = K_APP_WIDTH - 2 * x;
        _contentView = [BaseUIView createView:CGRectMake(x, 0, w, k_view_height *2 +1)
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
        _txtEmail.keyboardType = UIKeyboardTypeEmailAddress;//UIKeyboardTypeEmailAddress UIKeyboardTypeNumberPad
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
        rect.origin.y += rect.size.height;
        
        _txtPwd = [[ANCustomTextField alloc] initWithFrame:rect];
        _txtPwd.placeholder = @"请输入密码";
        
        _txtPwd.delegate = self;
        _txtPwd.hasBorder = NO;
        _txtPwd.hasBottomBorder = YES;
        _txtPwd.borderStyle = UITextBorderStyleNone;
        //_txtPwd.bottomLine.backgroundColor = K_APP_SPLIT_LINE_COLOR;
        
        //密码框
        _txtPwd.secureTextEntry = YES;
        
        //显示清除按钮
        _txtPwd.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        _txtPwd.keyboardType = UIKeyboardTypeDefault;
        _txtPwd.returnKeyType = UIReturnKeyJoin;
    }
    return _txtPwd;
}

-(UIButton *)btnLogin{
    if (!_btnLogin) {
        CGFloat w = K_APP_WIDTH - 60;
        CGFloat h = 46;
        CGFloat x = (K_APP_WIDTH - w) * 0.5;
        CGFloat y = self.contentView.origin.y + self.contentView.size.height + 25;
        _btnLogin = [BaseUIView createBtn:CGRectMake(x, y, w, h)
                                 AndTitle:@"登录"
                            AndTitleColor:[UIColor colorWithHexString:@"#FFFFFF"]
                               AndTxtFont:[UIFont systemFontOfSize:14]
                                 AndImage:nil
                       AndbackgroundColor:[UIColor colorWithHexString:@"#66C0FF"]
                           AndBorderColor:nil
                          AndCornerRadius:h*0.5
                             WithIsRadius:YES
                      WithBackgroundImage:nil
                          WithBorderWidth:0.0];
        
        [_btnLogin addTarget:self action:@selector(btnLoginAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnLogin;
}


//MARK: - 登录
-(IBAction)btnLoginAction:(UIButton *)sender{
    
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
    //手机号登录
    NSDictionary *dicData = @{
                              //@"phone":strUserName,
                              @"email":strUserName,
                              @"password":strPassword,
                              @"deviceID":[Utils dy_getIDFV]
                              };
    
    [[LoginViewController shareInstance] logininApp:dicData];
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
    
    //回车登录
    if ([string isEqualToString:@"\n"]) {
        [self btnLoginAction:nil];
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
@end
