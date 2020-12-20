//
//  AboutViewController.m
//  CCPlayer
//
//  Created by 崔玉冠 on 2020/12/19.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupUI];
}

- (void)setupUI {
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"wb_goback"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(navBtnClick:)];
    self.navigationItem.leftBarButtonItems = @[leftBtn];
    
    UIImageView *iconImage = [[UIImageView alloc] init];
    iconImage.image = [UIImage imageNamed:@"Icon"];
    [self.view addSubview:iconImage];
    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(120);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    UILabel *title = [[UILabel alloc] init];
    title.textColor = [UIColor grayColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont systemFontOfSize:18.0];
    title.text = @"CCPlayer (1.0.0)";
    [self.view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(iconImage.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
}

- (void)navBtnClick:(UIBarButtonItem *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
