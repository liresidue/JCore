//
//  UIView+Gradient.h
//  Category
//
//  Created by Hitter on 2017/6/29.
//  Copyright © 2017年 Hitter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Gradient)

@property(nullable, copy) NSArray *colors;

@property(nullable, copy) NSArray<NSNumber *> *locations;

@property CGPoint startPoint;
@property CGPoint endPoint;

+ (UIView *_Nullable)gradientViewWithColors:(NSArray<UIColor *> *_Nullable)colors locations:(NSArray<NSNumber *> *_Nullable)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

- (void)setGradientBackgroundWithColors:(NSArray<UIColor *> *_Nullable)colors locations:(NSArray<NSNumber *> *_Nullable)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

@end
