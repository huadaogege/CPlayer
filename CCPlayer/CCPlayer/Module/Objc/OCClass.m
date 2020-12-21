//
//  OCClass.m
//  CCPlayer
//
//  Created by 崔玉冠 on 2020/12/1.
//

#import "OCClass.h"
#include <sys/param.h>
#include <sys/mount.h>

@implementation OCClass

static OCClass *instance;
+ (OCClass *)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[OCClass alloc] init];
    });
    return instance;
}

- (NSString *)memoryFree {
    /// 总大小
    float totalsize = 0.0;
    /// 剩余大小
    float freesize = 0.0;
    /// 是否登录
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    if (dictionary)
    {
        NSNumber *_free = [dictionary objectForKey:NSFileSystemFreeSize];
        freesize = [_free unsignedLongLongValue]*1.0/(1024);

        NSNumber *_total = [dictionary objectForKey:NSFileSystemSize];
        totalsize = [_total unsignedLongLongValue]*1.0/(1024);
    } else
    {
        NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %ld", [error domain], (long)[error code]);
    }
    NSLog(@"totalsize = %.2f, freesize = %f",totalsize/1024/1024/1024, freesize/1024);
    NSString *free = [NSString stringWithFormat:@"%.2fG", freesize/1024/1024];
    return free;
}


@end
