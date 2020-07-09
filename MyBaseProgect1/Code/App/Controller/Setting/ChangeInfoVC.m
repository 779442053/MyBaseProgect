//


#import "ChangeInfoVC.h"
#import "RefreshTableViewController.h"

@interface ChangeInfoVC ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *changeField;

@end

@implementation ChangeInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController.toolbar setHidden:NO];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setHidden:YES];
    [self.navigationController.toolbar setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initUI{
    [self addBackBtn];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, K_APP_NAVIGATION_BAR_HEIGHT, K_APP_WIDTH, K_APP_HEIGHT)];
    [self.view addSubview:view];
    view.backgroundColor = [UIColor whiteColor];
    
    //
    ZWWLog(@"昵称:%@",[UserModel shareInstance].name);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(confirm)];
    if (self.changeType == 0) {
        self.title = @"修改昵称";
        [_changeField setText:[UserModel shareInstance].name];
        [_changeField becomeFirstResponder];
    } else {
        self.title = @"修改邮箱";
        [_changeField setText:[UserModel shareInstance].email];
        [_changeField becomeFirstResponder];
    }
    [view addSubview:self.changeField];
    [self.changeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(40);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(35);
    }];
    
}

//MARK: - Action
- (void)confirm{
    //MARK:修改昵称
    if (self.changeType == 0) {
        if (![Utils checkName:self.changeField.text AndLength:kChineseLen]) {
            [MBProgressHUD showError:@"请输入昵称"];
        }
        else {
            NSString *strUrl = [NSString stringWithFormat:@"%@NickName",K_APP_HOST];
            NSDictionary *dicParams = @{@"nickName":self.changeField.text};
            __weak typeof(self) weakSelf = self;
            [Utils putRequestForServerData:strUrl
                            withParameters:dicParams
                            AndSuccessBack:^(id _responseData, NSString *strMsg) {
                                [YJProgressHUD showSuccess:(strMsg && ![strMsg isKindOfClass:[NSNull class]])?strMsg:@"修改成功"];
                                
                                NSMutableDictionary *objUserData = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:K_APP_LOGIN_DATA_KEY]];
                                if(objUserData){
                                    [objUserData setValue:weakSelf.changeField.text forKey:@"name"];
                                }
                                
                                //保存
                                [[NSUserDefaults standardUserDefaults] setObject:objUserData forKey:K_APP_LOGIN_DATA_KEY];
                                
                                [weakSelf.navigationController popViewControllerAnimated:YES];
                            }
                            AndFailureBack:^(NSString *_strError) {
                                ZWWLog(@"修改昵称异常！详见：%@",_strError);
                                [YJProgressHUD showError:_strError];
                            }
                             WithisLoading:YES];
        }
    }
    //MARK:修改邮箱
    else{
        if (![Utils checkEmail:self.changeField.text]) {
            [YJProgressHUD showError:@"请输入邮箱"];
        }
        else {
            NSString *strUrl = [NSString stringWithFormat:@"%@Email",K_APP_HOST];
            NSDictionary *dicParams = @{@"email":self.changeField.text};
            
            __weak typeof(self) weakSelf = self;
            [Utils putRequestForServerData:strUrl
                            withParameters:dicParams
                            AndSuccessBack:^(id _responseData, NSString *strMsg) {
                                [YJProgressHUD showSuccess:(strMsg && ![strMsg isKindOfClass:[NSNull class]])?strMsg:@"修改成功"];
                                
                                NSMutableDictionary *objUserData = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:K_APP_LOGIN_DATA_KEY]];
                                if(objUserData){
                                    [objUserData setValue:weakSelf.changeField.text forKey:@"email"];
                                }
                                
                                //保存
                                [[NSUserDefaults standardUserDefaults] setObject:objUserData forKey:K_APP_LOGIN_DATA_KEY];
                                
                                [weakSelf.navigationController popViewControllerAnimated:YES];
                            }
                            AndFailureBack:^(NSString *_strError) {
                                ZWWLog(@"修改昵称异常！详见：%@",_strError);
                                [YJProgressHUD showError:_strError];
                            }
                             WithisLoading:YES];
        }
    }
}


//MARK: - lazy load
- (UITextField *)changeField{
    if (!_changeField) {
        _changeField = [UITextField new];
        _changeField.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        _changeField.textColor = [UIColor colorWithHexString:@"#999999"];
        _changeField.delegate = self;
        _changeField.returnKeyType = UIReturnKeySend;
        
        if (self.changeType == 0) {
            _changeField.placeholder = @"请输入昵称";
            _changeField.keyboardType = UIKeyboardTypeDefault;
        } else {
            _changeField.placeholder = @"请输入邮箱";
            _changeField.keyboardType = UIKeyboardTypeEmailAddress;
        }
        [_changeField setPlaceholderColor:[UIColor colorWithHexString:@"#999999"]];
        
    }
    return _changeField;
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
    
    //MARK:邮箱长度
    if(strLength != 0 && textField == self.changeField && self.changeType != 0 && length >= 35){
        return NO;
    }
    
    //MARK:昵称长度
    else if(strLength != 0 && textField == self.changeField && self.changeType == 0 && length >= kChineseLen){
        return NO;
    }
    
    //回车提交
    if ([string isEqualToString:@"\n"]) {
        [self confirm];
    }
    
    return YES;
}

@end

