//
//  MBProgressHUD+TJ.m
//  BYOD
//
//  Created by liujia on 2018/5/3.
//  Copyright © 2018年 360tianji. All rights reserved.
//

#import "MBProgressHUD+TJ.h"

@interface MBProgressHUD ()

@end

@implementation MBProgressHUD (TJ)

+ (UIWindow*) getTopWindow
{
    if (@available(iOS 13.0, *)) {
      return [UIApplication sharedApplication].keyWindow;
    }else{
        NSArray *windows = [UIApplication sharedApplication].windows;
        for(UIWindow *window in [windows reverseObjectEnumerator]) {
            if ([window isKindOfClass:[UIWindow class]] && CGRectEqualToRect(window.bounds, [UIScreen mainScreen].bounds)  && window.hidden == NO) {
                return window;
            }
        }
    }
    return [UIApplication sharedApplication].keyWindow;
}

/*
 * 显示指定图标的提示框，通常为成功或者失败
 * view的选择，要么是顶层window，要么是某个view，这个选择决定了框弹出来的时候后面的按钮能不能点
 * 请参考这篇文章：http://blog.leichunfeng.com/blog/2015/03/16/talking-about-the-usage-of-mbprogresshud-combined-with-reveal/
 */
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil){
        view = [self getTopWindow];
    }

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.label.text = text;
    hud.label.textColor = [UIColor whiteColor];
    hud.label.font = [UIFont systemFontOfSize:16.0];
    hud.label.numberOfLines = 0;
    hud.bezelView.color = [UIColor blackColor];
    hud.bezelView.alpha = 0.85f;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.contentColor = [UIColor whiteColor];
    UIImage *image = [UIImage imageNamed:icon];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    
    hud.userInteractionEnabled = NO;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:1.5];
}

/**
 *  显示完成提示
 *  @param success text message
 */
+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}

/**
 *  显示完成提示
 *  @param success text message
 *  @view which is to add by
 */
+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"smile" view:view];
}

/**
 *  显示错误提示
 */
+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}

/**
 *  显示错误提示
 *  @param error text message
 *  @view which is to add by
 */
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"sad3" view:view];
}

/**
 *  显示加载菊花+文字，需手动停止
 *  @param message message to show
 *  @return MBProgressHUD实例
 */
+ (MBProgressHUD *)showLoadingMessage:(NSString *)message
{
    return [self showLoadingMessage:message toView:nil];
}

/**
 *  显示加载菊花+文字，需手动停止
 *  @param message message to show
 *  @param view    which is to add by
 *  @return MBProgressHUD实例
 */
+ (MBProgressHUD *)showLoadingMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) {
        view = [self getTopWindow];
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = message;
    hud.label.textColor = [UIColor whiteColor];
    hud.label.font = [UIFont systemFontOfSize:16.0];
    hud.bezelView.color = [UIColor blackColor];
    hud.bezelView.alpha = 0.85f;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.contentColor = [UIColor whiteColor];
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}

+ (void)showLongDEBUGText:(NSString *)text toView:(UIView *)view {
    [self showLongText:text toView:view];
}

/**
 *  toast文字提示
 */
+ (void)toast:(NSString *)message
{
    [self toast:message toView:nil];
}

/**
 *  toast文字提示
 *  @param view which is to add by
 */
+ (void)toast:(NSString *)message toView:(UIView *)view
{
    if (view == nil){
        view = [self getTopWindow];
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = message;
    hud.label.textColor = [UIColor whiteColor];
    hud.label.font = [UIFont systemFontOfSize:16.0];
    hud.label.numberOfLines = 0;
    hud.bezelView.color = [UIColor blackColor];
    hud.bezelView.alpha = 0.85f;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.userInteractionEnabled = NO;
    
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:1.5];
}

/**
 *  关闭所有
 */
+ (void)hideHUD
{
    [self hideHUDForView:nil];
}



/**
 *  关闭HUD视图
 *  @param view view to hide
 */
+ (void)hideHUDForView:(UIView *)view
{
    if (view == nil) {
        view = [self getTopWindow];
    }
    [self hideHUDForView:view animated:YES];
}

/**
 显示长文本提示

 @param text 提示内容
 */
+ (void)showLongText:(NSString *)text toView:(UIView *)view {
    if (view == nil) {
        view = [self getTopWindow];
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.detailsLabel.text = text;
    hud.label.textColor = [UIColor whiteColor];
    hud.label.font = [UIFont systemFontOfSize:16.0];
    hud.bezelView.color = [UIColor blackColor];
    hud.bezelView.alpha = 0.85f;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.contentColor = [UIColor whiteColor];

    
    hud.userInteractionEnabled = NO;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:4.0];
}

@end
