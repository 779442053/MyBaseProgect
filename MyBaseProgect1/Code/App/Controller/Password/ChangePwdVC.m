

#import "ChangePwdVC.h"

#import "ChangePwdCell.h"

@interface ChangePwdVC () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *setTableView;

@property (nonatomic, strong) NSString *oldPwd;

@property (nonatomic, strong) NSString *nPwd;

@property (nonatomic, strong) NSString *nPwd1;

@property (nonatomic, strong) UIButton *btnOk;
@property(nonatomic,strong) UIImageView *backImg;
@end

@implementation ChangePwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initUI{
     [self.view addSubview:self.backImg];
    float w = K_APP_WIDTH - 80;
    float h = 21;
    float y = (44 - h) * 0.5 + ([[UIDevice currentDevice] isiPhoneX]?K_APP_IPHONX_TOP:20);
    float x = (K_APP_WIDTH - w) / 2.f;
    UILabel *labPageTitle = [BaseUIView createLable:CGRectMake(x, y, w, h)
                                            AndText:@"修改密码"
                                       AndTextColor:[UIColor whiteColor]
                                         AndTxtFont:[UIFont systemFontOfSize:24]
                                 AndBackgroundColor:nil];
    labPageTitle.textAlignment = NSTextAlignmentCenter;
    labPageTitle.textColor = [UIColor whiteColor];
    labPageTitle.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:labPageTitle];

    CGFloat w1 = 35;
    CGFloat x1 = [[UIDevice currentDevice] isSmallDevice]?15:25;
    CGFloat h1 = 35;
    CGFloat y1 = ([[UIDevice currentDevice] isiPhoneX]?K_APP_IPHONX_TOP:20) + (44 - h1) * 0.5;
    UIButton *BackBTN = [BaseUIView createBtn:CGRectMake(x1, y1, w1, h1) AndTitle:nil AndTitleColor:nil AndTxtFont:nil AndImage:nil AndbackgroundColor:nil AndBorderColor:nil AndCornerRadius:0 WithIsRadius:NO WithBackgroundImage:[UIImage imageNamed:@"nav_camera_back_black.png"] WithBorderWidth:0];
    [BackBTN addTarget:self action:@selector(BackBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:BackBTN];
    //MARK:发布
    [self.view addSubview:self.btnOk];
    
    [self.view addSubview:self.setTableView];
    
    [self.setTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(K_APP_NAVIGATION_BAR_HEIGHT + 10);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(410);
        make.right.mas_equalTo(-15);
    }];
}
-(void)BackBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
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
-(UIButton *)btnOk{
    if (!_btnOk) {
        float y = (44 - 21) * 0.5 + ([[UIDevice currentDevice] isiPhoneX]?K_APP_IPHONX_TOP:20);
        CGRect rect = CGRectMake(0, y, 35, 17);
        rect.origin.x = K_APP_WIDTH - 20 - rect.size.width;
        
        _btnOk = [BaseUIView createBtn:rect
                                   AndTitle:@"确定"
                              AndTitleColor:[UIColor whiteColor]
                                 AndTxtFont:[UIFont systemFontOfSize:15]
                                   AndImage:nil
                         AndbackgroundColor:nil
                             AndBorderColor:nil
                            AndCornerRadius:0.0
                               WithIsRadius:NO
                        WithBackgroundImage:nil
                            WithBorderWidth:0];
        
        [_btnOk addTarget:self
                   action:@selector(btnChangePwd:)
              forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnOk;
}


//MARK: - 修改密码
-(IBAction)btnChangePwd:(UIButton *)sender{

    if (![Utils checkTextEmpty:_oldPwd]) {
        [MBProgressHUD showError:@"请输入旧密码"];
    } else if (![Utils checkTextEmpty:_nPwd]) {
        [MBProgressHUD showError:@"请输入新密码"];
    } else if (![Utils checkPassword:_nPwd]) {
        [MBProgressHUD showError:@"密码长度为6-20位字母或数字组成"];
    } else if (![Utils checkTextEmpty:_nPwd1]){
        [MBProgressHUD showError:@"请再次输入新密码"];
    } else if (![_nPwd isEqualToString:_nPwd1]) {
        [MBProgressHUD showError:@"两次输入的密码不一样"];
    } else {
        
        NSString *strUrl = [NSString stringWithFormat:@"%@Password",K_APP_HOST];
        
        NSDictionary *dicParams = @{
                                    @"oldPassword":_oldPwd,
                                    @"newPassword":_nPwd
                                    };
        
        __weak typeof(self) weakSelf = self;
        [Utils putRequestForServerData:strUrl
                        withParameters:dicParams
                        AndSuccessBack:^(id  _Nullable _responseData, NSString * _Nullable strMsg) {
                            [MBProgressHUD showSuccess:@"修改密成功"];
                            [weakSelf.navigationController popViewControllerAnimated:YES];
                        } AndFailureBack:^(NSString * _Nullable _strError) {
                            ZWWLog(@"修改密码异常！详见:%@",_strError);
                            [MBProgressHUD showError:_strError];
                        } WithisLoading:YES];
    }
}

- (void)changedTextField:(id)sender{
    UITextField *textField = (UITextField *)sender;
    if (textField.tag == 0) {
        _oldPwd = textField.text;
    } else if (textField.tag == 1) {
        _nPwd = textField.text;
    } else {
        _nPwd1 = textField.text;
    }
}


//MARK: - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        ChangePwdCell *cell = [ChangePwdCell xibWithTableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.changeField.placeholder = @"请输入原密码";
        cell.changeField.backgroundColor = [UIColor clearColor];
        cell.changeField.tag = indexPath.row;
        cell.changeField.delegate = self;
        [cell.changeField setPlaceholderColor:[UIColor colorWithHexString:@"#999999"]];
        cell.TitleLB.text = @"原密码";
        [cell.changeField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
        return cell;
    }
    else if (indexPath.row == 1) {
        ChangePwdCell *cell = [ChangePwdCell xibWithTableView];
        cell.TitleLB.text = @"新密码";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.changeField.placeholder = @"请输入新密码";
        cell.changeField.backgroundColor = [UIColor clearColor];
        cell.changeField.tag = indexPath.row;
        [cell.changeField setPlaceholderColor:[UIColor colorWithHexString:@"#999999"]];
        [cell.changeField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
        return cell;
    } else {
        ChangePwdCell *cell = [ChangePwdCell xibWithTableView];
        cell.TitleLB.text = @"确认密码";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.changeField.placeholder = @"请再次输入新密码";
        cell.changeField.backgroundColor = [UIColor clearColor];
        cell.changeField.tag = indexPath.row;
        [cell.changeField setPlaceholderColor:[UIColor colorWithHexString:@"#999999"]];
        [cell.changeField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
        return cell;
    }
    return nil;
}
//MARK: -  lazy load
- (UITableView *)setTableView{
    if (!_setTableView) {
        _setTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        _setTableView.backgroundColor = [UIColor whiteColor];
        _setTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        _setTableView.dataSource = self;
        _setTableView.delegate = self;
        _setTableView.layer.shadowOffset = CGSizeMake(0,1);
        _setTableView.layer.shadowOpacity = 1;
        _setTableView.layer.shadowRadius = 7;
        _setTableView.layer.cornerRadius = 12.8;
        _setTableView.layer.shadowColor = [UIColor colorWithRed:39/255.0 green:30/255.0 blue:29/255.0 alpha:0.6].CGColor;
    }
    return _setTableView;
}
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
    if(strLength != 0 && textField.tag == 1 && length >= 20){
        return NO;
    }
    //回车登录
    if ([string isEqualToString:@"\n"]) {
        [self btnChangePwd:nil];
    }
    return YES;
}


@end

