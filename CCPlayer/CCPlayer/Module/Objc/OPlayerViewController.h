//
//  PlayerViewController.h
//  CCPlayer
//
//  Created by 崔玉冠 on 2020/12/9.
//

#import <UIKit/UIKit.h>
#import "PlayModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OPlayerViewController : UIViewController

- (instancetype)initWithPlayModel:(PlayModel *)model;

@end

NS_ASSUME_NONNULL_END
