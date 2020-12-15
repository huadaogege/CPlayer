//
//  BroswerDownloadCell.m
//  TJBroswer
//
//  Created by 崔玉冠 on 2018/10/22.
//  Copyright © 2018 崔玉冠. All rights reserved.
//

#import "BroswerDownloadCell.h"
//#import "WebBroswerManager.h"
//#import "TJFileManager.h"

@interface BroswerDownloadCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) DownloadModel *model;

@end

@implementation BroswerDownloadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initializeView];
        self.backgroundColor = [UIColor whiteColor];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

- (void)initializeView {
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(15);
        make.top.equalTo(self.contentView).with.offset(10);
        make.right.equalTo(self.contentView).with.offset(-65);
        make.height.equalTo(@(25));
    }];
    
    [self.contentView addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(10);
        make.right.equalTo(self.contentView.mas_right).with.offset(-80);
        make.height.equalTo(@(2));
    }];
    
    [self.contentView addSubview:self.progressLabel];
    [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).with.offset(5);
        make.centerY.equalTo(self.progressView);
        make.right.equalTo(self.contentView).with.offset(-15);
        make.height.equalTo(@(25));
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = RGB(0x33, 0x33, 0x33);
        _titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        _titleLabel.text = @"正在下载的文件.zip";
    }
    return _titleLabel;
}

- (UILabel *)progressLabel {
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc] init];
        _progressLabel.textAlignment = NSTextAlignmentLeft;
        _progressLabel.textColor = RGB(29, 117, 220);
        _progressLabel.font = [UIFont boldSystemFontOfSize:12.0];
        _progressLabel.text = @"0.0%";
    }
    return _progressLabel;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] init];
        _progressView.progressViewStyle = UIProgressViewStyleDefault;
        _progressView.progress = 0;
    }
    return _progressView;
}

- (void)setContentModel:(DownloadModel *)model {
    self.model = model;
    if (model.status == Downloading) {
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(15);
            make.top.equalTo(self.contentView).with.offset(10);
            make.right.equalTo(self.contentView).with.offset(-65);
            make.height.equalTo(@(25));
        }];
        self.progressView.hidden = NO;
        self.progressLabel.hidden = NO;
        [self setDownloadProgress];
    } else if (model.status == DownloadFinished) {
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(15);
            make.right.equalTo(self.contentView).with.offset(-65);
            make.centerY.equalTo(self.contentView);
            make.height.equalTo(@(25));
        }];
        self.progressView.hidden = YES;
        self.progressLabel.hidden = YES;
    }
    /* 文件不存在, 文件标题置灰 */
    self.titleLabel.text = model.fileName;
//    NSString *filePath = [NSString stringWithFormat:@"%@/%@/%@", [TJFileManager getBaseDir], WebDir,model.filePath];
//    BOOL fileExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
//    UIColor *color = (fileExist || model.status == Downloading) ? COMMON_TITLE_TEXT_COLOR : TJ_LIGHTGRAY_COLOR;
//    self.titleLabel.textColor = color;
}

/**
 设置下载中的文件进度block
 */
- (void)setDownloadProgress {
    if ([WebBroswerManager shareInstance].downloadTasks.count > 0) {
        TJDownloadTask *dtask = nil;
        for (TJDownloadTask *task in [WebBroswerManager shareInstance].downloadTasks) {
            if ([task.createTimeStamp isEqualToString:self.model.createTimeStamp]) {
                dtask = task;
                break;
            }
        }
        if (dtask) {
            [dtask downLoadProgress:^(CGFloat downloadProgress) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.progressView.progress = downloadProgress;
                    self.progressLabel.text = [NSString stringWithFormat:@"%.f%%", downloadProgress*100];
                });
            }];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
