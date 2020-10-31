//
//  UIImage+Filter.m
//  MI Component
//
//  Created by HieuTDT on 10/24/20.
//  Copyright © 2020 HieuTDT. All rights reserved.
//

#import "UIImage+Extensions.h"

@implementation UIImage (Extensions)

- (UIImage *)addFilter:(NSString *)filterType {
    
    CIFilter *filter = [CIFilter filterWithName:filterType];
    
    // Convert UIImage to CIImage and set as input
    CIImage *ciInput = [CIImage imageWithCGImage:self.CGImage];
    
    if (filter) {
        [filter setValue:ciInput forKey:kCIInputImageKey];
        
        // Get output CIImage, render as CGImage first to retain
        // proper UIImage scale
        CIImage *ciOutput = [filter outputImage];
        
        // Return the image
        return [UIImage imageWithCIImage:ciOutput];
    }
    
    return nil;
}

- (UIImage *)fixOrientation {
    if (self.imageOrientation == UIImageOrientationUp) {
        return self;
    }
    
    UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale);
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    UIImage *normalizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return normalizeImage;
}

- (UIImage *)changeImageOrientation:(UIImageOrientation)orientation {
    if (self.imageOrientation == orientation) {
        return self;
    }
    
    UIImage *fixedOrientationImage = [self fixOrientation];

    return [UIImage imageWithCGImage:fixedOrientationImage.CGImage
                               scale:fixedOrientationImage.scale
                         orientation:orientation];
}

+ (UIImage *)rotatedImage:(UIImage *)image rotation:(CGFloat)rotation // rotation in radians
{
    // Calculate Destination Size
    CGAffineTransform t = CGAffineTransformMakeRotation(rotation);
    CGRect sizeRect = (CGRect) {.size = image.size};
    CGRect destRect = CGRectApplyAffineTransform(sizeRect, t);
    CGSize destinationSize = destRect.size;
    
    // Draw image
    UIGraphicsBeginImageContext(destinationSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, destinationSize.width / 2.0f, destinationSize.height / 2.0f);
    CGContextRotateCTM(context, rotation);
    [image drawInRect:CGRectMake(-image.size.width / 2.0f, -image.size.height / 2.0f,
                                 image.size.width, image.size.height)];
    
    // Save image
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (CGFloat)DegreesToRadians:(CGFloat)degrees {
    return degrees * M_PI / 180;
};

+ (CGFloat)RadiansToDegrees:(CGFloat) radians {
    return radians * 180 / M_PI;
};

+ (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

@end
