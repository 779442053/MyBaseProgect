//
//  JSBindingBankViewController.m


#import "JSBindingBankViewController.h"

@interface JSBindingBankViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *numberTF;
@property (weak, nonatomic) IBOutlet UITextField *bankNamTF;
@property (weak, nonatomic) IBOutlet UITextField *branchBankNameTF;
- (IBAction)sureBtnAction:(id)sender;

@end

@implementation JSBindingBankViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#EFEFEF"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //MARK:导航
    [self initNavgationBar:K_APP_NAVIGATION_BACKGROUND_COLOR
          AndHasBottomLine:NO
              AndHasShadow:YES
             WithHasOffset:0.0];
    
    //MARK:返回
    [self initNavigationBack:K_APP_BLACK_BACK];
    
    //MARK:标题
    [self initViewControllerTitle:@"绑定银行卡"
                     AndFontColor:K_APP_VIEWCONTROLLER_TITLE_COLOR
                       AndHasBold:NO
                      AndFontSize:K_APP_VIEWCONTROLLER_TITLE_FONT];
}

- (IBAction)sureBtnAction:(id)sender {
    
    if (_nameTF.text.length < 1)
    {
        [MBProgressHUD showError:@"请输出正确的姓名"];
        return;
    }
    if (_numberTF.text.length < 15)
    {
        [MBProgressHUD showError:@"请输出正确的银行卡"];
        return;
    }
    if (_bankNamTF.text.length < 3)
    {
        [MBProgressHUD showError:@"请输出正确银行"];
        return;
    }
    if (_branchBankNameTF.text.length < 3)
    {
        [MBProgressHUD showError:@"请输出正确开户行"];
        return;
    }
    
//    NSString *url = [BaseUrl stringByAppendingString:@"ChangeAccount"];
//    NSDictionary *parameter = @{
//                                @"AlipayAccount":_currentUserModel.alipayAccount,
//                                @"AlipayUser":@"",
//                                @"WeChatAccount":@"",
//                                @"WeChatUser":@"",
//                                @"BankAccount":_numberTF.text,
//                                @"Bank": _bankNamTF.text,
//                                @"RealName": _branchBankNameTF.text,
//                                @"IDCardNum": @"",
//                                @"BankAddress": @"",
//                                @"BankBranch": _branchBankNameTF.text,
//                                @"BankBindPhone": @"",
//                                };
//
//    [JSSingleton PUTWithURLString:url parameters:parameter success:^(id  _Nonnull responseObject) {
//        ZWWLog(@"responseObject = %@",responseObject);
//        if ([responseObject[@"resultCode"] integerValue] == 0)
//        {
//            [MyProgressHUD showSuccessWithText:@"绑定成功"];
//            if (_dismissType == 1)
//            {
//                int index = (int)[[self.navigationController viewControllers]indexOfObject:self];
//                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index -2)] animated:YES];
//            }else{
//                [self.navigationController popViewControllerAnimated:YES];
//            }
//        }
//    } failure:^(NSError * _Nonnull error) {
//        ZWWLog(@"error = %@",error);
//    }];
}
@end
