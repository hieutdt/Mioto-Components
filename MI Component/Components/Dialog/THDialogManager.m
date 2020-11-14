//
//  THDialogManager.m
//  MI Component
//
//  Created by HieuTDT on 11/7/20.
//  Copyright © 2020 HieuTDT. All rights reserved.
//

#import "THDialogManager.h"
#import "THComponents.h"
#import "THDialogView.h"
#import <Masonry/Masonry.h>

@interface THDialogManager()

@property (nonatomic, strong) THDialogView *dialog;
@property (nonatomic, strong) UIView *dimLayer;
@property (nonatomic, weak) UIViewController *presentingVC;
@property (nonatomic, assign) BOOL isShowing;

@end


@implementation THDialogManager

#pragma mark - Lifecycle

/// Singleton
+ (instancetype)shared {
    static THDialogManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[THDialogManager alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        if (!_dialog) {
            _dialog = [[THDialogView alloc] init];
            _dimLayer = [[UIView alloc] init];
            _dimLayer.backgroundColor = [UIColor blackColor];
            
            // Add tap gesture to dimlayer
            UITapGestureRecognizer *dimmerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_hideDialog)];
            [_dimLayer addGestureRecognizer:dimmerTap];
        }
    }
    return self;
}

#pragma mark - APIs

- (void)showSuccessDialogWithTitle:(NSString *)title
                              desc:(NSString *)desc
                  inViewController:(UIViewController *)vc
                        completion:(nullable dispatch_block_t)completion {
    
    if (!vc) {
        return;
    }
    
    THButtonModel *buttonModel = [[THButtonModel alloc] init];
    buttonModel.title = @"ĐÓNG";
    buttonModel.type = THButtonTypePrimary;
    buttonModel.iconName = @"";
    buttonModel.action = ^{
        [self _hideDialogWithCompletion:completion];
    };
    
    [_dialog setDialogWithType:THDialogTypeSuccess
                     imageName:@"ic_success"
                         title:title
                   description:desc
            primaryButtonModel:buttonModel
          secondaryButtonModel:nil];
    
    [self _showDialogInViewController:vc];
}

- (void)showFailedDialogWithTitle:(NSString *)title
                             desc:(NSString *)desc
                 inViewController:(UIViewController *)vc
                       completion:(nullable dispatch_block_t)completion {
    
    if (!vc || _isShowing) {
        return;
    }
    
    THButtonModel *buttonModel = [[THButtonModel alloc] init];
    buttonModel.title = @"ĐÓNG";
    buttonModel.type = THButtonTypeDestructive;
    buttonModel.iconName = @"";
    buttonModel.action = ^{
        [self _hideDialogWithCompletion:completion];
    };
    
    [_dialog setDialogWithType:THDialogTypeFailed
                     imageName:@"ic_failed"
                         title:title
                   description:desc
            primaryButtonModel:buttonModel
          secondaryButtonModel:nil];
    
    [self _showDialogInViewController:vc];
}

- (void)showConfirmDialogWithTitle:(NSString *)title
                              desc:(NSString *)desc
                   leftButtonTitle:(NSString *)leftButtonTitle
                  leftButtonAction:(nullable dispatch_block_t)leftButtonAction
                  rightButtonTitle:(NSString *)rightButtonTitle
                 rightButtonAction:(nullable dispatch_block_t)rightButtonAction
                  inViewController:(UIViewController *)vc {
    
    if (!vc || _isShowing) {
        return;
    }
    
    THButtonModel *leftModel = [[THButtonModel alloc] init];
    leftModel.type = THButtonTypeSecondary;
    leftModel.title = leftButtonTitle;
    leftModel.action = ^{
        [self _hideDialogWithCompletion:leftButtonAction];
    };
    
    THButtonModel *rightModel = [[THButtonModel alloc] init];
    rightModel.type = THButtonTypePrimary;
    rightModel.title = rightButtonTitle;
    rightModel.action = ^{
        [self _hideDialogWithCompletion:rightButtonAction];
    };
    
    [_dialog setDialogWithType:THDialogTypeInfo
                     imageName:@""
                         title:title
                   description:desc
            primaryButtonModel:rightModel
          secondaryButtonModel:leftModel];
    
    [self _showDialogInViewController:vc];
}

- (void)showInfoDialogWithTitle:(NSString *)title
                           desc:(NSString *)desc
               inViewController:(UIViewController *)vc
                     completion:(nullable dispatch_block_t)completion {
    
    if (!vc || _isShowing) {
        return;
    }
    
    THButtonModel *model = [[THButtonModel alloc] init];
    model.type = THButtonTypePrimary;
    model.title = @"ĐÓNG";
    model.action = ^{
        [self _hideDialogWithCompletion:completion];
    };
    
    [_dialog setDialogWithType:THDialogTypeInfo
                     imageName:@""
                         title:title
                   description:desc
            primaryButtonModel:model
          secondaryButtonModel:nil];
    
    [self _showDialogInViewController:vc];
}

#pragma mark - Show/Hide

- (void)_showDialogInViewController:(UIViewController *)vc {
    NSAssert(_dialog != nil, @"Dialog is nil!");
    
    if (!vc) {
        NSLog(@"THDialogManager> Present view controller is nil!");
        return;
    }
    
    _isShowing = YES;
    
    // Add dim layer to vc
    [_dimLayer removeFromSuperview];
    [vc.view addSubview:_dimLayer];
    [vc.view bringSubviewToFront:_dimLayer];
    
    // Add Dialog to vc
    [_dialog removeFromSuperview];
    [vc.view addSubview:_dialog];
    [vc.view bringSubviewToFront:_dialog];
    
    // Layouts
    [_dialog mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(vc.view.mas_centerX);
        make.centerY.equalTo(vc.view.mas_centerY);
        make.leading.equalTo(vc.view.mas_leading).with.offset(30);
        make.trailing.equalTo(vc.view.mas_trailing).with.offset(-30);
    }];
    
    [_dimLayer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(vc.view);
    }];
    
    // Animate showing
    [_dialog setHidden:NO];
    [_dialog setAlpha:1];
    _dialog.transform = CGAffineTransformScale(_dialog.transform, 0.01, 0.01);
    [_dimLayer setHidden:NO];
    [_dimLayer setAlpha:0];
    
    WEAKSELF
    [UIView animateWithDuration:0.25 animations:^{
        STRONGSELF
        strongSelf.dialog.transform = CGAffineTransformIdentity;
        strongSelf.dimLayer.alpha = 0.5;
    }];
}

- (void)_hideDialogWithCompletion:(dispatch_block_t)completion {
    _dialog.alpha = 1;
    
    _isShowing = NO;
    
    WEAKSELF
    [UIView animateWithDuration:0.25 animations:^{
        STRONGSELF
        strongSelf.dialog.transform = CGAffineTransformScale(strongSelf.dialog.transform, 0.01, 0.01);
        strongSelf.dialog.alpha = 0;
        strongSelf.dimLayer.alpha = 0;
        
    } completion:^(BOOL finished) {
        STRONGSELF
        strongSelf.dialog.transform = CGAffineTransformIdentity;
        [strongSelf.dialog removeFromSuperview];
        strongSelf.dialog.alpha = 1;
        strongSelf.dialog.hidden = YES;
        
        [strongSelf.dimLayer removeFromSuperview];
        strongSelf.dimLayer.hidden = YES;
        
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion();
            });
        }
    }];
}

- (void)_hideDialog {
    [self _hideDialogWithCompletion:nil];
}

@end
