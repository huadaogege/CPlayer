//
//  BrowserLoadFailedView.m
//  workspace
//
//  Created by 崔玉冠 on 2019/1/11.
//  Copyright © 2019 Beijing QiAnXin Technology Co., Ltd. All rights reserved.
//

#import "BrowserLoadFailedView.h"

@interface BrowserLoadFailedView ()

@property (nonatomic, copy) Reload_Network_Block reloadBlock;

@end

@implementation BrowserLoadFailedView

- (instancetype)initWithReloadBlock:(Reload_Network_Block)reloadBlock {
    self = [super init];
    if (self) {
        [self setupUI];
        self.reloadBlock = reloadBlock;
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    
    UIImageView *networkFailedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"network_failed"]];
    [self addSubview:networkFailedImageView];
    [networkFailedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).with.offset(70);
        make.size.mas_equalTo(CGSizeMake(177, 105));
    }];
    
    UILabel *tipsLabel = [[UILabel alloc] init];
    tipsLabel.textColor = RGB(222, 222, 222);
    tipsLabel.font = [UIFont systemFontOfSize:16];
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.text = @"网络不给力, 请稍后重试";
    [self addSubview:tipsLabel];
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(networkFailedImageView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(177, 22));
    }];
    
    UIButton *reLoadButton = [[UIButton alloc] init];
    [reLoadButton setTitle:@"重新加载" forState:UIControlStateNormal];
    [reLoadButton setTitleColor:RGB(255,255,255) forState:UIControlStateNormal];
    [reLoadButton setBackgroundColor:[UIColor whiteColor]];
    reLoadButton.layer.cornerRadius = 4.0;
    [reLoadButton addTarget:self action:@selector(reLoadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:reLoadButton];
    [reLoadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).with.offset(-50);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth - 40, 44));
    }];
}

- (void)reLoadButtonClick:(UIButton *)sender {
    if (self.reloadBlock) {
        self.reloadBlock();
    }
}



@end
