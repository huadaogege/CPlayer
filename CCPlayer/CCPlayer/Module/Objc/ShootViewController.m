//
//  ShootViewController.m
//  CCPlayer
//
//  Created by 崔玉冠 on 2020/12/13.
//

#import "ShootViewController.h"
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>
#import<MobileCoreServices/MobileCoreServices.h>

@interface ShootViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation ShootViewController

- (void)setParams {
    self.sourceType = UIImagePickerControllerSourceTypeCamera;

    self.mediaTypes = @[(NSString *)kUTTypeMovie];//设定相机为视频
    self.cameraDevice = UIImagePickerControllerCameraDeviceRear;//设置相机后摄像头
    self.videoMaximumDuration = 5*60;//最长拍摄时间
    self.videoQuality = UIImagePickerControllerQualityTypeHigh;//拍摄质量

    self.allowsEditing = NO;//是否可编辑
    self.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    }
    return _dateFormatter;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]){//如果是录制视频
        NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];//视频路径
        NSString *urlStr = [url path];
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr)) {
            [self saveVideo:url];
        }
    }
}

- (void)saveVideo:(NSURL *)videoUrl {
    NSString *dateString = [self.dateFormatter stringFromDate:[NSDate date]];
    NSString *videoName = [dateString stringByAppendingString:@".mp4"];
    NSString *newVideoPath = [DocumentPath stringByAppendingPathComponent:videoName];
    NSError *error;
    [[NSFileManager defaultManager] copyItemAtURL:videoUrl toURL:[NSURL fileURLWithPath:newVideoPath] error:&error];
    if (error) {
        NSLog(@"%@", error);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
