//
//  THButtonModel.h
//  MI Component
//
//  Created by HieuTDT on 11/10/20.
//  Copyright © 2020 HieuTDT. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, THButtonType) {
    THButtonTypePrimary,
    THButtonTypeSecondary,
    THButtonTypeDestructive,
    THButtonTypeBlackBackground
};

/// Data model for create a Button.
@interface THButtonModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, assign) THButtonType type;
@property (nonatomic, strong) dispatch_block_t action;

@end


NS_ASSUME_NONNULL_END
