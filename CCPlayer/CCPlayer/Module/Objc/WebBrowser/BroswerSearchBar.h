//
//  BroswerSearchBar.h
//  TJBroswer
//
//  Created by 崔玉冠 on 2018/10/17.
//  Copyright © 2018 崔玉冠. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BroswerSearchBarDelegate <NSObject>

@required
- (void)searchButtonClick:(NSString *)searchContent fromRecord:(BOOL)fromRecord;

@end

@interface BroswerSearchBar : UIView

@property (nonatomic, strong) UITextField *searchTextFiled;
@property (nonatomic, strong) UIButton *searchButton;

@property (nonatomic, weak) id<BroswerSearchBarDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
