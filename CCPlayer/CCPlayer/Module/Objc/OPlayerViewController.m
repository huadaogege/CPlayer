//
//  PlayerViewController.m
//  CCPlayer
//
//  Created by 崔玉冠 on 2020/12/9.
//

#import "OPlayerViewController.h"
#import "AVPlayer+SeekSmoothly.h"
#import <AVKit/AVKit.h>


static CGFloat AnimationDuration = 0.3;//旋转动画执行时间

@interface OPlayerViewController ()

@property (nonatomic, nullable, strong) UIView *playerView;//播放器视图
@property (nonatomic, nullable, strong) UIView *playerSuperView;//记录播放器父视图
@property (nonatomic, assign) CGRect playerFrame;//记录播放器原始frame
@property (nonatomic, assign) BOOL isFullScreen;//记录是否全屏
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playLayer;
@property (nonatomic, assign) id timeObserve;
@property (nonatomic, strong) UITapGestureRecognizer *gesture;

@property (nonatomic, strong) UIView *controlTopView;
@property (nonatomic, nullable, strong) UIButton *btnBack;
@property (nonatomic, nullable, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *controlBottonView;
@property (nonatomic, nullable, strong) UIButton *btnPlay;
@property (nonatomic, nullable, strong) UIButton *btnFullScreen;
@property (nonatomic, nullable, strong) UILabel *timeLabel;
@property (nonatomic, strong) UISlider *slider;


@property (nonatomic, assign) UIInterfaceOrientation lastInterfaceOrientation;
@property (nonatomic, nullable, strong) UIWindow *mainWindow;
@property (nonatomic, strong) PlayModel *model;

@end

@implementation OPlayerViewController

- (instancetype)initWithPlayModel:(PlayModel *)model {
    if (self = [super init]) {
        self.model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backClick:)];
    [leftButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]  forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    if (@available(iOS 13.0, *)) {
        _lastInterfaceOrientation = [UIApplication sharedApplication].windows.firstObject.windowScene.interfaceOrientation;
    } else {
        _lastInterfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    }
    //开启和监听 设备旋转的通知
    if (![UIDevice currentDevice].generatesDeviceOrientationNotifications) {
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleDeviceOrientationChange:)
                                                name:UIDeviceOrientationDidChangeNotification object:nil];
    [self setupUI];
    
    WeakSelf;
    _timeObserve = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        int current = CMTimeGetSeconds(time);
        int total = CMTimeGetSeconds(weakSelf.player.currentItem.duration);
        if (current) {
            float value = CMTimeGetSeconds(time) / CMTimeGetSeconds(weakSelf.player.currentItem.duration);
            weakSelf.slider.value = value;
            NSString *currentTime = [NSString stringWithFormat:@"%02d:%02d", current/60, current%60];
            NSString *totalTime = [NSString stringWithFormat:@"%02d:%02d", total/60, total%60];
            weakSelf.timeLabel.text = [NSString stringWithFormat:@"%@:%@", currentTime, totalTime];
        }
    }];
    [self.player play];
}

- (void)backClick:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- UI --
- (void)setupUI {
    self.view.backgroundColor = [UIColor blackColor];
    
    self.playerView.frame = CGRectMake(0,
                                       (kScreenHeight - CGRectGetWidth(self.view.bounds) * 9 / 16.f)/2.0 + 20,
                                       CGRectGetWidth(self.view.bounds),
                                       CGRectGetWidth(self.view.bounds) * 9 / 16.f);
    [self.view addSubview:self.playerView];
    
    [self.playerView.layer addSublayer:self.playLayer];
    self.playLayer.frame = CGRectMake(0,
                                      0,
                                      self.playerView.bounds.size.width,
                                      self.playerView.bounds.size.height);
    
    [self initcontrolBottonView];
    self.titleLabel.text = self.model.name;
    
    self.gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gesTap:)];
    [self.view addGestureRecognizer:self.gesture];
}

- (void)gesTap:(UITapGestureRecognizer *)ges {
    self.controlTopView.hidden = !self.controlTopView.hidden;
    self.controlBottonView.hidden = !self.controlBottonView.hidden;
}

- (void)initcontrolBottonView {
    // top
    [self.playerView addSubview:self.controlTopView];
    [self.controlTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.playerView);
        make.height.equalTo(@30);
    }];
    
    [self.controlTopView addSubview:self.btnBack];
    [self.controlTopView addSubview:self.titleLabel];
    
    // bottom
    [self.playerView addSubview:self.controlBottonView];
    [self.controlBottonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playerView);
        make.bottom.equalTo(self.playerView);
        make.size.mas_equalTo(CGSizeMake(self.playerView.frame.size.width, 30));
    }];
    [self.controlBottonView addSubview:self.btnFullScreen];
    
    [self.controlBottonView addSubview:self.btnPlay];
    [self.controlBottonView addSubview:self.timeLabel];
    [self.controlBottonView addSubview:self.slider];
    [self updateControlSubViewFrame];
}

#pragma mark topControlView

- (UIView *)controlTopView {
    if (!_controlTopView) {
        _controlTopView = [[UIView alloc] init];
        _controlTopView.backgroundColor = [UIColor clearColor];
    }
    return _controlTopView;
}

- (UIButton *)btnBack {
    if (!_btnBack) {
        _btnBack = [[UIButton alloc] init];
        _btnBack.backgroundColor = [UIColor clearColor];
        [_btnBack setBackgroundImage:[UIImage imageNamed:@"play_back"] forState:UIControlStateNormal];
        [_btnBack addTarget:self
                     action:@selector(backClick)
           forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnBack;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _titleLabel;
}

- (void)backClick {
    [self.player pause];
    if (_timeObserve) {
        [self.player removeTimeObserver:_timeObserve];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark bottomControlView

- (UIView *)controlBottonView {
    if (!_controlBottonView) {
        _controlBottonView = [[UIView alloc] init];
        _controlBottonView.backgroundColor = [UIColor clearColor];
    }
    return _controlBottonView;
}

- (UIButton *)btnPlay {
    if (!_btnPlay) {
        _btnPlay = [[UIButton alloc] init];
        [_btnPlay setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        [_btnPlay setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateSelected];
        [_btnPlay addTarget:self action:@selector(playControlClick:) forControlEvents:UIControlEventTouchUpInside];
        _btnPlay.backgroundColor = [UIColor clearColor];
    }
    return _btnPlay;
}

- (void)playControlClick:(UIButton *)sender {
    self.btnPlay.selected = !self.btnPlay.selected;
    if (self.btnPlay.selected) {
        [self.player pause];
    } else {
        [self.player play];
    }
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.text = @"00:00/00:00";
    }
    return _timeLabel;
}

- (UISlider *)slider {
    if (!_slider) {
        _slider = [[UISlider alloc] init];
        [_slider addTarget:self action:@selector(avSliderAction) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchCancel|UIControlEventTouchUpOutside];
        [_slider setValue:0];
    }
    return _slider;
}

- (void)avSliderAction {
    float seconds = self.slider.value;
    //让视频从指定的CMTime对象处播放。
    CMTime startTime = CMTimeMakeWithSeconds(seconds*CMTimeGetSeconds(self.player.currentItem.duration), self.player.currentItem.currentTime.timescale);
    [self.player ss_seekToTime:startTime];
    [self.player play];
}

- (UIButton *)btnFullScreen {
    if (!_btnFullScreen) {
        _btnFullScreen = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnFullScreen setBackgroundImage:[UIImage imageNamed:@"play_full"] forState:UIControlStateNormal];
        _btnFullScreen.backgroundColor = [UIColor clearColor];
        [_btnFullScreen addTarget:self action:@selector(fullScreenAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnFullScreen;
}

- (UIView *)playerView {
    if (!_playerView) {
        _playerView = [[UIView alloc]init];
        _playerView.backgroundColor = [UIColor clearColor];
    }
    return _playerView;
}


- (UIWindow *)mainWindow {
    if (!_mainWindow) {
        if (@available(iOS 13.0, *)) {
            _mainWindow = [UIApplication sharedApplication].windows.firstObject;
        } else {
            _mainWindow = [UIApplication sharedApplication].keyWindow;
        }
    }
    return _mainWindow;
}

- (void)updateControlSubViewFrame {
    // top
    [self.btnBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.controlTopView).with.offset(5);
        make.top.equalTo(self.controlTopView);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    self.btnBack.hidden = self.isFullScreen;
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.btnBack.mas_right).with.offset(5);
        make.top.equalTo(self.controlTopView);
        make.right.equalTo(self.controlTopView.mas_right).with.offset(-80);
        make.height.equalTo(@30);
    }];
    // bottom
    CGFloat x1 = self.isFullScreen ? 45:5;
    CGFloat x2 = self.isFullScreen ? -90:-50;
    CGFloat x3 = self.isFullScreen ? -45:-5;
    [self.btnPlay mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.controlBottonView).with.offset(x1);
        make.top.equalTo(self.controlBottonView);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.btnPlay.mas_right).with.offset(5);
        make.top.equalTo(self.controlBottonView);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
    
    [self.slider mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLabel.mas_right).with.offset(5);
        make.right.equalTo(self.controlBottonView).with.offset(x2);
        make.top.equalTo(self.controlBottonView);
        make.height.equalTo(@30);
    }];
    
    [self.btnFullScreen mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.controlBottonView).with.offset(x3);
        make.bottom.equalTo(self.controlBottonView);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
}

#pragma mark player

- (AVPlayer *)player {
    if (!_player) {
        NSURL *videoUrl = [NSURL fileURLWithPath:self.model.path];
        AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:videoUrl];
        _player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
        _player.rate = 1.0;
    }
    return _player;
}

- (AVPlayerLayer *)playLayer {
    if (!_playLayer) {
        _playLayer = [[AVPlayerLayer alloc] init];
        _playLayer.player = self.player;
        _playLayer.backgroundColor = [UIColor blackColor].CGColor;
        _playLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    }
    return _playLayer;
}

//设备方向改变的处理
- (void)handleDeviceOrientationChange:(NSNotification *)notification {
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    switch (deviceOrientation) {
        case UIDeviceOrientationFaceUp:
            NSLog(@"屏幕朝上平躺");
            break;
        case UIDeviceOrientationFaceDown:
            NSLog(@"屏幕朝下平躺");
            break;
        case UIDeviceOrientationUnknown:
            NSLog(@"未知方向");
            break;
        case UIDeviceOrientationLandscapeLeft:
            if (self.isFullScreen) {
                [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
            }
            NSLog(@"屏幕向左横置");
            break;
        case UIDeviceOrientationLandscapeRight:
            if (self.isFullScreen) {
                [self interfaceOrientation:UIInterfaceOrientationLandscapeLeft];
            }
            NSLog(@"屏幕向右橫置");
            break;
        case UIDeviceOrientationPortrait:
            NSLog(@"屏幕直立");
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            NSLog(@"屏幕直立，上下顛倒");
            break;
        default:
            NSLog(@"无法辨识");
            break;
    }
}
//最后在dealloc中移除通知 和结束设备旋转的通知
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[UIDevice currentDevice]endGeneratingDeviceOrientationNotifications];
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (BOOL)prefersStatusBarHidden {
    if (@available(iOS 13.0, *)) {
        return self.isFullScreen;
    }
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskLandscapeLeft|UIInterfaceOrientationMaskLandscapeRight;
}

#pragma mark - private method

- (void)fullScreenAction:(UIButton *)sender {
    if (self.isFullScreen) {//如果是全屏，点击按钮进入小屏状态
        [self changeToOriginalFrame];
    } else {//不是全屏，点击按钮进入全屏状态
        [self changeToFullScreen];
    }
}

- (void)changeToOriginalFrame {
    if (!self.isFullScreen) {
        return;
    }
    
    [UIView animateWithDuration:AnimationDuration animations:^{
        [self interfaceOrientation:UIInterfaceOrientationPortrait];
        self.playerView.frame = self.playerFrame;
        self.playLayer.frame = CGRectMake(0,
                                          0,
                                          self.playerView.bounds.size.width,
                                          self.playerView.bounds.size.height);
        [self.controlBottonView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.playerView);
            make.bottom.equalTo(self.playerView);
            make.size.mas_equalTo(CGSizeMake(self.playerView.frame.size.width, 30));
        }];
    } completion:^(BOOL finished) {
        [self.playerView removeFromSuperview];
        [self.playerSuperView addSubview:self.playerView];
        self.isFullScreen = NO;
        [self updateControlSubViewFrame];
        //调用以下方法后，系统会在合适的时间调用prefersStatusBarHidden方法，控制状态栏的显示和隐藏，可根据自己的产品控制显示逻辑
        [self setNeedsStatusBarAppearanceUpdate];
    }];
}

- (void)changeToFullScreen {
    if (self.isFullScreen) {
        return;
    }
    //记录播放器视图的父视图和原始frame值,在实际项目中，可能会嵌套子视图，所以播放器的superView有可能不是self.view，所以需要记录父视图
    self.playerSuperView = self.playerView.superview;
    self.playerFrame = self.playerView.frame;
    
    CGRect rectInWindow = [self.playerView convertRect:self.playerView.bounds toView:self.mainWindow];
    [self.playerView removeFromSuperview];
    
    self.playerView.frame = rectInWindow;
    [self.mainWindow addSubview:self.playerView];
    //执行旋转动画
    [UIView animateWithDuration:AnimationDuration animations:^{
        
        UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
        if (orientation == UIDeviceOrientationLandscapeRight) {
            [self interfaceOrientation:UIInterfaceOrientationLandscapeLeft];
        } else {
            [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
        }
        
        self.playerView.bounds = CGRectMake(0,
                                            0,
                                            CGRectGetHeight(self.mainWindow.bounds),
                                            CGRectGetWidth(self.mainWindow.bounds));

        self.playerView.center = CGPointMake(CGRectGetMidX(self.mainWindow.bounds), CGRectGetMidY(self.mainWindow.bounds));
        self.playLayer.frame = CGRectMake(0,
                                          0,
                                          self.playerView.bounds.size.width,
                                          self.playerView.bounds.size.height);
        
        [self.controlBottonView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.playerView);
            make.bottom.equalTo(self.playerView);
            make.size.mas_equalTo(CGSizeMake(self.playerView.frame.size.height, 30));
        }];
    } completion:^(BOOL finished) {
        self.isFullScreen = YES;
        [self updateControlSubViewFrame];
        [self.view addGestureRecognizer:self.gesture];
        //调用以下方法后，系统会在合适的时间调用prefersStatusBarHidden方法，控制状态栏的显示和隐藏，可根据自己的产品控制显示逻辑
        [self setNeedsStatusBarAppearanceUpdate];
        
    }];
}

- (void)interfaceOrientation:(UIInterfaceOrientation)orientation {
    if (orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft) {
        // 设置横屏
        [self setOrientationLandscapeConstraint:orientation];
    } else if (orientation == UIInterfaceOrientationPortrait) {
        // 设置竖屏
        [self setOrientationPortraitConstraint];
    }
}

- (void)setOrientationLandscapeConstraint:(UIInterfaceOrientation)orientation {
    
    [self toOrientation:orientation];
}

- (void)setOrientationPortraitConstraint {
    [self toOrientation:UIInterfaceOrientationPortrait];
}

- (void)toOrientation:(UIInterfaceOrientation)orientation {
    // 获取到当前状态条的方向------iOS13已经废弃，所以不能根据状态栏的方向判断是否旋转，手动记录最后一次的旋转方向
//    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    // 判断如果当前方向和要旋转的方向一致,那么不做任何操作
    if (self.lastInterfaceOrientation == orientation) { return; }
    
    if (@available(iOS 13.0, *)) {
        //iOS 13已经将setStatusBarOrientation废弃，调用此方法无效
    } else {
        [[UIApplication sharedApplication] setStatusBarOrientation:orientation animated:NO];
    }
    self.lastInterfaceOrientation = orientation;
    
    // 获取旋转状态条需要的时间:
    
    [UIView animateWithDuration:AnimationDuration animations:^{
        // 更改了状态条的方向,但是设备方向UIInterfaceOrientation还是正方向的,这就要设置给你播放视频的视图的方向设置旋转
        // 给你的播放视频的view视图设置旋转
        self.playerView.transform = CGAffineTransformIdentity;
        self.playerView.transform = [self getTransformRotationAngleWithOrientation:self.lastInterfaceOrientation];
        // 开始旋转
    } completion:^(BOOL finished) {}];
}

- (CGAffineTransform)getTransformRotationAngleWithOrientation:(UIInterfaceOrientation)orientation {

    // 根据要进行旋转的方向来计算旋转的角度
    if (orientation == UIInterfaceOrientationPortrait) {
        return CGAffineTransformIdentity;
    } else if (orientation == UIInterfaceOrientationLandscapeLeft){
        return CGAffineTransformMakeRotation(-M_PI_2);
    } else if(orientation == UIInterfaceOrientationLandscapeRight){
        return CGAffineTransformMakeRotation(M_PI_2);
    }
    return CGAffineTransformIdentity;
}

#pragma mark - setter

- (void)setIsFullScreen:(BOOL)isFullScreen {
    _isFullScreen = isFullScreen;
}

#pragma mark - getter

@end
