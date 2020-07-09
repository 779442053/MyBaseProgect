//
//  UIViewController+ZWAlertViewAndActionSheet.m
//  共享蜂
//
//  Created by 张威威 on 2017/12/17.
//  Copyright © 2017年 张威威. All rights reserved.
//

#import "UIViewController+ZWAlertViewAndActionSheet.h"
#ifdef kiOS8Later

#else
static click clickIndex = nil;
static clickHaveField clickIncludeFields = nil;
static click clickDestructive = nil;
#endif
static NSMutableArray *fields = nil;
@implementation UIViewController (ZWAlertViewAndActionSheet)

//- (ZWAlterViewPop *)alertView1title:(NSString *)title message:(NSString *)message {
//    ZWAlterViewPop *alertView = [[ZWAlterViewPop alloc] initWithTitle:title
//                                                              message:message
//                                                        constantWidth:290];
//    return alertView;
//}
//- (ZWAlterViewPop *)alertViewTwotitle:(NSString *)title message:(NSString *)message{
//    ZWAlterViewPop *alertView = [[ZWAlterViewPop alloc] initWithTitle:title
//                                                              message:message
//                                                        constantWidth:250];
//    alertView.titleLabel.textColor = [UIColor colorWithRed:80 green:72 blue:83 alpha:1];
//    alertView.titleLabel.font = [UIFont boldSystemFontOfSize:20];
//    alertView.messageLabel.textColor = [UIColor blackColor];
//    return alertView;
//}
//- (zhOverflyView *)overflyViewtitle:(NSString *)title titletwo:(NSString*)titletwo message:(NSString *)message{
//    NSString *title1 = title, *title2 = titletwo;
//    NSString *text = [NSString stringWithFormat:@"%@\n%@", title1, title2];
//    NSMutableAttributedString *attiTitle = [[NSMutableAttributedString alloc] initWithString:text];
//
//    [attiTitle addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:[text rangeOfString:title1]];
//    [attiTitle addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:[text rangeOfString:title1]];
//
//    [attiTitle addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:236 green:78 blue:39 alpha:1] range:[text rangeOfString:title2]];
//    [attiTitle addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:[text rangeOfString:title2]];
//
//    [attiTitle addAttribute:NSKernAttributeName value:@1.2 range:[text rangeOfString:title2]];//字距调整
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setLineSpacing:7];
//    [attiTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];//行距调整
//
//    NSString *msg = message;
//    NSMutableAttributedString *attiMessage = [[NSMutableAttributedString alloc] initWithString:msg];
//    [attiMessage addAttribute:NSKernAttributeName value:@1.1 range:NSMakeRange(0, [msg length])];
//    NSMutableParagraphStyle *paragraphStyle2 = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle2 setLineSpacing:7];
//    [attiMessage addAttribute:NSParagraphStyleAttributeName value:paragraphStyle2 range:NSMakeRange(0, [msg length])];
//    [attiMessage addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, [msg length])];
//    [attiMessage addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:49 green:49 blue:39 alpha:1] range:NSMakeRange(0, [msg length])];
//
//    CGFloat fac = 475; // 已知透明区域高度
//    UIImage *image = [UIImage imageNamed:@"fire_arrow"];
//    
//    zhOverflyView *overflyView = [[zhOverflyView alloc]
//                                  initWithFlyImage:image
//                                  highlyRatio:(fac / image.size.height)
//                                  attributedTitle:attiTitle
//                                  attributedMessage:attiMessage
//                                  constantWidth:290];
//    overflyView.layer.cornerRadius = 4;
//    overflyView.messageEdgeInsets = UIEdgeInsetsMake(10, 22, 10, 22);
//    overflyView.titleLabel.backgroundColor = [UIColor whiteColor];
//    overflyView.titleLabel.textAlignment = NSTextAlignmentCenter;
//    overflyView.splitLine.hidden = YES;
//    [overflyView reloadAllComponents];
//    return overflyView;
//}

#pragma mark - *****  alert view
- (void)AlertWithTitle:(NSString *)title
               message:(NSString *)message
             andOthers:(NSArray<NSString *> *)others
              animated:(BOOL)animated
                action:(click)click
{
#ifdef kiOS8Later
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [others enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx == 0)
        {
            [alertController addAction:[UIAlertAction actionWithTitle:obj style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                if (action && click)
                {
                    click(idx);
                }
            }]];
        }
        else
        {
            [alertController addAction:[UIAlertAction actionWithTitle:obj style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                if (action && click)
                {
                    click(idx);
                }
            }]];
        }
    }];
    
    [self presentViewController:alertController animated:YES completion:nil];
#else
    UIAlertView *alertView = nil;
    if (others.count > 0)
    {
        alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:others[0] otherButtonTitles: nil];
    }
    else
    {
        alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
    }
    
    [others enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx != 0)
        {
            [alertView addButtonWithTitle:obj];
        }
    }];
    
    clickIndex = click;
    
    [alertView show];
#endif
}

#pragma mark - *****  alertView delegate

#ifdef kiOS8Later

#else
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (clickIndex)
    {
        clickIndex(buttonIndex);
    }
    else if (clickIncludeFields)
    {
        clickIncludeFields(fields,buttonIndex);
    }
    
    clickIndex = nil;
    clickIncludeFields = nil;
}
#endif

#pragma mark - *****  sheet
- (void)ActionSheetWithTitle:(NSString *)title
                     message:(NSString *)message
                 destructive:(NSString *)destructive
           destructiveAction:(click )destructiveAction
                   andOthers:(NSArray <NSString *> *)others
                    animated:(BOOL )animated
                      action:(click )click
{
#ifdef kiOS8Later
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    
    if (destructive)
    {
        [alertController addAction:[UIAlertAction actionWithTitle:destructive style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            if (action)
            {
                destructiveAction(NO_USE);
            }
        }]];
    }
    
    
    [others enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0)
        {
            [alertController addAction:[UIAlertAction actionWithTitle:obj style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                if (action && click)
                {
                    click(idx);
                }
            }]];
        }
        else
        {
            [alertController addAction:[UIAlertAction actionWithTitle:obj style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (action && click)
                {
                    click(idx);
                }
            }]];
        }
        
    }];
    
    [self presentViewController:alertController animated:animated completion:nil];
    
#else
    UIActionSheet *sheet = nil;
    if (others.count > 0 && destructive)
    {
        sheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:others[0] destructiveButtonTitle:destructive otherButtonTitles:nil];
    }
    else
    {
        sheet = [[UIActionSheet alloc] initWithTitle:title delegate:nil cancelButtonTitle:nil destructiveButtonTitle:destructive otherButtonTitles:nil];
    }
    
    [others enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx != 0)
        {
            [sheet addButtonWithTitle:obj];
        }
    }];
    clickIndex = click;
    clickDestructive = destructiveAction;
    [sheet showInView:self.view];
#endif
}

#ifdef kiOS8Later

#else
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        if (clickDestructive)
        {
            clickDestructive(NO_USE);
        }
    }
    else
    {
        if (clickIndex)
        {
            clickIndex(buttonIndex - 1);
        }
    }
}
#endif

#pragma mark - *****  textField
- (void)AlertWithTitle:(NSString *)title
               message:(NSString *)message
               buttons:(NSArray<NSString *> *)buttons
       textFieldNumber:(NSInteger )number
         configuration:(configuration )configuration
              animated:(BOOL )animated
                action:(clickHaveField )click
{
    if (fields == nil)
    {
        fields = [NSMutableArray array];
    }
    else
    {
        [fields removeAllObjects];
    }
    
#ifdef kiOS8Later
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    // textfield
    for (NSInteger i = 0; i < number; i++)
    {
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            [fields addObject:textField];
            configuration(textField,i);
        }];
    }
    
    // button
    [buttons enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0)
        {
            [alertController addAction:[UIAlertAction actionWithTitle:obj style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                if (action && click)
                {
                    click(fields,idx);
                }
            }]];
        }
        else
        {
            [alertController addAction:[UIAlertAction actionWithTitle:obj style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (action && click)
                {
                    click(fields,idx);
                }
            }]];
        }
    }];
    [self presentViewController:alertController animated:animated completion:nil];
#else
    UIAlertView *alertView = nil;
    if (buttons.count > 0)
    {
        alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:buttons[0] otherButtonTitles:nil];
    }
    else
    {
        alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    }
    // field
    if (number == 1)
    {
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    }
    else if (number > 2)
    {
        alertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    }
    
    // configuration field
    if (alertView.alertViewStyle == UIAlertViewStyleLoginAndPasswordInput)
    {
        [fields addObject:[alertView textFieldAtIndex:0]];
        [fields addObject:[alertView textFieldAtIndex:1]];
        
        configuration([alertView textFieldAtIndex:0],0);
        configuration([alertView textFieldAtIndex:1],1);
    }
    else if(alertView.alertViewStyle == UIAlertViewStylePlainTextInput || alertView.alertViewStyle == UIAlertViewStyleSecureTextInput)
    {
        [fields addObject:[alertView textFieldAtIndex:0]];
        configuration([alertView textFieldAtIndex:0],0);
    }
    
    // other button
    [buttons enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx != 0)
        {
            [alertView addButtonWithTitle:obj];
        }
    }];
    clickIncludeFields = click;
    
    [alertView show];
#endif
}
@end
