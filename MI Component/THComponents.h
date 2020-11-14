//
//  THComponents.h
//  MI Component
//
//  Created by HieuTDT on 11/7/20.
//  Copyright © 2020 HieuTDT. All rights reserved.
//

#ifndef THComponents_h
#define THComponents_h

#pragma mark - Macro

#define SCREEN_WIDTH UIScreen.mainScreen.bounds.size.width
#define SCREEN_HEIGHT UIScreen.mainScreen.bounds.size.height

#define ColorBy(redVal, greenVal, blueVal) [UIColor colorWithRed:redVal/256.0 green:greenVal/256.0 blue:blueVal/256.0 alpha:1.0]
#define WordBy(str) UX_LOCALIZE_STRING(str)
#define ImageBy(name) [UIImage imageNamed:name]

#define WEAKSELF __weak typeof(self) weakSelf = self;
#define STRONGSELF __strong typeof(weakSelf) strongSelf = weakSelf; if (strongSelf == nil) return;
#define STRONGSELF_RET_NIL __strong typeof(weakSelf) strongSelf = weakSelf; if (strongSelf == nil) return nil;
#define STRONGSELF_IF_NIL_RETURN_NIL __strong __typeof(weakSelf) strongSelf = weakSelf; if (strongSelf == nil) return nil;
#define STRONGSELF_RETURN(obj) __strong __typeof(weakSelf) strongSelf = weakSelf; if (strongSelf == nil) return obj;

#define IS_NONEMPTY_STR(str)        (str && [str isKindOfClass:[NSString class]] && ((NSString*)str).length>0)
#define IS_NONEMPTY_ARR(arr)        (arr && [arr isKindOfClass:[NSArray class]] && ((NSArray*)arr).count>0)
#define IS_NONEMPTY_DICT(dict)      (dict && [dict isKindOfClass:[NSDictionary class]] && ((NSDictionary*)dict).count>0)
#define IS_EMPTY_ARR(arr)           (!IS_NONEMPTY_ARR(arr))
#define IS_EMPTY_STR(str)           (!IS_NONEMPTY_STR(str))
#define IS_EMPTY_DICT(dict)          (!IS_NONEMPTY_DICT(dict))

#define IS_VALID_CLASS(obj, className)       (obj && [obj isKindOfClass:[className class]])
#define IS_INVALID_CLASS(obj, Type)   (!IS_VALID_CLASS(obj, Type))
#define IS_VALID_DELEGATE(delegateObj, selectorObj)  (delegateObj && [delegateObj respondsToSelector:selectorObj])
#define IS_INVALID_DELEGATE(delegateObj, selectorObj) (!IS_VALID_DELEGATE(delegateObj, selectorObj))

#define IS_EQUAL_STR(src, target)       (IS_NONEMPTY_STR(src) && IS_NONEMPTY_STR(target) && [src isEqualToString:target])
#define IS_NOT_EQUAL_STR(src, target)   (!IS_EQUAL_STR(src, target))

#define ifnot(condition)        if (!(condition))
#define elseifnot(condition)    else if (!(condition))
#define runAfter(delay, block)  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^block);
#define safeExec(block, ...)    block ? block(__VA_ARGS__) : nil
#define safeString(string)      string ? string : @""

/// @require Must have dispatch_queue_t internalQueue inside class
#define serialBlock(block) dispatch_async(self.internalQueue, ^block);

#define UX_SEPERATOR_HEIGHT UXSeparatorHeight()
#define LOCALIZE_STRING(string) [NSBundle getLocalizedString:string withComment:string]
#define UX_LOCALIZE_STRING(string) LOCALIZE_STRING(string)
#define LSTR(string) LOCALIZE_STRING(string)

#define TOSTR_(x...) #x
#define TOJSON_(chars) [[NSString stringWithUTF8String:chars] JSONValue]

#pragma mark - Extensions

#import "UIView+Additions.h"
#import "UIImage+Extensions.h"
#import "UIColor+Extensions.h"


#pragma mark - View Components

#import "THButton.h"
#import "VerticalIconTextButton.h"

#import "THDialogManager.h"

#import "BottomSheet.h"
#import "BottomSheetManager.h"

#pragma mark - ViewControllers



#endif /* THComponents_h */
