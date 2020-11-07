//
//  THFilterThumbImageCell.m
//  MI Component
//
//  Created by HieuTDT on 10/31/20.
//  Copyright © 2020 HieuTDT. All rights reserved.
//

#import "THFilterThumbImageCell.h"
#import <Masonry/Masonry.h>

@interface THFilterThumbImageCell ()

@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation THFilterThumbImageCell

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];
    if (self) {
        [self customInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self customInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self customInit];
    }
    return self;
}

- (void)customInit {
    
    self.backgroundColor = [UIColor clearColor];
    
    _imgView = [[UIImageView alloc] init];
    [self addSubview:_imgView];
    
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
    }];
    
    _imgView.layer.masksToBounds = YES;
    _imgView.layer.cornerRadius = 10;
    if (self.isSelected) {
        _imgView.layer.borderColor = [UIColor systemYellowColor].CGColor;
    } else {
        _imgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    _imgView.layer.borderWidth = 2;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    _imgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

#pragma mark - Setters

- (void)setImage:(UIImage *)image {
    [_imgView setImage:image];
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    if (_isSelected) {
        _imgView.layer.borderColor = [UIColor systemYellowColor].CGColor;
    } else {
        _imgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
}

@end
