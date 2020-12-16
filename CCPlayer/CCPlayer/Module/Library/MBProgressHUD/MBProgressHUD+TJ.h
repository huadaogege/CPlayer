//
//  MBProgressHUD+TJ.h
//  BYOD
//
//  Created by liujia on 2018/5/3.
//  Copyright © 2018年 360tianji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface MBProgressHUD (TJ)

+ (void)showSuccess:(NSString *)success;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

+ (void)showError:(NSString *)error;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showLoadingMessage:(NSString *)message;
+ (MBProgressHUD *)showLoadingMessage:(NSString *)message toView:(UIView *)view;

+ (void)toast:(NSString *)message;
+ (void)toast:(NSString *)message toView:(UIView *)view;

+ (void)hideHUD;
+ (void)hideHUDForView:(UIView *)view;

+ (void)showLongText:(NSString *)text toView:(UIView *)view;
+ (void)showLongDEBUGText:(NSString *)text toView:(UIView *)view;

@end
