//
//  THButton.h
//  MI Component
//
//  Created by HieuTDT on 11/7/20.
//  Copyright © 2020 HieuTDT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THComponents.h"

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

/// Custom button with icon and text in vertical stack.
@interface THButton : UIButton

- (instancetype)initWithText:(NSString *)text
                 iconImgName:(NSString *)iconName
                        type:(THButtonType)type
                      action:(dispatch_block_t)action;

- (void)setTitle:(NSString *)title;

- (void)setImgName:(NSString *)imgName;

- (void)setType:(THButtonType)type;

- (void)setButtonByModel:(THButtonModel *)model;

@end

NS_ASSUME_NONNULL_END
