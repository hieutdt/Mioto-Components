//
//  THImageZoomView.h
//  MI Component
//
//  Created by HieuTDT on 10/24/20.
//  Copyright © 2020 HieuTDT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface THImageZoomView : UIScrollView

@property (nonatomic, strong) UIImageView *imageView;

- (id)initWithFrame:(CGRect)frame image:(UIImage *)image;

- (void)setImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
