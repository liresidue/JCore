//
//  JPageConstant.h
//  JPage
//
//  Created by Hitter on 2019/1/30.
//  Copyright © 2019 Hitter. All rights reserved.
//

#import <UIKit/UIKit.h>

//
extern NSString *const kBackgroundColorAttributeName;   // JPageBar背景色 (defult : whiteColor)
extern NSString *const kFontSelectedAttributeName;      // JPageBar选中字体 (defult : 14.f)
extern NSString *const kFontAttributeName;              // JPageBar字体大小 (defult : 18.f)
extern NSString *const kFontColorAttributeName;         // JPageBar文字颜色 (defult : lightGrayColor)
extern NSString *const kFontColorSelectedAttributeName; // JPageBar字选中色 (defult : blackColor)

extern CGFloat const kPageBarMargin;
extern CGFloat const kPageBarTitleDefalutW;
extern CGFloat const kPageBarIndicatorDefaultH;
extern CGFloat const kPageBarIndicatorDefaultW;

typedef enum : NSUInteger {
    JPageIndicatorStyleInvariable,
    JPageIndicatorStyleAdaption,
    JPageIndicatorStyleShrink,
    JPageIndicatorStyleNone,
} JPageIndicatorStyle;
