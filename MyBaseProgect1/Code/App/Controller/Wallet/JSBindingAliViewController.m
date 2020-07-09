

#import "JSBindingAliViewController.h"

@interface JSBindingAliViewController ()
@property (weak, nonatomic) IBOutlet UITextField *inputAccountTF;
- (IBAction)sureBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *alipayUserNameTextF;

@end

@implementation JSBindingAliViewController

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
    [self initViewControllerTitle:@"绑定支付宝"
                     AndFontColor:K_APP_VIEWCONTROLLER_TITLE_COLOR
                       AndHasBold:NO
                      AndFontSize:K_APP_VIEWCONTROLLER_TITLE_FONT];
}

- (IBAction)sureBtnAction:(id)sender {
    
    if (_inputAccountTF.text.length < 3)
    {
        [MBProgressHUD showError:@"请输出正确的账号"];
        return;
    }
    if (_alipayUserNameTextF.text.length < 2)
    {
        [MBProgressHUD showError:@"请输出正确的姓名"];
        return;
    }
    
//    NSString *url = [BaseUrl stringByAppendingString:@"ChangeAccount"];
//    NSDictionary *parameter = @{
//                                @"AlipayAccount":_inputAccountTF.text,
//                                @"AlipayUser":_alipayUserNameTextF.text,
//                                @"WeChatAccount":@"",
//                                @"WeChatUser":@"",
//                                @"BankAccount": _currentUserModel.bankAccount,
//                                @"Bank": _currentUserModel.bank,
//                                @"RealName": _currentUserModel.realName,
//                                @"IDCardNum": _currentUserModel.idCardNum,
//                                @"BankAddress": _currentUserModel.bankAddress,
//                                @"BankBranch": _currentUserModel.bankBranch,
//                                @"BankBindPhone": _currentUserModel.bankBindPhone,
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
//               [self.navigationController popViewControllerAnimated:YES];
//            }
//            
//        }
//    } failure:^(NSError * _Nonnull error) {
//        ZWWLog(@"error = %@",error);
//    }];
}
@end
