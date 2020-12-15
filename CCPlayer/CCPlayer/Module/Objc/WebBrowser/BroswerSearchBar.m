//
//  BroswerSearchBar.m
//  TJBroswer
//
//  Created by 崔玉冠 on 2018/10/17.
//  Copyright © 2018 崔玉冠. All rights reserved.
//

#import "BroswerSearchBar.h"

@interface BroswerSearchBar () <UITextFieldDelegate>

@end

@implementation BroswerSearchBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.backgroundColor =RGB(239, 239, 239);
        self.layer.cornerRadius = 3.0;
        
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        UIImageView *searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
        searchImageView.image = [UIImage imageNamed:@"wb_search"];
        [leftView addSubview:searchImageView];
        self.searchTextFiled.leftView = leftView;
        [self addSubview:self.searchTextFiled];
        [self.searchTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.equalTo(@(45));
        }];
    }
    return self;
}

- (UITextField *)searchTextFiled {
    if (!_searchTextFiled) {
        _searchTextFiled = [[UITextField alloc] init];
        _searchTextFiled.placeholder = @"输入网址或搜索";
        _searchTextFiled.font = [UIFont systemFontOfSize:15];
        _searchTextFiled.textColor = RGB(0x33, 0x33, 0x33);
        _searchTextFiled.leftViewMode = UITextFieldViewModeAlways;
        _searchTextFiled.returnKeyType = UIReturnKeySearch;
        _searchTextFiled.delegate = self;
        _searchTextFiled.clearsOnBeginEditing = NO;
        _searchTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _searchTextFiled;
}

- (void)searchButtonClick:(UIButton *)sender {
    [self.searchTextFiled resignFirstResponder];
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchButtonClick:fromRecord:)]) {
        [self.delegate searchButtonClick:self.searchTextFiled.text fromRecord:NO];
    }
}

#pragma mark -- UITextFieldDelegate --

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.searchTextFiled]) {
        [self searchButtonClick:nil];
    }
    return YES;
}

@end
