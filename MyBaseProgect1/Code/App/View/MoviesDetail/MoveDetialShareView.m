//
//  MoveDetialShareView.m
//  KuaiZhu
//
//  Created by step_zhang on 2019/11/25.
//  Copyright © 2019 su. All rights reserved.
//

#import "MoveDetialShareView.h"
@interface MoveDetialShareView()
@property (nonatomic, strong) UIView *BottomView;//下面的自定义view
@end
@implementation MoveDetialShareView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addElement];
    }
    return self;
}
- (void)addElement{
    self.backgroundColor = [UIColor blackColor];//背景
    self.alpha = 0.2;
    _BottomView = [[UIView alloc]init];
    _BottomView.backgroundColor = [UIColor clearColor];
    _BottomView.layer.cornerRadius = 5;
    
    UIImageView *bgImageView = [[UIImageView alloc]init];
    bgImageView.frame = CGRectMake(0, 0, K_APP_WIDTH - 40, K_APP_HEIGHT * 2/3);
    bgImageView.image = [UIImage imageNamed:@"share_bg"];
    bgImageView.userInteractionEnabled = YES;
    [self.BottomView addSubview:bgImageView];
    
    //叉号
    UIButton *disBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [disBtn setBackgroundImage:[UIImage imageNamed:@"login_exit"] forState:UIControlStateNormal];
    disBtn.frame = CGRectMake(K_APP_WIDTH - 40 - 42, CGRectGetMidY(bgImageView.frame) - 60, 30, 30);
    [disBtn addTarget:self action:@selector(CloseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgImageView addSubview:disBtn];
    
    [bgImageView addSubview:self.CodeImageView];
    self.CodeImageView.frame = CGRectMake(10, K_APP_HEIGHT * 2/6, 153, 153);
    [bgImageView addSubview:self.labTitle];
    self.labTitle.frame = CGRectMake((K_APP_WIDTH - 40)/2, CGRectGetMaxY(self.CodeImageView.frame) - 40, CGRectGetWidth(bgImageView.frame)/2 - 10, 70);
    
    UIView *botView = [[UIView alloc]init];
    botView.backgroundColor = [UIColor clearColor];
    [self.BottomView addSubview:botView];
    botView.frame = CGRectMake(0, K_APP_HEIGHT * 2/3 - 88, K_APP_WIDTH - 60, 88);
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.frame = CGRectMake(20, 0, (K_APP_WIDTH - 60)/2 - 20, 47);
    [cancleBtn setBackgroundImage:[UIImage imageNamed:@"guanyingBtnBg"] forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(btnQQAction:) forControlEvents:UIControlEventTouchUpInside];
    [botView addSubview:cancleBtn];
    
    UIButton *SureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    SureBtn.frame = CGRectMake((K_APP_WIDTH - 60)/2 + 20, 0, (K_APP_WIDTH - 60)/2 - 20, 47);
    [SureBtn setBackgroundImage:[UIImage imageNamed:@"copyBtnBg"] forState:UIControlStateNormal];
    [SureBtn addTarget:self action:@selector(btnCopyAction:) forControlEvents:UIControlEventTouchUpInside];
    [botView addSubview:SureBtn];
}
-(void)CloseBtnClick:(UIButton *)sender{
    [self dismissAlert];
}
- (void)showAlert {
    [self.vc.view addSubview:self];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAlert)]];
    //遮罩
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.5;
    }];
    [self.vc.view addSubview:_BottomView];
    [_BottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.mas_offset(20);
        make.right.equalTo(self).with.mas_offset(-20);
        make.top.equalTo(self).with.mas_offset(30 + K_APP_NAVIGATION_BAR_HEIGHT);
        make.height.mas_equalTo(K_APP_HEIGHT *2/3);
    }];
    _BottomView.layer.cornerRadius = 5;
    _BottomView.layer.masksToBounds = YES;
    
    self.BottomView.transform = CGAffineTransformMakeTranslation(0.01, K_APP_WIDTH);
    [UIView animateWithDuration:0.3 animations:^{
        self.BottomView.transform = CGAffineTransformMakeTranslation(0.01, 0.01);
    }];
}
- (void)dismissAlert {
    [UIView animateWithDuration:0.3 animations:^{
        self.BottomView.transform = CGAffineTransformMakeTranslation(0.01, K_APP_WIDTH);
        self.BottomView.alpha = 0.2;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.BottomView removeFromSuperview];
    }];
}

//QQ点击
-(void)btnQQAction:(UIButton *)sender{
    [self dismissAlert];
    if (_shareTypeBlock) {
        _shareTypeBlock(1);
    }
}

//复制点击
-(void)btnCopyAction:(UIButton *)sender{
    [self dismissAlert];
    if (_shareTypeBlock) {
        _shareTypeBlock(3);
    }
    NSLog(@"复制点击");
}
-(UILabel *)labTitle{
    if (_labTitle == nil) {
        _labTitle = [[UILabel alloc]init];
        _labTitle.textColor = [UIColor colorWithHexString:@"#F400D4"];
        _labTitle.font = [UIFont systemFontOfSize:15];
        _labTitle.numberOfLines = 0;
    }
    return _labTitle;
}
-(UIImageView *)CodeImageView{
    if (_CodeImageView == nil) {
        _CodeImageView = [[UIImageView alloc]init];
    }
    return _CodeImageView;
}
@end
