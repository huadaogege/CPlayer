//
//  CustomAlertVC.h
//  workspace
//
//  Created by 崔玉冠 on 2018/7/20.
//  Copyright © 2018年 360tianji. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^clickCallBack)(NSInteger index);

@interface CustomAlertVC : UIView

+(instancetype)shareInstance;

+ (UIAlertController *)alertWithTitle:(NSString *)title
                              message:(NSString *)message
                            letfTitle:(NSString *)leftTitile
                           rightTitle:(NSString *)rightTitle
                        clickCallBack:(clickCallBack)clickCallBack;



@end

typedef void(^closeCallBack)(BOOL close);

@interface CloseButton : UIButton

@property (nonatomic, strong) UIView *maskingView;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, copy) closeCallBack closeCallBack;

@end

