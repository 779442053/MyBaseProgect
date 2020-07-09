

#import "RefreshTableViewController.h"

@interface RefreshTableViewController () {
    UIView *view;
    UIImageView *backgroundImg;
    UILabel *titleLabel;
}

@end

@implementation RefreshTableViewController

- (void)setMJrefreshHeader:(dispatch_block_t)block{
    //设置回调(一旦进入刷新状态，就调用target的action,也就是调用self的loadNewData方法)
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (block) {
            block();
        }
    }];
    
    //设置自动切换透明度
    header.automaticallyChangeAlpha = YES;
    
    //隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    
    self.refreshTableView.mj_header = header;
}

- (void)setAnimationMJrefreshHeader:(dispatch_block_t)block{
    self.refreshTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (block) {
            block();
        }
    }];
    
}

- (void)setMJrefreshFooter:(dispatch_block_t)block{
    self.refreshTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (block) {
            block();
        }
    }];
    //设置了底部inset
    self.refreshTableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
    //忽略底部inset
    self.refreshTableView.mj_footer.ignoredScrollViewContentInsetBottom = 30;
}

- (void)endHeaderRefresh {
    [self.refreshTableView.mj_footer endRefreshing];
}

- (void)endFooterRefresh{
    [self.refreshTableView.mj_footer endRefreshing];
}

- (void)endRefresh{
    [self endHeaderRefresh];
    [self endFooterRefresh];
}

- (void)hidenFooterView{
    [self.refreshTableView.mj_footer endRefreshingWithNoMoreData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.totalDataAry = [NSMutableArray array];
    self.refreshTableView.tableFooterView = [UIView new];
    self.currentPage = 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addBackBtn {
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -10;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"nav_camera_back_black.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"nav_camera_back_black.png"] forState:UIControlStateHighlighted];
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    button.size = CGSizeMake(40, 40);
    [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *imgBtnItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, imgBtnItem];
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)checkshowNoData{
    if (self.totalDataAry.count == 0) {
        
    } else {
        [view removeFromSuperview];
        return;
    }
    if (view == nil) {
        view = [[UIView alloc] initWithFrame:self.refreshTableView.frame];
        view.backgroundColor = [UIColor whiteColor];
        backgroundImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 128, 128)];
        backgroundImg.image = ims(@"search_empty_img.png");
        backgroundImg.center = CGPointMake(view.center.x, view.center.y-100);
        [view addSubview:backgroundImg];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
        titleLabel.center = CGPointMake(view.center.x, backgroundImg.center.y+backgroundImg.frame.size.height);
        titleLabel.text = @"暂时还没有数据";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = FONT(17);
        titleLabel.textColor = [UIColor grayColor];
        [view addSubview:titleLabel];
    }
    [self.refreshTableView addSubview:view];
}

- (void)beginFresh{
    [self.refreshTableView.mj_header beginRefreshing];
}


@end


