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
    
    [self addSubview:_imgView];
    
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
    }];
    
    _imgView.layer.masksToBounds = YES;
    _imgView.layer.cornerRadius = 5;
}

#pragma mark - Setters

- (void)setImage:(UIImage *)image {
    [_imgView setImage:image];
}

@end
