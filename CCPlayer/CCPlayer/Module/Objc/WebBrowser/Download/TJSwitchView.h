//
//  TJSwitchView.h
//  BYOD
//
//  Created by 崔玉冠 on 2018/5/8.
//  Copyright © 2018年 360tianji. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TJSwitchViewDeleagte <NSObject>

@required
- (void)switchViewClickIndex:(NSInteger)index;

@end

@interface TJSwitchView : UIView

@property (nonatomic, weak) id <TJSwitchViewDeleagte> swDelegate;

/**
 初始化控制条

 @param titles 标题数
 @return 控制条本身
 */
- (instancetype)initWithTitles:(NSArray *)titles;

/**
 切换选中状态

 @param index 被选中值
 */
- (void)swipeTitleSelectedStatus:(NSInteger)index;


@end
