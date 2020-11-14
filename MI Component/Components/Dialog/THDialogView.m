//
//  THDialogView.m
//  MI Component
//
//  Created by HieuTDT on 11/7/20.
//  Copyright © 2020 HieuTDT. All rights reserved.
//

#import <Masonry/Masonry.h>
#import "THDialogView.h"

@interface THDialogView()

/// Views
@property (nonatomic, strong) UIImageView *imgView;;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) UIStackView *buttonStackView;
@property (nonatomic, strong) THButton *primaryButton;
@property (nonatomic, strong) THButton *secondaryButton;
@property (nonatomic, strong) UIButton *cancelButton;

/// Data properties
@property (nonatomic, assign) THDialogType type;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *imgName;

@end

@implementation THDialogView

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];
    if (self) {
        [self customInit];
    }
    return self;
}

- (void)customInit {
    
    self.backgroundColor = [UIColor whiteColor];
    
    // -------------------------------------------------------------
    // 1. Stack view
    // -------------------------------------------------------------
    _stackView = [[UIStackView alloc] init];
    _stackView.alignment = UIStackViewAlignmentCenter;
    _stackView.axis = UILayoutConstraintAxisVertical;
    _stackView.distribution = UIStackViewDistributionFill;
    _stackView.backgroundColor = [UIColor clearColor];
    _stackView.spacing = 20;
    // Must disable stackview's interaction.
    [self addSubview:_stackView];
    [_stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(30);
        make.leading.equalTo(self.mas_leading);
        make.trailing.equalTo(self.mas_trailing);
        make.bottom.equalTo(self.mas_bottom).with.offset(-30);
    }];
    
    // -------------------------------------------------------------
    // 1.1. Image View
    // -------------------------------------------------------------
    _imgView = [[UIImageView alloc] init];
    _imgView.backgroundColor = [UIColor clearColor];
    [_stackView addArrangedSubview:_imgView];
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@70);
        make.width.equalTo(@70);
    }];
    
    // -------------------------------------------------------------
    // 1.2. Title Label
    // -------------------------------------------------------------
    _titleLabel = [[UILabel alloc] init];
    [_titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [_titleLabel setTextColor:[UIColor primary]];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_titleLabel setNumberOfLines:1];
    [_stackView addArrangedSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_stackView.mas_leading).with.offset(15);
        make.trailing.equalTo(_stackView.mas_trailing).with.offset(-15);
    }];
    
    // -------------------------------------------------------------
    // 1.3. Description Label
    // -------------------------------------------------------------
    _descLabel = [[UILabel alloc] init];
    [_descLabel setFont:[UIFont systemFontOfSize:16]];
    [_descLabel setTextColor:[UIColor darkTextColor]];
    [_descLabel setNumberOfLines:5];
    [_descLabel setTextAlignment:NSTextAlignmentCenter];
    [_stackView addArrangedSubview:_descLabel];
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_stackView.mas_leading).with.offset(15);
        make.trailing.equalTo(_stackView.mas_trailing).with.offset(-15);
    }];
    
    // -------------------------------------------------------------
    // 1.4. Button Stack View
    // -------------------------------------------------------------
    _buttonStackView = [[UIStackView alloc] init];
    _buttonStackView.alignment = UIStackViewAlignmentCenter;
    _buttonStackView.distribution = UIStackViewDistributionFill;
    _buttonStackView.axis = UILayoutConstraintAxisHorizontal;
    _buttonStackView.backgroundColor = [UIColor clearColor];
    _buttonStackView.spacing = 15;
    [_stackView addArrangedSubview:_buttonStackView];
    
    // -------------------------------------------------------------
    // 1.4.1. Secondary Button
    // -------------------------------------------------------------
    _secondaryButton = [[THButton alloc] init];
    [_secondaryButton setType:THButtonTypeSecondary];
    [_buttonStackView addArrangedSubview:_secondaryButton];
    [_secondaryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_buttonStackView.mas_top).with.offset(2);
        make.bottom.equalTo(_buttonStackView.mas_bottom).with.offset(-2);
        make.width.equalTo(@120);
        make.height.equalTo(@50);
    }];
    
    // -------------------------------------------------------------
    // 1.4.2. Primary Button
    // -------------------------------------------------------------
    _primaryButton = [[THButton alloc] init];
    [_primaryButton setType:THButtonTypePrimary];
    [_buttonStackView addArrangedSubview:_primaryButton];
    [_primaryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_buttonStackView.mas_top).with.offset(2);
        make.bottom.equalTo(_buttonStackView.mas_bottom).with.offset(-2);
        make.width.equalTo(@120);
        make.height.equalTo(@50);
    }];
    
    // -------------------------------------------------------------
    // 2. Cancel button
    // -------------------------------------------------------------
    _cancelButton = [[UIButton alloc] init];
    [_cancelButton setTitle:@"X" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self addSubview:_cancelButton];
    [_cancelButton setHidden:YES];
    [_cancelButton addTarget:self
                      action:@selector(cancelButtonTapped)
            forControlEvents:UIControlEventTouchUpInside];
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(4);
        make.leading.equalTo(self.mas_leading).with.offset(4);
        make.height.equalTo(@20);
        make.width.equalTo(@20);
    }];
    
    // Set up for DialogView
    self.layer.shadowColor = UIColor.blackColor.CGColor;
    self.layer.shadowOpacity = 0.3;
    self.layer.shadowRadius = 2;
    self.layer.shadowOffset = CGSizeMake(3, 3);
    self.layer.cornerRadius = 10;
}

#pragma mark - Setters

- (void)setDialogWithType:(THDialogType)type
                imageName:(NSString *)imageName
                    title:(NSString *)title
              description:(NSString *)desc
       primaryButtonModel:(THButtonModel *)primaryModel
     secondaryButtonModel:(THButtonModel *)secondaryModel {
    
    self.type = type;
    self.imgName = imageName;
    self.title = title;
    self.desc = desc;
    if (primaryModel) {
        [self.primaryButton setButtonByModel:primaryModel];
        [self.primaryButton setHidden:NO];
    } else {
        [self.primaryButton setHidden:YES];
    }
    
    if (secondaryModel) {
        [self.secondaryButton setButtonByModel:secondaryModel];
        [self.secondaryButton setHidden:NO];
    } else {
        [self.secondaryButton setHidden:YES];
    }
}

- (void)setImgName:(NSString *)imgName {
    _imgName = imgName;
    
    UIImage *image = [UIImage imageNamed:_imgName];
    if (image) {
        [_imgView setImage:image];
        [_imgView setHidden:NO];
    } else {
        [_imgView setHidden:YES];
    }
}

- (void)setTitle:(NSString *)title {
    _title = title;
    [_titleLabel setText:_title];
    if (self.type == THDialogTypeSuccess) {
        [_titleLabel setTextColor:[UIColor primary]];
    } else if (self.type == THDialogTypeFailed) {
        [_titleLabel setTextColor:[UIColor destructive]];
    } else {
        [_titleLabel setTextColor:[UIColor black]];
    }
}

- (void)setDesc:(NSString *)desc {
    _desc = desc;
    [_descLabel setText:_desc];
    [_descLabel setTextColor:[UIColor darkTextColor]];
}

- (void)setHiddenCancelButton:(BOOL)isHidden {
    [self.cancelButton setHidden:isHidden];
}

#pragma mark - Action

- (void)cancelButtonTapped {
    [self _animatedHide];
}

- (void)_animatedHide {
    self.alpha = 1;
    
    WEAKSELF
    [UIView animateWithDuration:0.25 animations:^{
        STRONGSELF
        strongSelf.transform = CGAffineTransformScale(strongSelf.transform, 0.01, 0.01);
        strongSelf.alpha = 0;
    } completion:^(BOOL finished) {
        STRONGSELF
        [strongSelf removeFromSuperview];
        strongSelf.alpha = 1;
        strongSelf.hidden = YES;
    }];
}

@end
