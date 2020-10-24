//
//  THImageZoomView.m
//  MI Component
//
//  Created by HieuTDT on 10/24/20.
//  Copyright © 2020 HieuTDT. All rights reserved.
//

#import "THImageZoomView.h"

@interface THImageZoomView() <UIScrollViewDelegate>

@end

@implementation THImageZoomView

- (id)initWithFrame:(CGRect)frame image:(UIImage *)image {
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithImage:image];
        _imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        [_imageView setContentMode:UIViewContentModeScaleAspectFill];
        [_imageView setUserInteractionEnabled:YES];
        
        [self addSubview:_imageView];
        
        [self setUpScrollView];
    }
    return self;
}

- (void)setUpScrollView {
    self.delegate = self;
    
    self.contentSize = self.imageView.image.size;
    
    CGRect scrollViewFrame = self.frame;
    CGFloat scaleWidth = scrollViewFrame.size.width / self.contentSize.width;
    CGFloat scaleHeight = scrollViewFrame.size.height / self.contentSize.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    
    self.minimumZoomScale = minScale;
    self.maximumZoomScale = 2;
    
//    [self centerScrollViewContent];
}

- (void)centerScrollViewContent {
    CGSize boundsSize = self.bounds.size;
    CGRect contentFrame = _imageView.frame;
    
    if (contentFrame.size.width < boundsSize.width) {
        contentFrame.origin.x = (boundsSize.width - contentFrame.size.width) / 2.f;
    } else {
        contentFrame.origin.x = 0;
    }
    
    if (contentFrame.size.height < boundsSize.height) {
        contentFrame.origin.y = (boundsSize.height - contentFrame.size.height) / 2.f;
    } else {
        contentFrame.origin.y = 0;
    }
    
    _imageView.frame = contentFrame;
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self centerScrollViewContent];
}

@end
