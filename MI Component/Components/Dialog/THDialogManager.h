//
//  THDialogManager.h
//  MI Component
//
//  Created by HieuTDT on 11/7/20.
//  Copyright © 2020 HieuTDT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface THDialogManager : NSObject

+ (instancetype)shared;

/// Show Success type dialog with only Close button and Success image view.
/// @param title Title of dialog
/// @param desc Description of dialog
/// @param vc View controller that dialog will show on.
/// @param completion Callback block when Dialog did hide.
- (void)showSuccessDialogWithTitle:(NSString *)title
                              desc:(NSString *)desc
                  inViewController:(UIViewController *)vc
                        completion:(nullable dispatch_block_t)completion;

/// Show Failure type dialog with only Close button and Failure image view.
/// @param title Title of dialog
/// @param desc Description of dialog.
/// @param vc View controller that dialog will show on.
/// @param completion Callback block when Dialog did hide.
- (void)showFailedDialogWithTitle:(NSString *)title
                             desc:(NSString *)desc
                 inViewController:(UIViewController *)vc
                       completion:(nullable dispatch_block_t)completion;

- (void)showConfirmDialogWithTitle:(NSString *)title
                              desc:(NSString *)desc
                   leftButtonTitle:(NSString *)leftButtonTitle
                  leftButtonAction:(nullable dispatch_block_t)leftButtonAction
                  rightButtonTitle:(NSString *)rightButtonTitle
                 rightButtonAction:(nullable dispatch_block_t)rightButtonAction
                  inViewController:(UIViewController *)vc;

- (void)showInfoDialogWithTitle:(NSString *)title
                           desc:(NSString *)desc
               inViewController:(UIViewController *)vc
                     completion:(nullable dispatch_block_t)completion;

@end

NS_ASSUME_NONNULL_END
