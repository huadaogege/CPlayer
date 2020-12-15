//
//  TJSwitchView.m
//  BYOD
//
//  Created by 崔玉冠 on 2018/5/8.
//  Copyright © 2018年 360tianji. All rights reserved.
//

#import "TJSwitchView.h"

#define OriginX (kScreenWidth/2.0 - 50)/2.0

@interface TJSwitchView ()

@property (nonatomic, copy) NSArray *titles;
@property (nonatomic, strong) UIView *indexBarView;//滚动条
@property (nonatomic, strong) UIButton *installedButton;//已安装按钮
@property (nonatomic, strong) UIButton *unInstalledButton;//未安装按钮

@end


@implementation TJSwitchView

- (instancetype)initWithTitles:(NSArray *)titles {
    if (self = [super init]) {
        self.titles = titles;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = TJ_WHITE_COLOR;
    for (int i = 0; i < self.titles.count; i ++) {
        NSString *title = self.titles[i];
        UIButton *button = [[UIButton alloc] init];
        button.frame = CGRectMake(i*kScreenWidth/2.0, 0, kScreenWidth/2.0, 45);
        [button setTitle:title forState:UIControlStateNormal];
        button.tag = i;
        if (i == 0) {
            [button setTitleColor:COMMON_TITLE_TEXT_COLOR forState:UIControlStateNormal];
            self.installedButton = button;
        } else {
            [button setTitleColor:TJ_GRAY_COLOR forState:UIControlStateNormal];
            self.unInstalledButton = button;
        }
        [button addTarget:self
                   action:@selector(switchButtonClick:)
         forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    CGRect rect = [self indexBarRectWithOriginx:OriginX];
    self.indexBarView = [[UIView alloc] initWithFrame:rect];
    self.indexBarView.backgroundColor = COMMON_TITLE_TEXT_COLOR;
    [self addSubview:self.indexBarView];
    [self addBottomView];
}

- (void)addBottomView {
    UIView *bottomV = [UIView new];
    bottomV.backgroundColor = COMMON_LINE_LIGHTGRAY_COLOR;
    
    [self addSubview:bottomV];
    [bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.height.equalTo(@1);
    }];
}
/**
 点击切换事件

 @param sender sender description
 */
- (void)switchButtonClick:(UIButton *)sender {
    if (self.swDelegate && [self.swDelegate respondsToSelector:@selector(switchViewClickIndex:)]) {
        [self.swDelegate switchViewClickIndex:sender.tag];
    }
    [self swipeTitleSelectedStatus:sender.tag];
}

- (CGRect)indexBarRectWithOriginx:(CGFloat)originX {
    return CGRectMake(originX, 45, 50, 3);
}

/**
 切换选中状态
 
 @param index 被选中值
 */
- (void)swipeTitleSelectedStatus:(NSInteger)index {
    BOOL installedIndex = (index == 0);
    CGFloat lastOriginX = installedIndex ? OriginX : kScreenWidth/2.0+OriginX;
    UIColor *installedColor = installedIndex ? RGB(38, 38, 38) : RGB(83, 83, 83);
    UIColor *unInstallColor = installedIndex ? RGB(83, 83, 83) : RGB(38, 38, 38);
    [self.installedButton setTitleColor:installedColor forState:UIControlStateNormal];
    [self.unInstalledButton setTitleColor:unInstallColor forState:UIControlStateNormal];
    [UIView animateWithDuration:0.15 animations:^{
        CGRect rect = [self indexBarRectWithOriginx:lastOriginX];
        self.indexBarView.frame = rect;
    } completion:^(BOOL finished) {
    }];
}

@end
