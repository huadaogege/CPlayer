//
//  PlayModel.h
//  CCPlayer
//
//  Created by 崔玉冠 on 2020/12/2.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlayModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *size;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, assign) CGSize bounds;

@end

NS_ASSUME_NONNULL_END
