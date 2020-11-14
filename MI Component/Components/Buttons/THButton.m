//
//  THButton.m
//  MI Component
//
//  Created by HieuTDT on 11/7/20.
//  Copyright © 2020 HieuTDT. All rights reserved.
//

#import <Masonry/Masonry.h>
#import "THButton.h"

#pragma mark - THButtonModel

@implementation THButtonModel

@end

#pragma mark - THButton

@interface THButton()

/// Data properties
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imgName;
@property (nonatomic, assign) THButtonType type;
@property (nonatomic, strong) dispatch_block_t action;

/// View components
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *textLbl;
@property (nonatomic, strong) UIStackView *stackView;

@end

@implementation THButton

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _customInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self _customInit];
    }
    return self;
}

/// Default initialize this button.
- (void)_customInit {
    _type = THButtonTypePrimary;
    _title = @"";
    _imgName = @"";
    _action = ^{};
    
    [self _configureLayout];
    
    // Add actions
    [self addTarget:self action:@selector(_touchDown) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(_touchCancel) forControlEvents:
     UIControlEventTouchUpOutside | UIControlEventTouchCancel | UIControlEventTouchDragOutside];
    [self addTarget:self action:@selector(_touchUpInside) forControlEvents:UIControlEventTouchUpInside];
}

- (void)_configureLayout {
    
    // -----------------------------------------------------
    // Stack view
    // -----------------------------------------------------
    _stackView = [[UIStackView alloc] init];
    _stackView.alignment = UIStackViewAlignmentCenter;
    _stackView.axis = UILayoutConstraintAxisHorizontal;
    _stackView.distribution = UIStackViewDistributionFill;
    _stackView.backgroundColor = [UIColor clearColor];
    _stackView.spacing = 10;
    // Must disable stackview's interaction.
    _stackView.userInteractionEnabled = NO;
    [self addSubview:_stackView];
    [_stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.leading.equalTo(self.mas_leading).with.offset(10);
        make.trailing.equalTo(self.mas_trailing).with.offset(-10);
    }];
    
    // -----------------------------------------------------
    // Image view
    // -----------------------------------------------------
    _imgView = [[UIImageView alloc] init];
    _imgView.backgroundColor = [UIColor clearColor];
    [_stackView addArrangedSubview:_imgView];
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@40);
        make.width.equalTo(@40);
    }];
    
    // -----------------------------------------------------
    // Text label
    // -----------------------------------------------------
    _textLbl = [[UILabel alloc] init];
    [_textLbl setFont:[UIFont boldSystemFontOfSize:16]];
    [_textLbl setTextColor:[UIColor whiteColor]];
    [_textLbl setTextAlignment:NSTextAlignmentCenter];
    [_stackView addArrangedSubview:_textLbl];
    [_textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_stackView.mas_top).with.offset(2);
        make.bottom.equalTo(_stackView.mas_bottom).with.offset(-2);
    }];
    
    self.layer.shadowColor = UIColor.blackColor.CGColor;
    self.layer.shadowOpacity = 0.2;
    self.layer.shadowRadius = 1;
    self.layer.shadowOffset = CGSizeMake(1, 1);
    self.layer.cornerRadius = 5;
}

#pragma mark - Custom Init

- (instancetype)initWithText:(NSString *)text
                 iconImgName:(NSString *)iconName
                        type:(THButtonType)type
                      action:(dispatch_block_t)action {
    self = [super init];
    if (self) {
        [self _customInit];
        
        self.title = text;
        self.imgName = iconName;
        self.type = type;
        self.action = action;
    }
    return self;
}

- (instancetype)initWithModel:(THButtonModel *)model {
    self = [super init];
    if (self) {
        [self _customInit];
        
        self.title = model.title;
        self.type = model.type;
        self.imgName = model.iconName;
        self.action = model.action;
    }
    return self;
}

#pragma mark - Setters

- (void)setTitle:(NSString *)title {
    _title = title;
    [_textLbl setText:_title];
    
    self.layer.borderWidth = 2;
    
    if (_type == THButtonTypePrimary) {
        [_textLbl setTextColor:[UIColor whiteColor]];
        self.layer.borderColor = [UIColor clearColor].CGColor;
        
    } else if (_type == THButtonTypeSecondary) {
        [_textLbl setTextColor:[UIColor primary]];
        self.layer.borderColor = [UIColor primary].CGColor;
        
    } else if (_type == THButtonTypeDestructive) {
        [_textLbl setTextColor:[UIColor whiteColor]];
    }
}

- (void)setImgName:(NSString *)imgName {
    _imgName = imgName;
    
    if ([_imgName isEqual: @""]) {
        [_imgView setHidden:YES];
        return;
    }
    
    UIImage *image = [UIImage imageNamed:_imgName];
    if (!image) {
        [_imgView setHidden:YES];
    } else {
        [_imgView setHidden:NO];
        [_imgView setImage:image];
    }
}

- (void)setType:(THButtonType)type {
    _type = type;
    [self _setBackgroundColorByTypeWithCompletion:nil];
}

- (void)_setBackgroundColorByTypeWithCompletion:(dispatch_block_t)completion {
    UIColor *backgroundColor = nil;
    if (_type == THButtonTypePrimary) {
        backgroundColor = [UIColor primary];
    } else if (_type == THButtonTypeSecondary) {
        backgroundColor = [UIColor secondary];
    } else if (_type == THButtonTypeDestructive) {
        backgroundColor = [UIColor destructive];
    } else {
        backgroundColor = [UIColor black];
    }
    
    [UIView animateWithDuration:0.15 animations:^{
        self.backgroundColor = backgroundColor;
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

- (void)setButtonByModel:(THButtonModel *)model {
    self.title = model.title;
    self.imgName = model.iconName;
    self.action = model.action;
    self.type = model.type;
}

#pragma mark - Action handle

- (void)_touchDown {
    UIColor *backgroundColor = nil;
    if (_type == THButtonTypePrimary) {
        backgroundColor = [UIColor primaryDark];
    } else if (_type == THButtonTypeSecondary) {
        backgroundColor = [UIColor secondaryDark];
    } else if (_type == THButtonTypeDestructive) {
        backgroundColor = [UIColor destructiveDark];
    } else {
        backgroundColor = [UIColor blackLight];
    }
    
    [UIView animateWithDuration:0.15 animations:^{
        self.backgroundColor = backgroundColor;
    }];
}

- (void)_touchCancel {
    [self _setBackgroundColorByTypeWithCompletion:nil];
}

- (void)_touchUpInside {
    WEAKSELF
    [self _setBackgroundColorByTypeWithCompletion:^{
        STRONGSELF
        if (strongSelf.action) {
            strongSelf.action();
        }
    }];
}

@end
