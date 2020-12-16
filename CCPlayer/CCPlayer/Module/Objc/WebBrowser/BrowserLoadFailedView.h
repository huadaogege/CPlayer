//
//  BrowserLoadFailedView.h
//  workspace
//
//  Created by 崔玉冠 on 2019/1/11.
//  Copyright © 2019 Beijing QiAnXin Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^Reload_Network_Block)(void);

@interface BrowserLoadFailedView : UIView

- (instancetype)initWithReloadBlock:(Reload_Network_Block)reloadBlock;

@end

NS_ASSUME_NONNULL_END
