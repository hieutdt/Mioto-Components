//
//  UIColor+Extensions.h
//  MI Component
//
//  Created by HieuTDT on 11/7/20.
//  Copyright © 2020 HieuTDT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Extensions)

+ (UIColor *)colorFromHexString:(NSString *)hexString;

#pragma mark - Colors

+ (UIColor *)primary;
+ (UIColor *)primaryDark;

+ (UIColor *)secondary;
+ (UIColor *)secondaryDark;

+ (UIColor *)destructive;
+ (UIColor *)destructiveDark;

+ (UIColor *)black;
+ (UIColor *)blackLight;

@end

NS_ASSUME_NONNULL_END
