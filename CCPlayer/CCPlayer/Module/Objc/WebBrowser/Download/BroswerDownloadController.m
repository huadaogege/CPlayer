//
//  BroswerDownloadControllerViewController.m
//  TJBroswer
//
//  Created by 崔玉冠 on 2018/10/22.
//  Copyright © 2018 崔玉冠. All rights reserved.
//

#import "BroswerDownloadController.h"
#import "TJSwitchView.h"
#import "BroswerDownloadCell.h"
#import "WebBroswerManager.h"
#import "MBProgressHUD+TJ.h"

#define CellIdentifier @"__BroswerDownloadControllerCellIdentifier__"



@interface BroswerDownloadController ()<UITableViewDelegate, UITableViewDataSource, TJSwitchViewDeleagte>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TJSwitchView *switchView;//列表切换控制头
@property (nonatomic, assign) DownloadStatus status;

@end

@implementation BroswerDownloadController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeView];
    self.title = @"下载管理";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)initializeView {
    self.status = Downloading;
    self.view.backgroundColor = [UIColor whiteColor];
    self.switchView = [[TJSwitchView alloc] initWithTitles:@[@"下载中", @"已下载"]];
    self.switchView.swDelegate = self;
    CGFloat switchView_Height = 55;
    self.switchView.frame = CGRectMake(0, 0, kScreenWidth, switchView_Height);
    [self.view addSubview:self.switchView];
    
    self.tableView.frame = CGRectMake(0,
                                      switchView_Height,
                                      kScreenWidth,
                                      kScreenHeight - switchView_Height - kStatusSafeAreaTopHeight - kStatusSafeAreaBottomHeight);
    [self.tableView registerClass:[BroswerDownloadCell class] forCellReuseIdentifier:CellIdentifier];
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    }
    return _tableView;
}

#pragma mark -- UITableViewDelegate, UITableViewDataSource --

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.status == Downloading) {
        return [WebBroswerManager shareInstance].downloadingModels.count;
    } else if (self.status == DownloadFinished) {
        return [WebBroswerManager shareInstance].downloadedModels.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView
                 cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    BroswerDownloadCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSMutableArray *models = nil;
    if (self.status == Downloading) {
        models = [NSMutableArray arrayWithArray:[WebBroswerManager shareInstance].downloadingModels];
    } else if (self.status == DownloadFinished) {
        models = [NSMutableArray arrayWithArray:[WebBroswerManager shareInstance].downloadedModels];
    }
    if (indexPath.row < models.count) {
        DownloadModel *model = models[indexPath.row];
        [cell setContentModel:model];
        if (self.status == Downloading) {
            [self setDownloadFinishTask:model];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.status == DownloadFinished) {
        UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            [self deleteModel:indexPath];
        }];
        return @[deleteAction];
    }
    return @[];
}

- (void)deleteModel:(NSIndexPath *)indexPath {
    NSMutableArray *models = [NSMutableArray arrayWithArray:[WebBroswerManager shareInstance].downloadedModels];
    if (indexPath.row < models.count) {
        DownloadModel *model = models[indexPath.row];
        [[WebBroswerManager shareInstance].downloadedModels removeObject:model];
//        [[WebBroswerManager shareInstance] deleteDownloadedModel:model];
        [self.tableView reloadData];
    }
}

/**
 为下载中的cell设置task, 下载完成之后处理文件

 @param model 下载模型
 */
- (void)setDownloadFinishTask:(DownloadModel *)model {
    if ([WebBroswerManager shareInstance].downloadTasks.count > 0) {
        TJDownloadTask *dtask = nil;
        for (TJDownloadTask *task in [WebBroswerManager shareInstance].downloadTasks) {
            if ([task.createTimeStamp isEqualToString:model.createTimeStamp]) {
                dtask = task;
                break;
            }
        }
        if (dtask) {
            WeakSelf;
            [dtask downloadFinish:^(BOOL state, NSString * _Nonnull message, NSString * _Nonnull filePath) {
                if (state) {
                    NSString * path = DocumentPath;
                    NSString *fileName = model.fileName;
                    NSString *desFilePath = [path stringByAppendingPathComponent:fileName];
                    /* 文件下载完成之后, 调用文件管理器的存储方法 */
                    NSData *fileData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:filePath]];
                    if (fileData) {
                        [fileData writeToFile:desFilePath atomically:YES];
                    }
                    [[WebBroswerManager shareInstance].downloadingModels removeObject:model];
                    [[WebBroswerManager shareInstance].downloadTasks removeObject:dtask];
                    model.filePath = fileName;//存储文件名, 路径临时拼接
                    model.status = DownloadFinished;
                } else {
                    NSLog(@"download failed.");
                    [MBProgressHUD showError:@"文件下载失败"];
                    [[WebBroswerManager shareInstance].downloadingModels removeObject:model];
                    [[WebBroswerManager shareInstance].downloadTasks removeObject:dtask];
                }
                NSError *error;
                [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
                if (error) {
                    NSLog(@"delete failed.");
                }
                [weakSelf.tableView reloadData];
            }];
        }
    }
}

#pragma mark -- TJAppTableViewDelegate methods --

- (void)switchViewClickIndex:(NSInteger)index {
    self.status = index;
    [self.tableView reloadData];
}




@end
