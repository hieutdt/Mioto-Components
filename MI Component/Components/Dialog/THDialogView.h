//
//  THDialogView.h
//  MI Component
//
//  Created by HieuTDT on 11/7/20.
//  Copyright © 2020 HieuTDT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THButton.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, THDialogType) {
    THDialogTypeSuccess,
    THDialogTypeFailed,
    THDialogTypeInfo,
    THDialogTypeCustomImage
};

@interface THDialogView : UIView

- (void)setDialogWithType:(THDialogType)type
                imageName:(NSString *)imageName
                    title:(NSString *)title
              description:(NSString *)desc
       primaryButtonModel:(nullable THButtonModel *)primaryModel
     secondaryButtonModel:(nullable THButtonModel *)secondaryModel;

- (void)setImgName:(NSString *)imgName;

- (void)setTitle:(NSString *)title;

- (void)setDesc:(NSString *)desc;

- (void)setHiddenCancelButton:(BOOL)isHidden;

@end

NS_ASSUME_NONNULL_END
