//
//  UIColor+Extensions.m
//  MI Component
//
//  Created by HieuTDT on 11/7/20.
//  Copyright © 2020 HieuTDT. All rights reserved.
//

#import "UIColor+Extensions.h"

@implementation UIColor (Extensions)

// Assumes input like "#00FF00" (#RRGGBB).
+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    if ([hexString characterAtIndex:0] == '#') {
        [scanner setScanLocation:1]; // bypass '#' character
    }
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

+ (UIColor *)primary {
    return [UIColor colorFromHexString:@"00A550"];
}

+ (UIColor *)primaryDark {
    return [UIColor colorFromHexString:@"25B95B"];
}

+ (UIColor *)secondary {
    return [UIColor whiteColor];
}

+ (UIColor *)secondaryDark {
    return [UIColor colorFromHexString:@"E2EAE5"];
}

+ (UIColor *)destructive {
    return [UIColor colorFromHexString:@"F44336"];
}

+ (UIColor *)destructiveDark {
    return [UIColor colorFromHexString:@"AF5749"];
}

+ (UIColor *)black {
    return [UIColor colorFromHexString:@"151515"];
}

+ (UIColor *)blackLight {
    return  [UIColor colorFromHexString:@"202020"];
}

@end
