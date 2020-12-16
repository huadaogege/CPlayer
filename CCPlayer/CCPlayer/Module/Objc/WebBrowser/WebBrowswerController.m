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
    self.title = @"在线浏览";
    
    [self.view addSubview:self.currentWebView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNav];
}

- (void)setNav {
    UIBarButtonItem *leftBtn1 = [[UIBarButtonItem alloc] initWithTitle:@"后退" style:UIBarButtonItemStylePlain target:self action:@selector(navBtnClick:)];
    [leftBtn1 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]  forState:UIControlStateNormal];
    leftBtn1.tag = 1;
    UIBarButtonItem *leftBtn2 = [[UIBarButtonItem alloc] initWithTitle:@"前进" style:UIBarButtonItemStylePlain target:self action:@selector(navBtnClick:)];
    [leftBtn2 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]  forState:UIControlStateNormal];
    leftBtn2.tag = 2;
    self.navigationItem.leftBarButtonItems = @[leftBtn1, leftBtn2];
    
    UIBarButtonItem *rightBtn1 = [[UIBarButtonItem alloc] initWithTitle:@"下载" style:UIBarButtonItemStylePlain target:self action:@selector(navBtnClick:)];
    [rightBtn1 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]  forState:UIControlStateNormal];
    rightBtn1.tag = 3;
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
