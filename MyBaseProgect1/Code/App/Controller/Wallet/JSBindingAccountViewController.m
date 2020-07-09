//
//  JSBindingAccountViewController.m


#import "JSBindingAccountViewController.h"
#import "JSBindingAliViewController.h"
#import "JSBindingBankViewController.h"

@interface JSBindingAccountViewController ()

@end

@implementation JSBindingAccountViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#EFEFEF"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
    //MARK:导航
    [self initNavgationBar:K_APP_NAVIGATION_BACKGROUND_COLOR
          AndHasBottomLine:NO
              AndHasShadow:YES
             WithHasOffset:0.0];
    
    //MARK:返回
    [self initNavigationBack:K_APP_BLACK_BACK];
    
    //MARK:标题
    [self initViewControllerTitle:@"绑定提现账户"
                     AndFontColor:K_APP_VIEWCONTROLLER_TITLE_COLOR
                       AndHasBold:NO
                      AndFontSize:K_APP_VIEWCONTROLLER_TITLE_FONT];
    
    UITapGestureRecognizer *aliGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(aliGesAction:)];
    self.aliView.userInteractionEnabled = YES;
    [self.aliView addGestureRecognizer:aliGes];
    
    UITapGestureRecognizer *bankGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bankGesAction:)];
    self.bankView.userInteractionEnabled = YES;
    [self.bankView addGestureRecognizer:bankGes];
}


//MARK: - action
-(void)aliGesAction:(id)sender{
    JSBindingAliViewController *aliVc = [[JSBindingAliViewController alloc] init];
    //aliVc.currentUserModel = [JSSingleton sharedTicket].curUserModel;
    aliVc.dismissType = 1;
    [self.navigationController pushViewController:aliVc animated:YES];
}

-(void)bankGesAction:(id)sender{
    JSBindingBankViewController *bankVc = [[JSBindingBankViewController alloc] init];
    //bankVc.currentUserModel = [JSSingleton sharedTicket].curUserModel;
    bankVc.dismissType = 1;
    [self.navigationController pushViewController:bankVc animated:YES];
}

@end
