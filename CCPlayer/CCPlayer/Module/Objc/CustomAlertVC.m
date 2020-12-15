//
//  CustomAlertVC.m
//  workspace
//
//  Created by 崔玉冠 on 2018/7/20.
//  Copyright © 2018年 360tianji. All rights reserved.
//

#import "CustomAlertVC.h"


#define  TipViewW    [CommonUtil getIsIpad]? kScreenWidth * 0.5 : kScreenWidth * 0.7
#define  TipViewH    [CommonUtil getIsIpad]? kScreenHeight * 0.3 : kScreenHeight * 0.5

@interface CustomAlertVC()
@property (nonatomic,strong)UIView *maskView;
@property (nonatomic,assign)BOOL ViewIsHidden;
@property (nonatomic, assign) NSInteger presentForceMessageCount;//当前屏幕上已经显示的强显示消息数
@end
static int count = 1;

@implementation CustomAlertVC


+(instancetype)shareInstance{
    static CustomAlertVC* shareInstance =nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[CustomAlertVC alloc] init];
        shareInstance.ViewIsHidden = NO;
        
    });
    return shareInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.presentForceMessageCount = 0;
    }
    return self;
}


/**
 类方法调用提示窗
 */
+ (UIAlertController *)alertWithTitle:(NSString *)title
                              message:(NSString *)message
                            letfTitle:(NSString *)leftTitile
                           rightTitle:(NSString *)rightTitle
                        clickCallBack:(clickCallBack)clickCallBack
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    if (leftTitile.length > 0) {
        UIAlertAction *leftAction = [UIAlertAction actionWithTitle:leftTitile style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (clickCallBack) {
                clickCallBack(0);
            }
        }];
        [alertController addAction:leftAction];
    }
    if (rightTitle.length > 0) {
        UIAlertAction *rightAction = [UIAlertAction actionWithTitle:rightTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (clickCallBack) {
                clickCallBack(1);
            }
        }];
        [alertController addAction:rightAction];
    }
    return alertController;
}


/**
 强显示消息的动画
 */
-(void)customViewAnimation:(UIView * )contentView{
    //执行动画
    contentView.alpha = 0;
    contentView.transform = CGAffineTransformScale(contentView.transform,0.1,0.1);
    [UIView animateWithDuration:0.3 animations:^{
        contentView.transform = CGAffineTransformIdentity;
        contentView.alpha = 1;
    }];
    self.presentForceMessageCount++;
    count= count+1;
}

+ (void)closeForceMessage:(CloseButton *)sender {
    UIView *contentView = sender.contentView;
    //执行动画
    [UIView animateWithDuration:0.3 animations:^{
        contentView.transform = CGAffineTransformScale(contentView.transform,0.1,0.1);
        contentView.alpha = 0;
    } completion:^(BOOL finished) {
        [sender.maskingView removeFromSuperview];
        sender.maskingView = nil;
    }];
    if (sender.closeCallBack) {
        sender.closeCallBack(YES);
    }
    [CustomAlertVC shareInstance].presentForceMessageCount--;
}

#pragma mark - 私有方法 子view隐藏显示
/**
 强显示view全部隐藏
 */
-(void)viewHiddenIsYes{
    self.ViewIsHidden = YES;
    NSArray *viewArray =  [UIApplication sharedApplication].keyWindow.subviews ;
    for (UIView *view in viewArray) {
        if (view.tag == 999) {
            view.hidden = YES;
        }
    }
}

/**
 强显示view全部显示
 */
-(void)viewHiddenIsNO{
    self.ViewIsHidden = NO;
    NSArray *viewArray =  [UIApplication sharedApplication].keyWindow.subviews ;
    for (UIView *view in viewArray) {
        if (view.tag == 999) {
            view.hidden = NO;
        }
    }
}

/**
 强显示view全部移除
 */
-(void)removeAllCustomAlertView{
    NSArray *viewArray =  [UIApplication sharedApplication].keyWindow.subviews ;
    for (UIView *view in viewArray) {
        if (view.tag == 999) {
            [view removeFromSuperview];
        }
    }
}

/**
 当前页面是否有强制显示的i消息
 */
-(BOOL)hasAlertView{
    NSArray *viewArray =  [UIApplication sharedApplication].keyWindow.subviews ;
    for (UIView *view in viewArray) {
        if (view.tag == 999) {
            return YES;
        }
    }
    
    return NO;
}


@end

@implementation CloseButton

@end


