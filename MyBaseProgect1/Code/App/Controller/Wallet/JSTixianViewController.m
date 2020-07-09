//


#import "JSTixianViewController.h"

@interface JSTixianViewController ()
@property (weak, nonatomic) IBOutlet UIView *tixianTypeView;
@property (weak, nonatomic) IBOutlet UITextField *inputTF;
@property (weak, nonatomic) IBOutlet UILabel *allMoneyLab;
@property (weak, nonatomic) IBOutlet UIButton *allTixianBtn;

@property (weak, nonatomic) IBOutlet UILabel *tixianToLab;
@property (weak, nonatomic) IBOutlet UILabel *tixianCardNumLab;

- (IBAction)allTixianBtnAction:(id)sender;
- (IBAction)suerBtnAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewBottomDis;
@property (weak, nonatomic) IBOutlet UIView *bankView;
@property (weak, nonatomic) IBOutlet UIView *aliView;

@property (nonatomic, copy) NSString *selTypeStr;

@end

@implementation JSTixianViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#EFEFEF"];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initNavgationBar:K_APP_NAVIGATION_BACKGROUND_COLOR AndHasBottomLine:NO AndHasShadow:NO WithHasOffset:0];
    //MARK:返回
    [self initNavigationBack:K_APP_BLACK_BACK];

    //MARK:标题
    [self initViewControllerTitle:@"我的提现"
                     AndFontColor:K_APP_VIEWCONTROLLER_TITLE_COLOR
                       AndHasBold:NO
                      AndFontSize:K_APP_VIEWCONTROLLER_TITLE_FONT];
    
    UITapGestureRecognizer *coverViewGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverviewDiss)];
    [self.coverView addGestureRecognizer:coverViewGes];
    
    UITapGestureRecognizer *typeViewGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choseTixanTypeAction)];
    [self.tixianTypeView addGestureRecognizer:typeViewGes];
    
    self.coverView.hidden = YES;
    
    UITapGestureRecognizer *type1Ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bankViewClick)];
    [self.bankView addGestureRecognizer:type1Ges];
    
    UITapGestureRecognizer *type2Ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(aliViewClick)];
    [self.aliView addGestureRecognizer:type2Ges];
    
    // Do any additional setup after loading the view from its nib.
    self.allMoneyLab.text = [NSString stringWithFormat:@"%.2f",_currentUserModel.balance];
    self.selTypeStr = @"0";
}

//弹出选项中银行卡被点击
- (void)bankViewClick
{
    [self coverviewDiss];
    self.tixianToLab.text = @"提现至银行卡";
    self.tixianCardNumLab.text = _currentUserModel.bankAccount;
    self.selTypeStr = @"2";
}
//弹出选项中支付宝被点击
- (void)aliViewClick
{
    [self coverviewDiss];
    self.tixianToLab.text = @"提现至支付宝";
    self.tixianCardNumLab.text = _currentUserModel.alipayAccount;
    self.selTypeStr = @"0";
}

//点击上方体现的方式选择的view点击事件
- (void)choseTixanTypeAction
{
    self.coverView.hidden = NO;
}

- (void)coverviewDiss
{
    self.coverView.hidden = YES;
}

- (IBAction)allTixianBtnAction:(id)sender {
    _inputTF.text = [NSString stringWithFormat:@"%.2f",_currentUserModel.balance];
}

- (IBAction)suerBtnAction:(id)sender {
    
//    NSString *url = [BaseUrl stringByAppendingString:@"Withdrawal"];
//    NSDictionary *parameter = @{@"Money":_inputTF.text,@"Type":self.selTypeStr};
//    
//    [JSSingleton PUTWithURLString:url parameters:parameter success:^(id  _Nonnull responseObject) {
//         ZWWLog(@"responseObject = %@",responseObject);
//        if ([responseObject[@"resultCode"] integerValue] == 0)
//        {
//            //提现成功
//            [MyProgressHUD showSuccessWithText:@"提现成功"];
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//    } failure:^(NSError * _Nonnull error) {
//         ZWWLog(@"error = %@",error);
//    }];
    
}
@end