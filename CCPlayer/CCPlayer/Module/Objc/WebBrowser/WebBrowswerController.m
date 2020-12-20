//
//  WebBrowswerController.m
//  CCPlayer
//
//  Created by 崔玉冠 on 2020/12/15.
//

#import "WebBrowswerController.h"
#import "BrowserWebView.h"
#import "BroswerDownloadController.h"

@interface WebBrowswerController ()

@property (nonatomic, strong) BrowserWebView *currentWebView;//当前web视图

@end

@implementation WebBrowswerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.currentWebView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNav];
}

- (void)setNav {
    UIBarButtonItem *leftBtn1 = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"wb_goback"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(navBtnClick:)];

    leftBtn1.tag = 1;
    UIBarButtonItem *leftBtn2 = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"wb_goForward"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(navBtnClick:)];
    leftBtn2.tag = 2;
    
    UIBarButtonItem *leftBtn3 = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"wb_gohome"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(navBtnClick:)];
    leftBtn3.tag = 3;
    leftBtn3.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItems = @[leftBtn1, leftBtn2, leftBtn3];
    
    UIBarButtonItem *rightBtn1 = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"wb_list"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(navBtnClick:)];
    rightBtn1.tag = 4;
    self.navigationItem.rightBarButtonItems = @[rightBtn1];
}

- (void)navBtnClick:(UIBarButtonItem *)btn {
    if (btn.tag == 1) {
        if ([self.currentWebView.webView canGoBack]) {
            [self.currentWebView.webView goBack];
        }
    } else if (btn.tag == 2) {
        if ([self.currentWebView.webView canGoForward]) {
            [self.currentWebView.webView goForward];
        }
    } else if (btn.tag == 3) {
        self.currentWebView.homePage = YES;
    } else if (btn.tag == 4) {
        BroswerDownloadController *downLoadVC = [[BroswerDownloadController alloc] init];
        downLoadVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:downLoadVC animated:YES];
    }
}

- (BrowserWebView *)currentWebView {
    if (!_currentWebView) {
        CGFloat broswerWebViewHeight = kScreenHeight - kStatusTabbarHeight - kStatusSafeAreaTopHeight;
        _currentWebView = [[BrowserWebView alloc] initWithFrame:CGRectMake(0,
                                                                           kStatusSafeAreaTopHeight,
                                                                           kScreenWidth,
                                                                           broswerWebViewHeight)];
        _currentWebView.homePage = YES;
    }
    return _currentWebView;
}


@end
